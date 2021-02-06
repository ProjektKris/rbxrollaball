-- serversideonly
local std = require(game.ReplicatedStorage.Source.std)
local configs = std.import("configs")
local ball = std.import("ball")
local chip = std.import("chip")
local module = {}
function module.init()
    -- create remotes
    local remotes = std.dir("ReplicatedStorage/remotes")
    local remote_function = Instance.new("RemoteFunction", remotes)
    local remote_event = Instance.new("RemoteEvent", remotes)

    -- set gravity
    workspace.Gravity = configs.gravity

    -- disable player walking
    std.create("Humanoid", game.StarterPlayer, {WalkSpeed = 0})

    local balls = {}
    local chips = {}

    -- load chips
    for _, node in pairs(workspace.Level.Chip_Nodes:GetChildren()) do
        if node:IsA("Attachment") then
            chips[#chips + 1] = chip.new(2, 1, {
                Anchored = true,
                CanCollide = false,
                Position = node.WorldPosition,
                Size = Vector3.new(4, 4, 4),
                BrickColor = BrickColor.Yellow()
            })
        end
    end

    -- events
    remote_function.OnServerInvoke = function(client, item, ...)
        if item == "spawn" then
            balls[client.UserId] = ball.new(client)
            return
        end
    end
    remote_event.OnServerEvent:Connect(function(client, item, ...)
        local args = {...}
        if item == "x" then
            balls[client.UserId]:apply_force_x(args[1])
        elseif item == "y" then
            balls[client.UserId]:apply_force_y(args[1])
        end
    end)
end
return module
