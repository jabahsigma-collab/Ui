--[[
    ============================================================
    VOID UI LIBRARY  //  Enterprise-Grade Roblox Interface Kit
    ============================================================
    Version      : 1.0.0
    Architecture : Monolithic OOP, Single-Script Deployment
    Aesthetic    : Monochrome Minimalist  (#000 / #222 / #FFF)
    Author       : VoidUI Framework
    Description  :
        A production-grade, Rayfield-style UI library for Roblox.
        Implements a full component suite with TweenService animations,
        a notification engine, dragging system, theme manager, and
        a comprehensive auto-layout engine. Written with strict
        code quality standards: verbose naming, full commentary,
        and modular OOP class architecture.
    ============================================================
--]]

-- ============================================================
-- [SECTION 1] SERVICE ACQUISITION
-- Acquire all required Roblox services at the top level for
-- consistent access throughout the library.
-- ============================================================

local TweenService         = game:GetService("TweenService")
local UserInputService     = game:GetService("UserInputService")
local RunService           = game:GetService("RunService")
local Players              = game:GetService("Players")
local CoreGui              = game:GetService("CoreGui")
local TextService          = game:GetService("TextService")
local HttpService          = game:GetService("HttpService")

-- ============================================================
-- [SECTION 2] LOCAL PLAYER REFERENCE
-- ============================================================

local LocalPlayer          = Players.LocalPlayer
local PlayerGui            = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- [SECTION 3] LIBRARY ROOT TABLE
-- The VoidUI table is the single exported object for this
-- entire library. All classes, utilities, and state live
-- under this namespace.
-- ============================================================

local VoidUI = {}
VoidUI.__index = VoidUI

-- ============================================================
-- [SECTION 4] THEME MANAGER
-- A table-driven color palette system. All visual elements
-- derive their colors from this theme table. Supports future
-- theme swapping without touching component code.
-- ============================================================

VoidUI.Theme = {

    -- Primary background surfaces
    BackgroundPrimary        = Color3.fromHex("000000"),  -- Pure Black
    BackgroundSecondary      = Color3.fromHex("0A0A0A"),  -- Near-Black (subtle depth)
    BackgroundTertiary       = Color3.fromHex("111111"),  -- Dark panel
    BackgroundQuaternary     = Color3.fromHex("161616"),  -- Element base

    -- Border and accent surfaces
    BorderPrimary            = Color3.fromHex("222222"),  -- Dark Charcoal border
    BorderSecondary          = Color3.fromHex("2E2E2E"),  -- Slightly lighter border
    BorderHover              = Color3.fromHex("444444"),  -- Hover border state
    BorderActive             = Color3.fromHex("666666"),  -- Active border state

    -- Text hierarchy
    TextPrimary              = Color3.fromHex("FFFFFF"),  -- Pure White (headings)
    TextSecondary            = Color3.fromHex("CCCCCC"),  -- Light Grey (body)
    TextTertiary             = Color3.fromHex("888888"),  -- Mid Grey (hints, labels)
    TextDisabled             = Color3.fromHex("444444"),  -- Disabled state text
    TextPlaceholder          = Color3.fromHex("555555"),  -- Input placeholder text

    -- Interactive element surfaces
    ElementBackground        = Color3.fromHex("0D0D0D"),  -- Default element bg
    ElementHover             = Color3.fromHex("1A1A1A"),  -- Hovered element bg
    ElementActive            = Color3.fromHex("252525"),  -- Active/pressed element bg
    ElementDisabled          = Color3.fromHex("080808"),  -- Disabled element bg

    -- Toggle states
    ToggleEnabled            = Color3.fromHex("FFFFFF"),  -- Toggle ON thumb
    ToggleDisabled           = Color3.fromHex("333333"),  -- Toggle OFF track
    ToggleTrackEnabled       = Color3.fromHex("383838"),  -- Toggle ON track fill

    -- Slider
    SliderTrack              = Color3.fromHex("1C1C1C"),  -- Unfilled track
    SliderFill               = Color3.fromHex("FFFFFF"),  -- Filled track
    SliderThumb              = Color3.fromHex("FFFFFF"),  -- Drag thumb

    -- Notification
    NotificationBackground   = Color3.fromHex("0C0C0C"),  -- Notification card bg
    NotificationBorder       = Color3.fromHex("2A2A2A"),  -- Notification card border
    NotificationProgress     = Color3.fromHex("FFFFFF"),  -- Progress bar fill

    -- Scrollbar
    ScrollbarTrack           = Color3.fromHex("111111"),
    ScrollbarThumb           = Color3.fromHex("333333"),
    ScrollbarThumbHover      = Color3.fromHex("555555"),

    -- Ripple effect
    RippleColor              = Color3.fromHex("FFFFFF"),  -- Material ripple

    -- Shadow simulation
    ShadowColor              = Color3.fromHex("000000"),

    -- Dropdown
    DropdownBackground       = Color3.fromHex("0E0E0E"),
    DropdownItemHover        = Color3.fromHex("1E1E1E"),
    DropdownItemSelected     = Color3.fromHex("282828"),

    -- Color picker monochrome shades (10 steps from black to white)
    ColorPickerShades = {
        Color3.fromHex("000000"),
        Color3.fromHex("1C1C1C"),
        Color3.fromHex("383838"),
        Color3.fromHex("555555"),
        Color3.fromHex("717171"),
        Color3.fromHex("8E8E8E"),
        Color3.fromHex("AAAAAA"),
        Color3.fromHex("C6C6C6"),
        Color3.fromHex("E3E3E3"),
        Color3.fromHex("FFFFFF"),
    },
}

-- ============================================================
-- [SECTION 5] TWEEN CONFIGURATION
-- Centralized easing presets for all TweenService calls.
-- Using Quart Out for smooth, premium-feeling animations.
-- ============================================================

VoidUI.TweenConfig = {

    -- Fast micro-interaction (button press, toggle)
    Fast   = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

    -- Standard UI transition (panel open, tab switch)
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

    -- Slow cinematic (notification slide, modal open)
    Slow   = TweenInfo.new(0.4,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

    -- Extra smooth (drag lerp, progress animations)
    Smooth = TweenInfo.new(0.6,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

    -- Elastic bounce (used sparingly for playful moments)
    Bounce = TweenInfo.new(0.5,  Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),

    -- Ripple expand (material design ripple effect)
    Ripple = TweenInfo.new(0.45, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out),
}

-- ============================================================
-- [SECTION 6] UTILITY MODULE
-- Internal utility functions used across all components.
-- Exposed as VoidUI.Utility for organized access.
-- ============================================================

VoidUI.Utility = {}

--[[
    CreateTween(instance, properties, tweenConfig)
    Wraps TweenService:Create and immediately plays the tween.
    Returns the Tween object for chaining or awaiting.
--]]
function VoidUI.Utility.CreateTween(targetInstance, propertyTable, tweenInfoObject)
    local createdTween = TweenService:Create(targetInstance, tweenInfoObject, propertyTable)
    createdTween:Play()
    return createdTween
end

--[[
    SafeDestroy(instance)
    Destroys a Roblox instance only if it exists and is valid.
    Prevents errors from double-destroy calls.
--]]
function VoidUI.Utility.SafeDestroy(targetInstance)
    if targetInstance and targetInstance.Parent ~= nil then
        targetInstance:Destroy()
    end
end

--[[
    ApplyCornerRadius(frame, radiusPixels)
    Creates and parents a UICorner to any frame with the
    given offset in pixels. Returns the UICorner object.
--]]
function VoidUI.Utility.ApplyCornerRadius(targetFrame, radiusInPixels)
    local cornerObject = Instance.new("UICorner")
    cornerObject.CornerRadius = UDim.new(0, radiusInPixels)
    cornerObject.Parent = targetFrame
    return cornerObject
end

--[[
    ApplyStroke(frame, color, thickness, lineJoinMode)
    Creates and parents a UIStroke for border rendering.
    Returns the UIStroke object.
--]]
function VoidUI.Utility.ApplyStroke(targetFrame, strokeColor, strokeThickness, joinMode)
    local strokeObject = Instance.new("UIStroke")
    strokeObject.Color = strokeColor or VoidUI.Theme.BorderPrimary
    strokeObject.Thickness = strokeThickness or 1
    strokeObject.LineJoinMode = joinMode or Enum.LineJoinMode.Round
    strokeObject.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    strokeObject.Parent = targetFrame
    return strokeObject
end

--[[
    ApplyPadding(frame, top, bottom, left, right)
    Creates a UIPadding and applies specified offsets (in pixels).
    Returns the UIPadding object.
--]]
function VoidUI.Utility.ApplyPadding(targetFrame, paddingTop, paddingBottom, paddingLeft, paddingRight)
    local paddingObject = Instance.new("UIPadding")
    paddingObject.PaddingTop    = UDim.new(0, paddingTop    or 0)
    paddingObject.PaddingBottom = UDim.new(0, paddingBottom or 0)
    paddingObject.PaddingLeft   = UDim.new(0, paddingLeft   or 0)
    paddingObject.PaddingRight  = UDim.new(0, paddingRight  or 0)
    paddingObject.Parent = targetFrame
    return paddingObject
end

--[[
    ApplyListLayout(frame, fillDirection, horizontalAlignment, verticalAlignment, sortOrder, padding)
    Creates and parents a UIListLayout with the given parameters.
    Returns the UIListLayout object.
--]]
function VoidUI.Utility.ApplyListLayout(
    targetFrame,
    fillDirection,
    horizontalAlignment,
    verticalAlignment,
    sortOrder,
    paddingBetweenItems
)
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection         = fillDirection         or Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment   = horizontalAlignment   or Enum.HorizontalAlignment.Left
    listLayout.VerticalAlignment     = verticalAlignment     or Enum.VerticalAlignment.Top
    listLayout.SortOrder             = sortOrder             or Enum.SortOrder.LayoutOrder
    listLayout.Padding               = UDim.new(0, paddingBetweenItems or 4)
    listLayout.Parent = targetFrame
    return listLayout
end

--[[
    CreateLabel(text, textSize, textColor, font, autoSize)
    Creates a minimal TextLabel instance with the given properties.
    Returns the TextLabel.
--]]
function VoidUI.Utility.CreateLabel(
    displayText,
    textSizePixels,
    textColorValue,
    fontFace,
    enableAutoSize
)
    local label = Instance.new("TextLabel")
    label.Text                = displayText    or ""
    label.TextSize            = textSizePixels or 14
    label.TextColor3          = textColorValue or VoidUI.Theme.TextPrimary
    label.Font                = fontFace       or Enum.Font.GothamMedium
    label.BackgroundTransparency = 1
    label.BorderSizePixel     = 0
    label.TextXAlignment      = Enum.TextXAlignment.Left
    label.TextYAlignment      = Enum.TextYAlignment.Center
    label.RichText            = true

    if enableAutoSize then
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.Size = UDim2.fromScale(0, 0)
    else
        label.AutomaticSize = Enum.AutomaticSize.Y
        label.Size = UDim2.new(1, 0, 0, 0)
    end

    return label
end

--[[
    CreateFrame(backgroundColor, size, position, name)
    Creates a minimal Frame with transparent borders and given color.
    Returns the Frame.
--]]
function VoidUI.Utility.CreateFrame(backgroundColor, sizeUDim2, positionUDim2, frameName)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3    = backgroundColor or VoidUI.Theme.BackgroundPrimary
    frame.Size                = sizeUDim2       or UDim2.fromScale(1, 1)
    frame.Position            = positionUDim2   or UDim2.fromOffset(0, 0)
    frame.Name                = frameName       or "VoidFrame"
    frame.BorderSizePixel     = 0
    frame.ClipsDescendants    = false
    return frame
end

--[[
    CreateButton(text, textSize, backgroundColor, textColor, name)
    Creates a TextButton ready for VoidUI styling.
    Returns the TextButton.
--]]
function VoidUI.Utility.CreateButton(displayText, textSizePixels, backgroundColor, textColorValue, buttonName)
    local button = Instance.new("TextButton")
    button.Text                  = displayText    or "Button"
    button.TextSize              = textSizePixels or 14
    button.TextColor3            = textColorValue or VoidUI.Theme.TextPrimary
    button.BackgroundColor3      = backgroundColor or VoidUI.Theme.ElementBackground
    button.Font                  = Enum.Font.GothamMedium
    button.BorderSizePixel       = 0
    button.AutoButtonColor       = false
    button.Name                  = buttonName     or "VoidButton"
    button.ClipsDescendants      = true
    return button
end

--[[
    GenerateUniqueId()
    Returns a random unique string identifier for component tracking.
--]]
function VoidUI.Utility.GenerateUniqueId()
    return HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 12)
end

--[[
    Lerp(a, b, t)
    Standard linear interpolation between two numbers.
--]]
function VoidUI.Utility.Lerp(valueA, valueB, interpolationT)
    return valueA + (valueB - valueA) * interpolationT
end

--[[
    Clamp(value, minimum, maximum)
    Clamps a value between a minimum and maximum bound.
--]]
function VoidUI.Utility.Clamp(currentValue, minimumValue, maximumValue)
    return math.max(minimumValue, math.min(maximumValue, currentValue))
end

--[[
    RoundToDecimal(value, decimalPlaces)
    Rounds a number to the specified number of decimal places.
--]]
function VoidUI.Utility.RoundToDecimal(numericValue, decimalPlaces)
    local multiplier = 10 ^ (decimalPlaces or 0)
    return math.floor(numericValue * multiplier + 0.5) / multiplier
end

--[[
    MapRange(value, inMin, inMax, outMin, outMax)
    Maps a value from one numeric range to another.
    Used extensively in slider and color picker math.
--]]
function VoidUI.Utility.MapRange(inputValue, inputMin, inputMax, outputMin, outputMax)
    local normalizedValue = (inputValue - inputMin) / (inputMax - inputMin)
    return outputMin + (normalizedValue * (outputMax - outputMin))
end

-- ============================================================
-- [SECTION 7] DRAGGING SYSTEM
-- Advanced smooth dragging engine with lerped position updates
-- and viewport boundary clamping. Attaches to any Frame.
-- ============================================================

VoidUI.DragSystem = {}
VoidUI.DragSystem.__index = VoidUI.DragSystem

--[[
    DragSystem.new(dragTargetFrame, dragHandleFrame)
    Creates a new drag controller for the given GUI frame.
    dragTargetFrame : The frame that will physically move.
    dragHandleFrame : The frame the user clicks to initiate drag.
--]]
function VoidUI.DragSystem.new(dragTargetFrame, dragHandleFrame)
    local self = setmetatable({}, VoidUI.DragSystem)

    -- References
    self.TargetFrame        = dragTargetFrame
    self.HandleFrame        = dragHandleFrame or dragTargetFrame

    -- State flags
    self.IsDragging         = false

    -- Raw target position (where we want to be)
    self.TargetPosition     = UDim2.new(
        dragTargetFrame.Position.X.Scale,
        dragTargetFrame.Position.X.Offset,
        dragTargetFrame.Position.Y.Scale,
        dragTargetFrame.Position.Y.Offset
    )

    -- Drag offset within the handle (where user clicked relative to frame top-left)
    self.DragOffset         = Vector2.new(0, 0)

    -- Lerp speed for smooth trailing motion (0.0 - 1.0, higher = snappier)
    self.LerpSpeed          = 0.18

    -- Store connections for cleanup
    self.Connections        = {}

    -- Initialize the drag event bindings
    self:_BindEvents()

    return self
end

--[[
    DragSystem:_BindEvents()
    Internal method. Binds InputBegan on the handle and global
    InputChanged / InputEnded on UserInputService.
--]]
function VoidUI.DragSystem:_BindEvents()

    -- When the user presses down on the drag handle
    local handleInputBeganConnection = self.HandleFrame.InputBegan:Connect(
        function(inputObject, gameProcessedEvent)
            -- Only respond to left mouse button or touch
            local isMouse = inputObject.UserInputType == Enum.UserInputType.MouseButton1
            local isTouch = inputObject.UserInputType == Enum.UserInputType.Touch

            if not (isMouse or isTouch) then
                return
            end

            -- Mark as dragging
            self.IsDragging = true

            -- Calculate offset: where the cursor landed relative to the frame's
            -- absolute top-left corner. This prevents the frame from snapping.
            local absoluteFramePosition = self.TargetFrame.AbsolutePosition
            local inputPosition         = inputObject.Position

            self.DragOffset = Vector2.new(
                inputPosition.X - absoluteFramePosition.X,
                inputPosition.Y - absoluteFramePosition.Y
            )
        end
    )

    table.insert(self.Connections, handleInputBeganConnection)

    -- While the cursor/touch moves globally
    local globalInputChangedConnection = UserInputService.InputChanged:Connect(
        function(inputObject, gameProcessedEvent)
            if not self.IsDragging then
                return
            end

            local isMouse = inputObject.UserInputType == Enum.UserInputType.MouseMovement
            local isTouch = inputObject.UserInputType == Enum.UserInputType.Touch

            if not (isMouse or isTouch) then
                return
            end

            -- Get current viewport size for boundary clamping
            local viewportSize   = workspace.CurrentCamera.ViewportSize
            local frameSize      = self.TargetFrame.AbsoluteSize
            local inputPosition  = inputObject.Position

            -- Calculate the raw desired top-left position
            local rawDesiredX = inputPosition.X - self.DragOffset.X
            local rawDesiredY = inputPosition.Y - self.DragOffset.Y

            -- Clamp within screen boundaries (keep frame fully visible)
            local clampedX = VoidUI.Utility.Clamp(rawDesiredX, 0, viewportSize.X - frameSize.X)
            local clampedY = VoidUI.Utility.Clamp(rawDesiredY, 0, viewportSize.Y - frameSize.Y)

            -- Update the target position (rendering is handled by lerp loop below)
            self.TargetPosition = UDim2.fromOffset(clampedX, clampedY)
        end
    )

    table.insert(self.Connections, globalInputChangedConnection)

    -- When the user releases the mouse/touch
    local globalInputEndedConnection = UserInputService.InputEnded:Connect(
        function(inputObject, gameProcessedEvent)
            local isMouse = inputObject.UserInputType == Enum.UserInputType.MouseButton1
            local isTouch = inputObject.UserInputType == Enum.UserInputType.Touch

            if isMouse or isTouch then
                self.IsDragging = false
            end
        end
    )

    table.insert(self.Connections, globalInputEndedConnection)

    -- Lerp render loop: runs every frame and smoothly interpolates
    -- the actual frame position toward the target position
    local renderSteppedConnection = RunService.RenderStepped:Connect(
        function(deltaTime)
            if not self.IsDragging then
                return
            end

            -- Current actual position offsets
            local currentX = self.TargetFrame.Position.X.Offset
            local currentY = self.TargetFrame.Position.Y.Offset

            -- Target position offsets
            local targetX  = self.TargetPosition.X.Offset
            local targetY  = self.TargetPosition.Y.Offset

            -- Adaptive lerp factor based on delta time for frame-rate independence
            local adaptiveLerpFactor = 1 - (1 - self.LerpSpeed) ^ (deltaTime * 60)

            -- Calculate new lerped position
            local newX = VoidUI.Utility.Lerp(currentX, targetX, adaptiveLerpFactor)
            local newY = VoidUI.Utility.Lerp(currentY, targetY, adaptiveLerpFactor)

            -- Apply the smoothly interpolated position
            self.TargetFrame.Position = UDim2.fromOffset(newX, newY)
        end
    )

    table.insert(self.Connections, renderSteppedConnection)
end

--[[
    DragSystem:Destroy()
    Disconnects all events and cleans up the drag controller.
--]]
function VoidUI.DragSystem:Destroy()
    for _, connection in ipairs(self.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    self.Connections = {}
end

-- ============================================================
-- [SECTION 8] NOTIFICATION ENGINE
-- Queue-based notification system. Notifications slide in from
-- the bottom-right corner, display a progress bar, and
-- auto-dismiss after a configurable duration.
-- ============================================================

VoidUI.NotificationEngine = {}
VoidUI.NotificationEngine.__index = VoidUI.NotificationEngine

-- Internal notification queue state
VoidUI.NotificationEngine._ActiveNotifications  = {}
VoidUI.NotificationEngine._MaxVisibleAtOnce     = 5
VoidUI.NotificationEngine._NotificationSpacing  = 8   -- Pixels between cards
VoidUI.NotificationEngine._BottomMargin         = 24  -- Pixels from screen bottom
VoidUI.NotificationEngine._RightMargin          = 24  -- Pixels from screen right
VoidUI.NotificationEngine._CardWidth            = 320 -- Fixed card width
VoidUI.NotificationEngine._CardMinHeight        = 72  -- Minimum card height
VoidUI.NotificationEngine._ContainerFrame       = nil -- Parent container frame

--[[
    NotificationEngine.Initialize(screenGui)
    Sets up the invisible notification container anchored to
    the bottom-right corner of the screen. Must be called once
    after the ScreenGui is created.
--]]
function VoidUI.NotificationEngine.Initialize(parentScreenGui)
    -- Create the absolute-positioned container frame
    local notificationContainer = Instance.new("Frame")
    notificationContainer.Name                 = "VoidNotificationContainer"
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.BorderSizePixel      = 0
    notificationContainer.Size                 = UDim2.fromScale(1, 1)
    notificationContainer.Position             = UDim2.fromOffset(0, 0)
    notificationContainer.ZIndex               = 100
    notificationContainer.Parent               = parentScreenGui

    VoidUI.NotificationEngine._ContainerFrame = notificationContainer
end

--[[
    NotificationEngine.Push(title, body, duration, notificationType)
    Pushes a new notification onto the queue and displays it.
    title            : Notification heading text
    body             : Notification body/description text
    duration         : How many seconds before auto-dismiss (default 4)
    notificationType : "info" | "success" | "warning" | "error" (affects icon)
--]]
function VoidUI.NotificationEngine.Push(titleText, bodyText, durationSeconds, notificationType)
    -- Validate container exists
    if not VoidUI.NotificationEngine._ContainerFrame then
        warn("[VoidUI] NotificationEngine not initialized. Call Initialize() first.")
        return
    end

    -- Default duration
    local displayDuration = durationSeconds or 4

    -- Unique ID for tracking this notification
    local notificationId = VoidUI.Utility.GenerateUniqueId()

    -- Determine the icon character based on type
    local iconMap = {
        info    = "ℹ",
        success = "✓",
        warning = "⚠",
        error   = "✗",
    }
    local displayIcon = iconMap[notificationType or "info"] or "ℹ"

    -- Get current viewport dimensions for positioning
    local viewportSize = workspace.CurrentCamera.ViewportSize

    -- ---- Build the notification card frame ----

    local cardFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.NotificationBackground,
        UDim2.fromOffset(VoidUI.NotificationEngine._CardWidth, VoidUI.NotificationEngine._CardMinHeight),
        UDim2.fromOffset(
            viewportSize.X + VoidUI.NotificationEngine._CardWidth + 40, -- Start off-screen right
            0  -- Y will be computed dynamically
        ),
        "VoidNotification_" .. notificationId
    )
    cardFrame.ZIndex                = 101
    cardFrame.ClipsDescendants      = false
    cardFrame.AutomaticSize         = Enum.AutomaticSize.Y
    cardFrame.Parent                = VoidUI.NotificationEngine._ContainerFrame

    -- Corner rounding
    VoidUI.Utility.ApplyCornerRadius(cardFrame, 10)

    -- Border stroke
    VoidUI.Utility.ApplyStroke(cardFrame, VoidUI.Theme.NotificationBorder, 1)

    -- Inner padding
    VoidUI.Utility.ApplyPadding(cardFrame, 14, 14, 16, 16)

    -- Inner content list layout
    local contentListLayout = VoidUI.Utility.ApplyListLayout(
        cardFrame,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        6
    )

    -- ---- Title row (icon + title text) ----

    local titleRowFrame = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 20),
        UDim2.fromOffset(0, 0),
        "TitleRow"
    )
    titleRowFrame.BackgroundTransparency = 1
    titleRowFrame.AutomaticSize         = Enum.AutomaticSize.Y
    titleRowFrame.LayoutOrder           = 1
    titleRowFrame.Parent                = cardFrame

    -- Icon label
    local iconLabel = VoidUI.Utility.CreateLabel(
        displayIcon, 16, VoidUI.Theme.TextPrimary, Enum.Font.GothamBold, true
    )
    iconLabel.Name        = "IconLabel"
    iconLabel.LayoutOrder = 1
    iconLabel.Size        = UDim2.fromOffset(20, 20)
    iconLabel.AutomaticSize = Enum.AutomaticSize.None
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent      = titleRowFrame

    -- Title text label
    local titleLabel = VoidUI.Utility.CreateLabel(
        titleText or "Notification",
        14,
        VoidUI.Theme.TextPrimary,
        Enum.Font.GothamBold,
        false
    )
    titleLabel.Name             = "TitleLabel"
    titleLabel.LayoutOrder      = 2
    titleLabel.Position         = UDim2.fromOffset(28, 0)
    titleLabel.Size             = UDim2.new(1, -28, 0, 20)
    titleLabel.AutomaticSize    = Enum.AutomaticSize.Y
    titleLabel.Parent           = titleRowFrame

    -- ---- Body text ----

    local bodyLabel = VoidUI.Utility.CreateLabel(
        bodyText or "",
        12,
        VoidUI.Theme.TextSecondary,
        Enum.Font.Gotham,
        false
    )
    bodyLabel.Name          = "BodyLabel"
    bodyLabel.LayoutOrder   = 2
    bodyLabel.TextWrapped   = true
    bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
    bodyLabel.Size          = UDim2.new(1, 0, 0, 0)
    bodyLabel.Parent        = cardFrame

    -- ---- Progress bar frame ----

    local progressTrack = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BorderPrimary,
        UDim2.new(1, 0, 0, 2),
        UDim2.fromOffset(0, 0),
        "ProgressTrack"
    )
    progressTrack.LayoutOrder   = 3
    progressTrack.ClipsDescendants = true
    progressTrack.Parent        = cardFrame
    VoidUI.Utility.ApplyCornerRadius(progressTrack, 2)

    local progressFill = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.NotificationProgress,
        UDim2.new(1, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "ProgressFill"
    )
    progressFill.Parent = progressTrack
    VoidUI.Utility.ApplyCornerRadius(progressFill, 2)

    -- ---- Register in active notifications table ----

    local notificationData = {
        Id          = notificationId,
        Frame       = cardFrame,
        Duration    = displayDuration,
        StartTime   = tick(),
        IsAnimating = false,
    }

    table.insert(VoidUI.NotificationEngine._ActiveNotifications, notificationData)

    -- ---- Reposition all visible notifications ----
    VoidUI.NotificationEngine._RepositionAll()

    -- ---- Animate card sliding in from the right ----
    task.spawn(function()
        -- Small delay to let layout settle
        task.wait(0.05)

        -- Compute the proper X so card is right-aligned
        local finalX = viewportSize.X
            - VoidUI.NotificationEngine._CardWidth
            - VoidUI.NotificationEngine._RightMargin

        -- Find this notification's target Y in the stack
        local targetY = VoidUI.NotificationEngine._GetTargetY(notificationId)

        -- Slide in
        VoidUI.Utility.CreateTween(
            cardFrame,
            { Position = UDim2.fromOffset(finalX, targetY) },
            VoidUI.TweenConfig.Slow
        )

        -- ---- Animate progress bar draining over duration ----
        task.spawn(function()
            local elapsed    = 0
            local interval   = 0.05  -- Update interval in seconds

            while elapsed < displayDuration do
                task.wait(interval)
                elapsed = elapsed + interval

                local remainingFraction = 1 - (elapsed / displayDuration)
                remainingFraction = VoidUI.Utility.Clamp(remainingFraction, 0, 1)

                -- Directly set size for smooth progress drain
                progressFill.Size = UDim2.new(remainingFraction, 0, 1, 0)
            end

            -- Progress exhausted: dismiss the notification
            VoidUI.NotificationEngine._Dismiss(notificationId)
        end)
    end)
end

--[[
    NotificationEngine._Dismiss(notificationId)
    Internal. Slides a notification card off-screen and removes it
    from the active list. Repositions remaining cards after removal.
--]]
function VoidUI.NotificationEngine._Dismiss(notificationId)
    local targetIndex = nil
    local targetData  = nil

    -- Find the notification in the active list
    for index, notifData in ipairs(VoidUI.NotificationEngine._ActiveNotifications) do
        if notifData.Id == notificationId then
            targetIndex = index
            targetData  = notifData
            break
        end
    end

    if not targetData then
        return
    end

    local viewportSize = workspace.CurrentCamera.ViewportSize

    -- Slide the card off-screen to the right
    local slideOutTween = VoidUI.Utility.CreateTween(
        targetData.Frame,
        {
            Position = UDim2.fromOffset(
                viewportSize.X + VoidUI.NotificationEngine._CardWidth + 40,
                targetData.Frame.Position.Y.Offset
            )
        },
        VoidUI.TweenConfig.Normal
    )

    -- After slide-out completes, destroy and reposition remaining
    slideOutTween.Completed:Connect(function()
        VoidUI.Utility.SafeDestroy(targetData.Frame)
        table.remove(VoidUI.NotificationEngine._ActiveNotifications, targetIndex)
        VoidUI.NotificationEngine._RepositionAll()
    end)
end

--[[
    NotificationEngine._GetTargetY(notificationId)
    Returns the pixel Y position for a given notification in the stack.
--]]
function VoidUI.NotificationEngine._GetTargetY(notificationId)
    local viewportSize  = workspace.CurrentCamera.ViewportSize
    local cardHeight    = VoidUI.NotificationEngine._CardMinHeight
    local spacing       = VoidUI.NotificationEngine._NotificationSpacing
    local bottomMargin  = VoidUI.NotificationEngine._BottomMargin

    -- Find the index of this notification
    local stackIndex = 0
    for index, notifData in ipairs(VoidUI.NotificationEngine._ActiveNotifications) do
        if notifData.Id == notificationId then
            stackIndex = index - 1  -- 0-based from bottom
            break
        end
    end

    -- Position Y from the bottom: first card is at viewportY - margin - cardHeight
    local targetY = viewportSize.Y
        - bottomMargin
        - cardHeight
        - (stackIndex * (cardHeight + spacing))

    return targetY
end

--[[
    NotificationEngine._RepositionAll()
    Smoothly repositions all active notifications to their correct
    stacked positions. Called after adding or removing any card.
--]]
function VoidUI.NotificationEngine._RepositionAll()
    local viewportSize  = workspace.CurrentCamera.ViewportSize
    local cardHeight    = VoidUI.NotificationEngine._CardMinHeight
    local spacing       = VoidUI.NotificationEngine._NotificationSpacing
    local bottomMargin  = VoidUI.NotificationEngine._BottomMargin
    local rightMargin   = VoidUI.NotificationEngine._RightMargin
    local cardWidth     = VoidUI.NotificationEngine._CardWidth

    for stackIndex, notifData in ipairs(VoidUI.NotificationEngine._ActiveNotifications) do
        local zeroBasedIndex = stackIndex - 1

        local targetX = viewportSize.X - cardWidth - rightMargin
        local targetY = viewportSize.Y
            - bottomMargin
            - cardHeight
            - (zeroBasedIndex * (cardHeight + spacing))

        -- Only animate if the card is already on screen (not the initial slide-in)
        if notifData.Frame.Position.X.Offset < viewportSize.X then
            VoidUI.Utility.CreateTween(
                notifData.Frame,
                { Position = UDim2.fromOffset(targetX, targetY) },
                VoidUI.TweenConfig.Normal
            )
        end
    end
end

-- ============================================================
-- [SECTION 9] LIBRARY INITIALIZATION
-- Creates the root ScreenGui with anti-deletion protection,
-- initializes the notification container, and returns the
-- library object ready for window creation.
-- ============================================================

--[[
    VoidUI.new(libraryName)
    Creates a new VoidUI library instance.
    libraryName : The display name and identifier for this UI.
    Returns the library instance table.
--]]
function VoidUI.new(libraryName)
    local self = setmetatable({}, VoidUI)

    -- Store name
    self.LibraryName    = libraryName or "VoidUI"
    self.IsVisible      = true
    self.Windows        = {}
    self.ToggleKeybind  = Enum.KeyCode.RightControl  -- Default hide/show keybind

    -- ---- Create the root ScreenGui ----
    -- Use pcall to handle environments without CoreGui access gracefully

    local screenGuiCreationSuccess, screenGuiOrError = pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name                    = "VoidUI_" .. (libraryName or "Library")
        gui.ResetOnSpawn            = false
        gui.ZIndexBehavior          = Enum.ZIndexBehavior.Sibling
        gui.IgnoreGuiInset          = true
        gui.DisplayOrder            = 999

        -- Try to parent to CoreGui first for protection against LocalScript resets
        local coreGuiSuccess = pcall(function()
            gui.Parent = CoreGui
        end)

        if not coreGuiSuccess then
            -- Fall back to PlayerGui if CoreGui is restricted
            gui.Parent = PlayerGui
        end

        return gui
    end)

    if not screenGuiCreationSuccess then
        warn("[VoidUI] Failed to create ScreenGui: " .. tostring(screenGuiOrError))
        return nil
    end

    self.ScreenGui = screenGuiOrError

    -- ---- Anti-deletion protection ----
    -- Reconnects the ScreenGui parent if it gets destroyed or re-parented
    self._GuardConnection = self.ScreenGui.AncestryChanged:Connect(function(_, newParent)
        if newParent == nil then
            -- GUI was destroyed; attempt to recreate
            warn("[VoidUI] ScreenGui was destroyed. Attempting recovery...")
            task.wait(0.1)

            local recoverySuccess = pcall(function()
                self.ScreenGui.Parent = CoreGui
            end)

            if not recoverySuccess then
                pcall(function()
                    self.ScreenGui.Parent = PlayerGui
                end)
            end
        end
    end)

    -- ---- Initialize the notification engine ----
    VoidUI.NotificationEngine.Initialize(self.ScreenGui)

    -- ---- Global toggle keybind listener ----
    self._KeybindConnection = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
        if gameProcessed then return end

        if inputObject.KeyCode == self.ToggleKeybind then
            self:ToggleVisibility()
        end
    end)

    return self
end

--[[
    VoidUI:ToggleVisibility()
    Shows or hides all windows in this library instance.
--]]
function VoidUI:ToggleVisibility()
    self.IsVisible = not self.IsVisible

    for _, windowInstance in ipairs(self.Windows) do
        if windowInstance and windowInstance.RootFrame then
            windowInstance.RootFrame.Visible = self.IsVisible
        end
    end
end

--[[
    VoidUI:SetToggleKeybind(keyCode)
    Changes the global show/hide keybind for this library.
--]]
function VoidUI:SetToggleKeybind(newKeyCode)
    self.ToggleKeybind = newKeyCode
end

--[[
    VoidUI:Notify(title, body, duration, notificationType)
    Convenience wrapper that pushes a notification via the engine.
--]]
function VoidUI:Notify(titleText, bodyText, durationSeconds, notificationType)
    VoidUI.NotificationEngine.Push(titleText, bodyText, durationSeconds, notificationType)
end

--[[
    VoidUI:Destroy()
    Tears down the entire library: disconnects events, destroys GUI.
--]]
function VoidUI:Destroy()
    -- Disconnect guard and keybind listeners
    if self._GuardConnection then
        self._GuardConnection:Disconnect()
    end
    if self._KeybindConnection then
        self._KeybindConnection:Disconnect()
    end

    -- Destroy all windows
    for _, windowInstance in ipairs(self.Windows) do
        if windowInstance and windowInstance.Destroy then
            windowInstance:Destroy()
        end
    end

    -- Destroy the root ScreenGui
    VoidUI.Utility.SafeDestroy(self.ScreenGui)
end

-- ============================================================
-- [SECTION 10] WINDOW CLASS
-- The primary container for all UI content. A window is a
-- draggable panel with a title bar, optional subtitle, a tab
-- strip, and a content area. Supports minimize/close actions.
-- ============================================================

local WindowClass = {}
WindowClass.__index = WindowClass

--[[
    WindowClass.new(libraryInstance, windowConfig)
    windowConfig table fields:
        Title       : string  (Window title)
        Subtitle    : string  (Optional subtitle beneath title)
        Width       : number  (Panel width in pixels, default 560)
        MinHeight   : number  (Minimum panel height, default 400)
        Position    : UDim2   (Initial position, defaults to center)
        Resizable   : bool    (Future: allow resize handle)
--]]
function WindowClass.new(libraryInstance, windowConfig)
    local self = setmetatable({}, WindowClass)

    -- References
    self.Library        = libraryInstance
    self.Config         = windowConfig or {}
    self.Tabs           = {}
    self.ActiveTab      = nil
    self.IsMinimized    = false
    self.IsOpen         = true

    -- Layout config
    local panelWidth    = self.Config.Width     or 560
    local panelHeight   = self.Config.MinHeight or 400

    -- ---- Compute initial centered position ----
    local viewportSize  = workspace.CurrentCamera.ViewportSize
    local initialX      = math.floor((viewportSize.X - panelWidth) / 2)
    local initialY      = math.floor((viewportSize.Y - panelHeight) / 2)
    local startPosition = self.Config.Position or UDim2.fromOffset(initialX, initialY)

    -- ========================================================
    -- ROOT PANEL FRAME
    -- This is the outermost container. It uses AutomaticSize Y
    -- to grow with content.
    -- ========================================================

    self.RootFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BackgroundPrimary,
        UDim2.fromOffset(panelWidth, 0),
        startPosition,
        "VoidWindow_" .. VoidUI.Utility.GenerateUniqueId()
    )
    self.RootFrame.AutomaticSize   = Enum.AutomaticSize.Y
    self.RootFrame.ClipsDescendants = false
    self.RootFrame.ZIndex           = 10
    self.RootFrame.Parent           = libraryInstance.ScreenGui

    -- Corner rounding for the outer panel
    VoidUI.Utility.ApplyCornerRadius(self.RootFrame, 12)

    -- Outer border stroke
    VoidUI.Utility.ApplyStroke(self.RootFrame, VoidUI.Theme.BorderPrimary, 1)

    -- Vertical list layout for: TitleBar, TabStrip, ContentArea
    VoidUI.Utility.ApplyListLayout(
        self.RootFrame,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        0
    )

    -- ========================================================
    -- TITLE BAR
    -- Contains: accent bar, window icon, title text, subtitle,
    -- minimize button, close button.
    -- ========================================================

    self.TitleBar = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BackgroundSecondary,
        UDim2.new(1, 0, 0, 52),
        UDim2.fromOffset(0, 0),
        "TitleBar"
    )
    self.TitleBar.LayoutOrder  = 1
    self.TitleBar.ZIndex       = 11
    self.TitleBar.Parent       = self.RootFrame

    -- Rounded only on top; we'll clip the bottom corners visually
    VoidUI.Utility.ApplyCornerRadius(self.TitleBar, 12)

    -- Left inner padding for title content
    VoidUI.Utility.ApplyPadding(self.TitleBar, 0, 0, 18, 12)

    -- Thin accent line at very top of title bar
    local titleAccentBar = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BorderSecondary,
        UDim2.new(1, 0, 0, 1),
        UDim2.fromOffset(0, 0),
        "TitleAccentBar"
    )
    titleAccentBar.ZIndex  = 12
    titleAccentBar.Parent  = self.TitleBar

    -- Title text label
    local titleLabel = VoidUI.Utility.CreateLabel(
        self.Config.Title or "VoidUI Window",
        16,
        VoidUI.Theme.TextPrimary,
        Enum.Font.GothamBold,
        false
    )
    titleLabel.Name         = "TitleLabel"
    titleLabel.Size         = UDim2.new(1, -80, 0, 22)
    titleLabel.Position     = UDim2.fromOffset(0, 8)
    titleLabel.ZIndex       = 12
    titleLabel.Parent       = self.TitleBar

    -- Subtitle text label (visible only if config provides subtitle)
    local subtitleLabel = VoidUI.Utility.CreateLabel(
        self.Config.Subtitle or "",
        11,
        VoidUI.Theme.TextTertiary,
        Enum.Font.Gotham,
        false
    )
    subtitleLabel.Name          = "SubtitleLabel"
    subtitleLabel.Size          = UDim2.new(1, -80, 0, 14)
    subtitleLabel.Position      = UDim2.fromOffset(0, 32)
    subtitleLabel.ZIndex        = 12
    subtitleLabel.Visible       = (self.Config.Subtitle ~= nil and self.Config.Subtitle ~= "")
    subtitleLabel.Parent        = self.TitleBar

    -- ---- Window Control Buttons (Minimize / Close) ----

    -- Close button
    local closeButton = VoidUI.Utility.CreateButton(
        "✕", 13, VoidUI.Theme.ElementBackground,
        VoidUI.Theme.TextTertiary, "CloseButton"
    )
    closeButton.Size          = UDim2.fromOffset(28, 28)
    closeButton.Position      = UDim2.new(1, -36, 0.5, -14)
    closeButton.ZIndex        = 12
    closeButton.Parent        = self.TitleBar
    VoidUI.Utility.ApplyCornerRadius(closeButton, 6)

    -- Minimize button
    local minimizeButton = VoidUI.Utility.CreateButton(
        "−", 16, VoidUI.Theme.ElementBackground,
        VoidUI.Theme.TextTertiary, "MinimizeButton"
    )
    minimizeButton.Size       = UDim2.fromOffset(28, 28)
    minimizeButton.Position   = UDim2.new(1, -68, 0.5, -14)
    minimizeButton.ZIndex     = 12
    minimizeButton.Parent     = self.TitleBar
    VoidUI.Utility.ApplyCornerRadius(minimizeButton, 6)

    -- ---- Button hover animations ----

    local function ApplyControlButtonHover(controlButton, hoverColor)
        controlButton.MouseEnter:Connect(function()
            VoidUI.Utility.CreateTween(
                controlButton,
                { BackgroundColor3 = hoverColor, TextColor3 = VoidUI.Theme.TextPrimary },
                VoidUI.TweenConfig.Fast
            )
        end)
        controlButton.MouseLeave:Connect(function()
            VoidUI.Utility.CreateTween(
                controlButton,
                { BackgroundColor3 = VoidUI.Theme.ElementBackground, TextColor3 = VoidUI.Theme.TextTertiary },
                VoidUI.TweenConfig.Fast
            )
        end)
    end

    ApplyControlButtonHover(closeButton,    VoidUI.Theme.ElementActive)
    ApplyControlButtonHover(minimizeButton, VoidUI.Theme.ElementHover)

    -- ---- Close button logic ----
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)

    -- ---- Minimize button logic ----
    minimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)

    -- ========================================================
    -- SEPARATOR LINE between title bar and tab strip
    -- ========================================================

    local titleSeparator = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BorderPrimary,
        UDim2.new(1, 0, 0, 1),
        UDim2.fromOffset(0, 0),
        "TitleSeparator"
    )
    titleSeparator.LayoutOrder = 2
    titleSeparator.ZIndex      = 11
    titleSeparator.Parent      = self.RootFrame

    -- ========================================================
    -- TAB STRIP
    -- Horizontal scrolling strip for tab buttons.
    -- ========================================================

    self.TabStrip = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BackgroundSecondary,
        UDim2.new(1, 0, 0, 40),
        UDim2.fromOffset(0, 0),
        "TabStrip"
    )
    self.TabStrip.LayoutOrder       = 3
    self.TabStrip.ClipsDescendants  = true
    self.TabStrip.ZIndex            = 11
    self.TabStrip.Parent            = self.RootFrame

    VoidUI.Utility.ApplyPadding(self.TabStrip, 0, 0, 12, 12)

    -- Horizontal list layout for tab buttons
    self.TabStripLayout = VoidUI.Utility.ApplyListLayout(
        self.TabStrip,
        Enum.FillDirection.Horizontal,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center,
        Enum.SortOrder.LayoutOrder,
        6
    )

    -- ========================================================
    -- SEPARATOR LINE between tab strip and content area
    -- ========================================================

    local tabSeparator = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BorderPrimary,
        UDim2.new(1, 0, 0, 1),
        UDim2.fromOffset(0, 0),
        "TabSeparator"
    )
    tabSeparator.LayoutOrder = 4
    tabSeparator.ZIndex      = 11
    tabSeparator.Parent      = self.RootFrame

    -- ========================================================
    -- CONTENT AREA (ScrollingFrame)
    -- All tab content panels render inside this scrolling frame.
    -- ========================================================

    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name                    = "ContentArea"
    self.ContentArea.BackgroundColor3        = VoidUI.Theme.BackgroundPrimary
    self.ContentArea.BorderSizePixel         = 0
    self.ContentArea.Size                    = UDim2.new(1, 0, 0, panelHeight - 94)
    self.ContentArea.CanvasSize              = UDim2.fromOffset(0, 0)
    self.ContentArea.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    self.ContentArea.ScrollBarThickness      = 4
    self.ContentArea.ScrollBarImageColor3    = VoidUI.Theme.ScrollbarThumb
    self.ContentArea.ScrollingDirection      = Enum.ScrollingDirection.Y
    self.ContentArea.LayoutOrder             = 5
    self.ContentArea.ZIndex                  = 11
    self.ContentArea.ClipsDescendants        = true
    self.ContentArea.Parent                  = self.RootFrame

    -- ========================================================
    -- ATTACH DRAG SYSTEM to title bar as the drag handle
    -- ========================================================

    self.DragController = VoidUI.DragSystem.new(self.RootFrame, self.TitleBar)

    -- ========================================================
    -- Store references and register with library
    -- ========================================================

    table.insert(libraryInstance.Windows, self)

    return self
end

--[[
    WindowClass:AddTab(tabConfig)
    Creates and registers a new tab on this window.
    tabConfig fields:
        Name    : string (Tab label)
        Icon    : string (Optional icon character, e.g. "⚙")
    Returns a Tab instance for adding components.
--]]
function WindowClass:AddTab(tabConfig)
    local tabInstance = TabClass.new(self, tabConfig)
    table.insert(self.Tabs, tabInstance)

    -- Auto-select the first tab added
    if #self.Tabs == 1 then
        self:SelectTab(tabInstance)
    end

    return tabInstance
end

--[[
    WindowClass:SelectTab(tabInstance)
    Switches the active tab. Fades out the old content and fades
    in the new content. Updates the tab button active states.
--]]
function WindowClass:SelectTab(newTabInstance)
    -- Deactivate the previously active tab
    if self.ActiveTab and self.ActiveTab ~= newTabInstance then
        local previousTab = self.ActiveTab

        -- Deactivate button appearance
        previousTab:_SetButtonInactive()

        -- Fade out old content panel
        if previousTab.ContentPanel then
            VoidUI.Utility.CreateTween(
                previousTab.ContentPanel,
                { BackgroundTransparency = 1 },
                VoidUI.TweenConfig.Fast
            )
            -- Wait a moment then hide the panel
            task.spawn(function()
                task.wait(0.15)
                previousTab.ContentPanel.Visible = false
            end)
        end
    end

    -- Activate the new tab
    self.ActiveTab = newTabInstance

    newTabInstance:_SetButtonActive()

    -- Show and fade in new content panel
    if newTabInstance.ContentPanel then
        newTabInstance.ContentPanel.Visible = true
        newTabInstance.ContentPanel.BackgroundTransparency = 1

        VoidUI.Utility.CreateTween(
            newTabInstance.ContentPanel,
            { BackgroundTransparency = 1 },
            VoidUI.TweenConfig.Fast
        )
    end
end

--[[
    WindowClass:ToggleMinimize()
    Toggles the content area and tab strip visibility,
    shrinking the window to just the title bar.
--]]
function WindowClass:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized

    if self.IsMinimized then
        -- Hide content elements with a smooth height tween
        VoidUI.Utility.CreateTween(
            self.ContentArea,
            { Size = UDim2.new(1, 0, 0, 0) },
            VoidUI.TweenConfig.Normal
        )
        VoidUI.Utility.CreateTween(
            self.TabStrip,
            { Size = UDim2.new(1, 0, 0, 0) },
            VoidUI.TweenConfig.Normal
        )
    else
        -- Restore content area size
        VoidUI.Utility.CreateTween(
            self.ContentArea,
            { Size = UDim2.new(1, 0, 0, (self.Config.MinHeight or 400) - 94) },
            VoidUI.TweenConfig.Normal
        )
        VoidUI.Utility.CreateTween(
            self.TabStrip,
            { Size = UDim2.new(1, 0, 0, 40) },
            VoidUI.TweenConfig.Normal
        )
    end
end

--[[
    WindowClass:Close()
    Animates the window closing (scale + fade) then destroys it.
--]]
function WindowClass:Close()
    self.IsOpen = false

    -- Scale down and fade out simultaneously
    VoidUI.Utility.CreateTween(
        self.RootFrame,
        { Size = UDim2.fromOffset(
            self.RootFrame.AbsoluteSize.X * 0.95,
            self.RootFrame.AbsoluteSize.Y * 0.95
        )},
        VoidUI.TweenConfig.Fast
    )

    task.spawn(function()
        task.wait(0.2)
        VoidUI.Utility.SafeDestroy(self.RootFrame)
    end)
end

--[[
    WindowClass:Destroy()
    Immediately destroys the window and its drag controller.
--]]
function WindowClass:Destroy()
    if self.DragController then
        self.DragController:Destroy()
    end
    VoidUI.Utility.SafeDestroy(self.RootFrame)
end

--[[
    VoidUI:CreateWindow(windowConfig)
    Public factory method on the library instance.
    Creates and returns a new WindowClass instance.
--]]
function VoidUI:CreateWindow(windowConfig)
    return WindowClass.new(self, windowConfig)
end

-- ============================================================
-- [SECTION 11] TAB CLASS
-- A tab consists of a button in the tab strip and a content
-- panel in the content area. Components are added to the panel.
-- ============================================================

TabClass = {}
TabClass.__index = TabClass

--[[
    TabClass.new(windowInstance, tabConfig)
    tabConfig fields:
        Name    : string (Display name for the tab button)
        Icon    : string (Optional Unicode icon character)
--]]
function TabClass.new(windowInstance, tabConfig)
    local self = setmetatable({}, TabClass)

    -- References
    self.Window     = windowInstance
    self.Config     = tabConfig or {}
    self.Sections   = {}
    self.IsActive   = false

    local tabName   = self.Config.Name or ("Tab " .. (#windowInstance.Tabs + 1))
    local tabIcon   = self.Config.Icon or ""

    -- ---- Build the tab button in the tab strip ----

    local buttonLabel = (tabIcon ~= "" and (tabIcon .. "  ") or "") .. tabName

    self.TabButton = VoidUI.Utility.CreateButton(
        buttonLabel,
        12,
        Color3.fromRGB(0, 0, 0),
        VoidUI.Theme.TextTertiary,
        "TabButton_" .. tabName
    )
    self.TabButton.BackgroundTransparency = 1
    self.TabButton.Size                   = UDim2.fromOffset(0, 28)
    self.TabButton.AutomaticSize          = Enum.AutomaticSize.X
    self.TabButton.TextXAlignment         = Enum.TextXAlignment.Center
    self.TabButton.ZIndex                 = 12
    self.TabButton.ClipsDescendants       = false

    VoidUI.Utility.ApplyPadding(self.TabButton, 0, 0, 12, 12)
    VoidUI.Utility.ApplyCornerRadius(self.TabButton, 6)

    self.TabButton.Parent = windowInstance.TabStrip

    -- Active indicator underline bar
    self.ActiveIndicator = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.TextPrimary,
        UDim2.new(1, -16, 0, 2),
        UDim2.new(0, 8, 1, -2),
        "ActiveIndicator"
    )
    self.ActiveIndicator.BackgroundTransparency = 1
    self.ActiveIndicator.ZIndex                 = 13
    VoidUI.Utility.ApplyCornerRadius(self.ActiveIndicator, 2)
    self.ActiveIndicator.Parent = self.TabButton

    -- ---- Build the content panel in the content area ----

    self.ContentPanel = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BackgroundPrimary,
        UDim2.new(1, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "TabPanel_" .. tabName
    )
    self.ContentPanel.ZIndex            = 12
    self.ContentPanel.Visible           = false
    self.ContentPanel.AutomaticSize     = Enum.AutomaticSize.Y
    self.ContentPanel.ClipsDescendants  = false
    self.ContentPanel.Parent            = windowInstance.ContentArea

    -- Padding inside the content panel
    VoidUI.Utility.ApplyPadding(self.ContentPanel, 12, 16, 16, 16)

    -- Vertical list layout for sections
    VoidUI.Utility.ApplyListLayout(
        self.ContentPanel,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        10
    )

    -- ---- Tab button click handler ----
    self.TabButton.MouseButton1Click:Connect(function()
        windowInstance:SelectTab(self)
    end)

    -- ---- Tab button hover animations ----
    self.TabButton.MouseEnter:Connect(function()
        if not self.IsActive then
            VoidUI.Utility.CreateTween(
                self.TabButton,
                { TextColor3 = VoidUI.Theme.TextSecondary },
                VoidUI.TweenConfig.Fast
            )
        end
    end)

    self.TabButton.MouseLeave:Connect(function()
        if not self.IsActive then
            VoidUI.Utility.CreateTween(
                self.TabButton,
                { TextColor3 = VoidUI.Theme.TextTertiary },
                VoidUI.TweenConfig.Fast
            )
        end
    end)

    return self
end

--[[
    TabClass:_SetButtonActive()
    Visual state when this tab is the selected/active tab.
--]]
function TabClass:_SetButtonActive()
    self.IsActive = true

    VoidUI.Utility.CreateTween(
        self.TabButton,
        { TextColor3 = VoidUI.Theme.TextPrimary },
        VoidUI.TweenConfig.Fast
    )

    VoidUI.Utility.CreateTween(
        self.ActiveIndicator,
        { BackgroundTransparency = 0 },
        VoidUI.TweenConfig.Fast
    )
end

--[[
    TabClass:_SetButtonInactive()
    Visual state when this tab is not the selected tab.
--]]
function TabClass:_SetButtonInactive()
    self.IsActive = false

    VoidUI.Utility.CreateTween(
        self.TabButton,
        { TextColor3 = VoidUI.Theme.TextTertiary },
        VoidUI.TweenConfig.Fast
    )

    VoidUI.Utility.CreateTween(
        self.ActiveIndicator,
        { BackgroundTransparency = 1 },
        VoidUI.TweenConfig.Fast
    )
end

--[[
    TabClass:AddSection(sectionConfig)
    Creates a labeled section grouping inside this tab's content panel.
    Returns a SectionClass instance for adding components.
--]]
function TabClass:AddSection(sectionConfig)
    local sectionInstance = SectionClass.new(self, sectionConfig)
    table.insert(self.Sections, sectionInstance)
    return sectionInstance
end

-- ============================================================
-- [SECTION 12] SECTION CLASS
-- Groups related components under a visual label with a
-- divider line. Sections use auto-sizing to fit their children.
-- ============================================================

SectionClass = {}
SectionClass.__index = SectionClass

--[[
    SectionClass.new(tabInstance, sectionConfig)
    sectionConfig fields:
        Name    : string (Section heading label text)
--]]
function SectionClass.new(tabInstance, sectionConfig)
    local self = setmetatable({}, SectionClass)

    -- References
    self.Tab        = tabInstance
    self.Config     = sectionConfig or {}
    self.Components = {}
    self.LayoutOrder = #tabInstance.Sections + 1

    local sectionName = self.Config.Name or "Section"

    -- ---- Outer section container ----

    self.SectionFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BackgroundTertiary,
        UDim2.new(1, 0, 0, 0),
        UDim2.fromOffset(0, 0),
        "Section_" .. sectionName
    )
    self.SectionFrame.AutomaticSize    = Enum.AutomaticSize.Y
    self.SectionFrame.LayoutOrder      = self.LayoutOrder
    self.SectionFrame.ZIndex           = 13
    self.SectionFrame.ClipsDescendants = false
    self.SectionFrame.Parent           = tabInstance.ContentPanel

    VoidUI.Utility.ApplyCornerRadius(self.SectionFrame, 8)
    VoidUI.Utility.ApplyStroke(self.SectionFrame, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(self.SectionFrame, 10, 10, 14, 14)

    -- Vertical list layout for components inside the section
    self.SectionLayout = VoidUI.Utility.ApplyListLayout(
        self.SectionFrame,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        2
    )

    -- ---- Section header row ----

    local headerRow = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 24),
        UDim2.fromOffset(0, 0),
        "SectionHeader"
    )
    headerRow.BackgroundTransparency = 1
    headerRow.LayoutOrder            = 0
    headerRow.ZIndex                 = 14
    headerRow.Parent                 = self.SectionFrame

    -- Section title label
    local sectionLabel = VoidUI.Utility.CreateLabel(
        sectionName,
        11,
        VoidUI.Theme.TextTertiary,
        Enum.Font.GothamBold,
        false
    )
    sectionLabel.Name           = "SectionLabel"
    sectionLabel.Size           = UDim2.new(1, 0, 1, 0)
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.ZIndex         = 14
    sectionLabel.Parent         = headerRow

    -- Thin divider line beneath section header
    local sectionDivider = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.BorderPrimary,
        UDim2.new(1, 0, 0, 1),
        UDim2.fromOffset(0, 0),
        "SectionDivider"
    )
    sectionDivider.LayoutOrder = 1
    sectionDivider.ZIndex      = 14
    sectionDivider.Parent      = self.SectionFrame

    -- Component container (separate from header)
    self.ComponentContainer = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 0),
        UDim2.fromOffset(0, 0),
        "ComponentContainer"
    )
    self.ComponentContainer.BackgroundTransparency = 1
    self.ComponentContainer.AutomaticSize          = Enum.AutomaticSize.Y
    self.ComponentContainer.LayoutOrder            = 2
    self.ComponentContainer.ZIndex                 = 14
    self.ComponentContainer.ClipsDescendants       = false
    self.ComponentContainer.Parent                 = self.SectionFrame

    VoidUI.Utility.ApplyListLayout(
        self.ComponentContainer,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        2
    )

    return self
end

--[[
    SectionClass:AddButton(buttonConfig) -> ButtonComponent
    SectionClass:AddToggle(toggleConfig) -> ToggleComponent
    SectionClass:AddSlider(sliderConfig) -> SliderComponent
    SectionClass:AddDropdown(dropdownConfig) -> DropdownComponent
    SectionClass:AddKeybind(keybindConfig) -> KeybindComponent
    SectionClass:AddColorPicker(colorPickerConfig) -> ColorPickerComponent
    SectionClass:AddLabel(labelConfig) -> LabelComponent
    All component factory methods below delegate to their respective classes.
--]]

function SectionClass:AddButton(buttonConfig)
    local component = ButtonComponent.new(self, buttonConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddToggle(toggleConfig)
    local component = ToggleComponent.new(self, toggleConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddSlider(sliderConfig)
    local component = SliderComponent.new(self, sliderConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddDropdown(dropdownConfig)
    local component = DropdownComponent.new(self, dropdownConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddKeybind(keybindConfig)
    local component = KeybindComponent.new(self, keybindConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddColorPicker(colorPickerConfig)
    local component = ColorPickerComponent.new(self, colorPickerConfig)
    table.insert(self.Components, component)
    return component
end

function SectionClass:AddLabel(labelConfig)
    local component = LabelComponent.new(self, labelConfig)
    table.insert(self.Components, component)
    return component
end

-- ============================================================
-- [SECTION 13] COMPONENT BASE CLASS
-- Shared logic inherited by all interactive components:
-- enabled state, label rendering, row frame construction.
-- ============================================================

local ComponentBase = {}
ComponentBase.__index = ComponentBase

--[[
    ComponentBase._BuildRowFrame(section, componentName, rowHeight)
    Creates the standard horizontal row frame used by all
    components. Returns the row frame and a label frame.
--]]
function ComponentBase._BuildRowFrame(parentSection, componentName, rowHeightPixels)
    local rowHeight = rowHeightPixels or 42

    -- Outer row frame (full-width, fixed height, transparent bg by default)
    local rowFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.ElementBackground,
        UDim2.new(1, 0, 0, rowHeight),
        UDim2.fromOffset(0, 0),
        componentName .. "_Row"
    )
    rowFrame.ZIndex           = 15
    rowFrame.ClipsDescendants = false
    rowFrame.LayoutOrder      = #parentSection.Components + 1
    rowFrame.Parent           = parentSection.ComponentContainer

    VoidUI.Utility.ApplyCornerRadius(rowFrame, 6)
    VoidUI.Utility.ApplyPadding(rowFrame, 0, 0, 12, 12)

    -- Left side: label region
    local labelFrame = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.55, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "LabelRegion"
    )
    labelFrame.BackgroundTransparency = 1
    labelFrame.ZIndex                 = 16
    labelFrame.Parent                 = rowFrame

    -- Right side: control region
    local controlFrame = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.45, 0, 1, 0),
        UDim2.new(0.55, 0, 0, 0),
        "ControlRegion"
    )
    controlFrame.BackgroundTransparency = 1
    controlFrame.ZIndex                 = 16
    controlFrame.Parent                 = rowFrame

    return rowFrame, labelFrame, controlFrame
end

--[[
    ComponentBase._BuildComponentLabel(labelFrame, title, description)
    Adds a title label and optional description label to the
    left-side label region of a component row.
--]]
function ComponentBase._BuildComponentLabel(labelFrame, titleText, descriptionText)
    -- Primary component title label
    local componentTitleLabel = VoidUI.Utility.CreateLabel(
        titleText or "Component",
        13,
        VoidUI.Theme.TextPrimary,
        Enum.Font.GothamMedium,
        false
    )
    componentTitleLabel.Name             = "ComponentTitle"
    componentTitleLabel.Size             = UDim2.new(1, 0, 0, 16)
    componentTitleLabel.Position         = descriptionText
        and UDim2.fromOffset(0, 4)
        or  UDim2.new(0, 0, 0.5, -8)
    componentTitleLabel.TextXAlignment   = Enum.TextXAlignment.Left
    componentTitleLabel.ZIndex           = 16
    componentTitleLabel.Parent           = labelFrame

    -- Optional description/hint label
    if descriptionText and descriptionText ~= "" then
        local descLabel = VoidUI.Utility.CreateLabel(
            descriptionText,
            10,
            VoidUI.Theme.TextTertiary,
            Enum.Font.Gotham,
            false
        )
        descLabel.Name           = "ComponentDescription"
        descLabel.Size           = UDim2.new(1, 0, 0, 12)
        descLabel.Position       = UDim2.fromOffset(0, 22)
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex         = 16
        descLabel.TextWrapped    = true
        descLabel.Parent         = labelFrame
    end
end

-- ============================================================
-- [SECTION 14] BUTTON COMPONENT
-- Clickable button with Material Design ripple effect,
-- hover scaling, press darkening, and callback execution.
-- ============================================================

ButtonComponent = {}
ButtonComponent.__index = ButtonComponent

--[[
    ButtonComponent.new(section, buttonConfig)
    buttonConfig fields:
        Name        : string   (Display label)
        Description : string   (Optional subtitle)
        Callback    : function (Called on click)
        Disabled    : bool     (If true, non-interactive)
--]]
function ButtonComponent.new(parentSection, buttonConfig)
    local self = setmetatable({}, ButtonComponent)

    self.Section    = parentSection
    self.Config     = buttonConfig or {}
    self.IsDisabled = self.Config.Disabled or false

    local displayName   = self.Config.Name        or "Button"
    local displayDesc   = self.Config.Description or ""
    local callbackFn    = self.Config.Callback     or function() end

    -- ---- Build the full-width button frame ----

    self.ButtonFrame = VoidUI.Utility.CreateButton(
        "",
        13,
        VoidUI.Theme.ElementBackground,
        VoidUI.Theme.TextPrimary,
        "ButtonComponent_" .. displayName
    )
    self.ButtonFrame.Size           = UDim2.new(1, 0, 0, 42)
    self.ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left
    self.ButtonFrame.ZIndex         = 15
    self.ButtonFrame.ClipsDescendants = true -- For ripple clipping
    self.ButtonFrame.LayoutOrder    = #parentSection.Components + 1
    self.ButtonFrame.Parent         = parentSection.ComponentContainer

    VoidUI.Utility.ApplyCornerRadius(self.ButtonFrame, 6)
    VoidUI.Utility.ApplyStroke(self.ButtonFrame, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(self.ButtonFrame, 0, 0, 14, 14)

    -- ---- Left region: name and description ----

    local innerContainer = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.75, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "ButtonInner"
    )
    innerContainer.BackgroundTransparency = 1
    innerContainer.ZIndex = 16
    innerContainer.Parent = self.ButtonFrame

    ComponentBase._BuildComponentLabel(innerContainer, displayName, displayDesc)

    -- ---- Right region: arrow indicator ----

    local arrowLabel = VoidUI.Utility.CreateLabel(
        "→",
        14,
        VoidUI.Theme.TextTertiary,
        Enum.Font.GothamBold,
        true
    )
    arrowLabel.Name             = "ArrowIndicator"
    arrowLabel.Position         = UDim2.new(0.78, 0, 0.5, -9)
    arrowLabel.Size             = UDim2.fromOffset(20, 20)
    arrowLabel.AutomaticSize    = Enum.AutomaticSize.None
    arrowLabel.TextXAlignment   = Enum.TextXAlignment.Center
    arrowLabel.ZIndex           = 16
    arrowLabel.Parent           = self.ButtonFrame

    -- ---- Disabled state visual ----

    if self.IsDisabled then
        self.ButtonFrame.BackgroundColor3 = VoidUI.Theme.ElementDisabled
        -- Iterate children to grey out text
        for _, child in ipairs(self.ButtonFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                child.TextColor3 = VoidUI.Theme.TextDisabled
            end
        end
    end

    -- ---- Hover animation ----

    self.ButtonFrame.MouseEnter:Connect(function()
        if self.IsDisabled then return end

        VoidUI.Utility.CreateTween(
            self.ButtonFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementHover },
            VoidUI.TweenConfig.Fast
        )
        VoidUI.Utility.CreateTween(
            arrowLabel,
            { TextColor3 = VoidUI.Theme.TextPrimary },
            VoidUI.TweenConfig.Fast
        )
    end)

    self.ButtonFrame.MouseLeave:Connect(function()
        if self.IsDisabled then return end

        VoidUI.Utility.CreateTween(
            self.ButtonFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementBackground },
            VoidUI.TweenConfig.Fast
        )
        VoidUI.Utility.CreateTween(
            arrowLabel,
            { TextColor3 = VoidUI.Theme.TextTertiary },
            VoidUI.TweenConfig.Fast
        )
    end)

    -- ---- Press animation ----

    self.ButtonFrame.MouseButton1Down:Connect(function()
        if self.IsDisabled then return end

        VoidUI.Utility.CreateTween(
            self.ButtonFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementActive },
            VoidUI.TweenConfig.Fast
        )
    end)

    -- ---- Click: Ripple effect + callback ----

    self.ButtonFrame.MouseButton1Click:Connect(function()
        if self.IsDisabled then return end

        -- Restore background
        VoidUI.Utility.CreateTween(
            self.ButtonFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementHover },
            VoidUI.TweenConfig.Fast
        )

        -- Launch ripple on separate thread to avoid blocking
        task.spawn(function()
            self:_PlayRippleEffect()
        end)

        -- Execute the user callback safely
        task.spawn(function()
            local callbackSuccess, callbackError = pcall(callbackFn)
            if not callbackSuccess then
                warn("[VoidUI] Button callback error: " .. tostring(callbackError))
            end
        end)
    end)

    return self
end

--[[
    ButtonComponent:_PlayRippleEffect()
    Creates a circular ripple that expands from the click position,
    simulating Material Design's ink ripple animation.
--]]
function ButtonComponent:_PlayRippleEffect()
    -- Get mouse position relative to the button frame
    local mousePosition     = UserInputService:GetMouseLocation()
    local framePosition     = self.ButtonFrame.AbsolutePosition
    local frameSize         = self.ButtonFrame.AbsoluteSize

    -- Relative position within the frame
    local relativeX = mousePosition.X - framePosition.X
    local relativeY = mousePosition.Y - framePosition.Y

    -- Ripple circle starting very small
    local rippleStartSize   = 4
    local rippleMaxSize     = math.max(frameSize.X, frameSize.Y) * 2.2

    -- Create the ripple circle frame
    local rippleCircle = Instance.new("Frame")
    rippleCircle.Name                 = "RippleCircle"
    rippleCircle.BackgroundColor3     = VoidUI.Theme.RippleColor
    rippleCircle.BackgroundTransparency = 0.82
    rippleCircle.BorderSizePixel      = 0
    rippleCircle.ZIndex               = 20
    rippleCircle.Size                 = UDim2.fromOffset(rippleStartSize, rippleStartSize)
    rippleCircle.Position             = UDim2.fromOffset(
        relativeX - (rippleStartSize / 2),
        relativeY - (rippleStartSize / 2)
    )
    rippleCircle.Parent               = self.ButtonFrame
    VoidUI.Utility.ApplyCornerRadius(rippleCircle, rippleStartSize / 2)

    -- Animate expansion and fade
    local expandTween = TweenService:Create(rippleCircle, VoidUI.TweenConfig.Ripple, {
        Size     = UDim2.fromOffset(rippleMaxSize, rippleMaxSize),
        Position = UDim2.fromOffset(
            relativeX - (rippleMaxSize / 2),
            relativeY - (rippleMaxSize / 2)
        ),
        BackgroundTransparency = 1,
    })

    expandTween:Play()

    -- Clean up the ripple frame after animation completes
    expandTween.Completed:Connect(function()
        VoidUI.Utility.SafeDestroy(rippleCircle)
    end)
end

--[[
    ButtonComponent:SetDisabled(isDisabled)
    Enables or disables this button at runtime.
--]]
function ButtonComponent:SetDisabled(isDisabled)
    self.IsDisabled = isDisabled

    local targetBackground = isDisabled
        and VoidUI.Theme.ElementDisabled
        or  VoidUI.Theme.ElementBackground

    VoidUI.Utility.CreateTween(
        self.ButtonFrame,
        { BackgroundColor3 = targetBackground },
        VoidUI.TweenConfig.Fast
    )
end

-- ============================================================
-- [SECTION 15] TOGGLE COMPONENT
-- Custom animated switch with TweenService-driven thumb
-- movement, track color change, and state callbacks.
-- ============================================================

ToggleComponent = {}
ToggleComponent.__index = ToggleComponent

--[[
    ToggleComponent.new(section, toggleConfig)
    toggleConfig fields:
        Name        : string   (Display label)
        Description : string   (Optional hint text)
        Default     : bool     (Initial state, default false)
        Callback    : function (Called with new bool value on change)
        Flag        : string   (Optional flag key for value retrieval)
--]]
function ToggleComponent.new(parentSection, toggleConfig)
    local self = setmetatable({}, ToggleComponent)

    self.Section    = parentSection
    self.Config     = toggleConfig or {}
    self.Value      = self.Config.Default or false
    self.IsDisabled = self.Config.Disabled or false

    local displayName   = self.Config.Name        or "Toggle"
    local displayDesc   = self.Config.Description or ""
    local callbackFn    = self.Config.Callback     or function() end

    -- ---- Row frame ----

    local rowFrame, labelFrame, controlFrame = ComponentBase._BuildRowFrame(
        parentSection, "Toggle_" .. displayName, 42
    )
    self.RowFrame = rowFrame

    ComponentBase._BuildComponentLabel(labelFrame, displayName, displayDesc)

    -- ---- Switch geometry ----
    -- Track: rounded pill shape
    -- Thumb: circle that slides left/right

    local trackWidth    = 46
    local trackHeight   = 24
    local thumbSize     = 18
    local thumbPadding  = 3

    -- Track background frame
    self.TrackFrame = VoidUI.Utility.CreateFrame(
        self.Value and VoidUI.Theme.ToggleTrackEnabled or VoidUI.Theme.ToggleDisabled,
        UDim2.fromOffset(trackWidth, trackHeight),
        UDim2.new(1, -(trackWidth), 0.5, -(trackHeight / 2)),
        "ToggleTrack"
    )
    self.TrackFrame.ZIndex  = 16
    self.TrackFrame.Parent  = controlFrame
    VoidUI.Utility.ApplyCornerRadius(self.TrackFrame, trackHeight / 2)
    VoidUI.Utility.ApplyStroke(self.TrackFrame, VoidUI.Theme.BorderPrimary, 1)

    -- Thumb circle frame
    local thumbOffsetOn  = trackWidth  - thumbSize - thumbPadding
    local thumbOffsetOff = thumbPadding

    self.ThumbFrame = VoidUI.Utility.CreateFrame(
        self.Value and VoidUI.Theme.ToggleEnabled or VoidUI.Theme.TextTertiary,
        UDim2.fromOffset(thumbSize, thumbSize),
        UDim2.fromOffset(
            self.Value and thumbOffsetOn or thumbOffsetOff,
            thumbPadding
        ),
        "ToggleThumb"
    )
    self.ThumbFrame.ZIndex  = 17
    self.ThumbFrame.Parent  = self.TrackFrame
    VoidUI.Utility.ApplyCornerRadius(self.ThumbFrame, thumbSize / 2)

    -- ---- Click interaction on entire row ----

    -- Make the row clickable
    self.RowFrame.Active = true

    self.RowFrame.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if self.IsDisabled then return end

        self:SetValue(not self.Value)
    end)

    -- Row hover highlight
    self.RowFrame.MouseEnter:Connect(function()
        if self.IsDisabled then return end
        VoidUI.Utility.CreateTween(
            self.RowFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementHover },
            VoidUI.TweenConfig.Fast
        )
    end)

    self.RowFrame.MouseLeave:Connect(function()
        VoidUI.Utility.CreateTween(
            self.RowFrame,
            { BackgroundColor3 = VoidUI.Theme.ElementBackground },
            VoidUI.TweenConfig.Fast
        )
    end)

    return self
end

--[[
    ToggleComponent:SetValue(newBooleanValue)
    Programmatically sets the toggle state and fires the callback.
--]]
function ToggleComponent:SetValue(newValue)
    self.Value = newValue

    local trackWidth    = 46
    local trackHeight   = 24
    local thumbSize     = 18
    local thumbPadding  = 3

    local thumbOffsetOn  = trackWidth  - thumbSize - thumbPadding
    local thumbOffsetOff = thumbPadding

    if newValue then
        -- Animate thumb to ON position
        VoidUI.Utility.CreateTween(
            self.ThumbFrame,
            {
                Position         = UDim2.fromOffset(thumbOffsetOn, thumbPadding),
                BackgroundColor3 = VoidUI.Theme.ToggleEnabled,
            },
            VoidUI.TweenConfig.Fast
        )

        -- Animate track to ON color
        VoidUI.Utility.CreateTween(
            self.TrackFrame,
            { BackgroundColor3 = VoidUI.Theme.ToggleTrackEnabled },
            VoidUI.TweenConfig.Fast
        )
    else
        -- Animate thumb to OFF position
        VoidUI.Utility.CreateTween(
            self.ThumbFrame,
            {
                Position         = UDim2.fromOffset(thumbOffsetOff, thumbPadding),
                BackgroundColor3 = VoidUI.Theme.TextTertiary,
            },
            VoidUI.TweenConfig.Fast
        )

        -- Animate track to OFF color
        VoidUI.Utility.CreateTween(
            self.TrackFrame,
            { BackgroundColor3 = VoidUI.Theme.ToggleDisabled },
            VoidUI.TweenConfig.Fast
        )
    end

    -- Fire the user callback on a separate thread
    task.spawn(function()
        local callbackFn = self.Config.Callback or function() end
        local success, err = pcall(callbackFn, self.Value)
        if not success then
            warn("[VoidUI] Toggle callback error: " .. tostring(err))
        end
    end)
end

--[[
    ToggleComponent:GetValue()
    Returns the current boolean state of the toggle.
--]]
function ToggleComponent:GetValue()
    return self.Value
end

-- ============================================================
-- [SECTION 16] SLIDER COMPONENT
-- Precision numeric slider with:
--   - Drag-to-set value
--   - Click-to-set value on track
--   - Manual text input mode (click the value label)
--   - Live percentage calculation
--   - Min/Max/Step constraints
--   - TweenService fill animation
-- ============================================================

SliderComponent = {}
SliderComponent.__index = SliderComponent

--[[
    SliderComponent.new(section, sliderConfig)
    sliderConfig fields:
        Name        : string   (Display label)
        Description : string   (Optional hint)
        Min         : number   (Minimum value, default 0)
        Max         : number   (Maximum value, default 100)
        Default     : number   (Starting value, default Min)
        Step        : number   (Increment step, default 1)
        Suffix      : string   (Unit suffix e.g. "%", "ms", "px")
        Callback    : function (Called with new number value on change)
--]]
function SliderComponent.new(parentSection, sliderConfig)
    local self = setmetatable({}, SliderComponent)

    self.Section    = parentSection
    self.Config     = sliderConfig or {}

    -- Numeric constraints
    self.MinValue   = self.Config.Min     or 0
    self.MaxValue   = self.Config.Max     or 100
    self.StepValue  = self.Config.Step    or 1
    self.Value      = self.Config.Default or self.MinValue
    self.Suffix     = self.Config.Suffix  or ""

    -- Clamp initial value to valid range
    self.Value = VoidUI.Utility.Clamp(self.Value, self.MinValue, self.MaxValue)

    -- Interaction state
    self.IsDragging         = false
    self.IsEditingText      = false

    local displayName   = self.Config.Name        or "Slider"
    local displayDesc   = self.Config.Description or ""
    local callbackFn    = self.Config.Callback     or function() end

    -- ---- Outer row frame (taller to accommodate track) ----

    local rowFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.ElementBackground,
        UDim2.new(1, 0, 0, 52),
        UDim2.fromOffset(0, 0),
        "SliderRow_" .. displayName
    )
    rowFrame.ZIndex         = 15
    rowFrame.ClipsDescendants = false
    rowFrame.LayoutOrder    = #parentSection.Components + 1
    rowFrame.Parent         = parentSection.ComponentContainer
    self.RowFrame           = rowFrame

    VoidUI.Utility.ApplyCornerRadius(rowFrame, 6)
    VoidUI.Utility.ApplyStroke(rowFrame, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(rowFrame, 6, 6, 14, 14)

    -- ---- Top area: label (left) + value display (right) ----

    local topRegion = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 20),
        UDim2.fromOffset(0, 0),
        "SliderTopRegion"
    )
    topRegion.BackgroundTransparency = 1
    topRegion.ZIndex  = 16
    topRegion.Parent  = rowFrame

    -- Component name label
    local nameLabel = VoidUI.Utility.CreateLabel(
        displayName, 13, VoidUI.Theme.TextPrimary, Enum.Font.GothamMedium, false
    )
    nameLabel.Size          = UDim2.new(0.65, 0, 1, 0)
    nameLabel.Position      = UDim2.fromOffset(0, 0)
    nameLabel.ZIndex        = 16
    nameLabel.Parent        = topRegion

    -- Value display / text input box
    self.ValueDisplay = Instance.new("TextBox")
    self.ValueDisplay.Name              = "ValueDisplay"
    self.ValueDisplay.BackgroundColor3  = VoidUI.Theme.ElementActive
    self.ValueDisplay.BackgroundTransparency = 1
    self.ValueDisplay.TextColor3        = VoidUI.Theme.TextSecondary
    self.ValueDisplay.Font              = Enum.Font.GothamMedium
    self.ValueDisplay.TextSize          = 12
    self.ValueDisplay.Text              = tostring(self.Value) .. self.Suffix
    self.ValueDisplay.Size              = UDim2.new(0.35, 0, 1, 0)
    self.ValueDisplay.Position          = UDim2.new(0.65, 0, 0, 0)
    self.ValueDisplay.TextXAlignment    = Enum.TextXAlignment.Right
    self.ValueDisplay.ZIndex            = 16
    self.ValueDisplay.BorderSizePixel   = 0
    self.ValueDisplay.ClearTextOnFocus  = true
    self.ValueDisplay.PlaceholderText   = tostring(self.Value)
    self.ValueDisplay.PlaceholderColor3 = VoidUI.Theme.TextPlaceholder
    self.ValueDisplay.Parent            = topRegion

    -- ---- Track area (lower portion of row) ----

    local trackContainerHeight = 14

    self.TrackContainer = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.SliderTrack,
        UDim2.new(1, 0, 0, 6),
        UDim2.new(0, 0, 1, -18),
        "SliderTrackContainer"
    )
    self.TrackContainer.ZIndex          = 16
    self.TrackContainer.ClipsDescendants = false
    self.TrackContainer.Parent          = rowFrame
    VoidUI.Utility.ApplyCornerRadius(self.TrackContainer, 4)

    -- Fill portion of the track (left side, colored white)
    self.TrackFill = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.SliderFill,
        UDim2.new(0, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "SliderTrackFill"
    )
    self.TrackFill.ZIndex  = 17
    self.TrackFill.Parent  = self.TrackContainer
    VoidUI.Utility.ApplyCornerRadius(self.TrackFill, 4)

    -- Thumb handle (sits at the fill/track boundary)
    local thumbDiameter = 14

    self.ThumbHandle = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.SliderThumb,
        UDim2.fromOffset(thumbDiameter, thumbDiameter),
        UDim2.fromOffset(0, -(thumbDiameter / 2 - 3)),
        "SliderThumb"
    )
    self.ThumbHandle.ZIndex  = 18
    self.ThumbHandle.Parent  = self.TrackContainer
    VoidUI.Utility.ApplyCornerRadius(self.ThumbHandle, thumbDiameter / 2)
    VoidUI.Utility.ApplyStroke(self.ThumbHandle, VoidUI.Theme.BorderSecondary, 1)

    -- ---- Initialize visual state to match default value ----
    self:_UpdateVisuals(self.Value, false)  -- false = no tween on init

    -- ---- Drag events on the track ----

    local function HandleTrackInput(inputPosition)
        local trackAbsPos  = self.TrackContainer.AbsolutePosition
        local trackAbsSize = self.TrackContainer.AbsoluteSize

        -- Normalize mouse X position within track [0, 1]
        local normalizedPosition = VoidUI.Utility.Clamp(
            (inputPosition.X - trackAbsPos.X) / trackAbsSize.X,
            0, 1
        )

        -- Map normalized to value range
        local rawValue = VoidUI.Utility.Lerp(self.MinValue, self.MaxValue, normalizedPosition)

        -- Quantize to step
        local quantizedValue = math.floor((rawValue - self.MinValue) / self.StepValue + 0.5)
            * self.StepValue + self.MinValue

        -- Clamp to valid range
        local finalValue = VoidUI.Utility.Clamp(
            VoidUI.Utility.RoundToDecimal(quantizedValue, 4),
            self.MinValue, self.MaxValue
        )

        self:SetValue(finalValue)
    end

    -- Begin drag on track click
    self.TrackContainer.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = true
            HandleTrackInput(inputObject.Position)
        end
    end)

    -- Also begin drag on thumb click
    self.ThumbHandle.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = true
        end
    end)

    -- Track global mouse movement while dragging
    local dragMoveConnection = UserInputService.InputChanged:Connect(function(inputObject)
        if not self.IsDragging then return end
        if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
            HandleTrackInput(inputObject.Position)
        end
    end)

    -- End drag on mouse release
    local dragEndConnection = UserInputService.InputEnded:Connect(function(inputObject)
        if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            self.IsDragging = false
        end
    end)

    -- ---- Text input for manual value entry ----

    self.ValueDisplay.FocusLost:Connect(function(enterPressed)
        local inputText = self.ValueDisplay.Text

        -- Strip suffix if user didn't type it
        inputText = inputText:gsub(self.Suffix, "")

        local parsedNumber = tonumber(inputText)

        if parsedNumber then
            local clampedValue = VoidUI.Utility.Clamp(parsedNumber, self.MinValue, self.MaxValue)
            self:SetValue(clampedValue)
        else
            -- Invalid input: restore previous value display
            self.ValueDisplay.Text = tostring(self.Value) .. self.Suffix
        end
    end)

    -- Thumb hover animation
    self.ThumbHandle.MouseEnter:Connect(function()
        VoidUI.Utility.CreateTween(
            self.ThumbHandle,
            { Size = UDim2.fromOffset(thumbDiameter + 2, thumbDiameter + 2) },
            VoidUI.TweenConfig.Fast
        )
    end)

    self.ThumbHandle.MouseLeave:Connect(function()
        if not self.IsDragging then
            VoidUI.Utility.CreateTween(
                self.ThumbHandle,
                { Size = UDim2.fromOffset(thumbDiameter, thumbDiameter) },
                VoidUI.TweenConfig.Fast
            )
        end
    end)

    return self
end

--[[
    SliderComponent:_UpdateVisuals(value, animateFill)
    Internally updates the fill width, thumb position, and
    value display text. Uses tweening when animateFill = true.
--]]
function SliderComponent:_UpdateVisuals(currentValue, shouldAnimate)
    -- Calculate fill fraction [0, 1]
    local totalRange     = self.MaxValue - self.MinValue
    local fillFraction   = VoidUI.Utility.Clamp(
        (currentValue - self.MinValue) / totalRange, 0, 1
    )

    -- Update fill width
    local fillUDim2 = UDim2.new(fillFraction, 0, 1, 0)

    if shouldAnimate then
        VoidUI.Utility.CreateTween(
            self.TrackFill,
            { Size = fillUDim2 },
            VoidUI.TweenConfig.Fast
        )
    else
        self.TrackFill.Size = fillUDim2
    end

    -- Update thumb position X (center of thumb at fill boundary)
    local thumbDiameter  = 14
    local trackWidth     = self.TrackContainer.AbsoluteSize.X

    local thumbX = fillFraction * trackWidth - (thumbDiameter / 2)
    thumbX = VoidUI.Utility.Clamp(thumbX, -(thumbDiameter / 2), trackWidth - (thumbDiameter / 2))

    if shouldAnimate then
        VoidUI.Utility.CreateTween(
            self.ThumbHandle,
            { Position = UDim2.fromOffset(thumbX, -(thumbDiameter / 2 - 3)) },
            VoidUI.TweenConfig.Fast
        )
    else
        self.ThumbHandle.Position = UDim2.fromOffset(thumbX, -(thumbDiameter / 2 - 3))
    end

    -- Update value display text
    self.ValueDisplay.Text = tostring(currentValue) .. self.Suffix
end

--[[
    SliderComponent:SetValue(newValue)
    Programmatically sets the slider to a new value,
    updates visuals, and fires the callback.
--]]
function SliderComponent:SetValue(newValue)
    -- Clamp and quantize
    local clampedValue = VoidUI.Utility.Clamp(newValue, self.MinValue, self.MaxValue)

    -- Only update if value actually changed
    if clampedValue == self.Value then return end

    self.Value = clampedValue

    -- Update visuals with animation
    self:_UpdateVisuals(self.Value, true)

    -- Fire callback on separate thread
    task.spawn(function()
        local callbackFn = self.Config.Callback or function() end
        local success, err = pcall(callbackFn, self.Value)
        if not success then
            warn("[VoidUI] Slider callback error: " .. tostring(err))
        end
    end)
end

--[[
    SliderComponent:GetValue()
    Returns the current numeric value of the slider.
--]]
function SliderComponent:GetValue()
    return self.Value
end

--[[
    SliderComponent:GetPercentage()
    Returns the current value as a percentage of the full range [0, 100].
--]]
function SliderComponent:GetPercentage()
    local totalRange = self.MaxValue - self.MinValue
    return VoidUI.Utility.RoundToDecimal(
        ((self.Value - self.MinValue) / totalRange) * 100, 1
    )
end

-- ============================================================
-- [SECTION 17] DROPDOWN COMPONENT
-- Searchable dropdown with a dynamic scrolling list.
-- Supports single-select. Opens/closes with smooth animations.
-- Handles click-outside-to-close.
-- ============================================================

DropdownComponent = {}
DropdownComponent.__index = DropdownComponent

--[[
    DropdownComponent.new(section, dropdownConfig)
    dropdownConfig fields:
        Name        : string   (Display label)
        Description : string   (Optional hint text)
        Options     : table    (Array of string option values)
        Default     : string   (Initially selected option)
        Placeholder : string   (Text when nothing selected)
        Callback    : function (Called with selected string value)
        Searchable  : bool     (If true, enables search box, default true)
--]]
function DropdownComponent.new(parentSection, dropdownConfig)
    local self = setmetatable({}, DropdownComponent)

    self.Section        = parentSection
    self.Config         = dropdownConfig or {}
    self.Options        = self.Config.Options     or {}
    self.Value          = self.Config.Default     or nil
    self.Placeholder    = self.Config.Placeholder or "Select an option..."
    self.IsOpen         = false
    self.IsSearchable   = (self.Config.Searchable ~= false)  -- Default true
    self.SearchQuery    = ""
    self.FilteredOptions = {}

    local displayName   = self.Config.Name        or "Dropdown"
    local displayDesc   = self.Config.Description or ""

    -- Copy all options into the filtered options initially
    for _, option in ipairs(self.Options) do
        table.insert(self.FilteredOptions, option)
    end

    -- ---- Main row frame ----

    self.RowFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.ElementBackground,
        UDim2.new(1, 0, 0, 42),
        UDim2.fromOffset(0, 0),
        "DropdownRow_" .. displayName
    )
    self.RowFrame.ZIndex            = 15
    self.RowFrame.ClipsDescendants  = false
    self.RowFrame.LayoutOrder       = #parentSection.Components + 1
    self.RowFrame.Parent            = parentSection.ComponentContainer

    VoidUI.Utility.ApplyCornerRadius(self.RowFrame, 6)
    VoidUI.Utility.ApplyStroke(self.RowFrame, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(self.RowFrame, 0, 0, 14, 14)

    -- Label on the left
    local labelRegion = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.45, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "LabelRegion"
    )
    labelRegion.BackgroundTransparency = 1
    labelRegion.ZIndex = 16
    labelRegion.Parent = self.RowFrame
    ComponentBase._BuildComponentLabel(labelRegion, displayName, displayDesc)

    -- ---- Dropdown header button (right side) ----

    self.HeaderButton = VoidUI.Utility.CreateButton(
        self.Value or self.Placeholder,
        12,
        VoidUI.Theme.BackgroundTertiary,
        self.Value and VoidUI.Theme.TextPrimary or VoidUI.Theme.TextPlaceholder,
        "DropdownHeader"
    )
    self.HeaderButton.Size              = UDim2.new(0.55, 0, 0, 28)
    self.HeaderButton.Position          = UDim2.new(0.45, 0, 0.5, -14)
    self.HeaderButton.TextXAlignment    = Enum.TextXAlignment.Left
    self.HeaderButton.ZIndex            = 16
    self.HeaderButton.ClipsDescendants  = false
    self.HeaderButton.Parent            = self.RowFrame

    VoidUI.Utility.ApplyCornerRadius(self.HeaderButton, 6)
    VoidUI.Utility.ApplyStroke(self.HeaderButton, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(self.HeaderButton, 0, 0, 10, 30)

    -- Chevron indicator (▾ or ▴ depending on open state)
    self.ChevronLabel = VoidUI.Utility.CreateLabel(
        "▾", 12, VoidUI.Theme.TextTertiary, Enum.Font.GothamBold, true
    )
    self.ChevronLabel.Name          = "Chevron"
    self.ChevronLabel.Position      = UDim2.new(1, -22, 0.5, -8)
    self.ChevronLabel.Size          = UDim2.fromOffset(16, 16)
    self.ChevronLabel.AutomaticSize = Enum.AutomaticSize.None
    self.ChevronLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.ChevronLabel.ZIndex        = 17
    self.ChevronLabel.Parent        = self.HeaderButton

    -- ---- Dropdown panel (initially hidden) ----
    -- Floats below the row frame with higher ZIndex

    local panelMaxVisibleItems = 5
    local itemHeight           = 32
    local searchBoxHeight      = self.IsSearchable and 32 or 0
    local panelPadding         = 8
    local panelWidth           = self.RowFrame.AbsoluteSize.X > 0
        and self.RowFrame.AbsoluteSize.X
        or  380

    self.DropdownPanel = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.DropdownBackground,
        UDim2.fromOffset(panelWidth, 0),
        UDim2.new(0, 0, 1, 4),
        "DropdownPanel"
    )
    self.DropdownPanel.ZIndex           = 50
    self.DropdownPanel.Visible          = false
    self.DropdownPanel.ClipsDescendants = true
    self.DropdownPanel.Size             = UDim2.fromOffset(panelWidth, 0)  -- Starts at 0 height
    self.DropdownPanel.Parent           = self.RowFrame

    VoidUI.Utility.ApplyCornerRadius(self.DropdownPanel, 8)
    VoidUI.Utility.ApplyStroke(self.DropdownPanel, VoidUI.Theme.BorderSecondary, 1)

    -- ---- Search box (inside panel) ----

    if self.IsSearchable then
        self.SearchBox = Instance.new("TextBox")
        self.SearchBox.Name                  = "SearchBox"
        self.SearchBox.BackgroundColor3      = VoidUI.Theme.BackgroundQuaternary
        self.SearchBox.BackgroundTransparency = 0
        self.SearchBox.TextColor3            = VoidUI.Theme.TextPrimary
        self.SearchBox.PlaceholderText       = "Search..."
        self.SearchBox.PlaceholderColor3     = VoidUI.Theme.TextPlaceholder
        self.SearchBox.Font                  = Enum.Font.Gotham
        self.SearchBox.TextSize              = 12
        self.SearchBox.Text                  = ""
        self.SearchBox.Size                  = UDim2.new(1, -16, 0, searchBoxHeight - 8)
        self.SearchBox.Position              = UDim2.fromOffset(8, 4)
        self.SearchBox.BorderSizePixel       = 0
        self.SearchBox.ZIndex                = 51
        self.SearchBox.ClearTextOnFocus      = false
        self.SearchBox.Parent                = self.DropdownPanel

        VoidUI.Utility.ApplyCornerRadius(self.SearchBox, 5)
        VoidUI.Utility.ApplyStroke(self.SearchBox, VoidUI.Theme.BorderPrimary, 1)
        VoidUI.Utility.ApplyPadding(self.SearchBox, 0, 0, 8, 8)

        -- Update filter on text change
        self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            self.SearchQuery = self.SearchBox.Text
            self:_RefreshOptionList()
        end)
    end

    -- ---- Scrolling frame for option items ----

    local listMaxHeight = panelMaxVisibleItems * itemHeight

    self.OptionScrollFrame = Instance.new("ScrollingFrame")
    self.OptionScrollFrame.Name                    = "OptionScrollFrame"
    self.OptionScrollFrame.BackgroundTransparency  = 1
    self.OptionScrollFrame.BorderSizePixel         = 0
    self.OptionScrollFrame.Size                    = UDim2.new(1, 0, 1, -(searchBoxHeight))
    self.OptionScrollFrame.Position                = UDim2.fromOffset(0, searchBoxHeight)
    self.OptionScrollFrame.CanvasSize              = UDim2.fromOffset(0, 0)
    self.OptionScrollFrame.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    self.OptionScrollFrame.ScrollBarThickness      = 3
    self.OptionScrollFrame.ScrollBarImageColor3    = VoidUI.Theme.ScrollbarThumb
    self.OptionScrollFrame.ScrollingDirection      = Enum.ScrollingDirection.Y
    self.OptionScrollFrame.ZIndex                  = 51
    self.OptionScrollFrame.ClipsDescendants        = true
    self.OptionScrollFrame.Parent                  = self.DropdownPanel

    VoidUI.Utility.ApplyPadding(self.OptionScrollFrame, 4, 4, 6, 6)

    self.OptionListLayout = VoidUI.Utility.ApplyListLayout(
        self.OptionScrollFrame,
        Enum.FillDirection.Vertical,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Top,
        Enum.SortOrder.LayoutOrder,
        2
    )

    -- ---- Initial option list render ----
    self:_RefreshOptionList()

    -- ---- Header button click: toggle open/close ----

    self.HeaderButton.MouseButton1Click:Connect(function()
        if self.IsOpen then
            self:Close()
        else
            self:Open()
        end
    end)

    -- ---- Header hover ----

    self.HeaderButton.MouseEnter:Connect(function()
        VoidUI.Utility.CreateTween(
            self.HeaderButton,
            { BackgroundColor3 = VoidUI.Theme.ElementHover },
            VoidUI.TweenConfig.Fast
        )
    end)

    self.HeaderButton.MouseLeave:Connect(function()
        VoidUI.Utility.CreateTween(
            self.HeaderButton,
            { BackgroundColor3 = VoidUI.Theme.BackgroundTertiary },
            VoidUI.TweenConfig.Fast
        )
    end)

    -- ---- Click-outside-to-close ----
    self._ClickOutsideConnection = UserInputService.InputBegan:Connect(
        function(inputObject, gameProcessed)
            if not self.IsOpen then return end

            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos   = UserInputService:GetMouseLocation()
                local panelPos   = self.DropdownPanel.AbsolutePosition
                local panelSize  = self.DropdownPanel.AbsoluteSize
                local rowPos     = self.RowFrame.AbsolutePosition
                local rowSize    = self.RowFrame.AbsoluteSize

                -- Check if click was outside both the row and the panel
                local insideRow = mousePos.X >= rowPos.X
                    and mousePos.X <= rowPos.X + rowSize.X
                    and mousePos.Y >= rowPos.Y
                    and mousePos.Y <= rowPos.Y + rowSize.Y

                local insidePanel = mousePos.X >= panelPos.X
                    and mousePos.X <= panelPos.X + panelSize.X
                    and mousePos.Y >= panelPos.Y
                    and mousePos.Y <= panelPos.Y + panelSize.Y

                if not insideRow and not insidePanel then
                    self:Close()
                end
            end
        end
    )

    return self
end

--[[
    DropdownComponent:_RefreshOptionList()
    Rebuilds the option item buttons based on the current
    search filter. Called on open and on search query change.
--]]
function DropdownComponent:_RefreshOptionList()
    -- Clear existing option frames
    for _, child in ipairs(self.OptionScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Filter options by search query
    self.FilteredOptions = {}
    local lowerQuery = self.SearchQuery:lower()

    for _, option in ipairs(self.Options) do
        if lowerQuery == "" or option:lower():find(lowerQuery, 1, true) then
            table.insert(self.FilteredOptions, option)
        end
    end

    -- Build item buttons for each filtered option
    for filterIndex, optionValue in ipairs(self.FilteredOptions) do
        local isSelected = (optionValue == self.Value)

        local itemButton = VoidUI.Utility.CreateButton(
            optionValue,
            12,
            isSelected and VoidUI.Theme.DropdownItemSelected or Color3.fromRGB(0, 0, 0),
            isSelected and VoidUI.Theme.TextPrimary or VoidUI.Theme.TextSecondary,
            "DropdownItem_" .. filterIndex
        )
        itemButton.BackgroundTransparency = isSelected and 0 or 1
        itemButton.Size                   = UDim2.new(1, 0, 0, 30)
        itemButton.TextXAlignment         = Enum.TextXAlignment.Left
        itemButton.ZIndex                 = 52
        itemButton.LayoutOrder            = filterIndex
        itemButton.Parent                 = self.OptionScrollFrame

        VoidUI.Utility.ApplyCornerRadius(itemButton, 5)
        VoidUI.Utility.ApplyPadding(itemButton, 0, 0, 10, 10)

        -- Checkmark for selected item
        if isSelected then
            local checkMark = VoidUI.Utility.CreateLabel(
                "✓", 11, VoidUI.Theme.TextPrimary, Enum.Font.GothamBold, true
            )
            checkMark.Position         = UDim2.new(1, -20, 0.5, -8)
            checkMark.Size             = UDim2.fromOffset(16, 16)
            checkMark.AutomaticSize    = Enum.AutomaticSize.None
            checkMark.TextXAlignment   = Enum.TextXAlignment.Center
            checkMark.ZIndex           = 53
            checkMark.Parent           = itemButton
        end

        -- Hover state
        itemButton.MouseEnter:Connect(function()
            if not isSelected then
                VoidUI.Utility.CreateTween(
                    itemButton,
                    {
                        BackgroundTransparency = 0,
                        BackgroundColor3       = VoidUI.Theme.DropdownItemHover,
                        TextColor3             = VoidUI.Theme.TextPrimary,
                    },
                    VoidUI.TweenConfig.Fast
                )
            end
        end)

        itemButton.MouseLeave:Connect(function()
            if not isSelected then
                VoidUI.Utility.CreateTween(
                    itemButton,
                    {
                        BackgroundTransparency = 1,
                        TextColor3             = VoidUI.Theme.TextSecondary,
                    },
                    VoidUI.TweenConfig.Fast
                )
            end
        end)

        -- Selection click
        local capturedOption = optionValue
        itemButton.MouseButton1Click:Connect(function()
            self:SetValue(capturedOption)
            self:Close()
        end)
    end
end

--[[
    DropdownComponent:Open()
    Animates the dropdown panel opening downward.
--]]
function DropdownComponent:Open()
    if self.IsOpen then return end
    self.IsOpen = true

    -- Calculate target panel height based on item count
    local searchBoxHeight     = self.IsSearchable and 36 or 0
    local itemHeight          = 32
    local maxVisibleItems     = 5
    local visibleItemCount    = math.min(#self.FilteredOptions, maxVisibleItems)
    local listContentHeight   = visibleItemCount * (itemHeight + 2)
    local targetPanelHeight   = searchBoxHeight + listContentHeight + 16

    -- Get panel width from row frame
    local panelWidth = self.RowFrame.AbsoluteSize.X

    self.DropdownPanel.Size    = UDim2.fromOffset(panelWidth, 0)
    self.DropdownPanel.Visible = true

    -- Animate height from 0 to target
    VoidUI.Utility.CreateTween(
        self.DropdownPanel,
        { Size = UDim2.fromOffset(panelWidth, targetPanelHeight) },
        VoidUI.TweenConfig.Normal
    )

    -- Rotate chevron upward
    VoidUI.Utility.CreateTween(
        self.ChevronLabel,
        { Rotation = 180 },
        VoidUI.TweenConfig.Normal
    )

    -- Focus search box if searchable
    if self.IsSearchable and self.SearchBox then
        task.spawn(function()
            task.wait(0.15)
            self.SearchBox:CaptureFocus()
        end)
    end
end

--[[
    DropdownComponent:Close()
    Animates the dropdown panel closing upward.
--]]
function DropdownComponent:Close()
    if not self.IsOpen then return end
    self.IsOpen = false

    local panelWidth = self.RowFrame.AbsoluteSize.X

    -- Animate height to 0
    local closeTween = VoidUI.Utility.CreateTween(
        self.DropdownPanel,
        { Size = UDim2.fromOffset(panelWidth, 0) },
        VoidUI.TweenConfig.Fast
    )

    -- Hide panel after animation
    closeTween.Completed:Connect(function()
        self.DropdownPanel.Visible = false

        -- Clear search query on close
        self.SearchQuery = ""
        if self.SearchBox then
            self.SearchBox.Text = ""
        end
    end)

    -- Rotate chevron back down
    VoidUI.Utility.CreateTween(
        self.ChevronLabel,
        { Rotation = 0 },
        VoidUI.TweenConfig.Fast
    )
end

--[[
    DropdownComponent:SetValue(newOptionValue)
    Selects a specific option by value, updates display, fires callback.
--]]
function DropdownComponent:SetValue(newOptionValue)
    self.Value = newOptionValue

    -- Update header button text and color
    self.HeaderButton.Text       = newOptionValue
    self.HeaderButton.TextColor3 = VoidUI.Theme.TextPrimary

    -- Refresh the option list to show new checkmark
    self:_RefreshOptionList()

    -- Fire callback
    task.spawn(function()
        local callbackFn = self.Config.Callback or function() end
        local success, err = pcall(callbackFn, newOptionValue)
        if not success then
            warn("[VoidUI] Dropdown callback error: " .. tostring(err))
        end
    end)
end

--[[
    DropdownComponent:GetValue()
    Returns the currently selected option string, or nil.
--]]
function DropdownComponent:GetValue()
    return self.Value
end

--[[
    DropdownComponent:SetOptions(newOptionsTable)
    Replaces the options list at runtime and refreshes the display.
--]]
function DropdownComponent:SetOptions(newOptionsTable)
    self.Options = newOptionsTable
    self.Value = nil
    self.HeaderButton.Text       = self.Placeholder
    self.HeaderButton.TextColor3 = VoidUI.Theme.TextPlaceholder
    self:_RefreshOptionList()
end

-- ============================================================
-- [SECTION 18] KEYBIND COMPONENT
-- Input-capture system for remapping keybinds.
-- Displays current key, enters "listening" mode on click,
-- captures the next key press, and updates display.
-- ============================================================

KeybindComponent = {}
KeybindComponent.__index = KeybindComponent

--[[
    KeybindComponent.new(section, keybindConfig)
    keybindConfig fields:
        Name        : string           (Display label)
        Description : string           (Optional hint)
        Default     : Enum.KeyCode     (Initial keybind, default None)
        Callback    : function         (Called with new KeyCode on change)
        BlackList   : table            (KeyCodes that cannot be bound)
--]]
function KeybindComponent.new(parentSection, keybindConfig)
    local self = setmetatable({}, KeybindComponent)

    self.Section        = parentSection
    self.Config         = keybindConfig or {}
    self.Value          = self.Config.Default or Enum.KeyCode.Unknown
    self.IsListening    = false

    -- Default blacklisted keys (system keys that shouldn't be remapped)
    self.BlackList = self.Config.BlackList or {
        Enum.KeyCode.Unknown,
        Enum.KeyCode.LeftControl,
        Enum.KeyCode.RightControl,
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift,
        Enum.KeyCode.LeftAlt,
        Enum.KeyCode.RightAlt,
        Enum.KeyCode.LeftMeta,
        Enum.KeyCode.RightMeta,
        Enum.KeyCode.Tab,
        Enum.KeyCode.Escape,
    }

    local displayName = self.Config.Name        or "Keybind"
    local displayDesc = self.Config.Description or ""

    -- ---- Row frame ----

    local rowFrame, labelFrame, controlFrame = ComponentBase._BuildRowFrame(
        parentSection, "Keybind_" .. displayName, 42
    )
    self.RowFrame = rowFrame

    ComponentBase._BuildComponentLabel(labelFrame, displayName, displayDesc)

    -- ---- Keybind display button ----

    local keyCodeName = self:_FormatKeyName(self.Value)

    self.KeybindButton = VoidUI.Utility.CreateButton(
        "[" .. keyCodeName .. "]",
        12,
        VoidUI.Theme.BackgroundTertiary,
        VoidUI.Theme.TextSecondary,
        "KeybindButton"
    )
    self.KeybindButton.Size          = UDim2.new(1, 0, 0, 26)
    self.KeybindButton.Position      = UDim2.new(0, 0, 0.5, -13)
    self.KeybindButton.ZIndex        = 16
    self.KeybindButton.Parent        = controlFrame

    VoidUI.Utility.ApplyCornerRadius(self.KeybindButton, 5)
    VoidUI.Utility.ApplyStroke(self.KeybindButton, VoidUI.Theme.BorderPrimary, 1)

    -- ---- Click to enter listening mode ----

    self.KeybindButton.MouseButton1Click:Connect(function()
        if self.IsListening then
            self:_ExitListeningMode()
        else
            self:_EnterListeningMode()
        end
    end)

    -- ---- Button hover ----

    self.KeybindButton.MouseEnter:Connect(function()
        if not self.IsListening then
            VoidUI.Utility.CreateTween(
                self.KeybindButton,
                { BackgroundColor3 = VoidUI.Theme.ElementHover },
                VoidUI.TweenConfig.Fast
            )
        end
    end)

    self.KeybindButton.MouseLeave:Connect(function()
        if not self.IsListening then
            VoidUI.Utility.CreateTween(
                self.KeybindButton,
                { BackgroundColor3 = VoidUI.Theme.BackgroundTertiary },
                VoidUI.TweenConfig.Fast
            )
        end
    end)

    return self
end

--[[
    KeybindComponent:_EnterListeningMode()
    Visual transition into listening state. Starts capturing
    the next valid key press.
--]]
function KeybindComponent:_EnterListeningMode()
    self.IsListening = true

    -- Animate button to listening state
    VoidUI.Utility.CreateTween(
        self.KeybindButton,
        { BackgroundColor3 = VoidUI.Theme.ElementActive },
        VoidUI.TweenConfig.Fast
    )

    -- Update button text with pulsing indicator
    self.KeybindButton.Text = "[ Press a key... ]"
    self.KeybindButton.TextColor3 = VoidUI.Theme.TextPrimary

    -- Listen for the next valid key press
    self._ListenConnection = UserInputService.InputBegan:Connect(
        function(inputObject, gameProcessed)
            -- Only capture keyboard input
            if inputObject.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            local pressedKey = inputObject.KeyCode

            -- Check blacklist
            local isBlacklisted = false
            for _, blacklistedKey in ipairs(self.BlackList) do
                if pressedKey == blacklistedKey then
                    isBlacklisted = true
                    break
                end
            end

            if isBlacklisted then
                return
            end

            -- Valid key pressed: update value and exit listening
            self:SetValue(pressedKey)
            self:_ExitListeningMode()
        end
    )
end

--[[
    KeybindComponent:_ExitListeningMode()
    Restores the button to its normal display state and
    disconnects the key capture listener.
--]]
function KeybindComponent:_ExitListeningMode()
    self.IsListening = false

    -- Disconnect the listener
    if self._ListenConnection then
        self._ListenConnection:Disconnect()
        self._ListenConnection = nil
    end

    -- Restore button appearance
    VoidUI.Utility.CreateTween(
        self.KeybindButton,
        { BackgroundColor3 = VoidUI.Theme.BackgroundTertiary },
        VoidUI.TweenConfig.Fast
    )

    -- Update text to current value
    self.KeybindButton.Text = "[" .. self:_FormatKeyName(self.Value) .. "]"
    self.KeybindButton.TextColor3 = VoidUI.Theme.TextSecondary
end

--[[
    KeybindComponent:_FormatKeyName(keyCode)
    Converts a KeyCode enum to a human-readable short string.
    E.g. Enum.KeyCode.LeftBracket -> "["
--]]
function KeybindComponent:_FormatKeyName(keyCode)
    if keyCode == Enum.KeyCode.Unknown then
        return "None"
    end

    -- Map special keycodes to readable names
    local specialKeyNames = {
        [Enum.KeyCode.LeftBracket]      = "[",
        [Enum.KeyCode.RightBracket]     = "]",
        [Enum.KeyCode.BackSlash]        = "\\",
        [Enum.KeyCode.Semicolon]        = ";",
        [Enum.KeyCode.Quote]            = "'",
        [Enum.KeyCode.Comma]            = ",",
        [Enum.KeyCode.Period]           = ".",
        [Enum.KeyCode.Slash]            = "/",
        [Enum.KeyCode.Backquote]        = "`",
        [Enum.KeyCode.Minus]            = "-",
        [Enum.KeyCode.Equals]           = "=",
        [Enum.KeyCode.Space]            = "Space",
        [Enum.KeyCode.Return]           = "Enter",
        [Enum.KeyCode.BackSpace]        = "Backspace",
        [Enum.KeyCode.Delete]           = "Delete",
        [Enum.KeyCode.Insert]           = "Insert",
        [Enum.KeyCode.Home]             = "Home",
        [Enum.KeyCode.End]              = "End",
        [Enum.KeyCode.PageUp]           = "PgUp",
        [Enum.KeyCode.PageDown]         = "PgDn",
        [Enum.KeyCode.CapsLock]         = "Caps",
        [Enum.KeyCode.NumLock]          = "NumLk",
        [Enum.KeyCode.ScrollLock]       = "ScrLk",
        [Enum.KeyCode.LeftControl]      = "LCtrl",
        [Enum.KeyCode.RightControl]     = "RCtrl",
        [Enum.KeyCode.LeftShift]        = "LShift",
        [Enum.KeyCode.RightShift]       = "RShift",
        [Enum.KeyCode.LeftAlt]          = "LAlt",
        [Enum.KeyCode.RightAlt]         = "RAlt",
        [Enum.KeyCode.Up]               = "↑",
        [Enum.KeyCode.Down]             = "↓",
        [Enum.KeyCode.Left]             = "←",
        [Enum.KeyCode.Right]            = "→",
        [Enum.KeyCode.F1]               = "F1",
        [Enum.KeyCode.F2]               = "F2",
        [Enum.KeyCode.F3]               = "F3",
        [Enum.KeyCode.F4]               = "F4",
        [Enum.KeyCode.F5]               = "F5",
        [Enum.KeyCode.F6]               = "F6",
        [Enum.KeyCode.F7]               = "F7",
        [Enum.KeyCode.F8]               = "F8",
        [Enum.KeyCode.F9]               = "F9",
        [Enum.KeyCode.F10]              = "F10",
        [Enum.KeyCode.F11]              = "F11",
        [Enum.KeyCode.F12]              = "F12",
    }

    if specialKeyNames[keyCode] then
        return specialKeyNames[keyCode]
    end

    -- Default: use the KeyCode name and strip the "KeyCode." prefix
    local rawName = tostring(keyCode)
    return rawName:gsub("Enum%.KeyCode%.", "")
end

--[[
    KeybindComponent:SetValue(newKeyCode)
    Programmatically sets the keybind value and fires callback.
--]]
function KeybindComponent:SetValue(newKeyCode)
    self.Value = newKeyCode

    self.KeybindButton.Text = "[" .. self:_FormatKeyName(newKeyCode) .. "]"

    task.spawn(function()
        local callbackFn = self.Config.Callback or function() end
        local success, err = pcall(callbackFn, newKeyCode)
        if not success then
            warn("[VoidUI] Keybind callback error: " .. tostring(err))
        end
    end)
end

--[[
    KeybindComponent:GetValue()
    Returns the current KeyCode enum value.
--]]
function KeybindComponent:GetValue()
    return self.Value
end

-- ============================================================
-- [SECTION 19] COLOR PICKER COMPONENT
-- Monochromatic greyscale picker with 10 shades from
-- #000000 to #FFFFFF. Displays current color swatch.
-- Shows expanded palette on click with TweenService animation.
-- ============================================================

ColorPickerComponent = {}
ColorPickerComponent.__index = ColorPickerComponent

--[[
    ColorPickerComponent.new(section, colorPickerConfig)
    colorPickerConfig fields:
        Name        : string   (Display label)
        Description : string   (Optional hint)
        Default     : Color3   (Initial color, defaults to white)
        Callback    : function (Called with Color3 value on change)
--]]
function ColorPickerComponent.new(parentSection, colorPickerConfig)
    local self = setmetatable({}, ColorPickerComponent)

    self.Section        = parentSection
    self.Config         = colorPickerConfig or {}
    self.Value          = self.Config.Default or Color3.fromHex("FFFFFF")
    self.IsOpen         = false

    local displayName = self.Config.Name        or "Color"
    local displayDesc = self.Config.Description or ""

    -- ---- Row frame ----

    self.RowFrame = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.ElementBackground,
        UDim2.new(1, 0, 0, 42),
        UDim2.fromOffset(0, 0),
        "ColorPickerRow_" .. displayName
    )
    self.RowFrame.ZIndex            = 15
    self.RowFrame.ClipsDescendants  = false
    self.RowFrame.LayoutOrder       = #parentSection.Components + 1
    self.RowFrame.Parent            = parentSection.ComponentContainer

    VoidUI.Utility.ApplyCornerRadius(self.RowFrame, 6)
    VoidUI.Utility.ApplyStroke(self.RowFrame, VoidUI.Theme.BorderPrimary, 1)
    VoidUI.Utility.ApplyPadding(self.RowFrame, 0, 0, 14, 14)

    -- Label
    local labelRegion = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.55, 0, 1, 0),
        UDim2.fromOffset(0, 0),
        "LabelRegion"
    )
    labelRegion.BackgroundTransparency = 1
    labelRegion.ZIndex = 16
    labelRegion.Parent = self.RowFrame
    ComponentBase._BuildComponentLabel(labelRegion, displayName, displayDesc)

    -- Right: color swatch + hex label
    local controlRegion = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(0.45, 0, 1, 0),
        UDim2.new(0.55, 0, 0, 0),
        "ControlRegion"
    )
    controlRegion.BackgroundTransparency = 1
    controlRegion.ZIndex = 16
    controlRegion.Parent = self.RowFrame

    -- Color swatch button (shows current color, clickable)
    self.SwatchButton = VoidUI.Utility.CreateButton(
        "", 12,
        self.Value,
        VoidUI.Theme.TextPrimary,
        "ColorSwatch"
    )
    self.SwatchButton.Size     = UDim2.new(1, 0, 0, 28)
    self.SwatchButton.Position = UDim2.new(0, 0, 0.5, -14)
    self.SwatchButton.ZIndex   = 16
    self.SwatchButton.Parent   = controlRegion
    VoidUI.Utility.ApplyCornerRadius(self.SwatchButton, 6)
    VoidUI.Utility.ApplyStroke(self.SwatchButton, VoidUI.Theme.BorderPrimary, 1)

    -- Hex code label inside swatch
    self.HexLabel = VoidUI.Utility.CreateLabel(
        self:_ColorToHex(self.Value),
        11,
        self:_GetContrastTextColor(self.Value),
        Enum.Font.GothamMedium,
        false
    )
    self.HexLabel.Size           = UDim2.fromScale(1, 1)
    self.HexLabel.TextXAlignment = Enum.TextXAlignment.Center
    self.HexLabel.ZIndex         = 17
    self.HexLabel.Parent         = self.SwatchButton

    -- ---- Color palette panel ----

    self.PalettePanel = VoidUI.Utility.CreateFrame(
        VoidUI.Theme.DropdownBackground,
        UDim2.fromOffset(self.RowFrame.AbsoluteSize.X > 0 and self.RowFrame.AbsoluteSize.X or 380, 0),
        UDim2.new(0, 0, 1, 4),
        "ColorPalettePanel"
    )
    self.PalettePanel.ZIndex    = 50
    self.PalettePanel.Visible   = false
    self.PalettePanel.ClipsDescendants = true
    self.PalettePanel.Parent    = self.RowFrame
    VoidUI.Utility.ApplyCornerRadius(self.PalettePanel, 8)
    VoidUI.Utility.ApplyStroke(self.PalettePanel, VoidUI.Theme.BorderSecondary, 1)
    VoidUI.Utility.ApplyPadding(self.PalettePanel, 10, 10, 10, 10)

    -- Shades row: horizontal grid of color squares
    local shadesRow = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 36),
        UDim2.fromOffset(0, 0),
        "ShadesRow"
    )
    shadesRow.BackgroundTransparency = 1
    shadesRow.ZIndex = 51
    shadesRow.Parent = self.PalettePanel

    VoidUI.Utility.ApplyListLayout(
        shadesRow,
        Enum.FillDirection.Horizontal,
        Enum.HorizontalAlignment.Left,
        Enum.VerticalAlignment.Center,
        Enum.SortOrder.LayoutOrder,
        4
    )

    -- Build shade swatches
    for shadeIndex, shadeColor in ipairs(VoidUI.Theme.ColorPickerShades) do
        local swatchFrame = VoidUI.Utility.CreateButton(
            "", 12, shadeColor, Color3.fromRGB(0,0,0), "Shade_" .. shadeIndex
        )
        swatchFrame.Size        = UDim2.fromOffset(26, 26)
        swatchFrame.LayoutOrder = shadeIndex
        swatchFrame.ZIndex      = 52
        swatchFrame.Parent      = shadesRow
        VoidUI.Utility.ApplyCornerRadius(swatchFrame, 4)
        VoidUI.Utility.ApplyStroke(swatchFrame, VoidUI.Theme.BorderPrimary, 1)

        -- Hover: scale up the swatch
        swatchFrame.MouseEnter:Connect(function()
            VoidUI.Utility.CreateTween(
                swatchFrame,
                { Size = UDim2.fromOffset(28, 28) },
                VoidUI.TweenConfig.Fast
            )
        end)
        swatchFrame.MouseLeave:Connect(function()
            VoidUI.Utility.CreateTween(
                swatchFrame,
                { Size = UDim2.fromOffset(26, 26) },
                VoidUI.TweenConfig.Fast
            )
        end)

        -- Select this shade
        local capturedColor = shadeColor
        swatchFrame.MouseButton1Click:Connect(function()
            self:SetValue(capturedColor)
            self:_ClosePalette()
        end)
    end

    -- Selected color info row
    local infoRow = VoidUI.Utility.CreateFrame(
        Color3.fromRGB(0, 0, 0),
        UDim2.new(1, 0, 0, 28),
        UDim2.fromOffset(0, 44),
        "InfoRow"
    )
    infoRow.BackgroundTransparency = 1
    infoRow.ZIndex = 51
    infoRow.Parent = self.PalettePanel

    self.PaletteCurrentSwatch = VoidUI.Utility.CreateFrame(
        self.Value,
        UDim2.fromOffset(22, 22),
        UDim2.fromOffset(0, 3),
        "CurrentSwatch"
    )
    self.PaletteCurrentSwatch.ZIndex = 52
    self.PaletteCurrentSwatch.Parent = infoRow
    VoidUI.Utility.ApplyCornerRadius(self.PaletteCurrentSwatch, 4)

    local currentLabel = VoidUI.Utility.CreateLabel(
        "Selected", 11, VoidUI.Theme.TextTertiary, Enum.Font.Gotham, false
    )
    currentLabel.Position = UDim2.fromOffset(30, 0)
    currentLabel.Size     = UDim2.new(0.3, 0, 1, 0)
    currentLabel.ZIndex   = 52
    currentLabel.Parent   = infoRow

    self.PaletteHexDisplay = VoidUI.Utility.CreateLabel(
        self:_ColorToHex(self.Value), 11, VoidUI.Theme.TextPrimary, Enum.Font.GothamMedium, false
    )
    self.PaletteHexDisplay.Position = UDim2.new(0.35, 0, 0, 0)
    self.PaletteHexDisplay.Size     = UDim2.new(0.65, 0, 1, 0)
    self.PaletteHexDisplay.ZIndex   = 52
    self.PaletteHexDisplay.Parent   = infoRow

    -- ---- Swatch click: toggle palette ----

    self.SwatchButton.MouseButton1Click:Connect(function()
        if self.IsOpen then
            self:_ClosePalette()
        else
            self:_OpenPalette()
        end
    end)

    -- Click-outside-to-close
    self._ClickOutsideConnection = UserInputService.InputBegan:Connect(
        function(inputObject, gameProcessed)
            if not self.IsOpen then return end
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos   = UserInputService:GetMouseLocation()
                local panelPos   = self.PalettePanel.AbsolutePosition
                local panelSize  = self.PalettePanel.AbsoluteSize
                local rowPos     = self.RowFrame.AbsolutePosition
                local rowSize    = self.RowFrame.AbsoluteSize

                local insideRow = mousePos.X >= rowPos.X and mousePos.X <= rowPos.X + rowSize.X
                    and mousePos.Y >= rowPos.Y and mousePos.Y <= rowPos.Y + rowSize.Y
                local insidePanel = mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X
                    and mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y

                if not insideRow and not insidePanel then
                    self:_ClosePalette()
                end
            end
        end
    )

    return self
end

--[[
    ColorPickerComponent:_OpenPalette()
    Slides the palette panel open.
--]]
function ColorPickerComponent:_OpenPalette()
    self.IsOpen = true
    local panelWidth = self.RowFrame.AbsoluteSize.X
    self.PalettePanel.Size    = UDim2.fromOffset(panelWidth, 0)
    self.PalettePanel.Visible = true

    VoidUI.Utility.CreateTween(
        self.PalettePanel,
        { Size = UDim2.fromOffset(panelWidth, 86) },
        VoidUI.TweenConfig.Normal
    )
end

--[[
    ColorPickerComponent:_ClosePalette()
    Slides the palette panel closed.
--]]
function ColorPickerComponent:_ClosePalette()
    self.IsOpen = false
    local panelWidth = self.RowFrame.AbsoluteSize.X

    local closeTween = VoidUI.Utility.CreateTween(
        self.PalettePanel,
        { Size = UDim2.fromOffset(panelWidth, 0) },
        VoidUI.TweenConfig.Fast
    )
    closeTween.Completed:Connect(function()
        self.PalettePanel.Visible = false
    end)
end

--[[
    ColorPickerComponent:_ColorToHex(color3Value)
    Converts a Color3 to a hex string like "#FFFFFF".
--]]
function ColorPickerComponent:_ColorToHex(colorValue)
    local r = math.floor(colorValue.R * 255)
    local g = math.floor(colorValue.G * 255)
    local b = math.floor(colorValue.B * 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

--[[
    ColorPickerComponent:_GetContrastTextColor(backgroundColor)
    Returns black or white text color for readability on the given bg.
--]]
function ColorPickerComponent:_GetContrastTextColor(bgColor)
    -- Relative luminance formula (ITU-R BT.709)
    local luminance = 0.2126 * bgColor.R + 0.7152 * bgColor.G + 0.0722 * bgColor.B
    return luminance > 0.5
        and Color3.fromHex("000000")
        or  Color3.fromHex("FFFFFF")
end

--[[
    ColorPickerComponent:SetValue(newColor3Value)
    Sets the current color, updates swatches, fires callback.
--]]
function ColorPickerComponent:SetValue(newColor)
    self.Value = newColor

    -- Update main swatch
    self.SwatchButton.BackgroundColor3  = newColor
    self.HexLabel.Text                  = self:_ColorToHex(newColor)
    self.HexLabel.TextColor3            = self:_GetContrastTextColor(newColor)

    -- Update palette info
    if self.PaletteCurrentSwatch then
        self.PaletteCurrentSwatch.BackgroundColor3 = newColor
    end
    if self.PaletteHexDisplay then
        self.PaletteHexDisplay.Text = self:_ColorToHex(newColor)
    end

    task.spawn(function()
        local callbackFn = self.Config.Callback or function() end
        local success, err = pcall(callbackFn, newColor)
        if not success then
            warn("[VoidUI] ColorPicker callback error: " .. tostring(err))
        end
    end)
end

--[[
    ColorPickerComponent:GetValue()
    Returns the current Color3 value.
--]]
function ColorPickerComponent:GetValue()
    return self.Value
end

-- ============================================================
-- [SECTION 20] LABEL COMPONENT
-- A purely informational text display. Supports rich text,
-- multiple visual styles (header, body, hint, code, divider).
-- ============================================================

LabelComponent = {}
LabelComponent.__index = LabelComponent

--[[
    LabelComponent.new(section, labelConfig)
    labelConfig fields:
        Text    : string (Content to display)
        Style   : string ("header" | "body" | "hint" | "code" | "divider")
        Align   : string ("left" | "center" | "right")
--]]
function LabelComponent.new(parentSection, labelConfig)
    local self = setmetatable({}, LabelComponent)

    self.Section    = parentSection
    self.Config     = labelConfig or {}

    local displayText   = self.Config.Text  or ""
    local labelStyle    = self.Config.Style or "body"
    local alignStr      = self.Config.Align or "left"

    -- Alignment enum mapping
    local alignMap = {
        left   = Enum.TextXAlignment.Left,
        center = Enum.TextXAlignment.Center,
        right  = Enum.TextXAlignment.Right,
    }
    local textAlignment = alignMap[alignStr] or Enum.TextXAlignment.Left

    -- Style property mapping
    local styleConfig = {
        header  = { size = 15, color = VoidUI.Theme.TextPrimary,    font = Enum.Font.GothamBold,   height = 24, bg = false },
        body    = { size = 13, color = VoidUI.Theme.TextSecondary,  font = Enum.Font.Gotham,        height = 18, bg = false },
        hint    = { size = 11, color = VoidUI.Theme.TextTertiary,   font = Enum.Font.Gotham,        height = 16, bg = false },
        code    = { size = 11, color = VoidUI.Theme.TextPrimary,    font = Enum.Font.Code,          height = 28, bg = true  },
        divider = { size = 11, color = VoidUI.Theme.TextTertiary,   font = Enum.Font.Gotham,        height = 20, bg = false },
    }

    local activeStyle = styleConfig[labelStyle] or styleConfig.body

    -- ---- Container frame ----

    self.LabelContainer = VoidUI.Utility.CreateFrame(
        activeStyle.bg and VoidUI.Theme.BackgroundQuaternary or Color3.fromRGB(0,0,0),
        UDim2.new(1, 0, 0, activeStyle.height),
        UDim2.fromOffset(0, 0),
        "LabelComponent"
    )
    self.LabelContainer.BackgroundTransparency = activeStyle.bg and 0 or 1
    self.LabelContainer.AutomaticSize          = Enum.AutomaticSize.Y
    self.LabelContainer.ZIndex                 = 15
    self.LabelContainer.LayoutOrder            = #parentSection.Components + 1
    self.LabelContainer.Parent                 = parentSection.ComponentContainer

    if activeStyle.bg then
        VoidUI.Utility.ApplyCornerRadius(self.LabelContainer, 5)
        VoidUI.Utility.ApplyPadding(self.LabelContainer, 6, 6, 10, 10)
    end

    -- ---- Special: Divider line ----

    if labelStyle == "divider" then
        local dividerLine = VoidUI.Utility.CreateFrame(
            VoidUI.Theme.BorderPrimary,
            UDim2.new(1, 0, 0, 1),
            UDim2.new(0, 0, 0.5, 0),
            "DividerLine"
        )
        dividerLine.ZIndex = 16
        dividerLine.Parent = self.LabelContainer

        if displayText ~= "" then
            -- Centered text label on top of the line
            local centeredLabel = VoidUI.Utility.CreateLabel(
                displayText, activeStyle.size, activeStyle.color, activeStyle.font, true
            )
            centeredLabel.BackgroundColor3       = VoidUI.Theme.BackgroundPrimary
            centeredLabel.BackgroundTransparency = 0
            centeredLabel.AnchorPoint            = Vector2.new(0.5, 0.5)
            centeredLabel.Position               = UDim2.new(0.5, 0, 0.5, 0)
            centeredLabel.TextXAlignment         = Enum.TextXAlignment.Center
            centeredLabel.ZIndex                 = 17
            centeredLabel.Parent                 = self.LabelContainer
            VoidUI.Utility.ApplyPadding(centeredLabel, 0, 0, 6, 6)
        end
    else
        -- Standard text label
        self.TextLabel = VoidUI.Utility.CreateLabel(
            displayText,
            activeStyle.size,
            activeStyle.color,
            activeStyle.font,
            false
        )
        self.TextLabel.Size         = UDim2.new(1, 0, 0, 0)
        self.TextLabel.AutomaticSize = Enum.AutomaticSize.Y
        self.TextLabel.TextXAlignment = textAlignment
        self.TextLabel.TextWrapped   = true
        self.TextLabel.ZIndex        = 16
        self.TextLabel.Parent        = self.LabelContainer
    end

    return self
end

--[[
    LabelComponent:SetText(newText)
    Updates the label text at runtime.
--]]
function LabelComponent:SetText(newText)
    if self.TextLabel then
        self.TextLabel.Text = newText
    end
end

-- ============================================================
-- [SECTION 21] FINAL LIBRARY EXPORT
-- Return the VoidUI table as the library interface.
-- Usage:
--
--   local VoidUI = loadstring(game:HttpGet("..."))()
--
--   local Library = VoidUI.new("My Script")
--
--   local Window = Library:CreateWindow({
--       Title    = "My Script",
--       Subtitle = "v1.0.0",
--       Width    = 540,
--   })
--
--   local MainTab = Window:AddTab({ Name = "Main", Icon = "⚙" })
--   local Section = MainTab:AddSection({ Name = "SETTINGS" })
--
--   Section:AddButton({
--       Name     = "Execute",
--       Callback = function() print("clicked") end,
--   })
--
--   Section:AddToggle({
--       Name     = "Auto-Farm",
--       Default  = false,
--       Callback = function(value) print("AutoFarm:", value) end,
--   })
--
--   Section:AddSlider({
--       Name     = "Walk Speed",
--       Min      = 0, Max = 100,
--       Default  = 16,
--       Suffix   = " st/s",
--       Callback = function(value) print("Speed:", value) end,
--   })
--
--   Library:Notify("Hello", "VoidUI initialized.", 4, "success")
-- ============================================================

return VoidUI
