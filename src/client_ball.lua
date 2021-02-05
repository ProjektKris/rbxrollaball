-- clientsideonly
local velocity = 1000
local module = {}
module.__index = module
function module.new()
    local remote_function = game.ReplicatedStorage:WaitForChild("remotes")
                                :WaitForChild("RemoteFunction")
    remote_function:InvokeServer("spawn")
    local new_instance = workspace:WaitForChild(
                             tostring(game.Players.LocalPlayer.UserId))
    local new_object = {instance = new_instance}
    setmetatable(new_object, module)
    return new_object
end
function module:move_y(positive)
    if positive then
        self.instance.center.Velocity =
            self.instance.center.Velocity + Vector3.new(0, 0, velocity)
    else
        self.instance.center.Velocity =
            self.instance.center.Velocity - Vector3.new(0, 0, velocity)
    end
end
function module:move_x(positive)
    if positive then
        self.instance.center.Velocity =
            self.instance.center.Velocity + Vector3.new(velocity, 0, 0)
    else
        self.instance.center.Velocity =
            self.instance.center.Velocity - Vector3.new(velocity, 0, 0)
    end
end
return module
