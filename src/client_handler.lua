-- clientsideonly
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local std = require(game.ReplicatedStorage.Source.std)
local ui = std.import("client_ui")
local cam = std.import("client_camera")
local module = {}
function module.init()
    local remote_function = game.ReplicatedStorage:WaitForChild("remotes")
                                :WaitForChild("RemoteFunction")
    local remote_event = game.ReplicatedStorage:WaitForChild("remotes")
                             :WaitForChild("RemoteEvent")

    local cam_sys = cam.new()
    local ui_sys = ui.new()

    local playing = false

    -- disable core guis
    game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
    game.StarterGui:SetCoreGuiEnabled("Backpack", false)

    -- events
    remote_function:InvokeServer("spawn")
    user_input_service.InputBegan:Connect(
        function(input, process)
            if not process then
                if playing then
                    if input.KeyCode == Enum.KeyCode.W then
                        remote_event:FireServer("y", true)
                    elseif input.KeyCode == Enum.KeyCode.A then
                        remote_event:FireServer("x", true)
                    elseif input.KeyCode == Enum.KeyCode.S then
                        remote_event:FireServer("y", false)
                    elseif input.KeyCode == Enum.KeyCode.D then
                        remote_event:FireServer("x", false)
                    end
                end
            end
        end)
    user_input_service.InputEnded:Connect(
        function(input, process)
            if not process then
                if playing then
                    if input.KeyCode == Enum.KeyCode.W then
                        remote_event:FireServer("y", false)
                    elseif input.KeyCode == Enum.KeyCode.A then
                        remote_event:FireServer("x", false)
                    elseif input.KeyCode == Enum.KeyCode.S then
                        remote_event:FireServer("y", true)
                    elseif input.KeyCode == Enum.KeyCode.D then
                        remote_event:FireServer("x", true)
                    end
                end
            end
        end)
    run_service.RenderStepped:Connect(function()
        cam_sys:update()
        ui_sys:update()
    end)
    local play_button_ready = true
    ui_sys.screen_gui.main_menu.play_button.MouseButton1Down:Connect(
        function()
            if not playing and play_button_ready then
                play_button_ready = false
                remote_function:InvokeServer("Spawn")
                ui_sys:update_mode(2)
                cam_sys:update_mode(2)
                playing = true
                wait(5)
                play_button_ready = true
            end
        end)
end
return module
