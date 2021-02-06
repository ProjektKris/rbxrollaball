-- replicated
-- contains all instructions to build instances with script
-- this is done because this project utilizes rojo
local collection_service = game:GetService("CollectionService")
local std = require(game.ReplicatedStorage.Source.std)
local build = {}
function build.ball(client)
    local instance = std.create("Model", workspace.Players,
                                {Name = tostring(client.UserId)})
    local sphere = std.create("Part", instance, {
        Name = "sphere",
        Size = Vector3.new(5, 5, 5),
        Position = Vector3.new(0, 0, 0),
        Shape = Enum.PartType.Ball,
        CanCollide = true
    })
    local center = std.create("Part", instance, {
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

    instance.PrimaryPart = instance.center
    instance.PrimaryPart:SetNetworkOwner(client)
    collection_service:AddTag(sphere, "player")
    return instance
end
function build.ui()
    --[[
        struct
        ScreenGui {
            main_menu {
                play_buton
            }
            ingame {
                timer_text
            }
        }
    ]]
    local new_screen_gui = Instance.new("ScreenGui",  game.Players.LocalPlayer.PlayerGui)
    local main_menu_frame = std.create("Frame", new_screen_gui, {
        Name = "main_menu",
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1
    })
    local ingame_frame = std.create("Frame", new_screen_gui, {
        Name = "ingame",
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false
    })
    local play_button = std.create("TextButton", main_menu_frame, {
        Name = "play_button",
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextXAlignment = Enum.TextXAlignment.Center,
        FontSize = Enum.FontSize.Size42,
        Font = Enum.Font.RobotoCondensed,
        Text = "Start!"
    })
    local timer_text = std.create("TextLabel", ingame_frame, {
        Name = "timer_text",
        Size = UDim2.new(1,0,.1,0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        Font = Enum.Font.RobotoCondensed,
        Text = "0"
    })
    return new_screen_gui
end
function build.chip(property)
    local new_chip = std.create("Part", workspace.Chips, property)
    collection_service:AddTag(new_chip, "chip")
    return new_chip
end
return build
