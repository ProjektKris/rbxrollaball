local module = {}
module.__index = module
function module.new()
    local newCamera = {
        mode = 1
    }
    setmetatable(newCamera, module)
    return newCamera
end
function module:update_mode(target_mode)
    self.mode = target_mode
end
function module:update()
    
end
return module