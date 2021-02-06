-- serversideonly
local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local std = require(game.ReplicatedStorage.Source.std)
local build = std.import("build")
local chip = {}
chip.__index = chip
function chip.new(rot_speed, reward, part_property)
    local new_chip = {
        instance = build.chip(part_property),
        rot_speed = rot_speed or 1, -- def: 1
        reward = reward or 1, -- def: 1
        disabled = false,
        connections = {},
        on_touched_func = {}
    }
    setmetatable(new_chip, chip)
    new_chip.connections[#new_chip.connections + 1] =
        run_service.Stepped:Connect(function(t, step)
            -- animates the object
            local dr = step * new_chip.rot_speed
            new_chip.instance.CFrame = new_chip.instance.CFrame *
                                           CFrame.fromEulerAnglesXYZ(dr, dr, dr)
        end)
    new_chip.connections[#new_chip.connections + 1] =
        new_chip.instance.Touched:Connect(
            function(part)
                if not new_chip.disabled then
                    if part then
                        if collection_service:HasTag(part, "player") then
                            new_chip.disabled = true
                            for i = 1, #new_chip.on_touched_func do
                                local new_thread =
                                    coroutine.wrap(
                                        function()
                                            new_chip.on_touched_func[i](part)
                                        end)
                                new_thread()
                            end
                            for _, connection in pairs(new_chip.connections) do
                                connection:Disconnect()
                            end
                            new_chip.instance:Destroy()
                            new_chip = nil
                        end
                    end
                end
            end)
    return new_chip
end
function chip:on_touched(func)
    self.on_touched_func[#self.on_touched_func + 1] = func
end
return chip
