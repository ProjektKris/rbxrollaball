--clientsideonly
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local std = require(game.ReplicatedStorage.Source.std)
local module = {}
function module.init()
    local remote_function = game.ReplicatedStorage:WaitForChild("remotes"):WaitForChild("RemoteFunction")
    local remote_event = game.ReplicatedStorage:WaitForChild("remotes"):WaitForChild("RemoteEvent")

    remote_function:InvokeServer("spawn")
    user_input_service.InputBegan:Connect(function(input, process)
        if not process then
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
    end)
    user_input_service.InputEnded:Connect(function(input, process)
        if not process then
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
    end)
    run_service.RenderStepped:Connect(function()
        
    end)
end
return module