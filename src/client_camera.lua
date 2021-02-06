-- clientsideonly
local configs = require(game.ReplicatedStorage.Source.configs)
local cam = {}
cam.__index = cam
function cam.new()
    local new_cam = {
        mode = 1, -- 1=lock; 2=ball;
        cam = workspace.CurrentCamera,
        client = game.Players.LocalPlayer,
        last_cf = CFrame.new()
    }
    setmetatable(new_cam, cam)
    return new_cam
end
function cam:update_mode(target_mode) self.mode = target_mode end
function cam:update() -- runs each frame
    local cases = {
        [1] = function() -- lock
            self.cam.CFrame = self.last_cf
        end,
        [2] = function() -- ball
            local ball_center = workspace.Players[tostring(self.client.UserId)]
                                    .center
            self.cam.CFrame = CFrame.lookAt(ball_center.Position + configs.cam_offset,
                                            ball_center.Position)
        end
    }
    xpcall(cases[self.mode], function(err) warn(err) end)
end
return cam
