-- Simple Popup UI with Discord Copy Button
local discordLink = "https://discord.gg/2ynN9zcVFk" -- <-- HIER DEIN DISCORD LINK EINSETZEN

-- UI erstellen
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiscordPopup"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 60)
label.Position = UDim2.new(0, 10, 0, 10)
label.Text = "You must join our Discord to use this script and get more goty scripts!"
label.TextWrapped = true
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 16
label.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 40)
button.Position = UDim2.new(0.5, -100, 1, -60)
button.Text = "Copy Discord Link"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
button.Font = Enum.Font.Gotham
button.TextSize = 16
button.Parent = frame

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 8)

-- Funktion zum Kopieren
button.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    button.Text = "Copied!"
    wait(1.5)
    button.Text = "Copy Discord Link"
end)
