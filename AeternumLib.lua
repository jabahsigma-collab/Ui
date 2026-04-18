-- ============================================================
--  AETERNUM UI LIBRARY
--  A clean, reusable Roblox UI Library (LocalScript Module)
--  Supports: Windows, Tabs, Buttons, Toggles, Sliders, Dropdowns
-- ============================================================
--  USAGE EXAMPLE:
--
--  local Aeternum = require(path.to.AeternumLib)
--  local MyWindow = Aeternum:CreateWindow({ Title = "My Hub" })
--  local MyTab    = MyWindow:AddTab("Main")
--  local MySection = MyTab:AddSection("Controls")
--  MySection:AddButton("Click Me", function() print("Clicked!") end)
--  MySection:AddToggle("God Mode", false, function(Value) print(Value) end)
--  MySection:AddSlider("Speed", 0, 100, 16, function(Value) print(Value) end)
-- ============================================================

local AeternumLibrary = {}
AeternumLibrary.__index = AeternumLibrary

-- ============================================================
-- [SERVICES]
-- ============================================================

local Players                         = game:GetService("Players")
local RunService                      = game:GetService("RunService")
local TweenService                    = game:GetService("TweenService")
local UserInputService                = game:GetService("UserInputService")

local LocalPlayer                     = Players.LocalPlayer
local LocalPlayerGui                  = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- [GLOBAL THEME TABLE]
-- Edit these values to restyle the entire library at once.
-- ============================================================

local GlobalThemeTable = {
    -- Backgrounds
    ColorBackground           = Color3.fromRGB(13, 13, 13),
    ColorSidebar              = Color3.fromRGB(9, 9, 9),
    ColorSection              = Color3.fromRGB(18, 18, 22),
    ColorElementBase          = Color3.fromRGB(22, 22, 28),

    -- Borders & Strokes
    ColorBorder               = Color3.fromRGB(35, 35, 45),
    ColorAccent               = Color3.fromRGB(100, 180, 255),

    -- Text
    ColorTextPrimary          = Color3.fromRGB(235, 235, 245),
    ColorTextSecondary        = Color3.fromRGB(140, 140, 160),
    ColorTextDisabled         = Color3.fromRGB(70, 70, 90),

    -- Toggle
    ColorToggleOn             = Color3.fromRGB(80, 210, 150),
    ColorToggleOff            = Color3.fromRGB(50, 50, 65),
    ColorToggleKnob           = Color3.fromRGB(240, 240, 255),

    -- Slider
    ColorSliderFill           = Color3.fromRGB(100, 180, 255),
    ColorSliderTrack          = Color3.fromRGB(35, 35, 50),

    -- Fonts
    FontTitle                 = Enum.Font.GothamBold,
    FontBody                  = Enum.Font.Gotham,
    FontMono                  = Enum.Font.Code,

    -- Sizing
    CornerRadius              = UDim.new(0, 8),
    ElementHeight             = 36,
    SectionPadding            = 8,
    TweenDuration             = 0.25,
    TweenEasing               = Enum.EasingStyle.Quint,
}

-- ============================================================
-- [INTERNAL UTILITIES]
-- ============================================================

local function CreateTweenInfo(Duration: number): TweenInfo
    return TweenInfo.new(
        Duration or GlobalThemeTable.TweenDuration,
        GlobalThemeTable.TweenEasing,
        Enum.EasingDirection.Out
    )
end

local function ApplyCorner(ParentInstance: Instance, Radius: UDim)
    local CornerInstance      = Instance.new("UICorner")
    CornerInstance.CornerRadius = Radius or GlobalThemeTable.CornerRadius
    CornerInstance.Parent     = ParentInstance
    return CornerInstance
end

local function ApplyStroke(ParentInstance: Instance, StrokeColor: Color3, StrokeThickness: number)
    local StrokeInstance         = Instance.new("UIStroke")
    StrokeInstance.Color         = StrokeColor or GlobalThemeTable.ColorBorder
    StrokeInstance.Thickness     = StrokeThickness or 1
    StrokeInstance.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    StrokeInstance.Parent        = ParentInstance
    return StrokeInstance
end

local function ApplyPadding(ParentInstance: Instance, PaddingValue: number)
    local PaddingInstance            = Instance.new("UIPadding")
    local UniformPadding             = UDim.new(0, PaddingValue or 8)
    PaddingInstance.PaddingTop       = UniformPadding
    PaddingInstance.PaddingBottom    = UniformPadding
    PaddingInstance.PaddingLeft      = UniformPadding
    PaddingInstance.PaddingRight     = UniformPadding
    PaddingInstance.Parent           = ParentInstance
    return PaddingInstance
end

local function MakeLabel(ParentInstance: Instance, LabelText: string, FontEnum: Enum.Font, TextSize: number, TextColorValue: Color3): TextLabel
    local NewLabel                   = Instance.new("TextLabel")
    NewLabel.Text                    = LabelText or ""
    NewLabel.Font                    = FontEnum or GlobalThemeTable.FontBody
    NewLabel.TextSize                = TextSize or 14
    NewLabel.TextColor3              = TextColorValue or GlobalThemeTable.ColorTextPrimary
    NewLabel.BackgroundTransparency  = 1
    NewLabel.TextXAlignment          = Enum.TextXAlignment.Left
    NewLabel.TextYAlignment          = Enum.TextYAlignment.Center
    NewLabel.Size                    = UDim2.new(1, 0, 1, 0)
    NewLabel.Parent                  = ParentInstance
    return NewLabel
end

-- ============================================================
-- [DRAG SYSTEM]
-- Makes any Frame draggable by a given handle.
-- ============================================================

local function EnableDragOnFrame(DraggableFrame: Frame, DragHandleInstance: Instance)
    local IsDraggingActive            = false
    local DragOriginMousePosition     = Vector2.new(0, 0)
    local DragOriginFramePosition     = UDim2.new(0, 0, 0, 0)

    DragHandleInstance.InputBegan:Connect(function(InputObject: InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDraggingActive          = true
            DragOriginMousePosition   = Vector2.new(InputObject.Position.X, InputObject.Position.Y)
            DragOriginFramePosition   = DraggableFrame.Position
        end
    end)

    DragHandleInstance.InputEnded:Connect(function(InputObject: InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDraggingActive = false
        end
    end)

    UserInputService.InputChanged:Connect(function(InputObject: InputObject)
        if IsDraggingActive and InputObject.UserInputType == Enum.UserInputType.MouseMovement then
            local CurrentMouseX       = InputObject.Position.X
            local CurrentMouseY       = InputObject.Position.Y
            local DeltaX              = CurrentMouseX - DragOriginMousePosition.X
            local DeltaY              = CurrentMouseY - DragOriginMousePosition.Y

            DraggableFrame.Position   = UDim2.new(
                DragOriginFramePosition.X.Scale,
                DragOriginFramePosition.X.Offset + DeltaX,
                DragOriginFramePosition.Y.Scale,
                DragOriginFramePosition.Y.Offset + DeltaY
            )
        end
    end)
end

-- ============================================================
-- [ELEMENT BASE CLASS]
-- All UI components inherit from this.
-- ============================================================

local ElementBaseClass = {}
ElementBaseClass.__index = ElementBaseClass

function ElementBaseClass:Destroy()
    if self.ContainerFrame then
        self.ContainerFrame:Destroy()
    end
end

-- ============================================================
-- [BUTTON CLASS]
-- ============================================================

local ButtonClass = setmetatable({}, { __index = ElementBaseClass })
ButtonClass.__index = ButtonClass

function ButtonClass.new(ParentContainer: Frame, ButtonLabelText: string, OnClickCallback: () -> ())
    local ButtonSelf                          = setmetatable({}, ButtonClass)

    -- Outer container frame
    local ButtonContainerFrame                = Instance.new("Frame")
    ButtonContainerFrame.Name                 = "ButtonContainer_" .. ButtonLabelText
    ButtonContainerFrame.Size                 = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight)
    ButtonContainerFrame.BackgroundColor3     = GlobalThemeTable.ColorElementBase
    ButtonContainerFrame.BorderSizePixel      = 0
    ButtonContainerFrame.Parent               = ParentContainer
    ApplyCorner(ButtonContainerFrame)
    ApplyStroke(ButtonContainerFrame, GlobalThemeTable.ColorBorder, 1)

    -- Invisible clickable button overlay
    local ClickableButtonOverlay              = Instance.new("TextButton")
    ClickableButtonOverlay.Size               = UDim2.new(1, 0, 1, 0)
    ClickableButtonOverlay.BackgroundTransparency = 1
    ClickableButtonOverlay.Text               = ""
    ClickableButtonOverlay.Parent             = ButtonContainerFrame

    -- Label
    local ButtonTextLabel                     = Instance.new("TextLabel")
    ButtonTextLabel.Size                      = UDim2.new(1, -16, 1, 0)
    ButtonTextLabel.Position                  = UDim2.new(0, 12, 0, 0)
    ButtonTextLabel.BackgroundTransparency    = 1
    ButtonTextLabel.Text                      = ButtonLabelText
    ButtonTextLabel.Font                      = GlobalThemeTable.FontBody
    ButtonTextLabel.TextSize                  = 13
    ButtonTextLabel.TextColor3                = GlobalThemeTable.ColorTextPrimary
    ButtonTextLabel.TextXAlignment            = Enum.TextXAlignment.Left
    ButtonTextLabel.Parent                    = ButtonContainerFrame

    -- Hover highlight effect
    ClickableButtonOverlay.MouseEnter:Connect(function()
        TweenService:Create(
            ButtonContainerFrame,
            CreateTweenInfo(0.15),
            { BackgroundColor3 = Color3.fromRGB(30, 30, 38) }
        ):Play()
    end)

    ClickableButtonOverlay.MouseLeave:Connect(function()
        TweenService:Create(
            ButtonContainerFrame,
            CreateTweenInfo(0.15),
            { BackgroundColor3 = GlobalThemeTable.ColorElementBase }
        ):Play()
    end)

    -- Click flash + callback
    ClickableButtonOverlay.MouseButton1Click:Connect(function()
        TweenService:Create(
            ButtonContainerFrame,
            CreateTweenInfo(0.08),
            { BackgroundColor3 = GlobalThemeTable.ColorAccent }
        ):Play()
        task.delay(0.12, function()
            TweenService:Create(
                ButtonContainerFrame,
                CreateTweenInfo(0.2),
                { BackgroundColor3 = GlobalThemeTable.ColorElementBase }
            ):Play()
        end)
        if typeof(OnClickCallback) == "function" then
            task.spawn(OnClickCallback)
        end
    end)

    ButtonSelf.ContainerFrame = ButtonContainerFrame
    return ButtonSelf
end

-- ============================================================
-- [TOGGLE CLASS]
-- ============================================================

local ToggleClass = setmetatable({}, { __index = ElementBaseClass })
ToggleClass.__index = ToggleClass

function ToggleClass.new(ParentContainer: Frame, ToggleLabelText: string, DefaultValue: boolean, OnToggleCallback: (boolean) -> ())
    local ToggleSelf                          = setmetatable({}, ToggleClass)
    local ToggleCurrentValue                  = DefaultValue or false

    local ToggleContainerFrame                = Instance.new("Frame")
    ToggleContainerFrame.Name                 = "ToggleContainer_" .. ToggleLabelText
    ToggleContainerFrame.Size                 = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight)
    ToggleContainerFrame.BackgroundColor3     = GlobalThemeTable.ColorElementBase
    ToggleContainerFrame.BorderSizePixel      = 0
    ToggleContainerFrame.Parent               = ParentContainer
    ApplyCorner(ToggleContainerFrame)
    ApplyStroke(ToggleContainerFrame, GlobalThemeTable.ColorBorder, 1)

    local ToggleTextLabel                     = Instance.new("TextLabel")
    ToggleTextLabel.Size                      = UDim2.new(1, -64, 1, 0)
    ToggleTextLabel.Position                  = UDim2.new(0, 12, 0, 0)
    ToggleTextLabel.BackgroundTransparency    = 1
    ToggleTextLabel.Text                      = ToggleLabelText
    ToggleTextLabel.Font                      = GlobalThemeTable.FontBody
    ToggleTextLabel.TextSize                  = 13
    ToggleTextLabel.TextColor3                = GlobalThemeTable.ColorTextPrimary
    ToggleTextLabel.TextXAlignment            = Enum.TextXAlignment.Left
    ToggleTextLabel.Parent                    = ToggleContainerFrame

    -- Switch track
    local ToggleSwitchTrack                   = Instance.new("Frame")
    ToggleSwitchTrack.Name                    = "SwitchTrack"
    ToggleSwitchTrack.Size                    = UDim2.new(0, 40, 0, 22)
    ToggleSwitchTrack.Position                = UDim2.new(1, -52, 0.5, -11)
    ToggleSwitchTrack.BackgroundColor3        = ToggleCurrentValue and GlobalThemeTable.ColorToggleOn or GlobalThemeTable.ColorToggleOff
    ToggleSwitchTrack.BorderSizePixel         = 0
    ToggleSwitchTrack.Parent                  = ToggleContainerFrame
    ApplyCorner(ToggleSwitchTrack, UDim.new(1, 0))

    -- Knob
    local ToggleSwitchKnob                    = Instance.new("Frame")
    ToggleSwitchKnob.Name                     = "SwitchKnob"
    ToggleSwitchKnob.Size                     = UDim2.new(0, 16, 0, 16)
    ToggleSwitchKnob.Position                 = ToggleCurrentValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    ToggleSwitchKnob.BackgroundColor3         = GlobalThemeTable.ColorToggleKnob
    ToggleSwitchKnob.BorderSizePixel          = 0
    ToggleSwitchKnob.Parent                   = ToggleSwitchTrack
    ApplyCorner(ToggleSwitchKnob, UDim.new(1, 0))

    -- Clickable overlay
    local ToggleClickableOverlay              = Instance.new("TextButton")
    ToggleClickableOverlay.Size               = UDim2.new(1, 0, 1, 0)
    ToggleClickableOverlay.BackgroundTransparency = 1
    ToggleClickableOverlay.Text               = ""
    ToggleClickableOverlay.Parent             = ToggleContainerFrame

    local function UpdateToggleVisuals(NewValue: boolean)
        local TargetTrackColor                = NewValue and GlobalThemeTable.ColorToggleOn or GlobalThemeTable.ColorToggleOff
        local TargetKnobPosition              = NewValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)

        TweenService:Create(ToggleSwitchTrack, CreateTweenInfo(0.2), { BackgroundColor3 = TargetTrackColor }):Play()
        TweenService:Create(ToggleSwitchKnob, CreateTweenInfo(0.2), { Position = TargetKnobPosition }):Play()
    end

    ToggleClickableOverlay.MouseButton1Click:Connect(function()
        ToggleCurrentValue = not ToggleCurrentValue
        UpdateToggleVisuals(ToggleCurrentValue)
        if typeof(OnToggleCallback) == "function" then
            task.spawn(OnToggleCallback, ToggleCurrentValue)
        end
    end)

    UpdateToggleVisuals(ToggleCurrentValue)

    function ToggleSelf:SetValue(NewValue: boolean)
        ToggleCurrentValue = NewValue
        UpdateToggleVisuals(ToggleCurrentValue)
    end

    function ToggleSelf:GetValue(): boolean
        return ToggleCurrentValue
    end

    ToggleSelf.ContainerFrame = ToggleContainerFrame
    return ToggleSelf
end

-- ============================================================
-- [SLIDER CLASS]
-- ============================================================

local SliderClass = setmetatable({}, { __index = ElementBaseClass })
SliderClass.__index = SliderClass

function SliderClass.new(ParentContainer: Frame, SliderLabelText: string, MinimumValue: number, MaximumValue: number, DefaultValue: number, OnChangeCallback: (number) -> ())
    local SliderSelf                          = setmetatable({}, SliderClass)
    local SliderCurrentValue                  = math.clamp(DefaultValue or MinimumValue, MinimumValue, MaximumValue)
    local SliderIsDragging                    = false

    local SliderContainerFrame                = Instance.new("Frame")
    SliderContainerFrame.Name                 = "SliderContainer_" .. SliderLabelText
    SliderContainerFrame.Size                 = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight + 10)
    SliderContainerFrame.BackgroundColor3     = GlobalThemeTable.ColorElementBase
    SliderContainerFrame.BorderSizePixel      = 0
    SliderContainerFrame.Parent               = ParentContainer
    ApplyCorner(SliderContainerFrame)
    ApplyStroke(SliderContainerFrame, GlobalThemeTable.ColorBorder, 1)

    -- Label and value display
    local SliderTextLabel                     = Instance.new("TextLabel")
    SliderTextLabel.Size                      = UDim2.new(0.7, -12, 0, 20)
    SliderTextLabel.Position                  = UDim2.new(0, 12, 0, 6)
    SliderTextLabel.BackgroundTransparency    = 1
    SliderTextLabel.Text                      = SliderLabelText
    SliderTextLabel.Font                      = GlobalThemeTable.FontBody
    SliderTextLabel.TextSize                  = 13
    SliderTextLabel.TextColor3                = GlobalThemeTable.ColorTextPrimary
    SliderTextLabel.TextXAlignment            = Enum.TextXAlignment.Left
    SliderTextLabel.Parent                    = SliderContainerFrame

    local SliderValueDisplay                  = Instance.new("TextLabel")
    SliderValueDisplay.Size                   = UDim2.new(0.3, -12, 0, 20)
    SliderValueDisplay.Position               = UDim2.new(0.7, 0, 0, 6)
    SliderValueDisplay.BackgroundTransparency = 1
    SliderValueDisplay.Text                   = tostring(SliderCurrentValue)
    SliderValueDisplay.Font                   = GlobalThemeTable.FontMono
    SliderValueDisplay.TextSize               = 13
    SliderValueDisplay.TextColor3             = GlobalThemeTable.ColorAccent
    SliderValueDisplay.TextXAlignment         = Enum.TextXAlignment.Right
    SliderValueDisplay.Parent                 = SliderContainerFrame

    -- Track background
    local SliderTrackBackground               = Instance.new("Frame")
    SliderTrackBackground.Name                = "TrackBackground"
    SliderTrackBackground.Size                = UDim2.new(1, -24, 0, 6)
    SliderTrackBackground.Position            = UDim2.new(0, 12, 1, -14)
    SliderTrackBackground.BackgroundColor3    = GlobalThemeTable.ColorSliderTrack
    SliderTrackBackground.BorderSizePixel     = 0
    SliderTrackBackground.Parent              = SliderContainerFrame
    ApplyCorner(SliderTrackBackground, UDim.new(1, 0))

    -- Fill bar
    local SliderFillBar                       = Instance.new("Frame")
    SliderFillBar.Name                        = "FillBar"
    SliderFillBar.Size                        = UDim2.new(0, 0, 1, 0)
    SliderFillBar.BackgroundColor3            = GlobalThemeTable.ColorSliderFill
    SliderFillBar.BorderSizePixel             = 0
    SliderFillBar.Parent                      = SliderTrackBackground
    ApplyCorner(SliderFillBar, UDim.new(1, 0))

    -- Invisible input button over the track
    local SliderInputButton                   = Instance.new("TextButton")
    SliderInputButton.Size                    = UDim2.new(1, 0, 0, 20)
    SliderInputButton.Position                = UDim2.new(0, 0, 0, -7)
    SliderInputButton.BackgroundTransparency  = 1
    SliderInputButton.Text                    = ""
    SliderInputButton.Parent                  = SliderTrackBackground

    local function CalculateValueFromInputPosition(InputPositionX: number): number
        local TrackAbsolutePosition           = SliderTrackBackground.AbsolutePosition
        local TrackAbsoluteSize               = SliderTrackBackground.AbsoluteSize
        local RelativeX                       = math.clamp(InputPositionX - TrackAbsolutePosition.X, 0, TrackAbsoluteSize.X)
        local Fraction                        = RelativeX / TrackAbsoluteSize.X
        local RawValue                        = MinimumValue + Fraction * (MaximumValue - MinimumValue)
        return math.floor(RawValue + 0.5)
    end

    local function UpdateSliderVisuals(NewValue: number)
        SliderCurrentValue                    = math.clamp(NewValue, MinimumValue, MaximumValue)
        local FillFraction                    = (SliderCurrentValue - MinimumValue) / (MaximumValue - MinimumValue)
        SliderValueDisplay.Text               = tostring(SliderCurrentValue)
        TweenService:Create(
            SliderFillBar,
            CreateTweenInfo(0.1),
            { Size = UDim2.new(FillFraction, 0, 1, 0) }
        ):Play()
        if typeof(OnChangeCallback) == "function" then
            task.spawn(OnChangeCallback, SliderCurrentValue)
        end
    end

    SliderInputButton.MouseButton1Down:Connect(function(X: number)
        SliderIsDragging = true
        UpdateSliderVisuals(CalculateValueFromInputPosition(X))
    end)

    SliderInputButton.MouseButton1Up:Connect(function()
        SliderIsDragging = false
    end)

    UserInputService.InputChanged:Connect(function(InputObject: InputObject)
        if SliderIsDragging and InputObject.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSliderVisuals(CalculateValueFromInputPosition(InputObject.Position.X))
        end
    end)

    UserInputService.InputEnded:Connect(function(InputObject: InputObject)
        if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            SliderIsDragging = false
        end
    end)

    UpdateSliderVisuals(SliderCurrentValue)

    function SliderSelf:SetValue(NewValue: number)
        UpdateSliderVisuals(NewValue)
    end

    function SliderSelf:GetValue(): number
        return SliderCurrentValue
    end

    SliderSelf.ContainerFrame = SliderContainerFrame
    return SliderSelf
end

-- ============================================================
-- [DROPDOWN CLASS]
-- ============================================================

local DropdownClass = setmetatable({}, { __index = ElementBaseClass })
DropdownClass.__index = DropdownClass

function DropdownClass.new(ParentContainer: Frame, DropdownLabelText: string, OptionsList: {string}, OnSelectCallback: (string) -> ())
    local DropdownSelf                        = setmetatable({}, DropdownClass)
    local DropdownIsOpen                      = false
    local DropdownSelectedValue               = nil

    local DropdownContainerFrame              = Instance.new("Frame")
    DropdownContainerFrame.Name               = "DropdownContainer_" .. DropdownLabelText
    DropdownContainerFrame.Size               = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight)
    DropdownContainerFrame.BackgroundColor3   = GlobalThemeTable.ColorElementBase
    DropdownContainerFrame.BorderSizePixel    = 0
    DropdownContainerFrame.ClipsDescendants   = true
    DropdownContainerFrame.Parent             = ParentContainer
    ApplyCorner(DropdownContainerFrame)
    ApplyStroke(DropdownContainerFrame, GlobalThemeTable.ColorBorder, 1)

    local DropdownHeaderButton                = Instance.new("TextButton")
    DropdownHeaderButton.Size                 = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight)
    DropdownHeaderButton.BackgroundTransparency = 1
    DropdownHeaderButton.Text                 = ""
    DropdownHeaderButton.Parent               = DropdownContainerFrame

    local DropdownHeaderLabel                 = Instance.new("TextLabel")
    DropdownHeaderLabel.Size                  = UDim2.new(1, -44, 1, 0)
    DropdownHeaderLabel.Position              = UDim2.new(0, 12, 0, 0)
    DropdownHeaderLabel.BackgroundTransparency = 1
    DropdownHeaderLabel.Text                  = DropdownLabelText .. ":  —"
    DropdownHeaderLabel.Font                  = GlobalThemeTable.FontBody
    DropdownHeaderLabel.TextSize              = 13
    DropdownHeaderLabel.TextColor3            = GlobalThemeTable.ColorTextPrimary
    DropdownHeaderLabel.TextXAlignment        = Enum.TextXAlignment.Left
    DropdownHeaderLabel.Parent                = DropdownContainerFrame

    local DropdownArrowLabel                  = Instance.new("TextLabel")
    DropdownArrowLabel.Size                   = UDim2.new(0, 30, 1, 0)
    DropdownArrowLabel.Position               = UDim2.new(1, -36, 0, 0)
    DropdownArrowLabel.BackgroundTransparency = 1
    DropdownArrowLabel.Text                   = "▾"
    DropdownArrowLabel.Font                   = GlobalThemeTable.FontBody
    DropdownArrowLabel.TextSize               = 14
    DropdownArrowLabel.TextColor3             = GlobalThemeTable.ColorTextSecondary
    DropdownArrowLabel.Parent                 = DropdownContainerFrame

    -- Options list container (hidden initially)
    local DropdownOptionsContainer            = Instance.new("Frame")
    DropdownOptionsContainer.Name             = "OptionsContainer"
    DropdownOptionsContainer.Size             = UDim2.new(1, 0, 0, #OptionsList * 30)
    DropdownOptionsContainer.Position         = UDim2.new(0, 0, 0, GlobalThemeTable.ElementHeight)
    DropdownOptionsContainer.BackgroundColor3 = GlobalThemeTable.ColorSidebar
    DropdownOptionsContainer.BorderSizePixel  = 0
    DropdownOptionsContainer.Parent           = DropdownContainerFrame

    local DropdownOptionsList                 = Instance.new("UIListLayout")
    DropdownOptionsList.FillDirection         = Enum.FillDirection.Vertical
    DropdownOptionsList.SortOrder             = Enum.SortOrder.LayoutOrder
    DropdownOptionsList.Parent                = DropdownOptionsContainer

    -- Build each option row
    for OptionIndex, OptionText in ipairs(OptionsList) do
        local OptionRowButton                 = Instance.new("TextButton")
        OptionRowButton.Size                  = UDim2.new(1, 0, 0, 30)
        OptionRowButton.BackgroundColor3      = GlobalThemeTable.ColorSidebar
        OptionRowButton.BorderSizePixel       = 0
        OptionRowButton.Text                  = "  " .. OptionText
        OptionRowButton.Font                  = GlobalThemeTable.FontBody
        OptionRowButton.TextSize              = 13
        OptionRowButton.TextColor3            = GlobalThemeTable.ColorTextSecondary
        OptionRowButton.TextXAlignment        = Enum.TextXAlignment.Left
        OptionRowButton.LayoutOrder           = OptionIndex
        OptionRowButton.Parent                = DropdownOptionsContainer

        OptionRowButton.MouseEnter:Connect(function()
            TweenService:Create(OptionRowButton, CreateTweenInfo(0.12), { TextColor3 = GlobalThemeTable.ColorTextPrimary }):Play()
        end)
        OptionRowButton.MouseLeave:Connect(function()
            TweenService:Create(OptionRowButton, CreateTweenInfo(0.12), { TextColor3 = GlobalThemeTable.ColorTextSecondary }):Play()
        end)

        OptionRowButton.MouseButton1Click:Connect(function()
            DropdownSelectedValue             = OptionText
            DropdownHeaderLabel.Text          = DropdownLabelText .. ":  " .. OptionText
            -- Close dropdown
            DropdownIsOpen = false
            TweenService:Create(
                DropdownContainerFrame,
                CreateTweenInfo(0.2),
                { Size = UDim2.new(1, 0, 0, GlobalThemeTable.ElementHeight) }
            ):Play()
            if typeof(OnSelectCallback) == "function" then
                task.spawn(OnSelectCallback, OptionText)
            end
        end)
    end

    local DropdownCollapsedHeight             = GlobalThemeTable.ElementHeight
    local DropdownExpandedHeight              = GlobalThemeTable.ElementHeight + (#OptionsList * 30)

    DropdownHeaderButton.MouseButton1Click:Connect(function()
        DropdownIsOpen = not DropdownIsOpen
        local TargetHeight                    = DropdownIsOpen and DropdownExpandedHeight or DropdownCollapsedHeight
        TweenService:Create(
            DropdownContainerFrame,
            CreateTweenInfo(0.22),
            { Size = UDim2.new(1, 0, 0, TargetHeight) }
        ):Play()
    end)

    function DropdownSelf:GetValue(): string
        return DropdownSelectedValue
    end

    DropdownSelf.ContainerFrame = DropdownContainerFrame
    return DropdownSelf
end

-- ============================================================
-- [SECTION CLASS]
-- Holds all elements inside a Tab.
-- ============================================================

local SectionClass = {}
SectionClass.__index = SectionClass

function SectionClass.new(ParentScrollFrame: ScrollingFrame, SectionTitleText: string)
    local SectionSelf                         = setmetatable({}, SectionClass)

    local SectionOuterFrame                   = Instance.new("Frame")
    SectionOuterFrame.Name                    = "Section_" .. SectionTitleText
    SectionOuterFrame.Size                    = UDim2.new(1, 0, 0, 0)
    SectionOuterFrame.AutomaticSize           = Enum.AutomaticSize.Y
    SectionOuterFrame.BackgroundColor3        = GlobalThemeTable.ColorSection
    SectionOuterFrame.BorderSizePixel         = 0
    SectionOuterFrame.Parent                  = ParentScrollFrame
    ApplyCorner(SectionOuterFrame)
    ApplyStroke(SectionOuterFrame, GlobalThemeTable.ColorBorder, 1)

    local SectionTitleLabel                   = Instance.new("TextLabel")
    SectionTitleLabel.Size                    = UDim2.new(1, -16, 0, 28)
    SectionTitleLabel.Position                = UDim2.new(0, 10, 0, 4)
    SectionTitleLabel.BackgroundTransparency  = 1
    SectionTitleLabel.Text                    = SectionTitleText:upper()
    SectionTitleLabel.Font                    = GlobalThemeTable.FontTitle
    SectionTitleLabel.TextSize                = 11
    SectionTitleLabel.TextColor3              = GlobalThemeTable.ColorAccent
    SectionTitleLabel.TextXAlignment          = Enum.TextXAlignment.Left
    SectionTitleLabel.Parent                  = SectionOuterFrame

    -- Thin divider under title
    local SectionDivider                      = Instance.new("Frame")
    SectionDivider.Size                       = UDim2.new(1, -16, 0, 1)
    SectionDivider.Position                   = UDim2.new(0, 8, 0, 32)
    SectionDivider.BackgroundColor3           = GlobalThemeTable.ColorBorder
    SectionDivider.BorderSizePixel            = 0
    SectionDivider.Parent                     = SectionOuterFrame

    -- Elements container with list layout
    local SectionElementsContainer            = Instance.new("Frame")
    SectionElementsContainer.Name             = "ElementsContainer"
    SectionElementsContainer.Size             = UDim2.new(1, -16, 0, 0)
    SectionElementsContainer.Position         = UDim2.new(0, 8, 0, 38)
    SectionElementsContainer.AutomaticSize    = Enum.AutomaticSize.Y
    SectionElementsContainer.BackgroundTransparency = 1
    SectionElementsContainer.BorderSizePixel  = 0
    SectionElementsContainer.Parent           = SectionOuterFrame

    local SectionListLayout                   = Instance.new("UIListLayout")
    SectionListLayout.FillDirection           = Enum.FillDirection.Vertical
    SectionListLayout.SortOrder               = Enum.SortOrder.LayoutOrder
    SectionListLayout.Padding                 = UDim.new(0, GlobalThemeTable.SectionPadding)
    SectionListLayout.Parent                  = SectionElementsContainer

    -- Bottom padding
    local SectionBottomPadding                = Instance.new("UIPadding")
    SectionBottomPadding.PaddingBottom        = UDim.new(0, 10)
    SectionBottomPadding.Parent               = SectionElementsContainer

    SectionSelf.ElementsContainer             = SectionElementsContainer
    SectionSelf.OuterFrame                    = SectionOuterFrame

    function SectionSelf:AddButton(LabelText: string, Callback: () -> ())
        return ButtonClass.new(self.ElementsContainer, LabelText, Callback)
    end

    function SectionSelf:AddToggle(LabelText: string, Default: boolean, Callback: (boolean) -> ())
        return ToggleClass.new(self.ElementsContainer, LabelText, Default, Callback)
    end

    function SectionSelf:AddSlider(LabelText: string, Min: number, Max: number, Default: number, Callback: (number) -> ())
        return SliderClass.new(self.ElementsContainer, LabelText, Min, Max, Default, Callback)
    end

    function SectionSelf:AddDropdown(LabelText: string, Options: {string}, Callback: (string) -> ())
        return DropdownClass.new(self.ElementsContainer, LabelText, Options, Callback)
    end

    return SectionSelf
end

-- ============================================================
-- [TAB CLASS]
-- ============================================================

local TabClass = {}
TabClass.__index = TabClass

function TabClass.new(TabContentHolder: Frame)
    local TabSelf                             = setmetatable({}, TabClass)

    local TabScrollingFrame                   = Instance.new("ScrollingFrame")
    TabScrollingFrame.Name                    = "TabScrollingFrame"
    TabScrollingFrame.Size                    = UDim2.new(1, 0, 1, 0)
    TabScrollingFrame.BackgroundTransparency  = 1
    TabScrollingFrame.BorderSizePixel         = 0
    TabScrollingFrame.ScrollBarThickness      = 3
    TabScrollingFrame.ScrollBarImageColor3    = GlobalThemeTable.ColorAccent
    TabScrollingFrame.CanvasSize              = UDim2.new(0, 0, 0, 0)
    TabScrollingFrame.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    TabScrollingFrame.Visible                 = false
    TabScrollingFrame.Parent                  = TabContentHolder

    local TabContentListLayout                = Instance.new("UIListLayout")
    TabContentListLayout.FillDirection        = Enum.FillDirection.Vertical
    TabContentListLayout.SortOrder            = Enum.SortOrder.LayoutOrder
    TabContentListLayout.Padding              = UDim.new(0, 10)
    TabContentListLayout.Parent               = TabScrollingFrame

    local TabContentPadding                   = Instance.new("UIPadding")
    TabContentPadding.PaddingTop              = UDim.new(0, 10)
    TabContentPadding.PaddingLeft             = UDim.new(0, 10)
    TabContentPadding.PaddingRight            = UDim.new(0, 10)
    TabContentPadding.Parent                  = TabScrollingFrame

    TabSelf.ScrollingFrame                    = TabScrollingFrame

    function TabSelf:AddSection(SectionTitle: string)
        return SectionClass.new(self.ScrollingFrame, SectionTitle)
    end

    function TabSelf:SetVisible(IsVisible: boolean)
        self.ScrollingFrame.Visible = IsVisible
    end

    return TabSelf
end

-- ============================================================
-- [WINDOW CLASS]
-- ============================================================

local WindowClass = {}
WindowClass.__index = WindowClass

function WindowClass.new(WindowOptions: table)
    local WindowSelf                          = setmetatable({}, WindowClass)
    local WindowTitle                         = WindowOptions.Title or "Aeternum"
    local WindowWidth                         = WindowOptions.Width or 500
    local WindowHeight                        = WindowOptions.Height or 400

    WindowSelf.TabList                        = {}
    WindowSelf.ActiveTabIndex                 = 1

    -- Root ScreenGui
    local WindowScreenGui                     = Instance.new("ScreenGui")
    WindowScreenGui.Name                      = "AeternumGui_" .. WindowTitle
    WindowScreenGui.ResetOnSpawn              = false
    WindowScreenGui.ZIndexBehavior            = Enum.ZIndexBehavior.Sibling
    WindowScreenGui.IgnoreGuiInset            = true
    WindowScreenGui.Parent                    = LocalPlayerGui

    -- Outer window frame
    local WindowMainFrame                     = Instance.new("Frame")
    WindowMainFrame.Name                      = "WindowMainFrame"
    WindowMainFrame.Size                      = UDim2.new(0, WindowWidth, 0, WindowHeight)
    WindowMainFrame.Position                  = UDim2.new(0.5, -WindowWidth / 2, 0.5, -WindowHeight / 2)
    WindowMainFrame.BackgroundColor3          = GlobalThemeTable.ColorBackground
    WindowMainFrame.BorderSizePixel           = 0
    WindowMainFrame.ClipsDescendants          = true
    WindowMainFrame.Parent                    = WindowScreenGui
    ApplyCorner(WindowMainFrame, UDim.new(0, 10))
    ApplyStroke(WindowMainFrame, GlobalThemeTable.ColorBorder, 1.5)

    -- Title bar
    local WindowTitleBar                      = Instance.new("Frame")
    WindowTitleBar.Name                       = "TitleBar"
    WindowTitleBar.Size                       = UDim2.new(1, 0, 0, 44)
    WindowTitleBar.BackgroundColor3           = GlobalThemeTable.ColorSidebar
    WindowTitleBar.BorderSizePixel            = 0
    WindowTitleBar.Parent                     = WindowMainFrame

    local WindowTitleBarAccentLine            = Instance.new("Frame")
    WindowTitleBarAccentLine.Size             = UDim2.new(1, 0, 0, 2)
    WindowTitleBarAccentLine.Position         = UDim2.new(0, 0, 1, -2)
    WindowTitleBarAccentLine.BackgroundColor3 = GlobalThemeTable.ColorAccent
    WindowTitleBarAccentLine.BorderSizePixel  = 0
    WindowTitleBarAccentLine.Parent           = WindowTitleBar

    local WindowTitleLabel                    = Instance.new("TextLabel")
    WindowTitleLabel.Size                     = UDim2.new(1, -60, 1, 0)
    WindowTitleLabel.Position                 = UDim2.new(0, 14, 0, 0)
    WindowTitleLabel.BackgroundTransparency   = 1
    WindowTitleLabel.Text                     = WindowTitle
    WindowTitleLabel.Font                     = GlobalThemeTable.FontTitle
    WindowTitleLabel.TextSize                 = 15
    WindowTitleLabel.TextColor3               = GlobalThemeTable.ColorTextPrimary
    WindowTitleLabel.TextXAlignment           = Enum.TextXAlignment.Left
    WindowTitleLabel.Parent                   = WindowTitleBar

    -- Close button
    local WindowCloseButton                   = Instance.new("TextButton")
    WindowCloseButton.Size                    = UDim2.new(0, 28, 0, 28)
    WindowCloseButton.Position                = UDim2.new(1, -38, 0.5, -14)
    WindowCloseButton.BackgroundColor3        = Color3.fromRGB(200, 60, 60)
    WindowCloseButton.Text                    = "✕"
    WindowCloseButton.Font                    = GlobalThemeTable.FontTitle
    WindowCloseButton.TextSize                = 12
    WindowCloseButton.TextColor3              = Color3.fromRGB(255, 255, 255)
    WindowCloseButton.Parent                  = WindowTitleBar
    ApplyCorner(WindowCloseButton, UDim.new(0, 6))

    WindowCloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(
            WindowMainFrame,
            CreateTweenInfo(0.2),
            { Size = UDim2.new(0, WindowWidth, 0, 0), BackgroundTransparency = 1 }
        ):Play()
        task.delay(0.25, function()
            WindowScreenGui:Destroy()
        end)
    end)

    -- Tab button bar
    local WindowTabButtonBar                  = Instance.new("Frame")
    WindowTabButtonBar.Name                   = "TabButtonBar"
    WindowTabButtonBar.Size                   = UDim2.new(1, 0, 0, 34)
    WindowTabButtonBar.Position               = UDim2.new(0, 0, 0, 44)
    WindowTabButtonBar.BackgroundColor3       = GlobalThemeTable.ColorSidebar
    WindowTabButtonBar.BorderSizePixel        = 0
    WindowTabButtonBar.Parent                 = WindowMainFrame

    local WindowTabButtonListLayout           = Instance.new("UIListLayout")
    WindowTabButtonListLayout.FillDirection   = Enum.FillDirection.Horizontal
    WindowTabButtonListLayout.SortOrder       = Enum.SortOrder.LayoutOrder
    WindowTabButtonListLayout.Padding         = UDim.new(0, 2)
    WindowTabButtonListLayout.Parent          = WindowTabButtonBar

    local WindowTabButtonPadding              = Instance.new("UIPadding")
    WindowTabButtonPadding.PaddingLeft        = UDim.new(0, 8)
    WindowTabButtonPadding.PaddingTop         = UDim.new(0, 4)
    WindowTabButtonPadding.Parent             = WindowTabButtonBar

    -- Tab content area
    local WindowTabContentHolder              = Instance.new("Frame")
    WindowTabContentHolder.Name               = "TabContentHolder"
    WindowTabContentHolder.Size               = UDim2.new(1, 0, 1, -80)
    WindowTabContentHolder.Position           = UDim2.new(0, 0, 0, 80)
    WindowTabContentHolder.BackgroundTransparency = 1
    WindowTabContentHolder.BorderSizePixel    = 0
    WindowTabContentHolder.Parent             = WindowMainFrame

    WindowSelf.ScreenGui                      = WindowScreenGui
    WindowSelf.MainFrame                      = WindowMainFrame
    WindowSelf.TabButtonBar                   = WindowTabButtonBar
    WindowSelf.TabContentHolder               = WindowTabContentHolder

    EnableDragOnFrame(WindowMainFrame, WindowTitleBar)

    -- Window open animation
    WindowMainFrame.Size = UDim2.new(0, WindowWidth, 0, 0)
    TweenService:Create(
        WindowMainFrame,
        CreateTweenInfo(0.35),
        { Size = UDim2.new(0, WindowWidth, 0, WindowHeight) }
    ):Play()

    function WindowSelf:AddTab(TabName: string)
        local TabIndex                        = #self.TabList + 1

        -- Tab button
        local TabButton                       = Instance.new("TextButton")
        TabButton.Name                        = "TabButton_" .. TabName
        TabButton.Size                        = UDim2.new(0, 80, 0, 26)
        TabButton.BackgroundColor3            = GlobalThemeTable.ColorElementBase
        TabButton.Text                        = TabName
        TabButton.Font                        = GlobalThemeTable.FontBody
        TabButton.TextSize                    = 12
        TabButton.TextColor3                  = GlobalThemeTable.ColorTextSecondary
        TabButton.LayoutOrder                 = TabIndex
        TabButton.Parent                      = self.TabButtonBar
        ApplyCorner(TabButton, UDim.new(0, 6))

        local NewTab                          = TabClass.new(self.TabContentHolder)
        NewTab.Button                         = TabButton

        table.insert(self.TabList, NewTab)

        -- First tab is visible by default
        if TabIndex == 1 then
            NewTab:SetVisible(true)
            TabButton.TextColor3              = GlobalThemeTable.ColorAccent
            TabButton.BackgroundColor3        = Color3.fromRGB(30, 30, 40)
        end

        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, ExistingTab in ipairs(self.TabList) do
                ExistingTab:SetVisible(false)
                TweenService:Create(
                    ExistingTab.Button,
                    CreateTweenInfo(0.15),
                    { TextColor3 = GlobalThemeTable.ColorTextSecondary, BackgroundColor3 = GlobalThemeTable.ColorElementBase }
                ):Play()
            end
            -- Show selected tab
            NewTab:SetVisible(true)
            TweenService:Create(
                TabButton,
                CreateTweenInfo(0.15),
                { TextColor3 = GlobalThemeTable.ColorAccent, BackgroundColor3 = Color3.fromRGB(30, 30, 40) }
            ):Play()
        end)

        return NewTab
    end

    function WindowSelf:Destroy()
        WindowScreenGui:Destroy()
    end

    return WindowSelf
end

-- ============================================================
-- [LIBRARY ENTRY POINT]
-- ============================================================

function AeternumLibrary:CreateWindow(Options: table)
    return WindowClass.new(Options or {})
end

return AeternumLibrary
