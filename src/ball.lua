-- serversideonly
local std = require(game.ReplicatedStorage.Source.std)
local build = std.import("build")
local ball = {}
ball.__index = ball
function ball.new(client)
    local new_instance = build.ball(client)
    local new_object = {
        instance = new_instance,
        max_force = 1000,
        health = 100
    }
    setmetatable(new_object, ball)
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
    
end
function ball:on_remove()
    
end
return ball
