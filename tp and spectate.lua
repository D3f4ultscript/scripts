--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[ 
    UPD:
    - Better spectate
    - Better GUI
	- Close/Open Gui with Right CTRL 
]]

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local gui = Instance.new("ScreenGui")
gui.Name = "AdvancedPlayerList"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")


local notification = Instance.new("TextLabel")
notification.Text = "Click Right CTRL to close the Gui"
notification.Size = UDim2.new(0, 250, 0, 35)
notification.Position = UDim2.new(1, -260, 1, -45)
notification.AnchorPoint = Vector2.new(1, 1)
notification.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
notification.TextColor3 = Color3.new(1, 1, 1)
notification.Font = Enum.Font.GothamMedium
notification.TextSize = 14
notification.BorderSizePixel = 0
notification.Parent = gui


spawn(function()
    wait(5)
    for i = 1, 0, -0.1 do
        notification.BackgroundTransparency = i
        notification.TextTransparency = i
        notification.Position = UDim2.new(1, -260, 1, -45 + (35 * (1 - i)))
        task.wait(0.05)
    end
    notification:Destroy()
end)


local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 450)
main.Position = UDim2.new(0, 15, 0, 15)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui


local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Text = "Player List ("..#game:GetService("Players"):GetPlayers()..")"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar


local drag = {Active = false}
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag.Start = i.Position
        drag.Pos = main.Position
        drag.Active = true
        
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                drag.Active = false
            end
        end)
    end
end)

UserInput.InputChanged:Connect(function(i)
    if drag.Active and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - drag.Start
        main.Position = UDim2.new(
            drag.Pos.X.Scale, 
            drag.Pos.X.Offset + delta.X,
            drag.Pos.Y.Scale, 
            drag.Pos.Y.Offset + delta.Y
        )
    end
end)


local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -35)
scroll.Position = UDim2.new(0, 5, 0, 30)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.Parent = main


local function CreatePlayerEntry(p)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, -5)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bg.BorderSizePixel = 0
    bg.Parent = frame


    local spec = Instance.new("TextButton")
    spec.Size = UDim2.new(0, 35, 1, -5)
    spec.Position = UDim2.new(0, 5, 0, 0)
    spec.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    spec.Text = "👁"
    spec.Font = Enum.Font.GothamMedium
    spec.TextSize = 14
    spec.Parent = bg


    local tp = Instance.new("TextButton")
    tp.Size = UDim2.new(0, 35, 1, -5)
    tp.Position = UDim2.new(1, -40, 0, 0)
    tp.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    tp.Text = "🌀"
    tp.Font = Enum.Font.GothamMedium
    tp.TextSize = 14
    tp.Parent = bg
    

    spec.MouseButton1Click:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

            camera.CameraSubject = p.Character:WaitForChild("Humanoid")
            spec.Text = "👁"
            spec.BackgroundColor3 = Color3.fromRGB(255, 50, 50)


            local stopSpecButton = Instance.new("TextButton")
            stopSpecButton.Size = UDim2.new(0, 150, 0, 30)
            stopSpecButton.Position = UDim2.new(0.5, -75, 0, 10)
            stopSpecButton.Text = "Beenden Spectate"
            stopSpecButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            stopSpecButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            stopSpecButton.Font = Enum.Font.GothamMedium
            stopSpecButton.TextSize = 14
            stopSpecButton.Parent = gui


            stopSpecButton.MouseButton1Click:Connect(function()
                camera.CameraSubject = player.Character:WaitForChild("Humanoid")
                stopSpecButton:Destroy()
                spec.Text = "👁"
                spec.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            end)
        end
    end)


    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -80, 1, 0)
    name.Position = UDim2.new(0, 40, 0, 0)
    name.Text = p.Name
    name.TextColor3 = Color3.new(1, 1, 1)
    name.Font = Enum.Font.Gotham
    name.TextSize = 13
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.BackgroundTransparency = 1
    name.Parent = bg


    tp.MouseButton1Click:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = p.Character.HumanoidRootPart.Position
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            end
        end
    end)

    return frame
end


local function UpdatePlayers()
    scroll:ClearAllChildren()
    local y = 0
    
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player then
            local entry = CreatePlayerEntry(p)
            entry.Position = UDim2.new(0, 0, 0, y)
            entry.Parent = scroll
            y += 40
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
    titleText.Text = "Player List ("..#game:GetService("Players"):GetPlayers()..")"
end


UserInput.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)


UpdatePlayers()
game:GetService("Players").PlayerAdded:Connect(UpdatePlayers)
game:GetService("Players").PlayerRemoving:Connect(UpdatePlayers)
