local Library = {}

-- Сервисы
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Настройки анимаций
local TweenConfig = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Защита от дублирования интерфейса
for _, oldGui in pairs(CoreGui:GetChildren()) do
    if oldGui.Name == "OverdriveUI_Library" then
        oldGui:Destroy()
    end
end

-- Главная функция создания окна
function Library:CreateWindow(WindowConfig)
    local WindowName = WindowConfig.Name or "OVERDRIVE H"
    local Version = WindowConfig.Version or "v3.4"
    
    local OverdriveUI_Library = Instance.new("ScreenGui")
    OverdriveUI_Library.Name = "OverdriveUI_Library"
    OverdriveUI_Library.Parent = CoreGui
    OverdriveUI_Library.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = OverdriveUI_Library
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(90, 40, 150)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBar.BackgroundTransparency = 1.000
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1.000
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18.000
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Name = "VersionLabel"
    VersionLabel.Parent = TopBar
    VersionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    VersionLabel.BackgroundTransparency = 1.000
    VersionLabel.Position = UDim2.new(0, 15, 0, -5)
    VersionLabel.Size = UDim2.new(0, 200, 0, 15)
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.Text = Version .. " | Murder Mystery 2 | .gg/overdrivehub"
    VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    VersionLabel.TextSize = 10.000
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Информация о пользователе (Верхний правый угол)
    local UserInfoFrame = Instance.new("Frame")
    UserInfoFrame.Name = "UserInfoFrame"
    UserInfoFrame.Parent = TopBar
    UserInfoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserInfoFrame.BackgroundTransparency = 1.000
    UserInfoFrame.Position = UDim2.new(1, -160, 0, 5)
    UserInfoFrame.Size = UDim2.new(0, 150, 0, 30)

    local LoggedInAs = Instance.new("TextLabel")
    LoggedInAs.Name = "LoggedInAs"
    LoggedInAs.Parent = UserInfoFrame
    LoggedInAs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LoggedInAs.BackgroundTransparency = 1.000
    LoggedInAs.Position = UDim2.new(0, 0, 0, 0)
    LoggedInAs.Size = UDim2.new(1, -35, 0, 12)
    LoggedInAs.Font = Enum.Font.Gotham
    LoggedInAs.Text = "Logged in as"
    LoggedInAs.TextColor3 = Color3.fromRGB(150, 150, 150)
    LoggedInAs.TextSize = 10.000
    LoggedInAs.TextXAlignment = Enum.TextXAlignment.Right

    local UserNameLabel = Instance.new("TextLabel")
    UserNameLabel.Name = "UserNameLabel"
    UserNameLabel.Parent = UserInfoFrame
    UserNameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserNameLabel.BackgroundTransparency = 1.000
    UserNameLabel.Position = UDim2.new(0, 0, 0, 12)
    UserNameLabel.Size = UDim2.new(1, -35, 0, 18)
    UserNameLabel.Font = Enum.Font.GothamBold
    UserNameLabel.Text = LocalPlayer.Name
    UserNameLabel.TextColor3 = Color3.fromRGB(40, 180, 130)
    UserNameLabel.TextSize = 14.000
    UserNameLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Секция с аватаром (внутри центральной области слева)
    local ProfileCard = Instance.new("Frame")
    ProfileCard.Name = "ProfileCard"
    ProfileCard.Parent = MainFrame
    ProfileCard.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ProfileCard.BackgroundTransparency = 0.5
    ProfileCard.Position = UDim2.new(0, 15, 0, 60)
    ProfileCard.Size = UDim2.new(0, 200, 0, 60)

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 8)
    ProfileCorner.Parent = ProfileCard

    local ProfileStroke = Instance.new("UIStroke")
    ProfileStroke.Color = Color3.fromRGB(120, 60, 180)
    ProfileStroke.Thickness = 1
    ProfileStroke.Parent = ProfileCard

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Name = "AvatarImage"
    AvatarImage.Parent = ProfileCard
    AvatarImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AvatarImage.BackgroundTransparency = 1.000
    AvatarImage.Position = UDim2.new(0, 10, 0, 10)
    AvatarImage.Size = UDim2.new(0, 40, 0, 40)
    AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 20)
    AvatarCorner.Parent = AvatarImage

    local ProfileName = Instance.new("TextLabel")
    ProfileName.Name = "ProfileName"
    ProfileName.Parent = ProfileCard
    ProfileName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProfileName.BackgroundTransparency = 1.000
    ProfileName.Position = UDim2.new(0, 60, 0, 10)
    ProfileName.Size = UDim2.new(0, 130, 0, 20)
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.Text = LocalPlayer.DisplayName
    ProfileName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ProfileName.TextSize = 14.000
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left

    local ProfileRank = Instance.new("TextLabel")
    ProfileRank.Name = "ProfileRank"
    ProfileRank.Parent = ProfileCard
    ProfileRank.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProfileRank.BackgroundTransparency = 1.000
    ProfileRank.Position = UDim2.new(0, 60, 0, 30)
    ProfileRank.Size = UDim2.new(0, 130, 0, 15)
    ProfileRank.Font = Enum.Font.Gotham
    ProfileRank.Text = "Premium & Exclusive"
    ProfileRank.TextColor3 = Color3.fromRGB(0, 80, 255)
    ProfileRank.TextSize = 11.000
    ProfileRank.TextXAlignment = Enum.TextXAlignment.Left

    -- Секция Статистики (Справа)
    local StatsContainer = Instance.new("Frame")
    StatsContainer.Name = "StatsContainer"
    StatsContainer.Parent = MainFrame
    StatsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StatsContainer.BackgroundTransparency = 1.000
    StatsContainer.Position = UDim2.new(1, -215, 0, 60)
    StatsContainer.Size = UDim2.new(0, 200, 0, 150)

    -- FPS Панель
    local FPSCard = Instance.new("Frame")
    FPSCard.Name = "FPSCard"
    FPSCard.Parent = StatsContainer
    FPSCard.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    FPSCard.BackgroundTransparency = 0.5
    FPSCard.Position = UDim2.new(0, 0, 0, 0)
    FPSCard.Size = UDim2.new(1, 0, 0, 65)

    local FPSCorner = Instance.new("UICorner")
    FPSCorner.CornerRadius = UDim.new(0, 8)
    FPSCorner.Parent = FPSCard

    local FPSStroke = Instance.new("UIStroke")
    FPSStroke.Color = Color3.fromRGB(50, 100, 150)
    FPSStroke.Thickness = 1
    FPSStroke.Parent = FPSCard

    local FPSTitle = Instance.new("TextLabel")
    FPSTitle.Name = "FPSTitle"
    FPSTitle.Parent = FPSCard
    FPSTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FPSTitle.BackgroundTransparency = 1.000
    FPSTitle.Position = UDim2.new(0, 15, 0, 10)
    FPSTitle.Size = UDim2.new(0, 50, 0, 15)
    FPSTitle.Font = Enum.Font.Gotham
    FPSTitle.Text = "FPS"
    FPSTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    FPSTitle.TextSize = 12.000
    FPSTitle.TextXAlignment = Enum.TextXAlignment.Left

    local FPSValue = Instance.new("TextLabel")
    FPSValue.Name = "FPSValue"
    FPSValue.Parent = FPSCard
    FPSValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FPSValue.BackgroundTransparency = 1.000
    FPSValue.Position = UDim2.new(0, 0, 0, 25)
    FPSValue.Size = UDim2.new(1, 0, 0, 40)
    FPSValue.Font = Enum.Font.GothamBold
    FPSValue.Text = "0.00"
    FPSValue.TextColor3 = Color3.fromRGB(50, 255, 100)
    FPSValue.TextSize = 24.000

    -- Network Панель
    local PingCard = Instance.new("Frame")
    PingCard.Name = "PingCard"
    PingCard.Parent = StatsContainer
    PingCard.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    PingCard.BackgroundTransparency = 0.5
    PingCard.Position = UDim2.new(0, 0, 0, 80)
    PingCard.Size = UDim2.new(1, 0, 0, 65)

    local PingCorner = Instance.new("UICorner")
    PingCorner.CornerRadius = UDim.new(0, 8)
    PingCorner.Parent = PingCard

    local PingStroke = Instance.new("UIStroke")
    PingStroke.Color = Color3.fromRGB(150, 50, 100)
    PingStroke.Thickness = 1
    PingStroke.Parent = PingCard

    local PingTitle = Instance.new("TextLabel")
    PingTitle.Name = "PingTitle"
    PingTitle.Parent = PingCard
    PingTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PingTitle.BackgroundTransparency = 1.000
    PingTitle.Position = UDim2.new(0, 15, 0, 10)
    PingTitle.Size = UDim2.new(0, 100, 0, 15)
    PingTitle.Font = Enum.Font.Gotham
    PingTitle.Text = "Network Latency"
    PingTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    PingTitle.TextSize = 12.000
    PingTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PingValue = Instance.new("TextLabel")
    PingValue.Name = "PingValue"
    PingValue.Parent = PingCard
    PingValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PingValue.BackgroundTransparency = 1.000
    PingValue.Position = UDim2.new(0, 0, 0, 25)
    PingValue.Size = UDim2.new(1, 0, 0, 40)
    PingValue.Font = Enum.Font.GothamBold
    PingValue.Text = "0.00ms"
    PingValue.TextColor3 = Color3.fromRGB(255, 50, 50)
    PingValue.TextSize = 24.000

    -- Контейнер для вкладок (Снизу)
    local BottomNav = Instance.new("Frame")
    BottomNav.Name = "BottomNav"
    BottomNav.Parent = MainFrame
    BottomNav.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BottomNav.BackgroundTransparency = 1.000
    BottomNav.Position = UDim2.new(0, 0, 1, -70)
    BottomNav.Size = UDim2.new(1, 0, 0, 50)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = BottomNav
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabContainer.BackgroundTransparency = 1.000
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0.5, -200, 0, 0)
    TabContainer.Size = UDim2.new(0, 400, 1, 0)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    TabContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 10)

    -- Контейнер для страниц
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PagesContainer.BackgroundTransparency = 1.000
    PagesContainer.Position = UDim2.new(0, 15, 0, 130)
    PagesContainer.Size = UDim2.new(1, -245, 0, 140)
    PagesContainer.ClipsDescendants = true

    -- Логика перетаскивания окна (Drag)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Обновление FPS и Пинга
    local TimeFunction = RunService:IsRunning() and time or os.clock
    local LastIteration, Start
    local FrameUpdateTable = {}

    local function UpdateFPS()
        LastIteration = TimeFunction()
        for Index = #FrameUpdateTable, 1, -1 do
            FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
        end
        FrameUpdateTable[1] = LastIteration
        local CurrentFPS = (TimeFunction() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (TimeFunction() - Start))
        CurrentFPS = math.floor(CurrentFPS)
        FPSValue.Text = string.format("%.2f", CurrentFPS)
    end

    Start = TimeFunction()
    RunService.RenderStepped:Connect(UpdateFPS)

    task.spawn(function()
        while task.wait(1) do
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            PingValue.Text = string.format("%.2fms", ping)
        end
    end)

    local Window = {}
    local CurrentTab = nil

    -- Функция добавления новой вкладки
    function Window:CreateTab(TabName, IconId)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName .. "_Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 80, 70)
        TabButton.BackgroundTransparency = 0.6
        TabButton.Size = UDim2.new(0, 40, 0, 40)
        TabButton.Text = ""
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Color = Color3.fromRGB(40, 180, 130)
        TabStroke.Thickness = 1
        TabStroke.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.BackgroundTransparency = 1.000
        TabIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Image = "rbxassetid://" .. tostring(IconId)
        TabIcon.ImageColor3 = Color3.fromRGB(40, 180, 130)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = TabName .. "_Page"
        Page.Parent = PagesContainer
        Page.Active = true
        Page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Page.BackgroundTransparency = 1.000
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.ScrollBarThickness = 2
        Page.Visible = false

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 5)

        -- Анимации для вкладки
        TabButton.MouseEnter:Connect(function()
            TweenService:Create(TabButton, TweenConfig, {BackgroundColor3 = Color3.fromRGB(40, 100, 90)}):Play()
            TweenService:Create(TabStroke, TweenConfig, {Color = Color3.fromRGB(60, 220, 160)}):Play()
        end)

        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= Page then
                TweenService:Create(TabButton, TweenConfig, {BackgroundColor3 = Color3.fromRGB(30, 80, 70)}):Play()
                TweenService:Create(TabStroke, TweenConfig, {Color = Color3.fromRGB(40, 180, 130)}):Play()
            end
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(PagesContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            for _, child in pairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenConfig, {BackgroundColor3 = Color3.fromRGB(30, 80, 70)}):Play()
                    TweenService:Create(child:FindFirstChildOfClass("UIStroke"), TweenConfig, {Color = Color3.fromRGB(40, 180, 130)}):Play()
                end
            end
            
            Page.Visible = true
            CurrentTab = Page
            TweenService:Create(TabButton, TweenConfig, {BackgroundColor3 = Color3.fromRGB(50, 130, 110)}):Play()
            TweenService:Create(TabStroke, TweenConfig, {Color = Color3.fromRGB(100, 255, 200)}):Play()
            TweenService:Create(TabIcon, TweenConfig, {ImageColor3 = Color3.fromRGB(100, 255, 200)}):Play()
        end)

        -- Динамическое обновление размера скроллинга страницы
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        TabContainer.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X + 20, 0, 0)

        local Elements = {}

        -- Функция добавления кнопки на страницу
        function Elements:CreateButton(ButtonText, Callback)
            Callback = Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = Page
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            ButtonFrame.BackgroundTransparency = 0.3
            ButtonFrame.Size = UDim2.new(1, -10, 0, 35)
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame

            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(60, 60, 80)
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = ButtonFrame

            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "ButtonLabel"
            ButtonLabel.Parent = ButtonFrame
            ButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonLabel.BackgroundTransparency = 1.000
            ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.TextSize = 13.000

            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenConfig, {BackgroundColor3 = Color3.fromRGB(35, 35,45)}):Play()
                TweenService:Create(ButtonStroke, TweenConfig, {Color = Color3.fromRGB(90, 40, 150)}):Play()
            end)

            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenConfig, {BackgroundColor3 = Color3.fromRGB(25, 25,35)}):Play()
                TweenService:Create(ButtonStroke, TweenConfig, {Color = Color3.fromRGB(60, 60, 80)}):Play()
            end)

            ButtonFrame.MouseButton1Click:Connect(function()
                -- Эффект нажатия
                local clickTween = TweenService:Create(ButtonLabel, TweenInfo.new(0.1), {TextSize = 11})
                clickTween:Play()
                clickTween.Completed:Wait()
                TweenService:Create(ButtonLabel, TweenInfo.new(0.1), {TextSize = 13}):Play()
                
                Callback()
            end)
        end

        return Elements
    end

    return Window
end
