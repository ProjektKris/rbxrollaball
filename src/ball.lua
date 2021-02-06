-- serversideonly
local collection_service = game:GetService("CollectionService")
local std = require(game.ReplicatedStorage.Source.std)
local build = std.import("build")
local ball = {}
ball.__index = ball
function ball.new(client)
    local new_object = {
        instance = build.ball(client),
        max_force = 1000,
        health = 100,
        on_remove_func = {},
        on_points_added_func = {}
    }
    setmetatable(new_object, ball)
    new_object.instance.sphere.Touched:Connect(function(part)
        if part then
            if collection_service:HasTag(part, "chip") then
                for i = 1, #new_object.on_points_added_func do
                    local new_thread = coroutine.wrap(function()
                        new_object.on_points_added_func[i](part)
                    end)
                    new_thread()
                end
            end
        end
    end)
    return new_object
end
function ball:apply_force_x(positive)
    if positive then
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force + Vector3.new(self.max_force, 0, 0)
    else
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force - Vector3.new(self.max_force, 0, 0)
    end
end
function ball:apply_force_y(positive)
    if positive then
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force + Vector3.new(0, 0, self.max_force)
    else
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force - Vector3.new(0, 0, self.max_force)
    end
end
function ball:remove()
    for i = 1, #self.on_remove_func do
        local new_thread = coroutine.wrap(function()
            self.on_remove_func[i]()
        end)
        new_thread()
    end
    self.instance:Destroy()
    self = nil
end
function ball:on_remove(func)
    self.on_remove_func[#self.on_remove_func+1] = func
end
function ball:on_points_added(func)
    self.on_points_added_func[#self.on_points_added_func+1] = func
end
return ball
