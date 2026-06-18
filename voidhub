-- =============================================
-- OverdriveHub UI Library - Полная версия
-- Стиль как на твоём скриншоте + функционал Rayfield
-- =============================================

local OverdriveHub = {}
OverdriveHub.__index = OverdriveHub

function OverdriveHub:CreateWindow(config)
    local Window = setmetatable({}, OverdriveHub)

    local TS = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OverdriveHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 740, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -370, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(13, 15, 28)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 48)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 26))
    }
    Gradient.Rotation = 135
    Gradient.Parent = MainFrame

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 62)
    TopBar.BackgroundColor3 = Color3.fromRGB(9, 10, 22)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 16)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Text = config.Title or "OVERDRIVE H"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 26
    Title.TextColor3 = Color3.fromRGB(90, 170, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 25, 0, 15)
    Title.Size = UDim2.new(0.45, 0, 0, 35)
    Title.Parent = TopBar

    local Version = Instance.new("TextLabel")
    Version.Text = config.Version or "v3.4 | Murder Mystery 2"
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 14
    Version.TextColor3 = Color3.fromRGB(110, 120, 150)
    Version.BackgroundTransparency = 1
    Version.Position = UDim2.new(0, 25, 0, 40)
    Version.Size = UDim2.new(0.45, 0, 0, 20)
    Version.Parent = TopBar

    -- Draggable
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- Tabs
    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(0, 160, 1, -62)
    TabHolder.Position = UDim2.new(0, 0, 0, 62)
    TabHolder.BackgroundColor3 = Color3.fromRGB(11, 13, 24)
    TabHolder.ScrollBarThickness = 4
    TabHolder.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabHolder

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -160, 1, -62)
    ContentHolder.Position = UDim2.new(0, 160, 0, 62)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    Window.Tabs = {}
    Window.CurrentTab = nil

    function Window:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -20, 0, 48)
        TabButton.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 16
        TabButton.TextColor3 = Color3.fromRGB(170, 180, 210)
        TabButton.Parent = TabHolder

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 10)
        BtnCorner.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
        TabContent.Visible = false
        TabContent.Parent = ContentHolder

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        local Tab = { Button = TabButton, Content = TabContent }

        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
                Window.CurrentTab.Button.TextColor3 = Color3.fromRGB(170, 180, 210)
            end
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end)

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end

        return Tab
    end

    -- ==================== ELEMENTS ====================

    function Window:CreateButton(tab, text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -24, 0, 52)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
        Btn.Text = text
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 16
        Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
        Btn.Parent = tab.Content

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            TS:Create(Btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(80, 130, 220)}):Play()
            task.delay(0.1, function()
                TS:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 30, 55)}):Play()
            end)
            callback()
        end)
    end

    function Window:CreateToggle(tab, text, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -24, 0, 52)
        Frame.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
        Frame.Parent = tab.Content

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Text = text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 16
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 16, 0, 0)
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.new(0, 48, 0, 28)
        Toggle.Position = UDim2.new(1, -64, 0.5, -14)
        Toggle.BackgroundColor3 = default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(55, 55, 65)
        Toggle.Text = ""
        Toggle.Parent = Frame

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(1, 0)
        TCorner.Parent = Toggle

        local enabled = default

        Toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            TS:Create(Toggle, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                BackgroundColor3 = enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(55, 55, 65)
            }):Play()
            callback(enabled)
        end)
    end

    function Window:CreateSlider(tab, text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, -24, 0, 68)
        Frame.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
        Frame.Parent = tab.Content

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Text = text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 16
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0, 16, 0, 8)
        Label.Size = UDim2.new(1, -32, 0, 20)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Text = tostring(default)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.TextSize = 15
        ValueLabel.TextColor3 = Color3.fromRGB(140, 190, 255)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -70, 0, 8)
        ValueLabel.Size = UDim2.new(0, 60, 0, 20)
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Frame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -32, 0, 8)
        Bar.Position = UDim2.new(0, 16, 1, -24)
        Bar.BackgroundColor3 = Color3.fromRGB(40, 45, 70)
        Bar.Parent = Frame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(0, 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
        Fill.Parent = Bar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local value = default
        local dragging = false

        local function update(val)
            value = math.clamp(val, min, max)
            local percent = (value - min) / (max - min)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(math.floor(value))
            callback(value)
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local mousePos = UIS:GetMouseLocation().X
                local barPos = Bar.AbsolutePosition.X
                local barSize = Bar.AbsoluteSize.X
                update(min + ((mousePos - barPos) / barSize) * (max - min))
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UIS:GetMouseLocation().X
                local barPos = Bar.AbsolutePosition.X
                local barSize = Bar.AbsoluteSize.X
                update(min + ((mousePos - barPos) / barSize) * (max - min))
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)

        update(default)
    end

    function Window:CreateDropdown(tab, text, options, default, callback)
        -- Простая реализация Dropdown (можно улучшить)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -24, 0, 52)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 30, 55)
        Btn.Text = text .. ": " .. (default or options[1])
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextSize = 16
        Btn.TextColor3 = Color3.fromRGB(230, 230, 235)
        Btn.Parent = tab.Content

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            -- Здесь можно добавить полноценный дропдаун, но для простоты — принт
            print("Dropdown:", text, options)
            callback(options[1])
        end)
    end

    function Window:CreateLabel(tab, text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -24, 0, 40)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 16
        Label.TextColor3 = Color3.fromRGB(200, 210, 230)
        Label.TextWrapped = true
        Label.Parent = tab.Content
    end

    function Window:CreateSection(tab, text)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, -24, 0, 36)
        Section.BackgroundTransparency = 1
        Section.Text = "— " .. text .. " —"
        Section.Font = Enum.Font.GothamBold
        Section.TextSize = 15
        Section.TextColor3 = Color3.fromRGB(100, 160, 255)
        Section.Parent = tab.Content
    end

    -- Notification
    function Window:Notify(title, text, duration)
        duration = duration or 4
        local Notif = Instance.new("Frame")
        Notif.Size = UDim2.new(0, 280, 0, 80)
        Notif.Position = UDim2.new(1, -300, 1, -100)
        Notif.BackgroundColor3 = Color3.fromRGB(15, 18, 35)
        Notif.Parent = ScreenGui

        local NC = Instance.new("UICorner")
        NC.CornerRadius = UDim.new(0, 12)
        NC.Parent = Notif

        local TitleL = Instance.new("TextLabel")
        TitleL.Text = title
        TitleL.Font = Enum.Font.GothamBold
        TitleL.TextSize = 16
        TitleL.TextColor3 = Color3.fromRGB(100, 190, 255)
        TitleL.BackgroundTransparency = 1
        TitleL.Position = UDim2.new(0, 12, 0, 8)
        TitleL.Size = UDim2.new(1, -24, 0, 20)
        TitleL.Parent = Notif

        local TextL = Instance.new("TextLabel")
        TextL.Text = text
        TextL.Font = Enum.Font.Gotham
        TextL.TextSize = 14
        TextL.TextColor3 = Color3.fromRGB(200, 200, 220)
        TextL.BackgroundTransparency = 1
        TextL.Position = UDim2.new(0, 12, 0, 32)
        TextL.Size = UDim2.new(1, -24, 0, 40)
        TextL.TextWrapped = true
        TextL.Parent = Notif

        TS:Create(Notif, TweenInfo.new(0.4), {Position = UDim2.new(1, -300, 1, -100 - (#ScreenGui:GetChildren()*90)}):Play()

        task.delay(duration, function()
            TS:Create(Notif, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, Notif.Position.Y.Offset)}):Play()
            task.delay(0.6, function() Notif:Destroy() end)
        end)
    end

    print("✅ OverdriveHub Library (Full) загружена!")
    return Window
end

return OverdriveHub
