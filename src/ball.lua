-- serversideonly
local std = require(game.ReplicatedStorage.Source.std)
local function build_ball(client)
    local ball =
        std.create("Model", workspace, {Name = tostring(client.UserId)})
    local sphere = std.create("Part", ball, {
        Name = "sphere",
        Size = Vector3.new(5, 5, 5),
        Position = Vector3.new(0, 0, 0),
        Shape = Enum.PartType.Ball,
        CanCollide = true
    })
    local center = std.create("Part", ball, {
        Name = "center",
        Size = Vector3.new(1, 1, 1),
        Position = Vector3.new(0, 0, 0),
        Shape = Enum.PartType.Ball,
        CanCollide = false
    })
    local a0 = std.create("Attachment", center)
    local a1 = std.create("Attachment", sphere)
    std.create("BallSocketConstraint", center,
               {Attachment0 = a0, Attachment1 = a1})
    std.create("BodyThrust", center, {Force = Vector3.new(0, 0, 0)})
    std.create("BodyGyro", center)

    ball.PrimaryPart = ball.center
    ball.PrimaryPart:SetNetworkOwner(client)
    return ball
end
local ball = {}
ball.__index = ball
function ball.new(client)
    local new_instance = build_ball(client)
    local new_object = {instance = new_instance, velocity = 100}
    setmetatable(new_object, ball)
    return new_object
end
function ball:translate_x(positive)
    if positive then
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force + Vector3.new(self.velocity, 0, 0)
    else
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force - Vector3.new(self.velocity, 0, 0)
    end
end
function ball:translate_y(positive)
    if positive then
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force + Vector3.new(0, 0, self.velocity)
    else
        self.instance.center.BodyThrust.Force =
            self.instance.center.BodyThrust.Force - Vector3.new(0, 0, self.velocity)
    end
end
function ball:remove()
    
end
function ball:on_remove()
    
end
return ball
