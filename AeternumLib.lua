-- ============================================================
--  AETERNUM UI LIBRARY  v2.0
--  Полная профессиональная UI-библиотека для Roblox
--
--  КОМПОНЕНТЫ:
--    Window       — Окно с drag, minimize, close
--    Tab          — Вкладки с анимацией переключения
--    Section      — Секции с заголовком и разделителем
--    Button       — Кнопка с hover и click-эффектом
--    Toggle       — Переключатель с анимацией
--    Slider       — Ползунок с отображением значения
--    Dropdown     — Выпадающий список с поиском
--    TextInput    — Поле ввода текста
--    Keybind      — Привязка клавиш
--    ColorPicker  — Выбор цвета (HSV)
--    Paragraph    — Текстовый блок / описание
--    Separator    — Визуальный разделитель
--    Notification — Всплывающие уведомления
--    ProgressBar  — Полоса прогресса
--    MultiToggle  — Группа переключателей
--
--  ИСПОЛЬЗОВАНИЕ:
--    local Aeternum = require(script.AeternumLib)
--    local Win = Aeternum:CreateWindow({ Title = "Мой Хаб", Width = 540, Height = 420 })
--    local Tab = Win:AddTab("Главная")
--    local Sec = Tab:AddSection("Управление")
--    Sec:AddButton("Нажми меня", function() print("Нажато!") end)
--    Sec:AddToggle("Режим полёта", false, function(v) print(v) end)
--    Sec:AddSlider("Скорость", 0, 200, 16, function(v) print(v) end)
--    Sec:AddDropdown("Команда", {"Красные","Синие","Зелёные"}, function(v) print(v) end)
-- ============================================================

-- ============================================================
-- [СЕКЦИЯ 1: СЕРВИСЫ]
-- ============================================================

local ServicePlayers                                        = game:GetService("Players")
local ServiceRunService                                     = game:GetService("RunService")
local ServiceTweenService                                   = game:GetService("TweenService")
local ServiceUserInputService                               = game:GetService("UserInputService")
local ServiceGuiService                                     = game:GetService("GuiService")
local ServiceTextService                                    = game:GetService("TextService")

local ReferenceLocalPlayer                                  = ServicePlayers.LocalPlayer
local ReferenceLocalPlayerGui                               = ReferenceLocalPlayer:WaitForChild("PlayerGui")
local ReferenceMouse                                        = ReferenceLocalPlayer:GetMouse()

-- ============================================================
-- [СЕКЦИЯ 2: ГЛОБАЛЬНАЯ ТАБЛИЦА ТЕМ]
-- Измените значения здесь, чтобы изменить весь стиль библиотеки.
-- ============================================================

local GlobalThemeConfiguration = {

    -- ---- Основные фоны ----
    ColorMainBackground                                     = Color3.fromRGB(13, 13, 16),
    ColorSidebarBackground                                  = Color3.fromRGB(9, 9, 11),
    ColorSectionBackground                                  = Color3.fromRGB(18, 18, 24),
    ColorElementBackground                                  = Color3.fromRGB(22, 22, 30),
    ColorElementBackgroundHovered                           = Color3.fromRGB(28, 28, 38),
    ColorElementBackgroundPressed                           = Color3.fromRGB(35, 35, 50),

    -- ---- Акценты ----
    ColorAccentPrimary                                      = Color3.fromRGB(100, 180, 255),
    ColorAccentSecondary                                    = Color3.fromRGB(140, 100, 255),
    ColorAccentSuccess                                      = Color3.fromRGB(80, 210, 150),
    ColorAccentWarning                                      = Color3.fromRGB(255, 190, 80),
    ColorAccentDanger                                       = Color3.fromRGB(220, 70, 70),

    -- ---- Границы и обводка ----
    ColorBorderNormal                                       = Color3.fromRGB(35, 35, 50),
    ColorBorderActive                                       = Color3.fromRGB(60, 60, 85),
    ColorBorderFocused                                      = Color3.fromRGB(100, 180, 255),

    -- ---- Текст ----
    ColorTextPrimary                                        = Color3.fromRGB(235, 235, 245),
    ColorTextSecondary                                      = Color3.fromRGB(140, 140, 165),
    ColorTextDisabled                                       = Color3.fromRGB(65, 65, 85),
    ColorTextAccent                                         = Color3.fromRGB(100, 180, 255),
    ColorTextSuccess                                        = Color3.fromRGB(80, 210, 150),
    ColorTextDanger                                         = Color3.fromRGB(220, 70, 70),
    ColorTextWarning                                        = Color3.fromRGB(255, 190, 80),

    -- ---- Переключатель (Toggle) ----
    ColorToggleTrackEnabled                                 = Color3.fromRGB(80, 210, 150),
    ColorToggleTrackDisabled                                = Color3.fromRGB(45, 45, 62),
    ColorToggleKnobNormal                                   = Color3.fromRGB(240, 240, 255),
    ColorToggleKnobShadow                                   = Color3.fromRGB(10, 10, 15),

    -- ---- Слайдер (Slider) ----
    ColorSliderFill                                         = Color3.fromRGB(100, 180, 255),
    ColorSliderTrack                                        = Color3.fromRGB(30, 30, 45),
    ColorSliderKnob                                         = Color3.fromRGB(240, 240, 255),

    -- ---- Прогресс-бар ----
    ColorProgressBarFill                                    = Color3.fromRGB(100, 180, 255),
    ColorProgressBarTrack                                   = Color3.fromRGB(30, 30, 45),

    -- ---- Поле ввода (TextInput) ----
    ColorInputBackground                                    = Color3.fromRGB(14, 14, 20),
    ColorInputBorderNormal                                  = Color3.fromRGB(35, 35, 50),
    ColorInputBorderFocused                                 = Color3.fromRGB(100, 180, 255),
    ColorInputText                                          = Color3.fromRGB(235, 235, 245),
    ColorInputPlaceholder                                   = Color3.fromRGB(80, 80, 105),

    -- ---- Уведомления ----
    ColorNotificationBackground                             = Color3.fromRGB(20, 20, 28),
    ColorNotificationBorder                                 = Color3.fromRGB(50, 50, 70),

    -- ---- Шрифты ----
    FontNameTitle                                           = Enum.Font.GothamBold,
    FontNameBody                                            = Enum.Font.Gotham,
    FontNameMono                                            = Enum.Font.Code,
    FontNameSmall                                           = Enum.Font.Gotham,

    -- ---- Размеры ----
    MeasureCornerRadius                                     = UDim.new(0, 8),
    MeasureCornerRadiusSmall                                = UDim.new(0, 5),
    MeasureCornerRadiusLarge                                = UDim.new(0, 12),
    MeasureElementHeight                                    = 36,
    MeasureSectionInternalPadding                           = 8,
    MeasureWindowTitleBarHeight                             = 46,
    MeasureWindowTabBarHeight                               = 36,

    -- ---- Анимация ----
    AnimationTweenDuration                                  = 0.22,
    AnimationTweenDurationFast                              = 0.12,
    AnimationTweenDurationSlow                              = 0.35,
    AnimationEasingStyle                                    = Enum.EasingStyle.Quint,
    AnimationEasingDirection                                = Enum.EasingDirection.Out,
}

-- ============================================================
-- [СЕКЦИЯ 3: ВСПОМОГАТЕЛЬНЫЕ УТИЛИТЫ]
-- Внутренние функции, используемые всеми компонентами.
-- ============================================================

-- Создаёт объект TweenInfo из глобальных настроек темы.
local function Utility_BuildTweenInfo(OverrideDuration: number?): TweenInfo
    local ResolvedDuration = OverrideDuration or GlobalThemeConfiguration.AnimationTweenDuration
    return TweenInfo.new(
        ResolvedDuration,
        GlobalThemeConfiguration.AnimationEasingStyle,
        GlobalThemeConfiguration.AnimationEasingDirection
    )
end

-- Применяет UICorner к экземпляру с заданным радиусом.
local function Utility_ApplyRoundedCorners(TargetInstance: Instance, OverrideRadius: UDim?): UICorner
    local NewUICornerInstance                               = Instance.new("UICorner")
    NewUICornerInstance.CornerRadius                        = OverrideRadius or GlobalThemeConfiguration.MeasureCornerRadius
    NewUICornerInstance.Parent                              = TargetInstance
    return NewUICornerInstance
end

-- Применяет UIStroke (обводку) к экземпляру.
local function Utility_ApplyUIStroke(TargetInstance: Instance, StrokeColorValue: Color3?, StrokeThicknessValue: number?): UIStroke
    local NewUIStrokeInstance                               = Instance.new("UIStroke")
    NewUIStrokeInstance.Color                               = StrokeColorValue or GlobalThemeConfiguration.ColorBorderNormal
    NewUIStrokeInstance.Thickness                           = StrokeThicknessValue or 1
    NewUIStrokeInstance.ApplyStrokeMode                     = Enum.ApplyStrokeMode.Border
    NewUIStrokeInstance.Parent                              = TargetInstance
    return NewUIStrokeInstance
end

-- Применяет равномерный UIPadding к экземпляру.
local function Utility_ApplyUniformPadding(TargetInstance: Instance, PaddingAmountPixels: number?): UIPadding
    local NewUIPaddingInstance                              = Instance.new("UIPadding")
    local CalculatedUniformPadding                          = UDim.new(0, PaddingAmountPixels or 8)
    NewUIPaddingInstance.PaddingTop                         = CalculatedUniformPadding
    NewUIPaddingInstance.PaddingBottom                      = CalculatedUniformPadding
    NewUIPaddingInstance.PaddingLeft                        = CalculatedUniformPadding
    NewUIPaddingInstance.PaddingRight                       = CalculatedUniformPadding
    NewUIPaddingInstance.Parent                             = TargetInstance
    return NewUIPaddingInstance
end

-- Применяет асимметричный UIPadding.
local function Utility_ApplyCustomPadding(TargetInstance: Instance, TopPx: number, BottomPx: number, LeftPx: number, RightPx: number): UIPadding
    local NewUIPaddingInstance                              = Instance.new("UIPadding")
    NewUIPaddingInstance.PaddingTop                         = UDim.new(0, TopPx)
    NewUIPaddingInstance.PaddingBottom                      = UDim.new(0, BottomPx)
    NewUIPaddingInstance.PaddingLeft                        = UDim.new(0, LeftPx)
    NewUIPaddingInstance.PaddingRight                       = UDim.new(0, RightPx)
    NewUIPaddingInstance.Parent                             = TargetInstance
    return NewUIPaddingInstance
end

-- Создаёт TextLabel с заданными параметрами.
local function Utility_CreateTextLabel(
    ParentInstance: Instance,
    LabelDisplayText: string,
    LabelFont: Enum.Font,
    LabelTextSize: number,
    LabelTextColor: Color3,
    LabelSize: UDim2,
    LabelPosition: UDim2
): TextLabel
    local NewTextLabel                                      = Instance.new("TextLabel")
    NewTextLabel.Text                                       = LabelDisplayText or ""
    NewTextLabel.Font                                       = LabelFont or GlobalThemeConfiguration.FontNameBody
    NewTextLabel.TextSize                                   = LabelTextSize or 13
    NewTextLabel.TextColor3                                 = LabelTextColor or GlobalThemeConfiguration.ColorTextPrimary
    NewTextLabel.BackgroundTransparency                     = 1
    NewTextLabel.BorderSizePixel                            = 0
    NewTextLabel.TextXAlignment                             = Enum.TextXAlignment.Left
    NewTextLabel.TextYAlignment                             = Enum.TextYAlignment.Center
    NewTextLabel.Size                                       = LabelSize or UDim2.new(1, 0, 1, 0)
    NewTextLabel.Position                                   = LabelPosition or UDim2.new(0, 0, 0, 0)
    NewTextLabel.Parent                                     = ParentInstance
    return NewTextLabel
end

-- Создаёт вертикальный UIListLayout.
local function Utility_CreateVerticalListLayout(ParentInstance: Instance, SpacingBetweenItems: number?): UIListLayout
    local NewUIListLayout                                   = Instance.new("UIListLayout")
    NewUIListLayout.FillDirection                           = Enum.FillDirection.Vertical
    NewUIListLayout.SortOrder                               = Enum.SortOrder.LayoutOrder
    NewUIListLayout.Padding                                 = UDim.new(0, SpacingBetweenItems or 6)
    NewUIListLayout.Parent                                  = ParentInstance
    return NewUIListLayout
end

-- Зажимает число в диапазоне [Min, Max].
local function Utility_ClampNumber(InputNumber: number, MinimumBound: number, MaximumBound: number): number
    if InputNumber < MinimumBound then
        return MinimumBound
    elseif InputNumber > MaximumBound then
        return MaximumBound
    else
        return InputNumber
    end
end

-- Округляет число до заданного количества знаков после запятой.
local function Utility_RoundToDecimalPlaces(InputNumber: number, DecimalPlaces: number): number
    local ScaleFactor                                       = 10 ^ DecimalPlaces
    return math.floor(InputNumber * ScaleFactor + 0.5) / ScaleFactor
end

-- Преобразует HSV в Color3.
local function Utility_HSVToColor3(HueValue: number, SaturationValue: number, BrightnessValue: number): Color3
    return Color3.fromHSV(HueValue, SaturationValue, BrightnessValue)
end

-- ============================================================
-- [СЕКЦИЯ 4: СИСТЕМА DRAG (ПЕРЕТАСКИВАНИЕ)]
-- ============================================================

local function System_EnableWindowDragging(DraggableTargetFrame: Frame, DragTriggerHandle: Instance)
    local DragSystem_IsDraggingActive                       = false
    local DragSystem_MouseOriginPosition                    = Vector2.new(0, 0)
    local DragSystem_FrameOriginPosition                    = UDim2.new(0, 0, 0, 0)

    DragTriggerHandle.InputBegan:Connect(function(ReceivedInputObject: InputObject)
        if ReceivedInputObject.UserInputType == Enum.UserInputType.MouseButton1
            or ReceivedInputObject.UserInputType == Enum.UserInputType.Touch then
            DragSystem_IsDraggingActive                     = true
            DragSystem_MouseOriginPosition                  = Vector2.new(
                ReceivedInputObject.Position.X,
                ReceivedInputObject.Position.Y
            )
            DragSystem_FrameOriginPosition                  = DraggableTargetFrame.Position
        end
    end)

    DragTriggerHandle.InputEnded:Connect(function(ReceivedInputObject: InputObject)
        if ReceivedInputObject.UserInputType == Enum.UserInputType.MouseButton1
            or ReceivedInputObject.UserInputType == Enum.UserInputType.Touch then
            DragSystem_IsDraggingActive = false
        end
    end)

    ServiceUserInputService.InputChanged:Connect(function(ReceivedInputObject: InputObject)
        if DragSystem_IsDraggingActive then
            if ReceivedInputObject.UserInputType == Enum.UserInputType.MouseMovement
                or ReceivedInputObject.UserInputType == Enum.UserInputType.Touch then
                local CurrentInputPositionX                 = ReceivedInputObject.Position.X
                local CurrentInputPositionY                 = ReceivedInputObject.Position.Y
                local CalculatedDeltaX                      = CurrentInputPositionX - DragSystem_MouseOriginPosition.X
                local CalculatedDeltaY                      = CurrentInputPositionY - DragSystem_MouseOriginPosition.Y
                DraggableTargetFrame.Position               = UDim2.new(
                    DragSystem_FrameOriginPosition.X.Scale,
                    DragSystem_FrameOriginPosition.X.Offset + CalculatedDeltaX,
                    DragSystem_FrameOriginPosition.Y.Scale,
                    DragSystem_FrameOriginPosition.Y.Offset + CalculatedDeltaY
                )
            end
        end
    end)
end

-- ============================================================
-- [СЕКЦИЯ 5: СИСТЕМА УВЕДОМЛЕНИЙ]
-- ============================================================

local NotificationSystem_ActiveNotificationsList            = {}
local NotificationSystem_ContainerFrame                     = nil

local function NotificationSystem_InitializeContainer()
    if NotificationSystem_ContainerFrame then return end

    local NotificationScreenGui                             = Instance.new("ScreenGui")
    NotificationScreenGui.Name                              = "AeternumNotificationGui"
    NotificationScreenGui.ResetOnSpawn                      = false
    NotificationScreenGui.ZIndexBehavior                    = Enum.ZIndexBehavior.Sibling
    NotificationScreenGui.IgnoreGuiInset                    = true
    NotificationScreenGui.DisplayOrder                      = 999
    NotificationScreenGui.Parent                            = ReferenceLocalPlayerGui

    local NotificationHolderFrame                           = Instance.new("Frame")
    NotificationHolderFrame.Name                            = "NotificationHolder"
    NotificationHolderFrame.Size                            = UDim2.new(0, 300, 1, 0)
    NotificationHolderFrame.Position                        = UDim2.new(1, -315, 0, 0)
    NotificationHolderFrame.BackgroundTransparency          = 1
    NotificationHolderFrame.BorderSizePixel                 = 0
    NotificationHolderFrame.Parent                          = NotificationScreenGui

    local NotificationListLayout                            = Instance.new("UIListLayout")
    NotificationListLayout.FillDirection                    = Enum.FillDirection.Vertical
    NotificationListLayout.SortOrder                        = Enum.SortOrder.LayoutOrder
    NotificationListLayout.VerticalAlignment                = Enum.VerticalAlignment.Bottom
    NotificationListLayout.Padding                          = UDim.new(0, 8)
    NotificationListLayout.Parent                           = NotificationHolderFrame

    local NotificationContainerPadding                      = Instance.new("UIPadding")
    NotificationContainerPadding.PaddingBottom              = UDim.new(0, 16)
    NotificationContainerPadding.PaddingRight               = UDim.new(0, 8)
    NotificationContainerPadding.Parent                     = NotificationHolderFrame

    NotificationSystem_ContainerFrame                       = NotificationHolderFrame
end

local function NotificationSystem_Show(TitleText: string, MessageText: string, NotificationType: string, DurationSeconds: number?)
    NotificationSystem_InitializeContainer()

    local ResolvedDuration                                  = DurationSeconds or 4
    local ResolvedType                                      = NotificationType or "info"

    -- Определяем цвет акцента по типу уведомления
    local NotificationAccentColor                           = GlobalThemeConfiguration.ColorAccentPrimary
    if ResolvedType == "success" then
        NotificationAccentColor                             = GlobalThemeConfiguration.ColorAccentSuccess
    elseif ResolvedType == "warning" then
        NotificationAccentColor                             = GlobalThemeConfiguration.ColorAccentWarning
    elseif ResolvedType == "error" then
        NotificationAccentColor                             = GlobalThemeConfiguration.ColorAccentDanger
    end

    -- Контейнер уведомления
    local SingleNotificationFrame                           = Instance.new("Frame")
    SingleNotificationFrame.Name                            = "Notification_" .. os.time()
    SingleNotificationFrame.Size                            = UDim2.new(1, 0, 0, 70)
    SingleNotificationFrame.BackgroundColor3                = GlobalThemeConfiguration.ColorNotificationBackground
    SingleNotificationFrame.BorderSizePixel                 = 0
    SingleNotificationFrame.BackgroundTransparency          = 0.05
    SingleNotificationFrame.LayoutOrder                     = #NotificationSystem_ActiveNotificationsList + 1
    SingleNotificationFrame.Parent                          = NotificationSystem_ContainerFrame
    Utility_ApplyRoundedCorners(SingleNotificationFrame, GlobalThemeConfiguration.MeasureCornerRadiusSmall)
    Utility_ApplyUIStroke(SingleNotificationFrame, GlobalThemeConfiguration.ColorNotificationBorder, 1)

    -- Цветная полоска слева
    local NotificationLeftAccentBar                         = Instance.new("Frame")
    NotificationLeftAccentBar.Size                          = UDim2.new(0, 3, 1, 0)
    NotificationLeftAccentBar.BackgroundColor3              = NotificationAccentColor
    NotificationLeftAccentBar.BorderSizePixel               = 0
    NotificationLeftAccentBar.Parent                        = SingleNotificationFrame
    Utility_ApplyRoundedCorners(NotificationLeftAccentBar, UDim.new(0, 2))

    -- Заголовок
    local NotificationTitleLabel                            = Utility_CreateTextLabel(
        SingleNotificationFrame,
        TitleText,
        GlobalThemeConfiguration.FontNameTitle,
        13,
        NotificationAccentColor,
        UDim2.new(1, -20, 0, 20),
        UDim2.new(0, 14, 0, 8)
    )

    -- Сообщение
    local NotificationMessageLabel                          = Utility_CreateTextLabel(
        SingleNotificationFrame,
        MessageText,
        GlobalThemeConfiguration.FontNameBody,
        12,
        GlobalThemeConfiguration.ColorTextSecondary,
        UDim2.new(1, -20, 0, 30),
        UDim2.new(0, 14, 0, 28)
    )
    NotificationMessageLabel.TextWrapped                    = true
    NotificationMessageLabel.TextYAlignment                 = Enum.TextYAlignment.Top

    -- Анимация появления (слайд снизу)
    SingleNotificationFrame.Position                        = UDim2.new(0, 20, 0, 0)
    SingleNotificationFrame.BackgroundTransparency          = 1
    ServiceTweenService:Create(
        SingleNotificationFrame,
        Utility_BuildTweenInfo(0.3),
        { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.05 }
    ):Play()

    table.insert(NotificationSystem_ActiveNotificationsList, SingleNotificationFrame)

    -- Автоудаление
    task.delay(ResolvedDuration, function()
        ServiceTweenService:Create(
            SingleNotificationFrame,
            Utility_BuildTweenInfo(0.25),
            { Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1 }
        ):Play()
        task.wait(0.3)
        if SingleNotificationFrame and SingleNotificationFrame.Parent then
            SingleNotificationFrame:Destroy()
        end
        -- Убираем из списка
        for NotifIndex, NotifFrame in ipairs(NotificationSystem_ActiveNotificationsList) do
            if NotifFrame == SingleNotificationFrame then
                table.remove(NotificationSystem_ActiveNotificationsList, NotifIndex)
                break
            end
        end
    end)
end

-- ============================================================
-- [СЕКЦИЯ 6: БАЗОВЫЙ КЛАСС ЭЛЕМЕНТА]
-- ============================================================

local ElementBaseClass                                      = {}
ElementBaseClass.__index                                    = ElementBaseClass

function ElementBaseClass:BaseDestroy()
    if self.ContainerFrame and self.ContainerFrame.Parent then
        self.ContainerFrame:Destroy()
    end
end

function ElementBaseClass:SetVisible(IsVisible: boolean)
    if self.ContainerFrame then
        self.ContainerFrame.Visible = IsVisible
    end
end

-- ============================================================
-- [СЕКЦИЯ 7: КОМПОНЕНТ — SEPARATOR (РАЗДЕЛИТЕЛЬ)]
-- ============================================================

local SeparatorClass                                        = setmetatable({}, { __index = ElementBaseClass })
SeparatorClass.__index                                      = SeparatorClass

function SeparatorClass.new(ParentContainerFrame: Frame, LabelText: string?)
    local SeparatorSelf                                     = setmetatable({}, SeparatorClass)

    local SeparatorOuterFrame                               = Instance.new("Frame")
    SeparatorOuterFrame.Name                                = "SeparatorElement"
    SeparatorOuterFrame.Size                                = UDim2.new(1, 0, 0, 20)
    SeparatorOuterFrame.BackgroundTransparency              = 1
    SeparatorOuterFrame.BorderSizePixel                     = 0
    SeparatorOuterFrame.Parent                              = ParentContainerFrame

    local SeparatorLineLeft                                 = Instance.new("Frame")
    SeparatorLineLeft.Size                                  = LabelText and UDim2.new(0.3, -6, 0, 1) or UDim2.new(1, 0, 0, 1)
    SeparatorLineLeft.Position                              = UDim2.new(0, 0, 0.5, 0)
    SeparatorLineLeft.BackgroundColor3                      = GlobalThemeConfiguration.ColorBorderNormal
    SeparatorLineLeft.BorderSizePixel                       = 0
    SeparatorLineLeft.Parent                                = SeparatorOuterFrame

    if LabelText and LabelText ~= "" then
        local SeparatorTextLabel                            = Utility_CreateTextLabel(
            SeparatorOuterFrame,
            LabelText,
            GlobalThemeConfiguration.FontNameSmall,
            11,
            GlobalThemeConfiguration.ColorTextDisabled,
            UDim2.new(0.4, 0, 1, 0),
            UDim2.new(0.3, 0, 0, 0)
        )
        SeparatorTextLabel.TextXAlignment                   = Enum.TextXAlignment.Center

        local SeparatorLineRight                            = Instance.new("Frame")
        SeparatorLineRight.Size                             = UDim2.new(0.3, -6, 0, 1)
        SeparatorLineRight.Position                         = UDim2.new(0.7, 6, 0.5, 0)
        SeparatorLineRight.BackgroundColor3                 = GlobalThemeConfiguration.ColorBorderNormal
        SeparatorLineRight.BorderSizePixel                  = 0
        SeparatorLineRight.Parent                           = SeparatorOuterFrame
    end

    SeparatorSelf.ContainerFrame                            = SeparatorOuterFrame
    return SeparatorSelf
end

-- ============================================================
-- [СЕКЦИЯ 8: КОМПОНЕНТ — PARAGRAPH (ТЕКСТОВЫЙ БЛОК)]
-- ============================================================

local ParagraphClass                                        = setmetatable({}, { __index = ElementBaseClass })
ParagraphClass.__index                                      = ParagraphClass

function ParagraphClass.new(ParentContainerFrame: Frame, TitleText: string, BodyText: string)
    local ParagraphSelf                                     = setmetatable({}, ParagraphClass)

    local ParagraphOuterFrame                               = Instance.new("Frame")
    ParagraphOuterFrame.Name                                = "ParagraphElement_" .. TitleText
    ParagraphOuterFrame.Size                                = UDim2.new(1, 0, 0, 0)
    ParagraphOuterFrame.AutomaticSize                       = Enum.AutomaticSize.Y
    ParagraphOuterFrame.BackgroundColor3                    = GlobalThemeConfiguration.ColorElementBackground
    ParagraphOuterFrame.BorderSizePixel                     = 0
    ParagraphOuterFrame.Parent                              = ParentContainerFrame
    Utility_ApplyRoundedCorners(ParagraphOuterFrame)
    Utility_ApplyUIStroke(ParagraphOuterFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)
    Utility_ApplyCustomPadding(ParagraphOuterFrame, 10, 10, 12, 12)

    local ParagraphInnerLayout                              = Instance.new("UIListLayout")
    ParagraphInnerLayout.FillDirection                      = Enum.FillDirection.Vertical
    ParagraphInnerLayout.SortOrder                          = Enum.SortOrder.LayoutOrder
    ParagraphInnerLayout.Padding                            = UDim.new(0, 4)
    ParagraphInnerLayout.Parent                             = ParagraphOuterFrame

    local ParagraphTitleLabel                               = Instance.new("TextLabel")
    ParagraphTitleLabel.Size                                = UDim2.new(1, 0, 0, 0)
    ParagraphTitleLabel.AutomaticSize                       = Enum.AutomaticSize.Y
    ParagraphTitleLabel.BackgroundTransparency              = 1
    ParagraphTitleLabel.Text                                = TitleText
    ParagraphTitleLabel.Font                                = GlobalThemeConfiguration.FontNameTitle
    ParagraphTitleLabel.TextSize                            = 13
    ParagraphTitleLabel.TextColor3                          = GlobalThemeConfiguration.ColorTextPrimary
    ParagraphTitleLabel.TextXAlignment                      = Enum.TextXAlignment.Left
    ParagraphTitleLabel.TextWrapped                         = true
    ParagraphTitleLabel.LayoutOrder                         = 1
    ParagraphTitleLabel.Parent                              = ParagraphOuterFrame

    local ParagraphBodyLabel                                = Instance.new("TextLabel")
    ParagraphBodyLabel.Size                                 = UDim2.new(1, 0, 0, 0)
    ParagraphBodyLabel.AutomaticSize                        = Enum.AutomaticSize.Y
    ParagraphBodyLabel.BackgroundTransparency               = 1
    ParagraphBodyLabel.Text                                 = BodyText
    ParagraphBodyLabel.Font                                 = GlobalThemeConfiguration.FontNameBody
    ParagraphBodyLabel.TextSize                             = 12
    ParagraphBodyLabel.TextColor3                           = GlobalThemeConfiguration.ColorTextSecondary
    ParagraphBodyLabel.TextXAlignment                       = Enum.TextXAlignment.Left
    ParagraphBodyLabel.TextWrapped                          = true
    ParagraphBodyLabel.LayoutOrder                          = 2
    ParagraphBodyLabel.Parent                               = ParagraphOuterFrame

    function ParagraphSelf:SetTitle(NewTitleText: string)
        ParagraphTitleLabel.Text = NewTitleText
    end

    function ParagraphSelf:SetBody(NewBodyText: string)
        ParagraphBodyLabel.Text = NewBodyText
    end

    ParagraphSelf.ContainerFrame                            = ParagraphOuterFrame
    return ParagraphSelf
end

-- ============================================================
-- [СЕКЦИЯ 9: КОМПОНЕНТ — PROGRESSBAR (ПОЛОСА ПРОГРЕССА)]
-- ============================================================

local ProgressBarClass                                      = setmetatable({}, { __index = ElementBaseClass })
ProgressBarClass.__index                                    = ProgressBarClass

function ProgressBarClass.new(ParentContainerFrame: Frame, LabelText: string, InitialPercent: number)
    local ProgressBarSelf                                   = setmetatable({}, ProgressBarClass)
    local ProgressBarCurrentPercent                         = Utility_ClampNumber(InitialPercent or 0, 0, 100)

    local ProgressBarOuterFrame                             = Instance.new("Frame")
    ProgressBarOuterFrame.Name                              = "ProgressBarElement_" .. LabelText
    ProgressBarOuterFrame.Size                              = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight + 8)
    ProgressBarOuterFrame.BackgroundColor3                  = GlobalThemeConfiguration.ColorElementBackground
    ProgressBarOuterFrame.BorderSizePixel                   = 0
    ProgressBarOuterFrame.Parent                            = ParentContainerFrame
    Utility_ApplyRoundedCorners(ProgressBarOuterFrame)
    Utility_ApplyUIStroke(ProgressBarOuterFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local ProgressBarLabelText                              = Utility_CreateTextLabel(
        ProgressBarOuterFrame,
        LabelText,
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(0.7, -12, 0, 20),
        UDim2.new(0, 12, 0, 5)
    )

    local ProgressBarValueLabel                             = Utility_CreateTextLabel(
        ProgressBarOuterFrame,
        tostring(ProgressBarCurrentPercent) .. "%",
        GlobalThemeConfiguration.FontNameMono,
        13,
        GlobalThemeConfiguration.ColorTextAccent,
        UDim2.new(0.3, -12, 0, 20),
        UDim2.new(0.7, 0, 0, 5)
    )
    ProgressBarValueLabel.TextXAlignment                    = Enum.TextXAlignment.Right

    local ProgressBarTrackFrame                             = Instance.new("Frame")
    ProgressBarTrackFrame.Size                              = UDim2.new(1, -24, 0, 6)
    ProgressBarTrackFrame.Position                          = UDim2.new(0, 12, 1, -14)
    ProgressBarTrackFrame.BackgroundColor3                  = GlobalThemeConfiguration.ColorProgressBarTrack
    ProgressBarTrackFrame.BorderSizePixel                   = 0
    ProgressBarTrackFrame.Parent                            = ProgressBarOuterFrame
    Utility_ApplyRoundedCorners(ProgressBarTrackFrame, UDim.new(1, 0))

    local ProgressBarFillFrame                              = Instance.new("Frame")
    ProgressBarFillFrame.Size                               = UDim2.new(ProgressBarCurrentPercent / 100, 0, 1, 0)
    ProgressBarFillFrame.BackgroundColor3                   = GlobalThemeConfiguration.ColorProgressBarFill
    ProgressBarFillFrame.BorderSizePixel                    = 0
    ProgressBarFillFrame.Parent                             = ProgressBarTrackFrame
    Utility_ApplyRoundedCorners(ProgressBarFillFrame, UDim.new(1, 0))

    function ProgressBarSelf:SetPercent(NewPercent: number)
        ProgressBarCurrentPercent                           = Utility_ClampNumber(NewPercent, 0, 100)
        ProgressBarValueLabel.Text                          = tostring(math.floor(ProgressBarCurrentPercent)) .. "%"
        ServiceTweenService:Create(
            ProgressBarFillFrame,
            Utility_BuildTweenInfo(0.3),
            { Size = UDim2.new(ProgressBarCurrentPercent / 100, 0, 1, 0) }
        ):Play()
    end

    function ProgressBarSelf:GetPercent(): number
        return ProgressBarCurrentPercent
    end

    ProgressBarSelf.ContainerFrame                          = ProgressBarOuterFrame
    return ProgressBarSelf
end

-- ============================================================
-- [СЕКЦИЯ 10: КОМПОНЕНТ — BUTTON (КНОПКА)]
-- ============================================================

local ButtonClass                                           = setmetatable({}, { __index = ElementBaseClass })
ButtonClass.__index                                         = ButtonClass

function ButtonClass.new(ParentContainerFrame: Frame, ButtonDisplayText: string, OnClickCallbackFunction: (() -> ())?, ButtonStyle: string?)
    local ButtonSelf                                        = setmetatable({}, ButtonClass)
    local ResolvedButtonStyle                               = ButtonStyle or "default"

    -- Определяем цвет кнопки по стилю
    local ButtonStyleAccentColor                            = GlobalThemeConfiguration.ColorAccentPrimary
    if ResolvedButtonStyle == "success" then
        ButtonStyleAccentColor                              = GlobalThemeConfiguration.ColorAccentSuccess
    elseif ResolvedButtonStyle == "danger" then
        ButtonStyleAccentColor                              = GlobalThemeConfiguration.ColorAccentDanger
    elseif ResolvedButtonStyle == "warning" then
        ButtonStyleAccentColor                              = GlobalThemeConfiguration.ColorAccentWarning
    end

    local ButtonOuterContainerFrame                         = Instance.new("Frame")
    ButtonOuterContainerFrame.Name                          = "ButtonElement_" .. ButtonDisplayText
    ButtonOuterContainerFrame.Size                          = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight)
    ButtonOuterContainerFrame.BackgroundColor3              = GlobalThemeConfiguration.ColorElementBackground
    ButtonOuterContainerFrame.BorderSizePixel               = 0
    ButtonOuterContainerFrame.Parent                        = ParentContainerFrame
    Utility_ApplyRoundedCorners(ButtonOuterContainerFrame)
    Utility_ApplyUIStroke(ButtonOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local ButtonInnerClickableOverlay                       = Instance.new("TextButton")
    ButtonInnerClickableOverlay.Size                        = UDim2.new(1, 0, 1, 0)
    ButtonInnerClickableOverlay.BackgroundTransparency      = 1
    ButtonInnerClickableOverlay.BorderSizePixel             = 0
    ButtonInnerClickableOverlay.Text                        = ""
    ButtonInnerClickableOverlay.Parent                      = ButtonOuterContainerFrame

    -- Цветная полоса акцента слева
    local ButtonAccentLeftBar                               = Instance.new("Frame")
    ButtonAccentLeftBar.Size                                = UDim2.new(0, 3, 0.6, 0)
    ButtonAccentLeftBar.Position                            = UDim2.new(0, 0, 0.2, 0)
    ButtonAccentLeftBar.BackgroundColor3                    = ButtonStyleAccentColor
    ButtonAccentLeftBar.BackgroundTransparency              = 0.5
    ButtonAccentLeftBar.BorderSizePixel                     = 0
    ButtonAccentLeftBar.Parent                              = ButtonOuterContainerFrame
    Utility_ApplyRoundedCorners(ButtonAccentLeftBar, UDim.new(0, 2))

    local ButtonMainTextLabel                               = Utility_CreateTextLabel(
        ButtonOuterContainerFrame,
        ButtonDisplayText,
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(1, -16, 1, 0),
        UDim2.new(0, 14, 0, 0)
    )

    -- Иконка стрелки справа
    local ButtonRightArrowLabel                             = Utility_CreateTextLabel(
        ButtonOuterContainerFrame,
        "›",
        GlobalThemeConfiguration.FontNameTitle,
        18,
        GlobalThemeConfiguration.ColorTextDisabled,
        UDim2.new(0, 20, 1, 0),
        UDim2.new(1, -26, 0, 0)
    )
    ButtonRightArrowLabel.TextXAlignment                    = Enum.TextXAlignment.Center

    -- Hover эффект
    ButtonInnerClickableOverlay.MouseEnter:Connect(function()
        ServiceTweenService:Create(
            ButtonOuterContainerFrame,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { BackgroundColor3 = GlobalThemeConfiguration.ColorElementBackgroundHovered }
        ):Play()
        ServiceTweenService:Create(
            ButtonRightArrowLabel,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { TextColor3 = ButtonStyleAccentColor }
        ):Play()
        ServiceTweenService:Create(
            ButtonAccentLeftBar,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { BackgroundTransparency = 0 }
        ):Play()
    end)

    ButtonInnerClickableOverlay.MouseLeave:Connect(function()
        ServiceTweenService:Create(
            ButtonOuterContainerFrame,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { BackgroundColor3 = GlobalThemeConfiguration.ColorElementBackground }
        ):Play()
        ServiceTweenService:Create(
            ButtonRightArrowLabel,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { TextColor3 = GlobalThemeConfiguration.ColorTextDisabled }
        ):Play()
        ServiceTweenService:Create(
            ButtonAccentLeftBar,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
            { BackgroundTransparency = 0.5 }
        ):Play()
    end)

    -- Click эффект
    ButtonInnerClickableOverlay.MouseButton1Click:Connect(function()
        ServiceTweenService:Create(
            ButtonOuterContainerFrame,
            Utility_BuildTweenInfo(0.07),
            { BackgroundColor3 = GlobalThemeConfiguration.ColorElementBackgroundPressed }
        ):Play()
        task.delay(0.14, function()
            ServiceTweenService:Create(
                ButtonOuterContainerFrame,
                Utility_BuildTweenInfo(0.2),
                { BackgroundColor3 = GlobalThemeConfiguration.ColorElementBackground }
            ):Play()
        end)
        if typeof(OnClickCallbackFunction) == "function" then
            task.spawn(OnClickCallbackFunction)
        end
    end)

    function ButtonSelf:SetLabel(NewText: string)
        ButtonMainTextLabel.Text = NewText
    end

    ButtonSelf.ContainerFrame                               = ButtonOuterContainerFrame
    return ButtonSelf
end

-- ============================================================
-- [СЕКЦИЯ 11: КОМПОНЕНТ — TOGGLE (ПЕРЕКЛЮЧАТЕЛЬ)]
-- ============================================================

local ToggleClass                                           = setmetatable({}, { __index = ElementBaseClass })
ToggleClass.__index                                         = ToggleClass

function ToggleClass.new(ParentContainerFrame: Frame, ToggleDisplayText: string, DefaultEnabledState: boolean, OnToggleCallbackFunction: ((boolean) -> ())?)
    local ToggleSelf                                        = setmetatable({}, ToggleClass)
    local ToggleCurrentEnabledState                         = DefaultEnabledState or false
    local ToggleChangeCallbacks                             = {}

    local ToggleOuterContainerFrame                         = Instance.new("Frame")
    ToggleOuterContainerFrame.Name                          = "ToggleElement_" .. ToggleDisplayText
    ToggleOuterContainerFrame.Size                          = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight)
    ToggleOuterContainerFrame.BackgroundColor3              = GlobalThemeConfiguration.ColorElementBackground
    ToggleOuterContainerFrame.BorderSizePixel               = 0
    ToggleOuterContainerFrame.Parent                        = ParentContainerFrame
    Utility_ApplyRoundedCorners(ToggleOuterContainerFrame)
    Utility_ApplyUIStroke(ToggleOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local ToggleDisplayTextLabel                            = Utility_CreateTextLabel(
        ToggleOuterContainerFrame,
        ToggleDisplayText,
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(1, -68, 1, 0),
        UDim2.new(0, 12, 0, 0)
    )

    -- Статусный текст (ON/OFF)
    local ToggleStatusTextLabel                             = Utility_CreateTextLabel(
        ToggleOuterContainerFrame,
        ToggleCurrentEnabledState and "ON" or "OFF",
        GlobalThemeConfiguration.FontNameMono,
        11,
        ToggleCurrentEnabledState and GlobalThemeConfiguration.ColorToggleTrackEnabled or GlobalThemeConfiguration.ColorTextDisabled,
        UDim2.new(0, 30, 1, 0),
        UDim2.new(1, -100, 0, 0)
    )
    ToggleStatusTextLabel.TextXAlignment                    = Enum.TextXAlignment.Right

    -- Трек переключателя
    local ToggleSwitchTrackFrame                            = Instance.new("Frame")
    ToggleSwitchTrackFrame.Name                             = "SwitchTrackFrame"
    ToggleSwitchTrackFrame.Size                             = UDim2.new(0, 42, 0, 24)
    ToggleSwitchTrackFrame.Position                         = UDim2.new(1, -54, 0.5, -12)
    ToggleSwitchTrackFrame.BackgroundColor3                 = ToggleCurrentEnabledState
        and GlobalThemeConfiguration.ColorToggleTrackEnabled
        or GlobalThemeConfiguration.ColorToggleTrackDisabled
    ToggleSwitchTrackFrame.BorderSizePixel                  = 0
    ToggleSwitchTrackFrame.Parent                           = ToggleOuterContainerFrame
    Utility_ApplyRoundedCorners(ToggleSwitchTrackFrame, UDim.new(1, 0))

    -- Кнопка (knob) переключателя
    local ToggleSwitchKnobFrame                             = Instance.new("Frame")
    ToggleSwitchKnobFrame.Name                              = "SwitchKnobFrame"
    ToggleSwitchKnobFrame.Size                              = UDim2.new(0, 18, 0, 18)
    ToggleSwitchKnobFrame.Position                          = ToggleCurrentEnabledState
        and UDim2.new(1, -21, 0.5, -9)
        or UDim2.new(0, 3, 0.5, -9)
    ToggleSwitchKnobFrame.BackgroundColor3                  = GlobalThemeConfiguration.ColorToggleKnobNormal
    ToggleSwitchKnobFrame.BorderSizePixel                   = 0
    ToggleSwitchKnobFrame.Parent                            = ToggleSwitchTrackFrame
    Utility_ApplyRoundedCorners(ToggleSwitchKnobFrame, UDim.new(1, 0))

    -- Невидимая кнопка-оверлей для клика
    local ToggleClickableButtonOverlay                      = Instance.new("TextButton")
    ToggleClickableButtonOverlay.Size                       = UDim2.new(1, 0, 1, 0)
    ToggleClickableButtonOverlay.BackgroundTransparency     = 1
    ToggleClickableButtonOverlay.BorderSizePixel            = 0
    ToggleClickableButtonOverlay.Text                       = ""
    ToggleClickableButtonOverlay.Parent                     = ToggleOuterContainerFrame

    -- Функция обновления визуала при изменении состояния
    local function ToggleInternal_UpdateVisualState(NewEnabledState: boolean)
        local TargetTrackColor                              = NewEnabledState
            and GlobalThemeConfiguration.ColorToggleTrackEnabled
            or GlobalThemeConfiguration.ColorToggleTrackDisabled
        local TargetKnobPosition                            = NewEnabledState
            and UDim2.new(1, -21, 0.5, -9)
            or UDim2.new(0, 3, 0.5, -9)
        local TargetStatusText                              = NewEnabledState and "ON" or "OFF"
        local TargetStatusColor                             = NewEnabledState
            and GlobalThemeConfiguration.ColorToggleTrackEnabled
            or GlobalThemeConfiguration.ColorTextDisabled

        ServiceTweenService:Create(
            ToggleSwitchTrackFrame,
            Utility_BuildTweenInfo(0.2),
            { BackgroundColor3 = TargetTrackColor }
        ):Play()

        ServiceTweenService:Create(
            ToggleSwitchKnobFrame,
            Utility_BuildTweenInfo(0.2),
            { Position = TargetKnobPosition }
        ):Play()

        ServiceTweenService:Create(
            ToggleStatusTextLabel,
            Utility_BuildTweenInfo(0.15),
            { TextColor3 = TargetStatusColor }
        ):Play()

        ToggleStatusTextLabel.Text                          = TargetStatusText
    end

    ToggleClickableButtonOverlay.MouseButton1Click:Connect(function()
        ToggleCurrentEnabledState                           = not ToggleCurrentEnabledState
        ToggleInternal_UpdateVisualState(ToggleCurrentEnabledState)

        if typeof(OnToggleCallbackFunction) == "function" then
            task.spawn(OnToggleCallbackFunction, ToggleCurrentEnabledState)
        end

        for _, StoredCallback in ipairs(ToggleChangeCallbacks) do
            if typeof(StoredCallback) == "function" then
                task.spawn(StoredCallback, ToggleCurrentEnabledState)
            end
        end
    end)

    ToggleInternal_UpdateVisualState(ToggleCurrentEnabledState)

    function ToggleSelf:SetValue(NewValue: boolean)
        ToggleCurrentEnabledState = NewValue
        ToggleInternal_UpdateVisualState(ToggleCurrentEnabledState)
    end

    function ToggleSelf:GetValue(): boolean
        return ToggleCurrentEnabledState
    end

    function ToggleSelf:OnChanged(CallbackFunction: (boolean) -> ())
        table.insert(ToggleChangeCallbacks, CallbackFunction)
    end

    ToggleSelf.ContainerFrame                               = ToggleOuterContainerFrame
    return ToggleSelf
end

-- ============================================================
-- [СЕКЦИЯ 12: КОМПОНЕНТ — SLIDER (ПОЛЗУНОК)]
-- ============================================================

local SliderClass                                           = setmetatable({}, { __index = ElementBaseClass })
SliderClass.__index                                         = SliderClass

function SliderClass.new(ParentContainerFrame: Frame, SliderDisplayText: string, MinimumValue: number, MaximumValue: number, DefaultValue: number, OnChangeCallbackFunction: ((number) -> ())?, DecimalPlaces: number?)
    local SliderSelf                                        = setmetatable({}, SliderClass)
    local SliderResolvedDecimalPlaces                       = DecimalPlaces or 0
    local SliderCurrentValue                                = Utility_ClampNumber(DefaultValue or MinimumValue, MinimumValue, MaximumValue)
    local SliderIsDraggingActive                            = false
    local SliderChangeCallbacks                             = {}

    local SliderOuterContainerFrame                         = Instance.new("Frame")
    SliderOuterContainerFrame.Name                          = "SliderElement_" .. SliderDisplayText
    SliderOuterContainerFrame.Size                          = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight + 14)
    SliderOuterContainerFrame.BackgroundColor3              = GlobalThemeConfiguration.ColorElementBackground
    SliderOuterContainerFrame.BorderSizePixel               = 0
    SliderOuterContainerFrame.Parent                        = ParentContainerFrame
    Utility_ApplyRoundedCorners(SliderOuterContainerFrame)
    Utility_ApplyUIStroke(SliderOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local SliderMainTextLabel                               = Utility_CreateTextLabel(
        SliderOuterContainerFrame,
        SliderDisplayText,
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(0.65, -12, 0, 22),
        UDim2.new(0, 12, 0, 4)
    )

    local SliderCurrentValueDisplayLabel                    = Utility_CreateTextLabel(
        SliderOuterContainerFrame,
        tostring(Utility_RoundToDecimalPlaces(SliderCurrentValue, SliderResolvedDecimalPlaces)),
        GlobalThemeConfiguration.FontNameMono,
        13,
        GlobalThemeConfiguration.ColorTextAccent,
        UDim2.new(0.35, -12, 0, 22),
        UDim2.new(0.65, 0, 0, 4)
    )
    SliderCurrentValueDisplayLabel.TextXAlignment           = Enum.TextXAlignment.Right

    -- Диапазон (min/max)
    local SliderMinLabel                                    = Utility_CreateTextLabel(
        SliderOuterContainerFrame,
        tostring(MinimumValue),
        GlobalThemeConfiguration.FontNameMono,
        10,
        GlobalThemeConfiguration.ColorTextDisabled,
        UDim2.new(0, 30, 0, 12),
        UDim2.new(0, 12, 1, -14)
    )

    local SliderMaxLabel                                    = Utility_CreateTextLabel(
        SliderOuterContainerFrame,
        tostring(MaximumValue),
        GlobalThemeConfiguration.FontNameMono,
        10,
        GlobalThemeConfiguration.ColorTextDisabled,
        UDim2.new(0, 30, 0, 12),
        UDim2.new(1, -42, 1, -14)
    )
    SliderMaxLabel.TextXAlignment                           = Enum.TextXAlignment.Right

    -- Трек ползунка
    local SliderTrackBackgroundFrame                        = Instance.new("Frame")
    SliderTrackBackgroundFrame.Name                         = "SliderTrackBackground"
    SliderTrackBackgroundFrame.Size                         = UDim2.new(1, -24, 0, 6)
    SliderTrackBackgroundFrame.Position                     = UDim2.new(0, 12, 1, -18)
    SliderTrackBackgroundFrame.BackgroundColor3             = GlobalThemeConfiguration.ColorSliderTrack
    SliderTrackBackgroundFrame.BorderSizePixel              = 0
    SliderTrackBackgroundFrame.Parent                       = SliderOuterContainerFrame
    Utility_ApplyRoundedCorners(SliderTrackBackgroundFrame, UDim.new(1, 0))

    -- Заполнение трека
    local SliderFillBarFrame                                = Instance.new("Frame")
    SliderFillBarFrame.Name                                 = "SliderFillBar"
    SliderFillBarFrame.Size                                 = UDim2.new(0, 0, 1, 0)
    SliderFillBarFrame.BackgroundColor3                     = GlobalThemeConfiguration.ColorSliderFill
    SliderFillBarFrame.BorderSizePixel                      = 0
    SliderFillBarFrame.Parent                               = SliderTrackBackgroundFrame
    Utility_ApplyRoundedCorners(SliderFillBarFrame, UDim.new(1, 0))

    -- Кнопка-оверлей для захвата ввода
    local SliderInputCaptureButton                          = Instance.new("TextButton")
    SliderInputCaptureButton.Size                           = UDim2.new(1, 0, 0, 26)
    SliderInputCaptureButton.Position                       = UDim2.new(0, 0, 0, -10)
    SliderInputCaptureButton.BackgroundTransparency         = 1
    SliderInputCaptureButton.BorderSizePixel                = 0
    SliderInputCaptureButton.Text                           = ""
    SliderInputCaptureButton.Parent                         = SliderTrackBackgroundFrame

    local function SliderInternal_CalculateValueFromScreenX(ScreenPositionX: number): number
        local TrackAbsolutePositionX                        = SliderTrackBackgroundFrame.AbsolutePosition.X
        local TrackAbsoluteSizeX                            = SliderTrackBackgroundFrame.AbsoluteSize.X
        local ClampedRelativeX                              = Utility_ClampNumber(ScreenPositionX - TrackAbsolutePositionX, 0, TrackAbsoluteSizeX)
        local NormalizedFraction                            = ClampedRelativeX / TrackAbsoluteSizeX
        local RawCalculatedValue                            = MinimumValue + NormalizedFraction * (MaximumValue - MinimumValue)
        return Utility_RoundToDecimalPlaces(RawCalculatedValue, SliderResolvedDecimalPlaces)
    end

    local function SliderInternal_UpdateVisualAndCallbacks(NewValue: number)
        SliderCurrentValue                                  = Utility_ClampNumber(NewValue, MinimumValue, MaximumValue)
        local NormalizedFillFraction                        = (SliderCurrentValue - MinimumValue) / (MaximumValue - MinimumValue)

        SliderCurrentValueDisplayLabel.Text                 = tostring(Utility_RoundToDecimalPlaces(SliderCurrentValue, SliderResolvedDecimalPlaces))

        ServiceTweenService:Create(
            SliderFillBarFrame,
            Utility_BuildTweenInfo(0.08),
            { Size = UDim2.new(NormalizedFillFraction, 0, 1, 0) }
        ):Play()

        if typeof(OnChangeCallbackFunction) == "function" then
            task.spawn(OnChangeCallbackFunction, SliderCurrentValue)
        end

        for _, StoredCallback in ipairs(SliderChangeCallbacks) do
            if typeof(StoredCallback) == "function" then
                task.spawn(StoredCallback, SliderCurrentValue)
            end
        end
    end

    SliderInputCaptureButton.MouseButton1Down:Connect(function(ClickPositionX: number)
        SliderIsDraggingActive = true
        SliderInternal_UpdateVisualAndCallbacks(SliderInternal_CalculateValueFromScreenX(ClickPositionX))
    end)

    ServiceUserInputService.InputChanged:Connect(function(ReceivedInput: InputObject)
        if SliderIsDraggingActive and ReceivedInput.UserInputType == Enum.UserInputType.MouseMovement then
            SliderInternal_UpdateVisualAndCallbacks(SliderInternal_CalculateValueFromScreenX(ReceivedInput.Position.X))
        end
    end)

    ServiceUserInputService.InputEnded:Connect(function(ReceivedInput: InputObject)
        if ReceivedInput.UserInputType == Enum.UserInputType.MouseButton1 then
            SliderIsDraggingActive = false
        end
    end)

    SliderInternal_UpdateVisualAndCallbacks(SliderCurrentValue)

    function SliderSelf:SetValue(NewValue: number)
        SliderInternal_UpdateVisualAndCallbacks(NewValue)
    end

    function SliderSelf:GetValue(): number
        return SliderCurrentValue
    end

    function SliderSelf:OnChanged(CallbackFunction: (number) -> ())
        table.insert(SliderChangeCallbacks, CallbackFunction)
    end

    SliderSelf.ContainerFrame                               = SliderOuterContainerFrame
    return SliderSelf
end

-- ============================================================
-- [СЕКЦИЯ 13: КОМПОНЕНТ — TEXTINPUT (ПОЛЕ ВВОДА)]
-- ============================================================

local TextInputClass                                        = setmetatable({}, { __index = ElementBaseClass })
TextInputClass.__index                                      = TextInputClass

function TextInputClass.new(ParentContainerFrame: Frame, LabelText: string, PlaceholderText: string, OnSubmitCallbackFunction: ((string) -> ())?)
    local TextInputSelf                                     = setmetatable({}, TextInputClass)
    local TextInputCurrentValue                             = ""

    local TextInputOuterContainerFrame                      = Instance.new("Frame")
    TextInputOuterContainerFrame.Name                       = "TextInputElement_" .. LabelText
    TextInputOuterContainerFrame.Size                       = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight + 10)
    TextInputOuterContainerFrame.BackgroundColor3           = GlobalThemeConfiguration.ColorElementBackground
    TextInputOuterContainerFrame.BorderSizePixel            = 0
    TextInputOuterContainerFrame.Parent                     = ParentContainerFrame
    Utility_ApplyRoundedCorners(TextInputOuterContainerFrame)
    Utility_ApplyUIStroke(TextInputOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local TextInputLabelAbove                               = Utility_CreateTextLabel(
        TextInputOuterContainerFrame,
        LabelText,
        GlobalThemeConfiguration.FontNameBody,
        12,
        GlobalThemeConfiguration.ColorTextSecondary,
        UDim2.new(1, -16, 0, 18),
        UDim2.new(0, 12, 0, 4)
    )

    -- Фоновый фрейм поля ввода
    local TextInputFieldBackground                          = Instance.new("Frame")
    TextInputFieldBackground.Size                           = UDim2.new(1, -16, 0, 26)
    TextInputFieldBackground.Position                       = UDim2.new(0, 8, 0, 22)
    TextInputFieldBackground.BackgroundColor3               = GlobalThemeConfiguration.ColorInputBackground
    TextInputFieldBackground.BorderSizePixel                = 0
    TextInputFieldBackground.Parent                         = TextInputOuterContainerFrame
    Utility_ApplyRoundedCorners(TextInputFieldBackground, GlobalThemeConfiguration.MeasureCornerRadiusSmall)
    local TextInputFieldStroke                              = Utility_ApplyUIStroke(TextInputFieldBackground, GlobalThemeConfiguration.ColorInputBorderNormal, 1)

    -- Само поле ввода
    local TextInputBoxInstance                              = Instance.new("TextBox")
    TextInputBoxInstance.Size                               = UDim2.new(1, -16, 1, 0)
    TextInputBoxInstance.Position                           = UDim2.new(0, 8, 0, 0)
    TextInputBoxInstance.BackgroundTransparency             = 1
    TextInputBoxInstance.BorderSizePixel                    = 0
    TextInputBoxInstance.PlaceholderText                    = PlaceholderText or ""
    TextInputBoxInstance.PlaceholderColor3                  = GlobalThemeConfiguration.ColorInputPlaceholder
    TextInputBoxInstance.Text                               = ""
    TextInputBoxInstance.Font                               = GlobalThemeConfiguration.FontNameMono
    TextInputBoxInstance.TextSize                           = 13
    TextInputBoxInstance.TextColor3                         = GlobalThemeConfiguration.ColorInputText
    TextInputBoxInstance.TextXAlignment                     = Enum.TextXAlignment.Left
    TextInputBoxInstance.ClearTextOnFocus                   = false
    TextInputBoxInstance.Parent                             = TextInputFieldBackground

    -- Анимация фокуса
    TextInputBoxInstance.Focused:Connect(function()
        ServiceTweenService:Create(
            TextInputFieldStroke,
            Utility_BuildTweenInfo(0.15),
            { Color = GlobalThemeConfiguration.ColorInputBorderFocused }
        ):Play()
    end)

    TextInputBoxInstance.FocusLost:Connect(function(WasEnterPressed: boolean)
        ServiceTweenService:Create(
            TextInputFieldStroke,
            Utility_BuildTweenInfo(0.15),
            { Color = GlobalThemeConfiguration.ColorInputBorderNormal }
        ):Play()
        TextInputCurrentValue = TextInputBoxInstance.Text
        if WasEnterPressed and typeof(OnSubmitCallbackFunction) == "function" then
            task.spawn(OnSubmitCallbackFunction, TextInputCurrentValue)
        end
    end)

    function TextInputSelf:GetValue(): string
        return TextInputBoxInstance.Text
    end

    function TextInputSelf:SetValue(NewText: string)
        TextInputBoxInstance.Text = NewText
        TextInputCurrentValue = NewText
    end

    function TextInputSelf:Clear()
        TextInputBoxInstance.Text = ""
        TextInputCurrentValue = ""
    end

    TextInputSelf.ContainerFrame                            = TextInputOuterContainerFrame
    return TextInputSelf
end

-- ============================================================
-- [СЕКЦИЯ 14: КОМПОНЕНТ — DROPDOWN (ВЫПАДАЮЩИЙ СПИСОК)]
-- ============================================================

local DropdownClass                                         = setmetatable({}, { __index = ElementBaseClass })
DropdownClass.__index                                       = DropdownClass

function DropdownClass.new(ParentContainerFrame: Frame, DropdownLabelText: string, OptionsTable: {string}, OnSelectCallbackFunction: ((string) -> ())?)
    local DropdownSelf                                      = setmetatable({}, DropdownClass)
    local DropdownIsCurrentlyOpen                           = false
    local DropdownCurrentSelectedValue                      = nil
    local DropdownFilteredOptionsList                       = {}
    local DropdownAllOptionsList                            = OptionsTable or {}
    local DropdownOptionRowHeight                           = 28
    local DropdownSearchBarHeight                           = 30
    local DropdownHeaderHeight                              = GlobalThemeConfiguration.MeasureElementHeight
    local DropdownMaxVisibleOptions                         = 5
    local DropdownCollapsedHeightValue                      = DropdownHeaderHeight
    local DropdownExpandedHeightValue                       = DropdownHeaderHeight + DropdownSearchBarHeight + (math.min(#DropdownAllOptionsList, DropdownMaxVisibleOptions) * DropdownOptionRowHeight) + 6

    -- Копируем список опций
    for _, OptionEntry in ipairs(DropdownAllOptionsList) do
        table.insert(DropdownFilteredOptionsList, OptionEntry)
    end

    local DropdownOuterContainerFrame                       = Instance.new("Frame")
    DropdownOuterContainerFrame.Name                        = "DropdownElement_" .. DropdownLabelText
    DropdownOuterContainerFrame.Size                        = UDim2.new(1, 0, 0, DropdownCollapsedHeightValue)
    DropdownOuterContainerFrame.BackgroundColor3            = GlobalThemeConfiguration.ColorElementBackground
    DropdownOuterContainerFrame.BorderSizePixel             = 0
    DropdownOuterContainerFrame.ClipsDescendants            = true
    DropdownOuterContainerFrame.Parent                      = ParentContainerFrame
    Utility_ApplyRoundedCorners(DropdownOuterContainerFrame)
    Utility_ApplyUIStroke(DropdownOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    -- Заголовок дропдауна
    local DropdownHeaderClickableButton                     = Instance.new("TextButton")
    DropdownHeaderClickableButton.Size                      = UDim2.new(1, 0, 0, DropdownHeaderHeight)
    DropdownHeaderClickableButton.BackgroundTransparency    = 1
    DropdownHeaderClickableButton.BorderSizePixel           = 0
    DropdownHeaderClickableButton.Text                      = ""
    DropdownHeaderClickableButton.Parent                    = DropdownOuterContainerFrame

    local DropdownHeaderMainLabel                           = Utility_CreateTextLabel(
        DropdownOuterContainerFrame,
        DropdownLabelText .. ":   выберите...",
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextSecondary,
        UDim2.new(1, -48, 0, DropdownHeaderHeight),
        UDim2.new(0, 12, 0, 0)
    )

    local DropdownArrowIconLabel                            = Utility_CreateTextLabel(
        DropdownOuterContainerFrame,
        "▾",
        GlobalThemeConfiguration.FontNameTitle,
        16,
        GlobalThemeConfiguration.ColorTextDisabled,
        UDim2.new(0, 26, 0, DropdownHeaderHeight),
        UDim2.new(1, -32, 0, 0)
    )
    DropdownArrowIconLabel.TextXAlignment                   = Enum.TextXAlignment.Center

    -- Поле поиска
    local DropdownSearchBarBackground                       = Instance.new("Frame")
    DropdownSearchBarBackground.Size                        = UDim2.new(1, -16, 0, DropdownSearchBarHeight - 4)
    DropdownSearchBarBackground.Position                    = UDim2.new(0, 8, 0, DropdownHeaderHeight + 2)
    DropdownSearchBarBackground.BackgroundColor3            = GlobalThemeConfiguration.ColorInputBackground
    DropdownSearchBarBackground.BorderSizePixel             = 0
    DropdownSearchBarBackground.Parent                      = DropdownOuterContainerFrame
    Utility_ApplyRoundedCorners(DropdownSearchBarBackground, GlobalThemeConfiguration.MeasureCornerRadiusSmall)
    Utility_ApplyUIStroke(DropdownSearchBarBackground, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local DropdownSearchTextBox                             = Instance.new("TextBox")
    DropdownSearchTextBox.Size                              = UDim2.new(1, -16, 1, 0)
    DropdownSearchTextBox.Position                          = UDim2.new(0, 8, 0, 0)
    DropdownSearchTextBox.BackgroundTransparency            = 1
    DropdownSearchTextBox.BorderSizePixel                   = 0
    DropdownSearchTextBox.PlaceholderText                   = "🔍 Поиск..."
    DropdownSearchTextBox.PlaceholderColor3                 = GlobalThemeConfiguration.ColorInputPlaceholder
    DropdownSearchTextBox.Text                              = ""
    DropdownSearchTextBox.Font                              = GlobalThemeConfiguration.FontNameBody
    DropdownSearchTextBox.TextSize                          = 12
    DropdownSearchTextBox.TextColor3                        = GlobalThemeConfiguration.ColorInputText
    DropdownSearchTextBox.TextXAlignment                    = Enum.TextXAlignment.Left
    DropdownSearchTextBox.ClearTextOnFocus                  = false
    DropdownSearchTextBox.Parent                            = DropdownSearchBarBackground

    -- ScrollingFrame для опций
    local DropdownOptionsScrollFrame                        = Instance.new("ScrollingFrame")
    DropdownOptionsScrollFrame.Size                         = UDim2.new(1, -16, 0, math.min(#DropdownAllOptionsList, DropdownMaxVisibleOptions) * DropdownOptionRowHeight)
    DropdownOptionsScrollFrame.Position                     = UDim2.new(0, 8, 0, DropdownHeaderHeight + DropdownSearchBarHeight + 2)
    DropdownOptionsScrollFrame.BackgroundTransparency       = 1
    DropdownOptionsScrollFrame.BorderSizePixel              = 0
    DropdownOptionsScrollFrame.ScrollBarThickness           = 2
    DropdownOptionsScrollFrame.ScrollBarImageColor3         = GlobalThemeConfiguration.ColorAccentPrimary
    DropdownOptionsScrollFrame.CanvasSize                   = UDim2.new(0, 0, 0, #DropdownAllOptionsList * DropdownOptionRowHeight)
    DropdownOptionsScrollFrame.Parent                       = DropdownOuterContainerFrame

    local DropdownOptionsListLayout                         = Instance.new("UIListLayout")
    DropdownOptionsListLayout.FillDirection                 = Enum.FillDirection.Vertical
    DropdownOptionsListLayout.SortOrder                     = Enum.SortOrder.LayoutOrder
    DropdownOptionsListLayout.Parent                        = DropdownOptionsScrollFrame

    -- Создаём строки опций
    local DropdownOptionRowsTable                           = {}

    local function DropdownInternal_BuildOptionRows()
        -- Удаляем старые строки
        for _, ExistingRow in ipairs(DropdownOptionRowsTable) do
            ExistingRow:Destroy()
        end
        DropdownOptionRowsTable                             = {}

        local VisibleRowCount                               = 0

        for OptionIndex, OptionDisplayText in ipairs(DropdownFilteredOptionsList) do
            local IsCurrentlySelected                       = (DropdownCurrentSelectedValue == OptionDisplayText)

            local SingleOptionRowButton                     = Instance.new("TextButton")
            SingleOptionRowButton.Name                      = "DropdownOption_" .. OptionDisplayText
            SingleOptionRowButton.Size                      = UDim2.new(1, 0, 0, DropdownOptionRowHeight)
            SingleOptionRowButton.BackgroundColor3          = IsCurrentlySelected
                and GlobalThemeConfiguration.ColorElementBackgroundHovered
                or GlobalThemeConfiguration.ColorElementBackground
            SingleOptionRowButton.BackgroundTransparency    = IsCurrentlySelected and 0 or 0.4
            SingleOptionRowButton.BorderSizePixel           = 0
            SingleOptionRowButton.Text                      = "  " .. OptionDisplayText
            SingleOptionRowButton.Font                      = GlobalThemeConfiguration.FontNameBody
            SingleOptionRowButton.TextSize                  = 12
            SingleOptionRowButton.TextColor3                = IsCurrentlySelected
                and GlobalThemeConfiguration.ColorTextPrimary
                or GlobalThemeConfiguration.ColorTextSecondary
            SingleOptionRowButton.TextXAlignment            = Enum.TextXAlignment.Left
            SingleOptionRowButton.LayoutOrder               = OptionIndex
            SingleOptionRowButton.Parent                    = DropdownOptionsScrollFrame

            table.insert(DropdownOptionRowsTable, SingleOptionRowButton)
            VisibleRowCount                                 = VisibleRowCount + 1

            SingleOptionRowButton.MouseEnter:Connect(function()
                if DropdownCurrentSelectedValue ~= OptionDisplayText then
                    ServiceTweenService:Create(
                        SingleOptionRowButton,
                        Utility_BuildTweenInfo(0.1),
                        { TextColor3 = GlobalThemeConfiguration.ColorTextPrimary, BackgroundTransparency = 0.2 }
                    ):Play()
                end
            end)

            SingleOptionRowButton.MouseLeave:Connect(function()
                if DropdownCurrentSelectedValue ~= OptionDisplayText then
                    ServiceTweenService:Create(
                        SingleOptionRowButton,
                        Utility_BuildTweenInfo(0.1),
                        { TextColor3 = GlobalThemeConfiguration.ColorTextSecondary, BackgroundTransparency = 0.4 }
                    ):Play()
                end
            end)

            SingleOptionRowButton.MouseButton1Click:Connect(function()
                DropdownCurrentSelectedValue                = OptionDisplayText
                DropdownHeaderMainLabel.Text                = DropdownLabelText .. ":   " .. OptionDisplayText
                DropdownHeaderMainLabel.TextColor3          = GlobalThemeConfiguration.ColorTextPrimary

                -- Закрываем дропдаун
                DropdownIsCurrentlyOpen                     = false
                ServiceTweenService:Create(
                    DropdownOuterContainerFrame,
                    Utility_BuildTweenInfo(0.22),
                    { Size = UDim2.new(1, 0, 0, DropdownCollapsedHeightValue) }
                ):Play()
                ServiceTweenService:Create(
                    DropdownArrowIconLabel,
                    Utility_BuildTweenInfo(0.18),
                    { Rotation = 0 }
                ):Play()
                DropdownSearchTextBox.Text                  = ""

                DropdownInternal_BuildOptionRows()

                if typeof(OnSelectCallbackFunction) == "function" then
                    task.spawn(OnSelectCallbackFunction, OptionDisplayText)
                end
            end)
        end

        DropdownOptionsScrollFrame.CanvasSize               = UDim2.new(0, 0, 0, VisibleRowCount * DropdownOptionRowHeight)
    end

    -- Фильтрация по поиску
    DropdownSearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local SearchQuery                                   = DropdownSearchTextBox.Text:lower()
        DropdownFilteredOptionsList                         = {}

        for _, OptionEntry in ipairs(DropdownAllOptionsList) do
            if OptionEntry:lower():find(SearchQuery, 1, true) then
                table.insert(DropdownFilteredOptionsList, OptionEntry)
            end
        end

        DropdownInternal_BuildOptionRows()
    end)

    DropdownInternal_BuildOptionRows()

    -- Открытие/закрытие
    DropdownHeaderClickableButton.MouseButton1Click:Connect(function()
        DropdownIsCurrentlyOpen                             = not DropdownIsCurrentlyOpen
        DropdownExpandedHeightValue                         = DropdownHeaderHeight + DropdownSearchBarHeight + (math.min(#DropdownAllOptionsList, DropdownMaxVisibleOptions) * DropdownOptionRowHeight) + 6

        local TargetHeight                                  = DropdownIsCurrentlyOpen
            and DropdownExpandedHeightValue
            or DropdownCollapsedHeightValue

        ServiceTweenService:Create(
            DropdownOuterContainerFrame,
            Utility_BuildTweenInfo(0.22),
            { Size = UDim2.new(1, 0, 0, TargetHeight) }
        ):Play()

        ServiceTweenService:Create(
            DropdownArrowIconLabel,
            Utility_BuildTweenInfo(0.18),
            { Rotation = DropdownIsCurrentlyOpen and 180 or 0 }
        ):Play()
    end)

    function DropdownSelf:GetValue(): string?
        return DropdownCurrentSelectedValue
    end

    function DropdownSelf:SetOptions(NewOptionsTable: {string})
        DropdownAllOptionsList                              = NewOptionsTable
        DropdownFilteredOptionsList                         = {}
        for _, OptionEntry in ipairs(DropdownAllOptionsList) do
            table.insert(DropdownFilteredOptionsList, OptionEntry)
        end
        DropdownInternal_BuildOptionRows()
    end

    DropdownSelf.ContainerFrame                             = DropdownOuterContainerFrame
    return DropdownSelf
end

-- ============================================================
-- [СЕКЦИЯ 15: КОМПОНЕНТ — KEYBIND (ПРИВЯЗКА КЛАВИШ)]
-- ============================================================

local KeybindClass                                          = setmetatable({}, { __index = ElementBaseClass })
KeybindClass.__index                                        = KeybindClass

function KeybindClass.new(ParentContainerFrame: Frame, KeybindLabelText: string, DefaultKey: Enum.KeyCode?, OnActivateCallbackFunction: (() -> ())?)
    local KeybindSelf                                       = setmetatable({}, KeybindClass)
    local KeybindCurrentKey                                 = DefaultKey or Enum.KeyCode.RightShift
    local KeybindIsListeningForInput                        = false

    local KeybindOuterContainerFrame                        = Instance.new("Frame")
    KeybindOuterContainerFrame.Name                         = "KeybindElement_" .. KeybindLabelText
    KeybindOuterContainerFrame.Size                         = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight)
    KeybindOuterContainerFrame.BackgroundColor3             = GlobalThemeConfiguration.ColorElementBackground
    KeybindOuterContainerFrame.BorderSizePixel              = 0
    KeybindOuterContainerFrame.Parent                       = ParentContainerFrame
    Utility_ApplyRoundedCorners(KeybindOuterContainerFrame)
    Utility_ApplyUIStroke(KeybindOuterContainerFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local KeybindMainTextLabel                              = Utility_CreateTextLabel(
        KeybindOuterContainerFrame,
        KeybindLabelText,
        GlobalThemeConfiguration.FontNameBody,
        13,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(1, -110, 1, 0),
        UDim2.new(0, 12, 0, 0)
    )

    -- Кнопка отображения текущей клавиши
    local KeybindKeyDisplayButton                           = Instance.new("TextButton")
    KeybindKeyDisplayButton.Size                            = UDim2.new(0, 90, 0, 24)
    KeybindKeyDisplayButton.Position                        = UDim2.new(1, -100, 0.5, -12)
    KeybindKeyDisplayButton.BackgroundColor3                = GlobalThemeConfiguration.ColorSidebarBackground
    KeybindKeyDisplayButton.BorderSizePixel                 = 0
    KeybindKeyDisplayButton.Text                            = KeybindCurrentKey.Name
    KeybindKeyDisplayButton.Font                            = GlobalThemeConfiguration.FontNameMono
    KeybindKeyDisplayButton.TextSize                        = 12
    KeybindKeyDisplayButton.TextColor3                      = GlobalThemeConfiguration.ColorTextAccent
    KeybindKeyDisplayButton.Parent                          = KeybindOuterContainerFrame
    Utility_ApplyRoundedCorners(KeybindKeyDisplayButton, GlobalThemeConfiguration.MeasureCornerRadiusSmall)
    Utility_ApplyUIStroke(KeybindKeyDisplayButton, GlobalThemeConfiguration.ColorBorderActive, 1)

    KeybindKeyDisplayButton.MouseButton1Click:Connect(function()
        KeybindIsListeningForInput                          = true
        KeybindKeyDisplayButton.Text                        = "..."
        KeybindKeyDisplayButton.TextColor3                  = GlobalThemeConfiguration.ColorAccentWarning
        ServiceTweenService:Create(
            KeybindKeyDisplayButton,
            Utility_BuildTweenInfo(0.15),
            { BackgroundColor3 = GlobalThemeConfiguration.ColorElementBackgroundHovered }
        ):Play()
    end)

    ServiceUserInputService.InputBegan:Connect(function(ReceivedInput: InputObject, WasGameProcessed: boolean)
        if KeybindIsListeningForInput then
            if ReceivedInput.UserInputType == Enum.UserInputType.Keyboard then
                KeybindCurrentKey                           = ReceivedInput.KeyCode
                KeybindIsListeningForInput                  = false
                KeybindKeyDisplayButton.Text                = ReceivedInput.KeyCode.Name
                KeybindKeyDisplayButton.TextColor3          = GlobalThemeConfiguration.ColorTextAccent
                ServiceTweenService:Create(
                    KeybindKeyDisplayButton,
                    Utility_BuildTweenInfo(0.15),
                    { BackgroundColor3 = GlobalThemeConfiguration.ColorSidebarBackground }
                ):Play()
            end
        elseif not WasGameProcessed then
            if ReceivedInput.UserInputType == Enum.UserInputType.Keyboard then
                if ReceivedInput.KeyCode == KeybindCurrentKey then
                    if typeof(OnActivateCallbackFunction) == "function" then
                        task.spawn(OnActivateCallbackFunction)
                    end
                end
            end
        end
    end)

    function KeybindSelf:GetKey(): Enum.KeyCode
        return KeybindCurrentKey
    end

    function KeybindSelf:SetKey(NewKey: Enum.KeyCode)
        KeybindCurrentKey                                   = NewKey
        KeybindKeyDisplayButton.Text                        = NewKey.Name
    end

    KeybindSelf.ContainerFrame                              = KeybindOuterContainerFrame
    return KeybindSelf
end

-- ============================================================
-- [СЕКЦИЯ 16: КОМПОНЕНТ — MULTITOGGLE (ГРУППА ПЕРЕКЛЮЧАТЕЛЕЙ)]
-- ============================================================

local MultiToggleClass                                      = setmetatable({}, { __index = ElementBaseClass })
MultiToggleClass.__index                                    = MultiToggleClass

function MultiToggleClass.new(ParentContainerFrame: Frame, GroupLabelText: string, OptionsTable: {string}, DefaultSelected: string?, OnSelectCallbackFunction: ((string) -> ())?)
    local MultiToggleSelf                                   = setmetatable({}, MultiToggleClass)
    local MultiToggleCurrentSelected                        = DefaultSelected or (OptionsTable[1] or "")

    local MultiToggleOuterFrame                             = Instance.new("Frame")
    MultiToggleOuterFrame.Name                              = "MultiToggleElement_" .. GroupLabelText
    MultiToggleOuterFrame.Size                              = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureElementHeight + 10)
    MultiToggleOuterFrame.BackgroundColor3                  = GlobalThemeConfiguration.ColorElementBackground
    MultiToggleOuterFrame.BorderSizePixel                   = 0
    MultiToggleOuterFrame.Parent                            = ParentContainerFrame
    Utility_ApplyRoundedCorners(MultiToggleOuterFrame)
    Utility_ApplyUIStroke(MultiToggleOuterFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    local MultiToggleLabelAbove                             = Utility_CreateTextLabel(
        MultiToggleOuterFrame,
        GroupLabelText,
        GlobalThemeConfiguration.FontNameBody,
        12,
        GlobalThemeConfiguration.ColorTextSecondary,
        UDim2.new(1, -16, 0, 18),
        UDim2.new(0, 12, 0, 4)
    )

    -- Горизонтальный контейнер для кнопок-опций
    local MultiToggleButtonsRow                             = Instance.new("Frame")
    MultiToggleButtonsRow.Size                              = UDim2.new(1, -16, 0, 26)
    MultiToggleButtonsRow.Position                          = UDim2.new(0, 8, 0, 22)
    MultiToggleButtonsRow.BackgroundColor3                  = GlobalThemeConfiguration.ColorSidebarBackground
    MultiToggleButtonsRow.BorderSizePixel                   = 0
    MultiToggleButtonsRow.Parent                            = MultiToggleOuterFrame
    Utility_ApplyRoundedCorners(MultiToggleButtonsRow, GlobalThemeConfiguration.MeasureCornerRadiusSmall)

    local MultiToggleButtonsListLayout                      = Instance.new("UIListLayout")
    MultiToggleButtonsListLayout.FillDirection              = Enum.FillDirection.Horizontal
    MultiToggleButtonsListLayout.SortOrder                  = Enum.SortOrder.LayoutOrder
    MultiToggleButtonsListLayout.Parent                     = MultiToggleButtonsRow

    local MultiToggleButtonRefs                             = {}
    local SingleButtonWidth                                 = 1 / #OptionsTable

    for OptionIndex, OptionText in ipairs(OptionsTable) do
        local IsThisOptionSelected                          = (OptionText == MultiToggleCurrentSelected)

        local SingleOptionButton                            = Instance.new("TextButton")
        SingleOptionButton.Name                             = "MultiToggleOption_" .. OptionText
        SingleOptionButton.Size                             = UDim2.new(SingleButtonWidth, 0, 1, 0)
        SingleOptionButton.BackgroundColor3                 = IsThisOptionSelected
            and GlobalThemeConfiguration.ColorAccentPrimary
            or GlobalThemeConfiguration.ColorSidebarBackground
        SingleOptionButton.BackgroundTransparency           = IsThisOptionSelected and 0.3 or 0.8
        SingleOptionButton.BorderSizePixel                  = 0
        SingleOptionButton.Text                             = OptionText
        SingleOptionButton.Font                             = GlobalThemeConfiguration.FontNameBody
        SingleOptionButton.TextSize                         = 12
        SingleOptionButton.TextColor3                       = IsThisOptionSelected
            and GlobalThemeConfiguration.ColorTextPrimary
            or GlobalThemeConfiguration.ColorTextSecondary
        SingleOptionButton.LayoutOrder                      = OptionIndex
        SingleOptionButton.Parent                           = MultiToggleButtonsRow
        Utility_ApplyRoundedCorners(SingleOptionButton, GlobalThemeConfiguration.MeasureCornerRadiusSmall)

        table.insert(MultiToggleButtonRefs, { Button = SingleOptionButton, OptionText = OptionText })

        SingleOptionButton.MouseButton1Click:Connect(function()
            MultiToggleCurrentSelected                      = OptionText

            for _, ButtonRef in ipairs(MultiToggleButtonRefs) do
                local IsSelected                            = (ButtonRef.OptionText == MultiToggleCurrentSelected)
                ServiceTweenService:Create(
                    ButtonRef.Button,
                    Utility_BuildTweenInfo(0.15),
                    {
                        BackgroundColor3 = IsSelected and GlobalThemeConfiguration.ColorAccentPrimary or GlobalThemeConfiguration.ColorSidebarBackground,
                        BackgroundTransparency = IsSelected and 0.3 or 0.8,
                        TextColor3 = IsSelected and GlobalThemeConfiguration.ColorTextPrimary or GlobalThemeConfiguration.ColorTextSecondary
                    }
                ):Play()
            end

            if typeof(OnSelectCallbackFunction) == "function" then
                task.spawn(OnSelectCallbackFunction, MultiToggleCurrentSelected)
            end
        end)
    end

    function MultiToggleSelf:GetValue(): string
        return MultiToggleCurrentSelected
    end

    function MultiToggleSelf:SetValue(NewSelectedText: string)
        MultiToggleCurrentSelected                          = NewSelectedText
        for _, ButtonRef in ipairs(MultiToggleButtonRefs) do
            local IsSelected                                = (ButtonRef.OptionText == MultiToggleCurrentSelected)
            ButtonRef.Button.BackgroundColor3               = IsSelected and GlobalThemeConfiguration.ColorAccentPrimary or GlobalThemeConfiguration.ColorSidebarBackground
            ButtonRef.Button.BackgroundTransparency         = IsSelected and 0.3 or 0.8
            ButtonRef.Button.TextColor3                     = IsSelected and GlobalThemeConfiguration.ColorTextPrimary or GlobalThemeConfiguration.ColorTextSecondary
        end
    end

    MultiToggleSelf.ContainerFrame                          = MultiToggleOuterFrame
    return MultiToggleSelf
end

-- ============================================================
-- [СЕКЦИЯ 17: КЛАСС СЕКЦИИ (SECTION)]
-- ============================================================

local SectionClass                                          = {}
SectionClass.__index                                        = SectionClass

function SectionClass.new(ParentScrollingFrame: ScrollingFrame, SectionDisplayTitle: string)
    local SectionSelf                                       = setmetatable({}, SectionClass)

    local SectionOuterWrapperFrame                          = Instance.new("Frame")
    SectionOuterWrapperFrame.Name                           = "Section_" .. SectionDisplayTitle
    SectionOuterWrapperFrame.Size                           = UDim2.new(1, 0, 0, 0)
    SectionOuterWrapperFrame.AutomaticSize                  = Enum.AutomaticSize.Y
    SectionOuterWrapperFrame.BackgroundColor3               = GlobalThemeConfiguration.ColorSectionBackground
    SectionOuterWrapperFrame.BorderSizePixel                = 0
    SectionOuterWrapperFrame.Parent                         = ParentScrollingFrame
    Utility_ApplyRoundedCorners(SectionOuterWrapperFrame, GlobalThemeConfiguration.MeasureCornerRadiusLarge)
    Utility_ApplyUIStroke(SectionOuterWrapperFrame, GlobalThemeConfiguration.ColorBorderNormal, 1)

    -- Заголовок секции
    local SectionTitleRowFrame                              = Instance.new("Frame")
    SectionTitleRowFrame.Size                               = UDim2.new(1, 0, 0, 30)
    SectionTitleRowFrame.BackgroundTransparency             = 1
    SectionTitleRowFrame.BorderSizePixel                    = 0
    SectionTitleRowFrame.Parent                             = SectionOuterWrapperFrame

    local SectionTitleAccentDot                             = Instance.new("Frame")
    SectionTitleAccentDot.Size                              = UDim2.new(0, 4, 0, 4)
    SectionTitleAccentDot.Position                          = UDim2.new(0, 12, 0.5, -2)
    SectionTitleAccentDot.BackgroundColor3                  = GlobalThemeConfiguration.ColorAccentPrimary
    SectionTitleAccentDot.BorderSizePixel                   = 0
    SectionTitleAccentDot.Parent                            = SectionTitleRowFrame
    Utility_ApplyRoundedCorners(SectionTitleAccentDot, UDim.new(1, 0))

    local SectionTitleDisplayLabel                          = Utility_CreateTextLabel(
        SectionTitleRowFrame,
        SectionDisplayTitle:upper(),
        GlobalThemeConfiguration.FontNameTitle,
        11,
        GlobalThemeConfiguration.ColorAccentPrimary,
        UDim2.new(1, -28, 1, 0),
        UDim2.new(0, 20, 0, 0)
    )
    SectionTitleDisplayLabel.TextColor3                     = GlobalThemeConfiguration.ColorTextSecondary

    -- Горизонтальный разделитель под заголовком
    local SectionHorizontalDividerFrame                     = Instance.new("Frame")
    SectionHorizontalDividerFrame.Size                      = UDim2.new(1, -20, 0, 1)
    SectionHorizontalDividerFrame.Position                  = UDim2.new(0, 10, 0, 30)
    SectionHorizontalDividerFrame.BackgroundColor3          = GlobalThemeConfiguration.ColorBorderNormal
    SectionHorizontalDividerFrame.BorderSizePixel           = 0
    SectionHorizontalDividerFrame.Parent                    = SectionOuterWrapperFrame

    -- Контейнер для всех элементов секции
    local SectionElementsContainerFrame                     = Instance.new("Frame")
    SectionElementsContainerFrame.Name                      = "ElementsContainer"
    SectionElementsContainerFrame.Size                      = UDim2.new(1, -16, 0, 0)
    SectionElementsContainerFrame.Position                  = UDim2.new(0, 8, 0, 36)
    SectionElementsContainerFrame.AutomaticSize             = Enum.AutomaticSize.Y
    SectionElementsContainerFrame.BackgroundTransparency    = 1
    SectionElementsContainerFrame.BorderSizePixel           = 0
    SectionElementsContainerFrame.Parent                    = SectionOuterWrapperFrame

    local SectionElementsVerticalListLayout                 = Utility_CreateVerticalListLayout(SectionElementsContainerFrame, GlobalThemeConfiguration.MeasureSectionInternalPadding)

    local SectionBottomSpacingPadding                       = Instance.new("UIPadding")
    SectionBottomSpacingPadding.PaddingBottom               = UDim.new(0, 10)
    SectionBottomSpacingPadding.Parent                      = SectionElementsContainerFrame

    SectionSelf.ElementsContainerFrame                      = SectionElementsContainerFrame
    SectionSelf.OuterWrapperFrame                           = SectionOuterWrapperFrame

    -- ---- Методы добавления элементов ----

    function SectionSelf:AddButton(LabelText: string, Callback: (() -> ())?, Style: string?)
        return ButtonClass.new(self.ElementsContainerFrame, LabelText, Callback, Style)
    end

    function SectionSelf:AddToggle(LabelText: string, Default: boolean, Callback: ((boolean) -> ())?)
        return ToggleClass.new(self.ElementsContainerFrame, LabelText, Default, Callback)
    end

    function SectionSelf:AddSlider(LabelText: string, Min: number, Max: number, Default: number, Callback: ((number) -> ())?, Decimals: number?)
        return SliderClass.new(self.ElementsContainerFrame, LabelText, Min, Max, Default, Callback, Decimals)
    end

    function SectionSelf:AddDropdown(LabelText: string, Options: {string}, Callback: ((string) -> ())?)
        return DropdownClass.new(self.ElementsContainerFrame, LabelText, Options, Callback)
    end

    function SectionSelf:AddTextInput(LabelText: string, Placeholder: string, Callback: ((string) -> ())?)
        return TextInputClass.new(self.ElementsContainerFrame, LabelText, Placeholder, Callback)
    end

    function SectionSelf:AddKeybind(LabelText: string, DefaultKey: Enum.KeyCode?, Callback: (() -> ())?)
        return KeybindClass.new(self.ElementsContainerFrame, LabelText, DefaultKey, Callback)
    end

    function SectionSelf:AddParagraph(TitleText: string, BodyText: string)
        return ParagraphClass.new(self.ElementsContainerFrame, TitleText, BodyText)
    end

    function SectionSelf:AddSeparator(LabelText: string?)
        return SeparatorClass.new(self.ElementsContainerFrame, LabelText)
    end

    function SectionSelf:AddProgressBar(LabelText: string, InitialPercent: number)
        return ProgressBarClass.new(self.ElementsContainerFrame, LabelText, InitialPercent)
    end

    function SectionSelf:AddMultiToggle(LabelText: string, Options: {string}, Default: string?, Callback: ((string) -> ())?)
        return MultiToggleClass.new(self.ElementsContainerFrame, LabelText, Options, Default, Callback)
    end

    return SectionSelf
end

-- ============================================================
-- [СЕКЦИЯ 18: КЛАСС ВКЛАДКИ (TAB)]
-- ============================================================

local TabClass                                              = {}
TabClass.__index                                            = TabClass

function TabClass.new(TabContentHolderFrame: Frame)
    local TabSelf                                           = setmetatable({}, TabClass)

    local TabScrollingContentFrame                          = Instance.new("ScrollingFrame")
    TabScrollingContentFrame.Name                           = "TabScrollingContent"
    TabScrollingContentFrame.Size                           = UDim2.new(1, 0, 1, 0)
    TabScrollingContentFrame.BackgroundTransparency         = 1
    TabScrollingContentFrame.BorderSizePixel                = 0
    TabScrollingContentFrame.ScrollBarThickness             = 3
    TabScrollingContentFrame.ScrollBarImageColor3           = GlobalThemeConfiguration.ColorAccentPrimary
    TabScrollingContentFrame.CanvasSize                     = UDim2.new(0, 0, 0, 0)
    TabScrollingContentFrame.AutomaticCanvasSize            = Enum.AutomaticSize.Y
    TabScrollingContentFrame.Visible                        = false
    TabScrollingContentFrame.Parent                         = TabContentHolderFrame

    local TabContentInternalListLayout                      = Utility_CreateVerticalListLayout(TabScrollingContentFrame, 10)

    local TabContentInternalPadding                         = Instance.new("UIPadding")
    TabContentInternalPadding.PaddingTop                    = UDim.new(0, 10)
    TabContentInternalPadding.PaddingLeft                   = UDim.new(0, 10)
    TabContentInternalPadding.PaddingRight                  = UDim.new(0, 10)
    TabContentInternalPadding.PaddingBottom                 = UDim.new(0, 10)
    TabContentInternalPadding.Parent                        = TabScrollingContentFrame

    TabSelf.ScrollingFrame                                  = TabScrollingContentFrame

    function TabSelf:AddSection(SectionTitle: string)
        return SectionClass.new(self.ScrollingFrame, SectionTitle)
    end

    function TabSelf:SetVisible(ShouldBeVisible: boolean)
        self.ScrollingFrame.Visible = ShouldBeVisible
    end

    return TabSelf
end

-- ============================================================
-- [СЕКЦИЯ 19: КЛАСС ОКНА (WINDOW)]
-- ============================================================

local WindowClass                                           = {}
WindowClass.__index                                         = WindowClass

function WindowClass.new(WindowConfigurationOptions: table)
    local WindowSelf                                        = setmetatable({}, WindowClass)

    local WindowResolvedTitle                               = WindowConfigurationOptions.Title or "Aeternum"
    local WindowResolvedWidth                               = WindowConfigurationOptions.Width or 540
    local WindowResolvedHeight                              = WindowConfigurationOptions.Height or 440
    local WindowResolvedAccentColor                         = WindowConfigurationOptions.AccentColor or GlobalThemeConfiguration.ColorAccentPrimary

    WindowSelf.TabInstancesList                             = {}
    WindowSelf.IsWindowMinimized                            = false

    -- Root ScreenGui
    local WindowRootScreenGui                               = Instance.new("ScreenGui")
    WindowRootScreenGui.Name                                = "AeternumWindow_" .. WindowResolvedTitle
    WindowRootScreenGui.ResetOnSpawn                        = false
    WindowRootScreenGui.ZIndexBehavior                      = Enum.ZIndexBehavior.Sibling
    WindowRootScreenGui.IgnoreGuiInset                      = true
    WindowRootScreenGui.DisplayOrder                        = 10
    WindowRootScreenGui.Parent                              = ReferenceLocalPlayerGui

    -- Главный фрейм окна
    local WindowPrimaryFrame                                = Instance.new("Frame")
    WindowPrimaryFrame.Name                                 = "WindowPrimaryFrame"
    WindowPrimaryFrame.Size                                 = UDim2.new(0, WindowResolvedWidth, 0, WindowResolvedHeight)
    WindowPrimaryFrame.Position                             = UDim2.new(0.5, -WindowResolvedWidth / 2, 0.5, -WindowResolvedHeight / 2)
    WindowPrimaryFrame.BackgroundColor3                     = GlobalThemeConfiguration.ColorMainBackground
    WindowPrimaryFrame.BorderSizePixel                      = 0
    WindowPrimaryFrame.ClipsDescendants                     = true
    WindowPrimaryFrame.Parent                               = WindowRootScreenGui
    Utility_ApplyRoundedCorners(WindowPrimaryFrame, GlobalThemeConfiguration.MeasureCornerRadiusLarge)
    Utility_ApplyUIStroke(WindowPrimaryFrame, GlobalThemeConfiguration.ColorBorderNormal, 1.5)

    -- Заголовочная полоса
    local WindowTitleBarFrame                               = Instance.new("Frame")
    WindowTitleBarFrame.Name                                = "TitleBarFrame"
    WindowTitleBarFrame.Size                                = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureWindowTitleBarHeight)
    WindowTitleBarFrame.BackgroundColor3                    = GlobalThemeConfiguration.ColorSidebarBackground
    WindowTitleBarFrame.BorderSizePixel                     = 0
    WindowTitleBarFrame.Parent                              = WindowPrimaryFrame

    -- Тонкая акцентная линия под title bar
    local WindowTitleBarBottomAccentLine                    = Instance.new("Frame")
    WindowTitleBarBottomAccentLine.Size                     = UDim2.new(1, 0, 0, 2)
    WindowTitleBarBottomAccentLine.Position                 = UDim2.new(0, 0, 1, -2)
    WindowTitleBarBottomAccentLine.BackgroundColor3         = WindowResolvedAccentColor
    WindowTitleBarBottomAccentLine.BorderSizePixel          = 0
    WindowTitleBarBottomAccentLine.Parent                   = WindowTitleBarFrame

    -- Логотип / иконка
    local WindowLogoIndicatorFrame                          = Instance.new("Frame")
    WindowLogoIndicatorFrame.Size                           = UDim2.new(0, 8, 0, 8)
    WindowLogoIndicatorFrame.Position                       = UDim2.new(0, 14, 0.5, -4)
    WindowLogoIndicatorFrame.BackgroundColor3               = WindowResolvedAccentColor
    WindowLogoIndicatorFrame.BorderSizePixel                = 0
    WindowLogoIndicatorFrame.Parent                         = WindowTitleBarFrame
    Utility_ApplyRoundedCorners(WindowLogoIndicatorFrame, UDim.new(0, 2))

    -- Название окна
    local WindowTitleDisplayLabel                           = Utility_CreateTextLabel(
        WindowTitleBarFrame,
        WindowResolvedTitle,
        GlobalThemeConfiguration.FontNameTitle,
        15,
        GlobalThemeConfiguration.ColorTextPrimary,
        UDim2.new(1, -120, 1, 0),
        UDim2.new(0, 28, 0, 0)
    )

    -- Кнопка свернуть
    local WindowMinimizeButton                              = Instance.new("TextButton")
    WindowMinimizeButton.Size                               = UDim2.new(0, 28, 0, 28)
    WindowMinimizeButton.Position                           = UDim2.new(1, -72, 0.5, -14)
    WindowMinimizeButton.BackgroundColor3                   = GlobalThemeConfiguration.ColorElementBackground
    WindowMinimizeButton.BorderSizePixel                    = 0
    WindowMinimizeButton.Text                               = "—"
    WindowMinimizeButton.Font                               = GlobalThemeConfiguration.FontNameTitle
    WindowMinimizeButton.TextSize                           = 14
    WindowMinimizeButton.TextColor3                         = GlobalThemeConfiguration.ColorTextSecondary
    WindowMinimizeButton.Parent                             = WindowTitleBarFrame
    Utility_ApplyRoundedCorners(WindowMinimizeButton, GlobalThemeConfiguration.MeasureCornerRadiusSmall)

    -- Кнопка закрыть
    local WindowCloseButton                                 = Instance.new("TextButton")
    WindowCloseButton.Size                                  = UDim2.new(0, 28, 0, 28)
    WindowCloseButton.Position                              = UDim2.new(1, -38, 0.5, -14)
    WindowCloseButton.BackgroundColor3                      = GlobalThemeConfiguration.ColorAccentDanger
    WindowCloseButton.BackgroundTransparency                = 0.3
    WindowCloseButton.BorderSizePixel                       = 0
    WindowCloseButton.Text                                  = "✕"
    WindowCloseButton.Font                                  = GlobalThemeConfiguration.FontNameTitle
    WindowCloseButton.TextSize                              = 13
    WindowCloseButton.TextColor3                            = Color3.fromRGB(255, 255, 255)
    WindowCloseButton.Parent                                = WindowTitleBarFrame
    Utility_ApplyRoundedCorners(WindowCloseButton, GlobalThemeConfiguration.MeasureCornerRadiusSmall)

    -- Панель вкладок
    local WindowTabBarFrame                                 = Instance.new("Frame")
    WindowTabBarFrame.Name                                  = "TabBarFrame"
    WindowTabBarFrame.Size                                  = UDim2.new(1, 0, 0, GlobalThemeConfiguration.MeasureWindowTabBarHeight)
    WindowTabBarFrame.Position                              = UDim2.new(0, 0, 0, GlobalThemeConfiguration.MeasureWindowTitleBarHeight)
    WindowTabBarFrame.BackgroundColor3                      = GlobalThemeConfiguration.ColorSidebarBackground
    WindowTabBarFrame.BorderSizePixel                       = 0
    WindowTabBarFrame.Parent                                = WindowPrimaryFrame

    local WindowTabBarButtonsListLayout                     = Instance.new("UIListLayout")
    WindowTabBarButtonsListLayout.FillDirection             = Enum.FillDirection.Horizontal
    WindowTabBarButtonsListLayout.SortOrder                 = Enum.SortOrder.LayoutOrder
    WindowTabBarButtonsListLayout.VerticalAlignment         = Enum.VerticalAlignment.Center
    WindowTabBarButtonsListLayout.Padding                   = UDim.new(0, 4)
    WindowTabBarButtonsListLayout.Parent                    = WindowTabBarFrame

    local WindowTabBarInternalPadding                       = Instance.new("UIPadding")
    WindowTabBarInternalPadding.PaddingLeft                 = UDim.new(0, 10)
    WindowTabBarInternalPadding.PaddingTop                  = UDim.new(0, 4)
    WindowTabBarInternalPadding.PaddingBottom               = UDim.new(0, 4)
    WindowTabBarInternalPadding.Parent                      = WindowTabBarFrame

    -- Область контента вкладок
    local WindowTabContentAreaFrame                         = Instance.new("Frame")
    WindowTabContentAreaFrame.Name                          = "TabContentAreaFrame"
    WindowTabContentAreaFrame.Size                          = UDim2.new(
        1, 0, 1,
        -(GlobalThemeConfiguration.MeasureWindowTitleBarHeight + GlobalThemeConfiguration.MeasureWindowTabBarHeight)
    )
    WindowTabContentAreaFrame.Position                      = UDim2.new(
        0, 0, 0,
        GlobalThemeConfiguration.MeasureWindowTitleBarHeight + GlobalThemeConfiguration.MeasureWindowTabBarHeight
    )
    WindowTabContentAreaFrame.BackgroundTransparency        = 1
    WindowTabContentAreaFrame.BorderSizePixel               = 0
    WindowTabContentAreaFrame.Parent                        = WindowPrimaryFrame

    WindowSelf.RootScreenGui                                = WindowRootScreenGui
    WindowSelf.PrimaryFrame                                 = WindowPrimaryFrame
    WindowSelf.TabBarFrame                                  = WindowTabBarFrame
    WindowSelf.TabContentAreaFrame                          = WindowTabContentAreaFrame
    WindowSelf.ResolvedWidth                                = WindowResolvedWidth
    WindowSelf.ResolvedHeight                               = WindowResolvedHeight

    -- Перетаскивание
    System_EnableWindowDragging(WindowPrimaryFrame, WindowTitleBarFrame)

    -- Кнопка закрыть — логика
    WindowCloseButton.MouseButton1Click:Connect(function()
        ServiceTweenService:Create(
            WindowPrimaryFrame,
            Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationSlow),
            { Size = UDim2.new(0, WindowResolvedWidth, 0, 0), BackgroundTransparency = 1 }
        ):Play()
        task.delay(GlobalThemeConfiguration.AnimationTweenDurationSlow + 0.05, function()
            WindowRootScreenGui:Destroy()
        end)
    end)

    -- Кнопка свернуть — логика
    WindowMinimizeButton.MouseButton1Click:Connect(function()
        WindowSelf.IsWindowMinimized                        = not WindowSelf.IsWindowMinimized
        if WindowSelf.IsWindowMinimized then
            ServiceTweenService:Create(
                WindowPrimaryFrame,
                Utility_BuildTweenInfo(0.28),
                { Size = UDim2.new(0, WindowResolvedWidth, 0, GlobalThemeConfiguration.MeasureWindowTitleBarHeight) }
            ):Play()
            WindowMinimizeButton.Text                       = "□"
        else
            ServiceTweenService:Create(
                WindowPrimaryFrame,
                Utility_BuildTweenInfo(0.28),
                { Size = UDim2.new(0, WindowResolvedWidth, 0, WindowResolvedHeight) }
            ):Play()
            WindowMinimizeButton.Text                       = "—"
        end
    end)

    -- Анимация открытия окна
    WindowPrimaryFrame.Size                                 = UDim2.new(0, WindowResolvedWidth, 0, 0)
    WindowPrimaryFrame.BackgroundTransparency               = 0.5
    ServiceTweenService:Create(
        WindowPrimaryFrame,
        Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationSlow),
        {
            Size                                            = UDim2.new(0, WindowResolvedWidth, 0, WindowResolvedHeight),
            BackgroundTransparency                          = 0
        }
    ):Play()

    -- ---- Метод добавления вкладки ----
    function WindowSelf:AddTab(TabDisplayName: string)
        local TabPositionIndex                              = #self.TabInstancesList + 1

        local TabNavigationButton                           = Instance.new("TextButton")
        TabNavigationButton.Name                            = "TabNavButton_" .. TabDisplayName
        TabNavigationButton.Size                            = UDim2.new(0, 0, 1, 0)
        TabNavigationButton.AutomaticSize                   = Enum.AutomaticSize.X
        TabNavigationButton.BackgroundColor3                = GlobalThemeConfiguration.ColorElementBackground
        TabNavigationButton.BackgroundTransparency          = 0.5
        TabNavigationButton.BorderSizePixel                 = 0
        TabNavigationButton.Text                            = TabDisplayName
        TabNavigationButton.Font                            = GlobalThemeConfiguration.FontNameBody
        TabNavigationButton.TextSize                        = 13
        TabNavigationButton.TextColor3                      = GlobalThemeConfiguration.ColorTextSecondary
        TabNavigationButton.LayoutOrder                     = TabPositionIndex
        TabNavigationButton.Parent                          = self.TabBarFrame
        Utility_ApplyRoundedCorners(TabNavigationButton, GlobalThemeConfiguration.MeasureCornerRadiusSmall)
        Utility_ApplyCustomPadding(TabNavigationButton, 0, 0, 12, 12)

        local NewTabInstance                                = TabClass.new(self.TabContentAreaFrame)
        NewTabInstance.NavigationButton                     = TabNavigationButton

        table.insert(self.TabInstancesList, NewTabInstance)

        -- Первая вкладка видна по умолчанию
        if TabPositionIndex == 1 then
            NewTabInstance:SetVisible(true)
            TabNavigationButton.TextColor3                  = WindowResolvedAccentColor
            TabNavigationButton.BackgroundTransparency      = 0.2
        end

        TabNavigationButton.MouseButton1Click:Connect(function()
            -- Скрываем все вкладки и сбрасываем кнопки
            for _, ExistingTabInstance in ipairs(self.TabInstancesList) do
                ExistingTabInstance:SetVisible(false)
                ServiceTweenService:Create(
                    ExistingTabInstance.NavigationButton,
                    Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
                    {
                        TextColor3 = GlobalThemeConfiguration.ColorTextSecondary,
                        BackgroundTransparency = 0.5
                    }
                ):Play()
            end
            -- Показываем выбранную вкладку
            NewTabInstance:SetVisible(true)
            ServiceTweenService:Create(
                TabNavigationButton,
                Utility_BuildTweenInfo(GlobalThemeConfiguration.AnimationTweenDurationFast),
                {
                    TextColor3 = WindowResolvedAccentColor,
                    BackgroundTransparency = 0.2
                }
            ):Play()
        end)

        return NewTabInstance
    end

    -- ---- Метод уведомления ----
    function WindowSelf:Notify(Title: string, Message: string, NotifType: string, Duration: number?)
        NotificationSystem_Show(Title, Message, NotifType, Duration)
    end

    -- ---- Метод уничтожения ----
    function WindowSelf:Destroy()
        if WindowRootScreenGui and WindowRootScreenGui.Parent then
            WindowRootScreenGui:Destroy()
        end
    end

    return WindowSelf
end

-- ============================================================
-- [СЕКЦИЯ 20: ТОЧКА ВХОДА БИБЛИОТЕКИ]
-- ============================================================

local AeternumLibrary                                       = {}
AeternumLibrary.__index                                     = AeternumLibrary

function AeternumLibrary:CreateWindow(ConfigOptions: table)
    return WindowClass.new(ConfigOptions or {})
end

function AeternumLibrary:Notify(Title: string, Message: string, NotifType: string, Duration: number?)
    NotificationSystem_Show(Title, Message, NotifType or "info", Duration or 4)
end

function AeternumLibrary:GetTheme(): table
    return GlobalThemeConfiguration
end

function AeternumLibrary:SetThemeColor(ColorKey: string, NewColor: Color3)
    if GlobalThemeConfiguration[ColorKey] then
        GlobalThemeConfiguration[ColorKey]                  = NewColor
    end
end

return AeternumLibrary
