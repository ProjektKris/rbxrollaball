local configs = {module_src = game.ReplicatedStorage.Source}

-- replicated
local module = {}
function module.import(pkg_name)
    local pkg = configs.module_src:FindFirstChild(pkg_name)
    if pkg then return require(pkg) end
end
function module.printf(str, ...)
    local formatted_str = string.format(str, ...)
    print(formatted_str)
end
function module.warnf(str, ...)
    local formated_str = string.format(str, ...)
    warn(formated_str)
end
function module.dir(path)
    local subs = string.split(path, "/")
    local instance = game
    for i = 1, #subs do
        if instance:FindFirstChild(subs[i]) then
            instance = instance[subs[i]]
        else
            local new = Instance.new("Folder")
            new.Name = subs[i]
            new.Parent = instance
            instance = new
        end
    end
    return instance
end
function module.create(instance_type, parent, attributes)
    -- create a new instance
    local new = Instance.new(instance_type)
    -- set the attributes of the new instance
    if attributes then
        for attribute_name, value in pairs(attributes) do
            new[attribute_name] = value
        end
    end
    if parent then
        new.Parent = parent
    end
    return new
end
return module
