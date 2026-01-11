-- Veltrix Hub UI Library
-- Created by kingveltroh

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local VeltrixHub = {}
VeltrixHub.__index = VeltrixHub

-- Configuration Manager
local ConfigManager = {
    FolderName = "VeltrixHub",
    ConfigName = "default.json"
}

function ConfigManager:Save(data)
    local success, err = pcall(function()
        if not isfolder(self.FolderName) then
            makefolder(self.FolderName)
        end
        writefile(self.FolderName .. "/" .. self.ConfigName, HttpService:JSONEncode(data))
    end)
    return success
end

function ConfigManager:Load()
    local success, result = pcall(function()
        if isfile(self.FolderName .. "/" .. self.ConfigName) then
            return HttpService:JSONDecode(readfile(self.FolderName .. "/" .. self.ConfigName))
        end
        return nil
    end)
    return success and result or nil
end

-- Create Main Hub
function VeltrixHub:CreateHub(hubName)
    local self = setmetatable({}, VeltrixHub)
    
    self.HubName = hubName or "Veltrix Hub"
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsVisible = true
    self.ToggleKeybind = Enum.KeyCode.RightControl
    self.CurrentTheme = "Red"
    self.ConfigData = {}
    
    -- Themes
    self.Themes = {
        Red = {Primary = Color3.fromRGB(255, 80, 80), Dark = Color3.fromRGB(200, 50, 50)},
        Blue = {Primary = Color3.fromRGB(80, 120, 255), Dark = Color3.fromRGB(50, 90, 200)},
        Green = {Primary = Color3.fromRGB(80, 255, 120), Dark = Color3.fromRGB(50, 200, 90)},
        Purple = {Primary = Color3.fromRGB(180, 80, 255), Dark = Color3.fromRGB(140, 50, 200)},
        Orange = {Primary = Color3.fromRGB(255, 150, 80), Dark = Color3.fromRGB(200, 110, 50)},
        Pink = {Primary = Color3.fromRGB(255, 100, 200), Dark = Color3.fromRGB(200, 70, 150)}
    }
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "VeltrixHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 550, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true
    self.MainFrame.Parent = self.ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    self.TitleBar.BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    local titleCover = Instance.new("Frame")
    titleCover.Size = UDim2.new(1, 0, 0, 25)
    titleCover.Position = UDim2.new(0, 0, 1, -25)
    titleCover.BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
    titleCover.BorderSizePixel = 0
    titleCover.Parent = self.TitleBar
    
    -- Hub Name
    local hubLabel = Instance.new("TextLabel")
    hubLabel.Size = UDim2.new(1, -100, 0, 25)
    hubLabel.Position = UDim2.new(0, 15, 0, 5)
    hubLabel.BackgroundTransparency = 1
    hubLabel.Text = self.HubName
    hubLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    hubLabel.TextSize = 20
    hubLabel.TextXAlignment = Enum.TextXAlignment.Left
    hubLabel.Font = Enum.Font.GothamBold
    hubLabel.Parent = self.TitleBar
    
    -- Creator Label
    local creatorLabel = Instance.new("TextLabel")
    creatorLabel.Size = UDim2.new(1, -100, 0, 15)
    creatorLabel.Position = UDim2.new(0, 15, 0, 30)
    creatorLabel.BackgroundTransparency = 1
    creatorLabel.Text = "by kingveltroh"
    creatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    creatorLabel.TextTransparency = 0.3
    creatorLabel.TextSize = 12
    creatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    creatorLabel.Font = Enum.Font.Gotham
    creatorLabel.Parent = self.TitleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -45, 0, 7.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.IsVisible = false
    end)
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 35, 0, 35)
    minimizeButton.Position = UDim2.new(1, -85, 0, 7.5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 20
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = self.TitleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeButton
    
    minimizeButton.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = false
        self.IsVisible = false
    end)
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 150, 1, -60)
    self.TabContainer.Position = UDim2.new(0, 10, 0, 60)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.TabContainer
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -170, 1, -70)
    self.ContentContainer.Position = UDim2.new(0, 165, 0, 60)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame
    
    -- Resize Handle
    local resizeHandle = Instance.new("ImageButton")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Image = "rbxassetid://7072706663"
    resizeHandle.ImageColor3 = Color3.fromRGB(150, 150, 150)
    resizeHandle.Parent = self.MainFrame
    
    -- Make Draggable
    local dragging, dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Make Resizable
    local resizing = false
    local resizeStart, startSize
    
    resizeHandle.MouseButton1Down:Connect(function()
        resizing = true
        resizeStart = UserInputService:GetMouseLocation()
        startSize = self.MainFrame.Size
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentMouse = UserInputService:GetMouseLocation()
            local delta = currentMouse - resizeStart
            
            local newWidth = math.max(450, startSize.X.Offset + delta.X)
            local newHeight = math.max(350, startSize.Y.Offset + delta.Y)
            
            self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    -- Toggle UI with Keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == self.ToggleKeybind then
            self.IsVisible = not self.IsVisible
            self.MainFrame.Visible = self.IsVisible
        end
    end)
    
    -- Load saved config
    local savedConfig = ConfigManager:Load()
    if savedConfig then
        if savedConfig.Theme then
            self:SetTheme(savedConfig.Theme)
        end
        if savedConfig.Keybind then
            self.ToggleKeybind = Enum.KeyCode[savedConfig.Keybind]
        end
        if savedConfig.Size then
            self.MainFrame.Size = UDim2.new(0, savedConfig.Size.X, 0, savedConfig.Size.Y)
        end
        if savedConfig.Position then
            self.MainFrame.Position = UDim2.new(0, savedConfig.Position.X, 0, savedConfig.Position.Y)
        end
    end
    
    print("====================================")
    print("Veltrix Hub Loaded!")
    print("Created by kingveltroh")
    print("Press " .. self.ToggleKeybind.Name .. " to toggle UI")
    print("====================================")
    
    return self
end

-- Set Theme
function VeltrixHub:SetTheme(themeName)
    if not self.Themes[themeName] then return end
    
    self.CurrentTheme = themeName
    local theme = self.Themes[themeName]
    
    TweenService:Create(self.TitleBar, TweenInfo.new(0.3), {
        BackgroundColor3 = theme.Primary
    }):Play()
    
    TweenService:Create(self.TitleBar:FindFirstChild("Frame"), TweenInfo.new(0.3), {
        BackgroundColor3 = theme.Primary
    }):Play()
    
    -- Update all active tabs and toggles
    for _, tab in ipairs(self.Tabs) do
        if tab.Button.BackgroundColor3 ~= Color3.fromRGB(35, 35, 40) then
            TweenService:Create(tab.Button, TweenInfo.new(0.3), {
                BackgroundColor3 = theme.Primary
            }):Play()
        end
    end
    
    self:SaveConfig()
end

-- Save Config
function VeltrixHub:SaveConfig()
    local configData = {
        Theme = self.CurrentTheme,
        Keybind = self.ToggleKeybind.Name,
        Size = {
            X = self.MainFrame.Size.X.Offset,
            Y = self.MainFrame.Size.Y.Offset
        },
        Position = {
            X = self.MainFrame.Position.X.Offset,
            Y = self.MainFrame.Position.Y.Offset
        }
    }
    
    for key, value in pairs(self.ConfigData) do
        configData[key] = value
    end
    
    ConfigManager:Save(configData)
end

-- Create Tab
function VeltrixHub:CreateTab(tabName)
    local tab = {
        Name = tabName,
        Elements = {},
        Container = nil,
        Button = nil
    }
    
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    tabButton.Text = tabName
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    -- Tab Content Frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = self.Themes[self.CurrentTheme].Primary
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentFrame
    
    tab.Container = contentFrame
    tab.Button = tabButton
    
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    return tab
end

-- Select Tab
function VeltrixHub:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Container.Visible = false
        t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    end
    
    tab.Container.Visible = true
    tab.Button.BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
    self.CurrentTab = tab
end

-- Create Toggle
function VeltrixHub:CreateToggle(tab, labelText, defaultValue, callback)
    local configKey = "Toggle_" .. labelText:gsub(" ", "_")
    
    -- Load saved value
    local savedConfig = ConfigManager:Load()
    if savedConfig and savedConfig[configKey] ~= nil then
        defaultValue = savedConfig[configKey]
    end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -10, 0, 45)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = tab.Container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 45, 0, 22)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -11)
    toggleButton.BackgroundColor3 = defaultValue and self.Themes[self.CurrentTheme].Primary or Color3.fromRGB(50, 50, 55)
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local isOn = defaultValue
    
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isOn and self.Themes[self.CurrentTheme].Primary or Color3.fromRGB(50, 50, 55)
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
            Position = isOn and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
        
        self.ConfigData[configKey] = isOn
        self:SaveConfig()
        
        callback(isOn)
    end)
    
    -- Call callback with default value
    if defaultValue then
        callback(defaultValue)
    end
    
    return toggleFrame
end

-- Create Button
function VeltrixHub:CreateButton(tab, buttonText, callback)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Size = UDim2.new(1, -10, 0, 45)
    buttonFrame.BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Text = buttonText
    buttonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonFrame.TextSize = 14
    buttonFrame.Font = Enum.Font.GothamBold
    buttonFrame.AutoButtonColor = false
    buttonFrame.Parent = tab.Container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = buttonFrame
    
    buttonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Themes[self.CurrentTheme].Dark
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(buttonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
        }):Play()
        
        callback()
    end)
    
    return buttonFrame
end

-- Create Slider
function VeltrixHub:CreateSlider(tab, labelText, minValue, maxValue, defaultValue, callback)
    local configKey = "Slider_" .. labelText:gsub(" ", "_")
    
    -- Load saved value
    local savedConfig = ConfigManager:Load()
    if savedConfig and savedConfig[configKey] ~= nil then
        defaultValue = savedConfig[configKey]
    end
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 55)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = tab.Container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = self.Themes[self.CurrentTheme].Primary
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -30, 0, 5)
    sliderBar.Position = UDim2.new(0, 15, 1, -18)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2.5)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = self.Themes[self.CurrentTheme].Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2.5)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 18, 0, 18)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -9, 0.5, -9)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderBar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = minValue + (maxValue - minValue) * relativeX
        value = math.floor(value * 10) / 10
        
        valueLabel.Text = tostring(value)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativeX, -9, 0.5, -9)
        
        self.ConfigData[configKey] = value
        self:SaveConfig()
        
        callback(value)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
        end
    end)
    
    -- Call callback with default value
    if defaultValue then
        callback(defaultValue)
    end
    
    return sliderFrame
end

-- Create Label
function VeltrixHub:CreateLabel(tab, labelText)
    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, -10, 0, 35)
    labelFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    labelFrame.BorderSizePixel = 0
    labelFrame.Parent = tab.Container
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = labelFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = labelFrame
    
    return labelFrame
end

-- Create Dropdown
function VeltrixHub:CreateDropdown(tab, labelText, options, defaultOption, callback)
    local configKey = "Dropdown_" .. labelText:gsub(" ", "_")
    
    -- Load saved value
    local savedConfig = ConfigManager:Load()
    if savedConfig and savedConfig[configKey] then
        defaultOption = savedConfig[
