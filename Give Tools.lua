local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Funktion zum Suchen von Tools
local function findTools(parent)
    local tools = {}
    for _, item in ipairs(parent:GetDescendants()) do
        if item:IsA("Tool") then
            table.insert(tools, item)
        end
    end
    return tools
end

-- Funktion zum Erstellen der GUI
local function createGUI()
    -- Entferne existierende GUI, falls vorhanden
    local existingGui = playerGui:FindFirstChild("ToolSelectionGui")
    if existingGui then
        existingGui:Destroy()
    end

    -- Erstelle die GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToolSelectionGui"
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 250)
    frame.Position = UDim2.new(0.5, -100, 0.5, -125)
    frame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Tools"
    title.Parent = frame

    -- X-Button zum Schließen
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Text = "X"
    closeButton.Parent = frame
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -10, 1, -80)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollingFrame.Parent = frame

    local giveAllButton = Instance.new("TextButton")
    giveAllButton.Size = UDim2.new(1, -10, 0, 30)
    giveAllButton.Position = UDim2.new(0, 5, 1, -35)
    giveAllButton.Text = "Give all Tools"
    giveAllButton.Parent = frame

    -- Mache die GUI dragbar
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Funktion zum Aktualisieren der Tool-Liste
    local function updateToolList()
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            child:Destroy()
        end

        local tools = {}
        local allTools = {}
        table.insert(allTools, findTools(workspace))
        table.insert(allTools, findTools(ReplicatedStorage))
        table.insert(allTools, findTools(ServerStorage))

        for _, toolList in ipairs(allTools) do
            for _, tool in ipairs(toolList) do
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, -10, 0, 30)
                button.Position = UDim2.new(0, 5, 0, #tools * 35)
                button.Text = tool.Name
                button.Parent = scrollingFrame
                
                button.MouseButton1Click:Connect(function()
                    local clonedTool = tool:Clone()
                    clonedTool.Parent = player.Backpack
                end)
                
                table.insert(tools, button)
            end
        end

        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #tools * 35 + 5)
    end

    -- Funktion zum Geben aller Tools
    giveAllButton.MouseButton1Click:Connect(function()
        local allTools = {}
        table.insert(allTools, findTools(workspace))
        table.insert(allTools, findTools(ReplicatedStorage))
        table.insert(allTools, findTools(ServerStorage))

        for _, toolList in ipairs(allTools) do
            for _, tool in ipairs(toolList) do
                local clonedTool = tool:Clone()
                clonedTool.Parent = player.Backpack
            end
        end
    end)

    -- Initialisiere die Tool-Liste
    updateToolList()

    -- Aktualisiere die Tool-Liste alle 1 Sekunde
    spawn(function()
        while screenGui.Parent do
            wait(1)
            updateToolList()
        end
    end)
end

-- Funktion aufrufen, um die GUI zu erstellen
createGUI()
