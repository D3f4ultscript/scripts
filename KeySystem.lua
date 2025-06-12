-- Key System für Loadstring und Executor
-- Kompakter Code für die Verwendung in anderen Skripten
-- Liest den Key aus der separaten KeyConfig.lua Datei

-- Funktion für das Key System
local function KeySystemFunction()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    
    -- Funktion zum Laden der KeyConfig
    local function loadKeyConfig()
        local keyConfig = nil
        local success, result = pcall(function()
            -- Versuche zuerst, die Datei im selben Verzeichnis zu laden
            return loadfile("KeyConfig.lua")()
        end)
        
        if not success then
            -- Versuche mit absolutem Pfad
            success, result = pcall(function()
                return loadfile("c:\\Users\\Hannes\\Downloads\\Scripts\\Normal\\KeyConfig.lua")()
            end)
        end
        
        if success and type(result) == "table" and result.KEY then
            print("KeyConfig.lua erfolgreich geladen. Key: " .. result.KEY)
            return result.KEY
        else
            print("KeyConfig.lua konnte nicht geladen werden. Verwende Fallback-Key.")
            return "DEMO123" -- Fallback-Key
        end
    end
    
    -- Lade den Key beim Start
    local currentKey = loadKeyConfig()
    
    -- Konfiguration
    local config = {
        title = "Key System",
        loadingText = "Checking game status...",
        keySystemText = "Enter your key to continue",
        getKeyButtonText = "Get Key",
        checkKeyButtonText = "Check Key",
        loadingDuration = 3, -- Sekunden
        validKey = currentKey -- Key aus der externen Konfiguration
    }
    
    -- UI erstellen
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystemGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Loading Frame
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 300, 0, 150)
    loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = screenGui
    
    -- Abgerundete Ecken
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = loadingFrame
    
    -- Titel
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = config.title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Parent = loadingFrame
    
    -- Loading Text
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Name = "LoadingLabel"
    loadingLabel.Size = UDim2.new(1, 0, 0, 20)
    loadingLabel.Position = UDim2.new(0, 0, 0, 50)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Font = Enum.Font.Gotham
    loadingLabel.Text = config.loadingText
    loadingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingLabel.TextSize = 16
    loadingLabel.Parent = loadingFrame
    
    -- Loading Bar Hintergrund
    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Name = "LoadingBarBg"
    loadingBarBg.Size = UDim2.new(0.8, 0, 0, 20)
    loadingBarBg.Position = UDim2.new(0.1, 0, 0, 80)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadingBarBg.BorderSizePixel = 0
    loadingBarBg.Parent = loadingFrame
    
    -- Loading Bar Hintergrund Ecken
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 5)
    barCorner.Parent = loadingBarBg
    
    -- Loading Bar Füllung
    local loadingBarFill = Instance.new("Frame")
    loadingBarFill.Name = "LoadingBarFill"
    loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    loadingBarFill.BackgroundColor3 = Color3.fromRGB(0, 132, 255)
    loadingBarFill.BorderSizePixel = 0
    loadingBarFill.Parent = loadingBarBg
    
    -- Loading Bar Füllung Ecken
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = loadingBarFill
    
    -- Status Text
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 0, 0, 110)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "0%"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextSize = 14
    statusLabel.Parent = loadingFrame
    
    -- Key System Frame (anfangs versteckt)
    local keySystemFrame = Instance.new("Frame")
    keySystemFrame.Name = "KeySystemFrame"
    keySystemFrame.Size = UDim2.new(0, 300, 0, 180)
    keySystemFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    keySystemFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    keySystemFrame.BorderSizePixel = 0
    keySystemFrame.Visible = false
    keySystemFrame.Parent = screenGui
    
    -- Key System Ecken
    local keySystemCorner = Instance.new("UICorner")
    keySystemCorner.CornerRadius = UDim.new(0, 10)
    keySystemCorner.Parent = keySystemFrame
    
    -- Key System Titel
    local keySystemTitle = Instance.new("TextLabel")
    keySystemTitle.Name = "KeySystemTitle"
    keySystemTitle.Size = UDim2.new(1, 0, 0, 40)
    keySystemTitle.Position = UDim2.new(0, 0, 0, 10)
    keySystemTitle.BackgroundTransparency = 1
    keySystemTitle.Font = Enum.Font.GothamBold
    keySystemTitle.Text = config.title
    keySystemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    keySystemTitle.TextSize = 24
    keySystemTitle.Parent = keySystemFrame
    
    -- Key System Text
    local keySystemText = Instance.new("TextLabel")
    keySystemText.Name = "KeySystemText"
    keySystemText.Size = UDim2.new(1, 0, 0, 20)
    keySystemText.Position = UDim2.new(0, 0, 0, 50)
    keySystemText.BackgroundTransparency = 1
    keySystemText.Font = Enum.Font.Gotham
    keySystemText.Text = config.keySystemText
    keySystemText.TextColor3 = Color3.fromRGB(200, 200, 200)
    keySystemText.TextSize = 16
    keySystemText.Parent = keySystemFrame
    
    -- Key Eingabefeld
    local keyInputBox = Instance.new("TextBox")
    keyInputBox.Name = "KeyInputBox"
    keyInputBox.Size = UDim2.new(0.8, 0, 0, 30)
    keyInputBox.Position = UDim2.new(0.1, 0, 0, 80)
    keyInputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keyInputBox.BorderSizePixel = 0
    keyInputBox.Font = Enum.Font.Gotham
    keyInputBox.PlaceholderText = "Enter key here..."
    keyInputBox.Text = ""
    keyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInputBox.TextSize = 14
    keyInputBox.ClearTextOnFocus = false
    keyInputBox.Parent = keySystemFrame
    
    -- Eingabefeld Ecken
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 5)
    inputBoxCorner.Parent = keyInputBox
    
    -- Get Key Button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Size = UDim2.new(0.38, 0, 0, 30)
    getKeyButton.Position = UDim2.new(0.1, 0, 0, 130)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 132, 255) -- Blau
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Font = Enum.Font.GothamBold
    getKeyButton.Text = config.getKeyButtonText
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.TextSize = 14
    getKeyButton.Parent = keySystemFrame
    
    -- Get Key Button Ecken
    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 5)
    getKeyCorner.Parent = getKeyButton
    
    -- Check Key Button
    local checkKeyButton = Instance.new("TextButton")
    checkKeyButton.Name = "CheckKeyButton"
    checkKeyButton.Size = UDim2.new(0.38, 0, 0, 30)
    checkKeyButton.Position = UDim2.new(0.52, 0, 0, 130)
    checkKeyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 60) -- Grün
    checkKeyButton.BorderSizePixel = 0
    checkKeyButton.Font = Enum.Font.GothamBold
    checkKeyButton.Text = config.checkKeyButtonText
    checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkKeyButton.TextSize = 14
    checkKeyButton.Parent = keySystemFrame
    
    -- Check Key Button Ecken
    local checkKeyCorner = Instance.new("UICorner")
    checkKeyCorner.CornerRadius = UDim.new(0, 5)
    checkKeyCorner.Parent = checkKeyButton
    
    -- Status Nachricht
    local statusMessage = Instance.new("TextLabel")
    statusMessage.Name = "StatusMessage"
    statusMessage.Size = UDim2.new(1, 0, 0, 20)
    statusMessage.Position = UDim2.new(0, 0, 0, 170)
    statusMessage.BackgroundTransparency = 1
    statusMessage.Font = Enum.Font.Gotham
    statusMessage.Text = ""
    statusMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusMessage.TextSize = 14
    statusMessage.Visible = false
    statusMessage.Parent = keySystemFrame
    
    -- ScreenGui zum PlayerGui hinzufügen
    local player = Players.LocalPlayer
    if player then
        screenGui.Parent = player:WaitForChild("PlayerGui")
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Lade-Animation starten
    local loadingTween = TweenService:Create(
        loadingBarFill,
        TweenInfo.new(config.loadingDuration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    
    loadingTween:Play()
    
    -- Prozent-Text aktualisieren
    local startTime = tick()
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / config.loadingDuration, 1)
        local percentage = math.floor(progress * 100)
        
        statusLabel.Text = percentage .. "%"
        
        if progress >= 1 then
            connection:Disconnect()
            -- Key System anzeigen
            loadingFrame.Visible = false
            keySystemFrame.Visible = true
            
            -- Fade-In Effekt
            keySystemFrame.BackgroundTransparency = 1
            for i = 1, 0, -0.1 do
                keySystemFrame.BackgroundTransparency = i
                wait(0.02)
            end
            keySystemFrame.BackgroundTransparency = 0
        end
    end)
    
    -- Button-Funktionalität einrichten
    getKeyButton.MouseButton1Click:Connect(function()
        -- Versuche, den Key neu zu laden
        local newKey = loadKeyConfig()
        if newKey ~= config.validKey then
            config.validKey = newKey
            statusMessage.Text = "Key wurde aktualisiert: " .. newKey
        else
            statusMessage.Text = "Key ist bereits aktuell: " .. newKey
        end
        
        -- Benachrichtigung anzeigen
        local success, result = pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Key Information",
                Text = "Der Key wurde aus KeyConfig.lua geladen",
                Duration = 5
            })
        end)
        
        if not success then
            warn("Failed to show notification:", result)
        end
        statusMessage.TextColor3 = Color3.fromRGB(0, 255, 0)
        statusMessage.Visible = true
        wait(2)
        statusMessage.Visible = false
    end)
    
    -- Key überprüfen
    local keyValidated = false
    
    checkKeyButton.MouseButton1Click:Connect(function()
        local keyInput = keyInputBox.Text
        
        if keyInput == "" then
            statusMessage.Text = "Please enter a key!"
            statusMessage.TextColor3 = Color3.fromRGB(255, 50, 50)
            statusMessage.Visible = true
            return
        end
        
        -- Key-Validierung
        statusMessage.Text = "Checking key..."
        statusMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusMessage.Visible = true
        
        wait(1) -- Server-Verzögerung simulieren
        
        if keyInput == config.validKey then
            statusMessage.Text = "Key valid! Loading script..."
            statusMessage.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(1)
            screenGui:Destroy()
            keyValidated = true
        else
            statusMessage.Text = "Invalid key! Please try again."
            statusMessage.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
    
    -- Warten, bis der Key validiert wurde
    while not keyValidated do
        wait(0.1)
    end
    
    -- Wenn der Code hier ankommt, wurde der Key erfolgreich validiert
    return true
end

-- Dual-Mode: Direkte Ausführung für Executors und Modul-Export für loadstring
if getgenv and getgenv().KeySystemAsModule then
    -- Als Modul zurückgeben (für loadstring)
    return KeySystemFunction
else
    -- Direkt ausführen (für Executors)
    KeySystemFunction()
    return true
end