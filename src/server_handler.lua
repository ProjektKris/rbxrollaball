-- serversideonly
local std = require(game.ReplicatedStorage.Source.std)
local ball = std.import("ball")
local module = {}
function module.init()
    local remotes = std.dir("ReplicatedStorage/remotes")
    local remote_function = Instance.new("RemoteFunction", remotes)
    local remote_event = Instance.new("RemoteEvent", remotes)

    -- disable player walking
    std.create("Humanoid", game.StarterPlayer, {WalkSpeed = 0})

    local balls = {}

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
