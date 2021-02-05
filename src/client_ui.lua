--clientsideonly
local std = require(game.ReplicatedStorage.Source.std)
local configs = std.import("configs")
local build = std.import("build")
local ui = {}
ui.__index = ui
function ui.new()
    local new_ui = {
        screen_gui = build.ui(),
        mode = 1,
        t0 = time(),
        lifetime = 0
    }
    setmetatable(new_ui, ui)
    return new_ui
end
function ui:swap_frame(target_mode)
    for _, element in pairs(self.screen_gui:GetChildren())do
        if element.Name == configs.modes[target_mode] then
            element.Visible = true
        else
            element.Visible = false
        end
    end
end
function ui:update_mode(target_mode)
    self:swap_frame(target_mode)
    self.mode = target_mode
    if self.mode == 2 then
        self.t0 = time()
    end
end
function ui:update()--runs each frame
    local cases = {
        [1] = function()--mainmenu
            --for future use
        end,
        [2] = function()--ingame
            self.lifetime += (time()-self.t0)
            self.t0 = time()
            self.screen_gui.ingame.timer_text.Text = tostring(math.ceil(self.lifetime))
        end
    }
    xpcall(cases[self.mode], function(err)
        warn(err)
    end)
end
function ui:clr()
    self.screen_gui:Destroy()
    self = nil
end
return ui