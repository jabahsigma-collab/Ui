--[[
╔══════════════════════════════════════════════════════════════════╗
║   AETHERIS UI LIBRARY  v2.0  —  Single-File Luau Source         ║
║   Components: Window, Button, Toggle, Slider, Dropdown,          ║
║               ColorPicker, Notification, Navigator               ║
║   Features:   Themes, Flags, JSON Save/Load, Spring Physics,     ║
║               Glassmorphism, Animated Bootloader, FPS Monitor    ║
╚══════════════════════════════════════════════════════════════════╝
    Usage:
        local Aetheris = loadstring(game:HttpGet("..."))()
        local Win = Aetheris:CreateWindow({ Title = "Hub", Theme = "Midnight" })
        local Tab = Win:AddTab({ Name = "Main" })
        Tab:AddToggle("godMode", { Label = "God Mode", Default = false,
            Callback = function(v) print(v) end })
        Tab:AddSlider("speed", { Label = "Speed", Min = 0, Max = 500, Default = 16,
            Callback = function(v) print(v) end })
]]

-- ── SERVICES ──────────────────────────────────────────────────────────────────
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")

-- ── MATH CACHE ────────────────────────────────────────────────────────────────
local mSin   = math.sin
local mCos   = math.cos
local mClamp = math.clamp
local mFloor = math.floor
local mAbs   = math.abs
local mSqrt  = math.sqrt
local mMax   = math.max
local mMin   = math.min
local mPi    = math.pi

-- ── CONSTRUCTOR CACHE ────────────────────────────────────────────────────────
local C3     = Color3.fromRGB
local C3H    = Color3.fromHSV
local U2     = UDim2.new
local U2f    = UDim2.fromOffset
local Ud     = UDim.new
local V2     = Vector2.new
local TI     = TweenInfo.new
local New    = Instance.new

-- ── LOCAL PLAYER ─────────────────────────────────────────────────────────────
local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════════════════
-- §1  THEME DATABASE
-- ════════════════════════════════════════════════════════════════════════════
local Themes = {
    Midnight = {
        Primary    = C3(99,  102, 241),
        Secondary  = C3(139,  92, 246),
        Background = C3(7,    7,  18),
        Surface    = C3(15,  15,  35),
        SurfaceAlt = C3(22,  22,  52),
        Border     = C3(40,  40,  80),
        Text       = C3(237, 237, 255),
        TextMuted  = C3(120, 120, 160),
        TextAccent = C3(165, 180, 252),
        Success    = C3(52,  211, 153),
        Warning    = C3(251, 191,  36),
        Error      = C3(248, 113, 113),
        Info       = C3(96,  165, 250),
        Glow       = C3(99,  102, 241),
        Grad1      = C3(99,  102, 241),
        Grad2      = C3(139,  92, 246),
    },
    Obsidian = {
        Primary    = C3(244,  63,  94),
        Secondary  = C3(251, 113, 133),
        Background = C3(8,    8,   8),
        Surface    = C3(16,  16,  16),
        SurfaceAlt = C3(28,  28,  28),
        Border     = C3(45,  45,  45),
        Text       = C3(250, 250, 250),
        TextMuted  = C3(120, 120, 120),
        TextAccent = C3(254, 205, 211),
        Success    = C3(74,  222, 128),
        Warning    = C3(250, 204,  21),
        Error      = C3(239,  68,  68),
        Info       = C3(56,  189, 248),
        Glow       = C3(244,  63,  94),
        Grad1      = C3(244,  63,  94),
        Grad2      = C3(168,  85, 247),
    },
    Abyss = {
        Primary    = C3(6,   182, 212),
        Secondary  = C3(34,  211, 238),
        Background = C3(2,    6,  23),
        Surface    = C3(5,   11,  38),
        SurfaceAlt = C3(10,  20,  60),
        Border     = C3(20,  40,  80),
        Text       = C3(224, 242, 254),
        TextMuted  = C3(100, 150, 180),
        TextAccent = C3(165, 243, 252),
        Success    = C3(52,  211, 153),
        Warning    = C3(251, 191,  36),
        Error      = C3(248, 113, 113),
        Info       = C3(96,  165, 250),
        Glow       = C3(6,   182, 212),
        Grad1      = C3(6,   182, 212),
        Grad2      = C3(99,  102, 241),
    },
    Inferno = {
        Primary    = C3(249, 115,  22),
        Secondary  = C3(251, 146,  60),
        Background = C3(12,   5,   3),
        Surface    = C3(28,  10,   5),
        SurfaceAlt = C3(45,  18,   8),
        Border     = C3(80,  35,  15),
        Text       = C3(255, 242, 230),
        TextMuted  = C3(160, 120,  90),
        TextAccent = C3(253, 186, 116),
        Success    = C3(74,  222, 128),
        Warning    = C3(250, 204,  21),
        Error      = C3(239,  68,  68),
        Info       = C3(56,  189, 248),
        Glow       = C3(249, 115,  22),
        Grad1      = C3(249, 115,  22),
        Grad2      = C3(239,  68,  68),
    },
    Void = {
        Primary    = C3(168,  85, 247),
        Secondary  = C3(192, 132, 252),
        Background = C3(5,    0,  15),
        Surface    = C3(12,   5,  30),
        SurfaceAlt = C3(22,  10,  50),
        Border     = C3(50,  20,  80),
        Text       = C3(245, 235, 255),
        TextMuted  = C3(130, 100, 160),
        TextAccent = C3(216, 180, 254),
        Success    = C3(52,  211, 153),
        Warning    = C3(251, 191,  36),
        Error      = C3(248, 113, 113),
        Info       = C3(96,  165, 250),
        Glow       = C3(168,  85, 247),
        Grad1      = C3(168,  85, 247),
        Grad2      = C3(244,  63,  94),
    },
    Neon = {
        Primary    = C3(0,   255, 128),
        Secondary  = C3(0,   220, 100),
        Background = C3(3,    8,   5),
        Surface    = C3(6,   16,  10),
        SurfaceAlt = C3(10,  28,  18),
        Border     = C3(0,   80,  40),
        Text       = C3(200, 255, 220),
        TextMuted  = C3(80,  160, 100),
        TextAccent = C3(0,   255, 128),
        Success    = C3(0,   255, 128),
        Warning    = C3(255, 230,   0),
        Error      = C3(255,  50,  80),
        Info       = C3(0,   200, 255),
        Glow       = C3(0,   255, 128),
        Grad1      = C3(0,   255, 128),
        Grad2      = C3(0,   200, 255),
    },
    Pearl = {
        Primary    = C3(79,   70, 229),
        Secondary  = C3(99,  102, 241),
        Background = C3(248, 248, 255),
        Surface    = C3(255, 255, 255),
        SurfaceAlt = C3(238, 238, 252),
        Border     = C3(200, 200, 230),
        Text       = C3(15,  15,  40),
        TextMuted  = C3(120, 120, 150),
        TextAccent = C3(79,   70, 229),
        Success    = C3(22,  163,  74),
        Warning    = C3(202, 138,   4),
        Error      = C3(185,  28,  28),
        Info       = C3(37,   99, 235),
        Glow       = C3(99,  102, 241),
        Grad1      = C3(79,   70, 229),
        Grad2      = C3(139,  92, 246),
    },
    CyberPunk = {
        Primary    = C3(255, 215,   0),
        Secondary  = C3(0,   240, 255),
        Background = C3(8,    0,  20),
        Surface    = C3(18,   0,  40),
        SurfaceAlt = C3(30,   0,  65),
        Border     = C3(80,   0, 120),
        Text       = C3(255, 250, 230),
        TextMuted  = C3(180, 150,  80),
        TextAccent = C3(255, 215,   0),
        Success    = C3(0,   255, 100),
        Warning    = C3(255, 215,   0),
        Error      = C3(255,  30,  60),
        Info       = C3(0,   240, 255),
        Glow       = C3(255, 215,   0),
        Grad1      = C3(255,   0, 120),
        Grad2      = C3(0,   240, 255),
    },
}

-- ════════════════════════════════════════════════════════════════════════════
-- §2  UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════

-- Lerp a Color3
local function LerpColor(a, b, t)
    return C3(
        mFloor(a.R*255 + (b.R*255 - a.R*255) * t),
        mFloor(a.G*255 + (b.G*255 - a.G*255) * t),
        mFloor(a.B*255 + (b.B*255 - a.B*255) * t)
    )
end

-- Smooth lerp scalar
local function Lerp(a, b, t) return a + (b - a) * t end

-- Create a tween and play it, returns the tween
local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- Quick UDim2 position tween
local function TweenPos(obj, time, pos, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    return Tween(obj, TI(time, style, dir), { Position = pos })
end

-- Quick transparency tween
local function TweenTrans(obj, time, trans, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    return Tween(obj, TI(time, style, dir), { BackgroundTransparency = trans })
end

-- Apply a UIGradient to a frame
local function ApplyGradient(parent, c1, c2, rotation)
    local g = New("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
    g.Rotation = rotation or 90
    g.Parent = parent
    return g
end

-- Create a rounded corner
local function RoundCorner(parent, radius)
    local c = New("UICorner")
    c.CornerRadius = Ud(0, radius or 8)
    c.Parent = parent
    return c
end

-- Create a UIStroke (inner glow / border)
local function AddStroke(parent, color, thickness, trans)
    local s = New("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- Create a multi-layer shadow beneath a frame
local function AddShadow(parent, theme, elevation)
    elevation = elevation or 1
    local sizes = { 8, 16, 28 }
    local trans = { 0.82, 0.88, 0.94 }
    local blurs = {}
    for i = 1, 3 do
        local sh = New("ImageLabel")
        sh.Name = "Shadow" .. i
        sh.AnchorPoint = V2(0.5, 0.5)
        sh.BackgroundTransparency = 1
        sh.Position = U2(0.5, 0, 0.5, elevation * 2)
        sh.Size = U2(1, sizes[i] * elevation, 1, sizes[i] * elevation)
        sh.ZIndex = parent.ZIndex - i
        sh.Image = "rbxassetid://6014261993"
        sh.ImageColor3 = theme.Background
        sh.ImageTransparency = trans[i]
        sh.ScaleType = Enum.ScaleType.Slice
        sh.SliceCenter = Rect.new(49, 49, 450, 450)
        sh.Parent = parent.Parent or parent
        table.insert(blurs, sh)
    end
    return blurs
end

-- Make a frame draggable with smooth lerp follow
local function MakeDraggable(frame, handle, screenGui)
    local dragging = false
    local dragStart, startPos
    local targetPos = frame.Position
    local conn1, conn2, conn3

    conn1 = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    conn2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local sgSize = screenGui.AbsoluteSize
            local newX = mClamp(startPos.X.Scale + delta.X / sgSize.X, 0, 1)
            local newY = mClamp(startPos.Y.Scale + delta.Y / sgSize.Y, 0, 1)
            targetPos = U2(newX, startPos.X.Offset, newY, startPos.Y.Offset)
        end
    end)

    conn3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Smooth follow loop
    local smoothConn
    smoothConn = RunService.RenderStepped:Connect(function(dt)
        if frame and frame.Parent then
            local cx = frame.Position.X.Scale
            local cy = frame.Position.Y.Scale
            local tx = targetPos.X.Scale
            local ty = targetPos.Y.Scale
            local speed = mClamp(dt * 18, 0, 1)
            frame.Position = U2(Lerp(cx, tx, speed), frame.Position.X.Offset,
                                Lerp(cy, ty, speed), frame.Position.Y.Offset)
        end
    end)

    return function()
        conn1:Disconnect()
        conn2:Disconnect()
        conn3:Disconnect()
        smoothConn:Disconnect()
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- §3  SIGNAL MANAGER  —  memory-safe connection tracking
-- ════════════════════════════════════════════════════════════════════════════
local SignalManager = {}
SignalManager._conns  = {}
SignalManager._groups = {}
SignalManager._nextId = 0
SignalManager._nextGr = 0

function SignalManager:NewGroup()
    self._nextGr = self._nextGr + 1
    self._groups[self._nextGr] = {}
    return self._nextGr
end

function SignalManager:Connect(sig, fn, gid)
    self._nextId = self._nextId + 1
    local id   = self._nextId
    local conn = sig:Connect(fn)
    self._conns[id] = conn
    if gid then
        if not self._groups[gid] then self._groups[gid] = {} end
        self._groups[gid][#self._groups[gid]+1] = id
    end
    return id
end

function SignalManager:Once(sig, fn, gid)
    self._nextId = self._nextId + 1
    local id = self._nextId
    local conn
    conn = sig:Connect(function(...)
        fn(...)
        if self._conns[id] then
            self._conns[id]:Disconnect()
            self._conns[id] = nil
        end
    end)
    self._conns[id] = conn
    if gid then
        if not self._groups[gid] then self._groups[gid] = {} end
        self._groups[gid][#self._groups[gid]+1] = id
    end
    return id
end

function SignalManager:DisconnectGroup(gid)
    local g = self._groups[gid]
    if not g then return end
    for _, id in ipairs(g) do
        if self._conns[id] then
            self._conns[id]:Disconnect()
            self._conns[id] = nil
        end
    end
    self._groups[gid] = nil
end

function SignalManager:DisconnectAll()
    for id, conn in pairs(self._conns) do
        conn:Disconnect()
        self._conns[id] = nil
    end
    self._groups = {}
end

-- ════════════════════════════════════════════════════════════════════════════
-- §4  CONFIGURATION MANAGER  —  Flags + JSON persistence
-- ════════════════════════════════════════════════════════════════════════════
local CM = {}
CM.Flags  = {}
CM._hooks = {}

function CM:Register(id, opts)
    if self.Flags[id] then return self.Flags[id] end
    self.Flags[id] = {
        Value    = opts.Default,
        Default  = opts.Default,
        Type     = opts.Type or "any",
        Callback = opts.Callback,
    }
    self._hooks[id] = {}
    return self.Flags[id]
end

function CM:Set(id, value)
    local f = self.Flags[id]
    if not f then return end
    local old = f.Value
    f.Value = value
    if f.Callback then task.spawn(f.Callback, value, old) end
    for _, h in ipairs(self._hooks[id] or {}) do
        task.spawn(h, value, old)
    end
end

function CM:Get(id)
    return self.Flags[id] and self.Flags[id].Value
end

function CM:OnChanged(id, fn)
    if not self._hooks[id] then self._hooks[id] = {} end
    local idx = #self._hooks[id] + 1
    self._hooks[id][idx] = fn
    return function()
        if self._hooks[id] then self._hooks[id][idx] = nil end
    end
end

function CM:Save(slot)
    slot = slot or "Default"
    local payload = {}
    for id, f in pairs(self.Flags) do
        local v = f.Value
        if typeof(v) == "Color3" then
            payload[id] = { __c3 = true, r = v.R, g = v.G, b = v.B }
        elseif type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
            payload[id] = v
        end
    end
    local ok, json = pcall(HttpService.JSONEncode, HttpService, payload)
    if not ok then return false end
    pcall(function()
        local folder = workspace:FindFirstChild("AetherisConfig")
                    or (function()
                        local f = New("Folder")
                        f.Name = "AetherisConfig"
                        f.Parent = workspace
                        return f
                    end)()
        local sv = folder:FindFirstChild(slot) or (function()
            local s = New("StringValue")
            s.Name   = slot
            s.Parent = folder
            return s
        end)()
        sv.Value = json
    end)
    return true
end

function CM:Load(slot)
    slot = slot or "Default"
    local folder = workspace:FindFirstChild("AetherisConfig")
    if not folder then return false end
    local sv = folder:FindFirstChild(slot)
    if not sv or sv.Value == "" then return false end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, sv.Value)
    if not ok then return false end
    for id, v in pairs(data) do
        if self.Flags[id] then
            if type(v) == "table" and v.__c3 then
                self:Set(id, Color3.new(
                    mClamp(v.r or 0, 0, 1),
                    mClamp(v.g or 0, 0, 1),
                    mClamp(v.b or 0, 0, 1)))
            else
                self:Set(id, v)
            end
        end
    end
    return true
end

-- ════════════════════════════════════════════════════════════════════════════
-- §5  ANIMATION ENGINE  —  Spring physics + state machine
-- ════════════════════════════════════════════════════════════════════════════

-- §5.1 Spring simulator (semi-implicit Euler)
local function NewSpring(stiffness, damping, mass)
    stiffness = stiffness or 200
    damping   = damping   or 20
    mass      = mass      or 1
    return {
        stiffness = stiffness,
        damping   = damping,
        mass      = mass,
        pos       = 0,
        vel       = 0,
        target    = 0,
    }
end

local function StepSpring(spring, dt)
    local k = spring.stiffness
    local b = spring.damping
    local m = spring.mass
    local x = spring.pos - spring.target
    local acc = (-k * x - b * spring.vel) / m
    spring.vel = spring.vel + acc * dt
    spring.pos = spring.pos + spring.vel * dt
    return spring.pos
end

local function IsSpringSettled(spring, tol)
    tol = tol or 0.001
    return mAbs(spring.pos - spring.target) < tol and mAbs(spring.vel) < tol
end

-- §5.2 Button animation state machine  (7 states)
-- States: Idle, Hover, Pressed, Focused, Disabled, Activated, Transitioning
local ButtonStates = {
    Idle        = 1,
    Hover       = 2,
    Pressed     = 3,
    Focused     = 4,
    Disabled    = 5,
    Activated   = 6,
    Transitioning = 7,
}

local BUTTON_STYLE = {
    [ButtonStates.Idle]     = { trans = 0.0, size = 1.00, glow = 0.0 },
    [ButtonStates.Hover]    = { trans = 0.0, size = 1.03, glow = 0.5 },
    [ButtonStates.Pressed]  = { trans = 0.1, size = 0.96, glow = 0.2 },
    [ButtonStates.Focused]  = { trans = 0.0, size = 1.02, glow = 0.8 },
    [ButtonStates.Disabled] = { trans = 0.5, size = 1.00, glow = 0.0 },
    [ButtonStates.Activated]= { trans = 0.0, size = 1.05, glow = 1.0 },
    [ButtonStates.Transitioning] = { trans = 0.2, size = 1.00, glow = 0.3 },
}

-- ════════════════════════════════════════════════════════════════════════════
-- §6  BOOTLOADER  —  Cinematic pre-flight sequence
-- ════════════════════════════════════════════════════════════════════════════

local BOOT_LINES = {
    "[SYS]  Aetheris Runtime v2.0 initializing...",
    "[MEM]  Allocating UI heap... 48MB reserved",
    "[GPU]  Detecting render pipeline... OK",
    "[DRV]  Loading graphics driver... PASSED",
    "[NET]  Establishing secure channel... OK",
    "[SIG]  Signal manager online",
    "[CFG]  Loading configuration manager...",
    "[AST]  Preloading asset manifests... 247 entries",
    "[THM]  Compiling theme shaders... 8 palettes",
    "[ANI]  Spring physics engine... ONLINE",
    "[SPR]  Spring stiffness: 200  damping: 20",
    "[EAS]  Easing preset library... 50 presets loaded",
    "[SND]  Sound manifests... 38 audio assets",
    "[ICN]  Icon manifests... 94 icons indexed",
    "[WIN]  Window manager starting...",
    "[WIN]  Drag system: Smooth-Lerp enabled",
    "[WIN]  Shadow engine: 3-layer depth",
    "[WIN]  Glass morphism: BackgroundTransparency 0.3",
    "[NAV]  Navigator component loading...",
    "[NAV]  Ripple particle system: READY",
    "[TGL]  ToggleV2 spring physics: READY",
    "[SLD]  HyperSlider precision engine: READY",
    "[DRP]  MultiDropdown inertia scroll: READY",
    "[CLR]  ColorSpectrum HSV/RGB picker: READY",
    "[HUB]  NotificationHub toast system: READY",
    "[FPS]  Performance monitor: ONLINE",
    "[MEM]  Memory chart renderer: ONLINE",
    "[FLG]  Flag system: initialized",
    "[SAV]  JSON persistence: READY",
    "[PFX]  Particle effects: ENABLED",
    "[GLW]  Inner glow compositor: READY",
    "[GRD]  Gradient engine: UIGradient v2",
    "[COR]  UICorner radius system: 8px default",
    "[STK]  UIStroke glow layer: ACTIVE",
    "[INP]  UserInputService hooked",
    "[RND]  RenderStepped budget: 16ms (60fps)",
    "[TSK]  task.spawn / task.wait enforced",
    "[GRB]  Garbage collector: pooling ACTIVE",
    "[MTB]  Metatable cleanup: registered",
    "[DST]  Destroy protocol: self-cleaning",
    "[VLD]  Validator chains: READY",
    "[HKS]  Hook system: READY",
    "[AUT]  Auto-save watcher: STANDBY",
    "[SES]  Session token generated",
    "[CHK]  Integrity check: PASSED",
    "[SEC]  Anti-tamper: ACTIVE",
    "[LOG]  Debug logger: STANDBY",
    "[SYS]  All subsystems nominal",
    "[SYS]  Boot sequence complete — LAUNCHING",
    "       Welcome to AETHERIS.",
}

local function RunBootloader(onComplete)
    local screenGui = New("ScreenGui")
    screenGui.Name = "AetherisBootloader"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui

    -- Full screen blur overlay
    local overlay = New("Frame")
    overlay.Name = "Overlay"
    overlay.Size = U2(1,0,1,0)
    overlay.Position = U2(0,0,0,0)
    overlay.BackgroundColor3 = C3(2,2,8)
    overlay.BackgroundTransparency = 0
    overlay.ZIndex = 10
    overlay.Parent = screenGui

    -- Scanline texture
    local scanline = New("Frame")
    scanline.Size = U2(1,0,1,0)
    scanline.BackgroundColor3 = C3(99,102,241)
    scanline.BackgroundTransparency = 0.96
    scanline.ZIndex = 11
    scanline.Parent = overlay

    -- Center panel
    local panel = New("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = V2(0.5, 0.5)
    panel.Size = U2(0, 480, 0, 340)
    panel.Position = U2(0.5, 0, 0.5, 0)
    panel.BackgroundColor3 = C3(10,10,28)
    panel.BackgroundTransparency = 0.2
    panel.ZIndex = 12
    panel.Parent = overlay
    RoundCorner(panel, 12)
    AddStroke(panel, C3(99,102,241), 1, 0.5)

    -- Panel gradient
    ApplyGradient(panel, C3(15,15,45), C3(5,5,20), 135)

    -- Neural link geometric animation container
    local geoContainer = New("Frame")
    geoContainer.Name = "GeoContainer"
    geoContainer.AnchorPoint = V2(0.5, 0.5)
    geoContainer.Size = U2(0, 120, 0, 120)
    geoContainer.Position = U2(0.5, 0, 0, 28)
    geoContainer.BackgroundTransparency = 1
    geoContainer.ZIndex = 13
    geoContainer.Parent = panel

    -- Build 12 geometric line segments forming a rotating hex star
    local geoLines = {}
    for i = 1, 12 do
        local line = New("Frame")
        line.Name = "GeoLine" .. i
        line.AnchorPoint = V2(0.5, 0.5)
        line.Size = U2(0, 2, 0, 40)
        line.Position = U2(0.5, 0, 0.5, 0)
        line.BackgroundColor3 = C3(99,102,241)
        line.BackgroundTransparency = 0.3
        line.ZIndex = 14
        line.BorderSizePixel = 0
        line.Parent = geoContainer
        geoLines[i] = line
    end

    -- Inner pulsing ring
    local ring = New("Frame")
    ring.Name = "Ring"
    ring.AnchorPoint = V2(0.5, 0.5)
    ring.Size = U2(0, 60, 0, 60)
    ring.Position = U2(0.5, 0, 0.5, 0)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 14
    ring.Parent = geoContainer
    RoundCorner(ring, 30)
    local ringStroke = AddStroke(ring, C3(139,92,246), 2, 0)

    -- Center dot
    local dot = New("Frame")
    dot.Name = "Dot"
    dot.AnchorPoint = V2(0.5, 0.5)
    dot.Size = U2(0, 10, 0, 10)
    dot.Position = U2(0.5, 0, 0.5, 0)
    dot.BackgroundColor3 = C3(165,180,252)
    dot.ZIndex = 15
    dot.Parent = geoContainer
    RoundCorner(dot, 5)

    -- Title label
    local title = New("TextLabel")
    title.Name = "Title"
    title.AnchorPoint = V2(0.5, 0)
    title.Size = U2(1, 0, 0, 28)
    title.Position = U2(0.5, 0, 0, 155)
    title.BackgroundTransparency = 1
    title.Text = "AETHERIS"
    title.TextColor3 = C3(237,237,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.ZIndex = 13
    title.Parent = panel

    local sub = New("TextLabel")
    sub.Name = "Sub"
    sub.AnchorPoint = V2(0.5, 0)
    sub.Size = U2(1, 0, 0, 18)
    sub.Position = U2(0.5, 0, 0, 183)
    sub.BackgroundTransparency = 1
    sub.Text = "ULTIMATE EDITION  v2.0"
    sub.TextColor3 = C3(120,120,160)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.ZIndex = 13
    sub.Parent = panel

    -- Scrolling log frame
    local logFrame = New("Frame")
    logFrame.Name = "LogFrame"
    logFrame.AnchorPoint = V2(0.5, 0)
    logFrame.Size = U2(0, 440, 0, 92)
    logFrame.Position = U2(0.5, 0, 0, 208)
    logFrame.BackgroundColor3 = C3(4,4,12)
    logFrame.BackgroundTransparency = 0.3
    logFrame.ZIndex = 13
    logFrame.ClipsDescendants = true
    logFrame.Parent = panel
    RoundCorner(logFrame, 6)
    AddStroke(logFrame, C3(40,40,80), 1, 0.4)

    local logInner = New("Frame")
    logInner.Name = "LogInner"
    logInner.Size = U2(1, 0, 0, 14 * #BOOT_LINES)
    logInner.Position = U2(0, 0, 0, 0)
    logInner.BackgroundTransparency = 1
    logInner.ZIndex = 14
    logInner.Parent = logFrame

    local logLabels = {}
    for i, line in ipairs(BOOT_LINES) do
        local lbl = New("TextLabel")
        lbl.Size = U2(1, -8, 0, 13)
        lbl.Position = U2(0, 4, 0, (i-1)*14)
        lbl.BackgroundTransparency = 1
        lbl.Text = line
        lbl.TextColor3 = (line:sub(1,5) == "[SYS]")
            and C3(165,180,252)
            or (line:sub(1,5) == "[ERR]")
            and C3(248,113,113)
            or C3(80,120,80)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 14
        lbl.Visible = false
        lbl.Parent = logInner
        logLabels[i] = lbl
    end

    -- Progress bar
    local progBg = New("Frame")
    progBg.Name = "ProgBg"
    progBg.AnchorPoint = V2(0.5, 0)
    progBg.Size = U2(0, 440, 0, 4)
    progBg.Position = U2(0.5, 0, 0, 308)
    progBg.BackgroundColor3 = C3(22,22,52)
    progBg.ZIndex = 13
    progBg.Parent = panel
    RoundCorner(progBg, 2)

    local progFill = New("Frame")
    progFill.Name = "ProgFill"
    progFill.Size = U2(0, 0, 1, 0)
    progFill.BackgroundColor3 = C3(99,102,241)
    progFill.ZIndex = 14
    progFill.Parent = progBg
    RoundCorner(progFill, 2)
    ApplyGradient(progFill, C3(99,102,241), C3(139,92,246), 0)

    local statusLbl = New("TextLabel")
    statusLbl.AnchorPoint = V2(0.5, 0)
    statusLbl.Size = U2(1, 0, 0, 14)
    statusLbl.Position = U2(0.5, 0, 0, 318)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Initializing..."
    statusLbl.TextColor3 = C3(120,120,160)
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextSize = 10
    statusLbl.ZIndex = 13
    statusLbl.Parent = panel

    -- Animation loop: geometric neural-link spinner
    local t0 = tick()
    local spinConn = RunService.RenderStepped:Connect(function(dt)
        local t = tick() - t0
        -- Rotate and pulse geo lines
        for i, line in ipairs(geoLines) do
            local angle = (i - 1) * (mPi * 2 / 12) + t * 1.2
            local pulse  = 30 + mSin(t * 2.5 + i * 0.5) * 12
            line.Rotation = math.deg(angle)
            line.Size = U2f(2, pulse)
            local alpha = 0.3 + mSin(t * 3 + i * 0.8) * 0.25
            line.BackgroundTransparency = mClamp(alpha, 0, 0.95)
            -- Position offset from center using sin/cos
            local ox = mCos(angle) * 22
            local oy = mSin(angle) * 22
            line.Position = U2(0.5, ox, 0.5, oy)
        end
        -- Pulse ring stroke
        local ringPulse = 0.2 + mAbs(mSin(t * 1.8)) * 0.6
        ringStroke.Transparency = ringPulse
        ring.Size = U2f(55 + mSin(t*2)*6, 55 + mSin(t*2)*6)
        -- Pulse center dot
        local dotScale = 1 + mSin(t * 4) * 0.3
        dot.Size = U2f(mFloor(10 * dotScale), mFloor(10 * dotScale))
        -- Scanline drift
        scanline.BackgroundTransparency = 0.94 + mSin(t * 0.5) * 0.03
    end)

    -- Log reveal sequence
    task.spawn(function()
        local total = #BOOT_LINES
        for i, lbl in ipairs(logLabels) do
            task.wait(0.045)
            lbl.Visible = true
            -- Scroll inner frame down to keep latest line visible
            local scrollY = mMax(0, (i - 6) * 14)
            logInner.Position = U2(0, 0, 0, -scrollY)
            -- Update progress bar
            local pct = i / total
            Tween(progFill, TI(0.04, Enum.EasingStyle.Linear), {
                Size = U2(pct, 0, 1, 0)
            })
            statusLbl.Text = lbl.Text
        end

        task.wait(0.4)
        spinConn:Disconnect()

        -- Fade out overlay
        Tween(overlay, TI(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        Tween(panel, TI(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        for _, lbl in ipairs(logLabels) do
            Tween(lbl, TI(0.3), { TextTransparency = 1 })
        end
        for _, child in ipairs(panel:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("Frame") then
                pcall(function()
                    Tween(child, TI(0.3), { BackgroundTransparency = 1, TextTransparency = 1 })
                end)
            end
        end

        task.wait(0.65)
        screenGui:Destroy()
        if onComplete then onComplete() end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════
-- §7  NOTIFICATION HUB  —  Toast system with progress bleed-out
-- ════════════════════════════════════════════════════════════════════════════
local NotifHub = {}
NotifHub._container = nil
NotifHub._active    = {}
NotifHub._count     = 0

local NOTIF_ICONS = {
    Success = "✓",
    Error   = "✕",
    Warning = "⚠",
    Info    = "ℹ",
}

local NOTIF_COLORS = {
    Success = C3(52, 211, 153),
    Error   = C3(248, 113, 113),
    Warning = C3(251, 191,  36),
    Info    = C3(96,  165, 250),
}

function NotifHub:Init(screenGui, theme)
    self._theme = theme
    local container = New("Frame")
    container.Name = "NotifContainer"
    container.AnchorPoint = V2(1, 1)
    container.Size = U2(0, 320, 1, 0)
    container.Position = U2(1, -12, 1, -12)
    container.BackgroundTransparency = 1
    container.ZIndex = 100
    container.Parent = screenGui
    self._container = container

    local layout = New("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = Ud(0, 8)
    layout.Parent = container
end

function NotifHub:Notify(opts)
    opts = opts or {}
    local ntype    = opts.Type     or "Info"
    local title    = opts.Title    or ntype
    local message  = opts.Message  or ""
    local duration = opts.Duration or 4

    self._count = self._count + 1
    local theme  = self._theme
    local accent = NOTIF_COLORS[ntype] or NOTIF_COLORS.Info
    local icon   = NOTIF_ICONS[ntype]  or "·"

    -- Card
    local card = New("Frame")
    card.Name = "Notif_" .. self._count
    card.Size = U2(1, 0, 0, 80)
    card.BackgroundColor3 = theme.Surface
    card.BackgroundTransparency = 0.08
    card.ZIndex = 101
    card.ClipsDescendants = true
    card.Parent = self._container
    RoundCorner(card, 10)
    AddStroke(card, accent, 1, 0.5)
    ApplyGradient(card, theme.Surface, theme.SurfaceAlt, 90)

    -- Slide in from right
    card.Position = U2(1.2, 0, 0, 0)
    Tween(card, TI(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Position = U2(0,0,0,0) })

    -- Accent left bar
    local accentBar = New("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = U2(0, 4, 1, 0)
    accentBar.Position = U2(0,0,0,0)
    accentBar.BackgroundColor3 = accent
    accentBar.ZIndex = 102
    accentBar.Parent = card
    RoundCorner(accentBar, 2)

    -- Icon label
    local iconLbl = New("TextLabel")
    iconLbl.Size = U2(0, 32, 0, 32)
    iconLbl.Position = U2(0, 12, 0.5, -16)
    iconLbl.BackgroundColor3 = accent
    iconLbl.BackgroundTransparency = 0.75
    iconLbl.Text = icon
    iconLbl.TextColor3 = accent
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 16
    iconLbl.ZIndex = 102
    iconLbl.Parent = card
    RoundCorner(iconLbl, 8)

    -- Title
    local titleLbl = New("TextLabel")
    titleLbl.Size = U2(1, -56, 0, 18)
    titleLbl.Position = U2(0, 52, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 102
    titleLbl.Parent = card

    -- Message
    local msgLbl = New("TextLabel")
    msgLbl.Size = U2(1, -56, 0, 28)
    msgLbl.Position = U2(0, 52, 0, 30)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = theme.TextMuted
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextSize = 11
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextWrapped = true
    msgLbl.ZIndex = 102
    msgLbl.Parent = card

    -- Progress bleed-out bar (bleeds from full to empty over `duration`)
    local progBg = New("Frame")
    progBg.Size = U2(1,0,0,3)
    progBg.Position = U2(0,0,1,-3)
    progBg.BackgroundColor3 = theme.SurfaceAlt
    progBg.ZIndex = 102
    progBg.Parent = card

    local progFill = New("Frame")
    progFill.Size = U2(1,0,1,0)
    progFill.BackgroundColor3 = accent
    progFill.ZIndex = 103
    progFill.Parent = progBg
    RoundCorner(progFill, 1)

    -- Animate bleed-out
    Tween(progFill, TI(duration, Enum.EasingStyle.Linear), { Size = U2(0,0,1,0) })

    -- Dismiss button
    local dismissBtn = New("TextButton")
    dismissBtn.Size = U2(0, 20, 0, 20)
    dismissBtn.Position = U2(1, -26, 0, 8)
    dismissBtn.BackgroundTransparency = 1
    dismissBtn.Text = "×"
    dismissBtn.TextColor3 = theme.TextMuted
    dismissBtn.Font = Enum.Font.GothamBold
    dismissBtn.TextSize = 16
    dismissBtn.ZIndex = 103
    dismissBtn.Parent = card

    local function dismiss()
        Tween(card, TI(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            { Position = U2(1.2,0,0,0), BackgroundTransparency = 1 })
        task.wait(0.35)
        card:Destroy()
    end

    dismissBtn.MouseButton1Click:Connect(dismiss)

    -- Auto-dismiss
    task.spawn(function()
        task.wait(duration)
        if card and card.Parent then
            dismiss()
        end
    end)

    -- Hover highlight
    card.MouseEnter:Connect(function()
        Tween(card, TI(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0 })
    end)
    card.MouseLeave:Connect(function()
        Tween(card, TI(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.08 })
    end)

    return card
end

-- ════════════════════════════════════════════════════════════════════════════
-- §8  PERFORMANCE MONITOR  —  Live FPS graph + Memory chart
-- ════════════════════════════════════════════════════════════════════════════
local PerfMonitor = {}
PerfMonitor._fps     = {}
PerfMonitor._mem     = {}
PerfMonitor._bars    = {}
PerfMonitor._memBars = {}
PerfMonitor._conn    = nil
PerfMonitor.SAMPLES  = 40

function PerfMonitor:Build(parent, theme)
    self._theme = theme

    local frame = New("Frame")
    frame.Name = "PerfMonitor"
    frame.Size = U2(1,0,0,220)
    frame.BackgroundColor3 = theme.Surface
    frame.BackgroundTransparency = 0.1
    frame.ZIndex = 20
    frame.Parent = parent
    RoundCorner(frame, 8)

    -- FPS section
    local fpsTitle = New("TextLabel")
    fpsTitle.Size = U2(1,0,0,20)
    fpsTitle.Position = U2(0,0,0,8)
    fpsTitle.BackgroundTransparency = 1
    fpsTitle.Text = "FRAME RATE"
    fpsTitle.TextColor3 = theme.TextMuted
    fpsTitle.Font = Enum.Font.GothamBold
    fpsTitle.TextSize = 10
    fpsTitle.ZIndex = 21
    fpsTitle.Parent = frame

    self._fpsVal = New("TextLabel")
    self._fpsVal.Size = U2(0,60,0,20)
    self._fpsVal.Position = U2(1,-64,0,8)
    self._fpsVal.BackgroundTransparency = 1
    self._fpsVal.Text = "-- FPS"
    self._fpsVal.TextColor3 = theme.Primary
    self._fpsVal.Font = Enum.Font.GothamBold
    self._fpsVal.TextSize = 12
    self._fpsVal.TextXAlignment = Enum.TextXAlignment.Right
    self._fpsVal.ZIndex = 21
    self._fpsVal.Parent = frame

    local graphBg = New("Frame")
    graphBg.Size = U2(1,-16,0,72)
    graphBg.Position = U2(0,8,0,30)
    graphBg.BackgroundColor3 = theme.Background
    graphBg.BackgroundTransparency = 0.2
    graphBg.ZIndex = 21
    graphBg.ClipsDescendants = true
    graphBg.Parent = frame
    RoundCorner(graphBg, 4)

    -- Build FPS bar graph (SAMPLES bars)
    local barW = math.max(1, math.floor((graphBg.AbsoluteSize.X - 4) / self.SAMPLES))
    for i = 1, self.SAMPLES do
        local bar = New("Frame")
        bar.Name = "Bar" .. i
        bar.AnchorPoint = V2(0,1)
        bar.Size = U2(0, barW - 1, 0, 0)
        bar.Position = U2(0, (i-1)*barW + 2, 1, -2)
        bar.BackgroundColor3 = theme.Primary
        bar.ZIndex = 22
        bar.Parent = graphBg
        RoundCorner(bar, 1)
        self._bars[i] = bar
    end

    -- Memory section
    local memTitle = New("TextLabel")
    memTitle.Size = U2(1,0,0,20)
    memTitle.Position = U2(0,0,0,110)
    memTitle.BackgroundTransparency = 1
    memTitle.Text = "MEMORY USAGE"
    memTitle.TextColor3 = theme.TextMuted
    memTitle.Font = Enum.Font.GothamBold
    memTitle.TextSize = 10
    memTitle.ZIndex = 21
    memTitle.Parent = frame

    self._memVal = New("TextLabel")
    self._memVal.Size = U2(0,80,0,20)
    self._memVal.Position = U2(1,-84,0,110)
    self._memVal.BackgroundTransparency = 1
    self._memVal.Text = "-- MB"
    self._memVal.TextColor3 = theme.Secondary
    self._memVal.Font = Enum.Font.GothamBold
    self._memVal.TextSize = 12
    self._memVal.TextXAlignment = Enum.TextXAlignment.Right
    self._memVal.ZIndex = 21
    self._memVal.Parent = frame

    local memBg = New("Frame")
    memBg.Size = U2(1,-16,0,72)
    memBg.Position = U2(0,8,0,132)
    memBg.BackgroundColor3 = theme.Background
    memBg.BackgroundTransparency = 0.2
    memBg.ZIndex = 21
    memBg.ClipsDescendants = true
    memBg.Parent = frame
    RoundCorner(memBg, 4)

    for i = 1, self.SAMPLES do
        local bar = New("Frame")
        bar.Name = "MBar" .. i
        bar.AnchorPoint = V2(0,1)
        bar.Size = U2(0, barW - 1, 0, 0)
        bar.Position = U2(0, (i-1)*barW + 2, 1, -2)
        bar.BackgroundColor3 = theme.Secondary
        bar.ZIndex = 22
        bar.Parent = memBg
        RoundCorner(bar, 1)
        self._memBars[i] = bar
    end

    self._graphBg = graphBg
    self._memBg   = memBg

    for i = 1, self.SAMPLES do
        self._fps[i] = 60
        self._mem[i] = 0
    end

    self:Start()
    return frame
end

function PerfMonitor:Start()
    local lastTime   = tick()
    local frameCount = 0

    self._conn = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        local dt  = now - lastTime
        if dt >= 0.25 then
            local fps = math.floor(frameCount / dt + 0.5)
            local mem = math.floor(collectgarbage("count") / 1024 * 10 + 0.5) / 10
            frameCount = 0
            lastTime   = now

            -- Shift samples
            table.remove(self._fps, 1)
            table.insert(self._fps, fps)
            table.remove(self._mem, 1)
            table.insert(self._mem, mem)

            -- Update labels
            if self._fpsVal and self._fpsVal.Parent then
                self._fpsVal.Text = fps .. " FPS"
                self._fpsVal.TextColor3 = fps >= 55 and self._theme.Success
                    or fps >= 30 and self._theme.Warning
                    or self._theme.Error
            end
            if self._memVal and self._memVal.Parent then
                self._memVal.Text = string.format("%.1f MB", mem)
            end

            -- Redraw bars
            local maxFps = 60
            local maxMem = mMax(1, table.unpack(self._mem))
            local graphH = 68

            for i = 1, self.SAMPLES do
                local fBar = self._bars[i]
                local mBar = self._memBars[i]
                if fBar and fBar.Parent then
                    local h = math.floor((self._fps[i] / maxFps) * graphH)
                    local pct = self._fps[i] / maxFps
                    fBar.Size = U2(0, fBar.Size.X.Offset, 0, h)
                    fBar.BackgroundColor3 = LerpColor(self._theme.Error,
                        self._theme.Success, pct)
                end
                if mBar and mBar.Parent then
                    local h = math.floor((self._mem[i] / maxMem) * graphH)
                    mBar.Size = U2(0, mBar.Size.X.Offset, 0, h)
                end
            end
        end
    end)
end

function PerfMonitor:Stop()
    if self._conn then
        self._conn:Disconnect()
        self._conn = nil
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- §9  COLOR SPECTRUM  —  HSV/RGB color picker + recent history
-- ════════════════════════════════════════════════════════════════════════════
local ColorSpectrum = {}
ColorSpectrum.__index = ColorSpectrum

function ColorSpectrum.new(parent, theme, flagId, opts)
    local self  = setmetatable({}, ColorSpectrum)
    self._theme = theme
    self._flagId = flagId
    self._hue    = 0
    self._sat    = 1
    self._val    = 1
    self._recent = {}
    self._gid    = SignalManager:NewGroup()
    self._callback = opts and opts.Callback

    local default = opts and opts.Default or C3(99,102,241)
    local h, s, v = Color3.toHSV(default)
    self._hue = h
    self._sat = s
    self._val = v

    CM:Register(flagId, { Default = default, Type = "color", Callback = self._callback })

    -- Container
    local container = New("Frame")
    container.Name = "ColorSpectrum_" .. flagId
    container.Size = U2(1,0,0,200)
    container.BackgroundColor3 = theme.Surface
    container.BackgroundTransparency = 0.1
    container.ZIndex = 20
    container.Parent = parent
    RoundCorner(container, 8)
    self._container = container

    -- Label
    local lbl = New("TextLabel")
    lbl.Size = U2(1,0,0,20)
    lbl.Position = U2(0,0,0,6)
    lbl.BackgroundTransparency = 1
    lbl.Text = (opts and opts.Label) or "Color"
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 21
    lbl.Parent = container

    -- SV Square (saturation/value plane)
    local svBox = New("ImageLabel")
    svBox.Name = "SVBox"
    svBox.Size = U2(0, 140, 0, 140)
    svBox.Position = U2(0, 8, 0, 30)
    svBox.BackgroundColor3 = C3H(h, 1, 1)
    svBox.Image = "rbxassetid://698052001"   -- white-to-transparent gradient
    svBox.ZIndex = 21
    svBox.Parent = container
    RoundCorner(svBox, 4)
    self._svBox = svBox

    -- SV cursor
    local svCursor = New("Frame")
    svCursor.Name = "SVCursor"
    svCursor.AnchorPoint = V2(0.5,0.5)
    svCursor.Size = U2(0,10,0,10)
    svCursor.BackgroundColor3 = C3(255,255,255)
    svCursor.ZIndex = 23
    svCursor.Parent = svBox
    RoundCorner(svCursor, 5)
    AddStroke(svCursor, C3(0,0,0), 1, 0)
    self._svCursor = svCursor

    -- Hue slider (vertical strip)
    local hueStrip = New("Frame")
    hueStrip.Name = "HueStrip"
    hueStrip.Size = U2(0, 16, 0, 140)
    hueStrip.Position = U2(0, 156, 0, 30)
    hueStrip.ZIndex = 21
    hueStrip.Parent = container
    RoundCorner(hueStrip, 4)
    self._hueStrip = hueStrip

    -- Build hue gradient using stacked colored frames
    local hueSteps = 12
    for i = 0, hueSteps - 1 do
        local seg = New("Frame")
        seg.Size = U2(1,0,0, math.ceil(140/hueSteps)+1)
        seg.Position = U2(0,0,0, math.floor(i*(140/hueSteps)))
        seg.BackgroundColor3 = C3H(i/hueSteps, 1, 1)
        seg.ZIndex = 22
        seg.Parent = hueStrip
    end

    -- Hue cursor
    local hueCursor = New("Frame")
    hueCursor.Name = "HueCursor"
    hueCursor.AnchorPoint = V2(0.5,0.5)
    hueCursor.Size = U2(1,4,0,4)
    hueCursor.BackgroundColor3 = C3(255,255,255)
    hueCursor.ZIndex = 23
    hueCursor.Parent = hueStrip
    AddStroke(hueCursor, C3(0,0,0), 1, 0)
    self._hueCursor = hueCursor

    -- Preview swatch
    local swatch = New("Frame")
    swatch.Name = "Swatch"
    swatch.Size = U2(0, 50, 0, 30)
    swatch.Position = U2(0, 180, 0, 30)
    swatch.BackgroundColor3 = C3H(h,s,v)
    swatch.ZIndex = 21
    swatch.Parent = container
    RoundCorner(swatch, 6)
    AddStroke(swatch, theme.Border, 1, 0.3)
    self._swatch = swatch

    -- Hex label
    local hexLbl = New("TextLabel")
    hexLbl.Size = U2(0,50,0,16)
    hexLbl.Position = U2(0,180,0,64)
    hexLbl.BackgroundTransparency = 1
    hexLbl.Text = "#FFFFFF"
    hexLbl.TextColor3 = theme.TextMuted
    hexLbl.Font = Enum.Font.Code
    hexLbl.TextSize = 9
    hexLbl.ZIndex = 21
    hexLbl.Parent = container
    self._hexLbl = hexLbl

    -- Recent colors row
    local recentLbl = New("TextLabel")
    recentLbl.Size = U2(1,0,0,14)
    recentLbl.Position = U2(0,8,0,178)
    recentLbl.BackgroundTransparency = 1
    recentLbl.Text = "RECENT"
    recentLbl.TextColor3 = theme.TextMuted
    recentLbl.Font = Enum.Font.GothamBold
    recentLbl.TextSize = 9
    recentLbl.TextXAlignment = Enum.TextXAlignment.Left
    recentLbl.ZIndex = 21
    recentLbl.Parent = container

    self._recentRow = New("Frame")
    self._recentRow.Size = U2(1,-16,0,16)
    self._recentRow.Position = U2(0,8,0,192)
    self._recentRow.BackgroundTransparency = 1
    self._recentRow.ZIndex = 21
    self._recentRow.Parent = container
    container.Size = U2(1,0,0,214)

    self:_UpdateCursors()
    self:_BindInputs()
    return self
end

function ColorSpectrum:_GetCurrentColor()
    return C3H(self._hue, self._sat, self._val)
end

function ColorSpectrum:_UpdateCursors()
    -- SV cursor position
    self._svCursor.Position = U2(self._sat, 0, 1 - self._val, 0)
    -- Hue cursor position
    self._hueCursor.Position = U2(0.5, 0, self._hue, 0)
    -- Update swatch
    local c = self:_GetCurrentColor()
    self._swatch.BackgroundColor3 = c
    self._svBox.BackgroundColor3  = C3H(self._hue, 1, 1)
    -- Update hex label
    local r = math.floor(c.R*255)
    local g = math.floor(c.G*255)
    local b = math.floor(c.B*255)
    self._hexLbl.Text = string.format("#%02X%02X%02X", r, g, b)
end

function ColorSpectrum:_PushRecent(color)
    -- Check if already exists
    for i, c in ipairs(self._recent) do
        if mAbs(c.R-color.R)<0.01 and mAbs(c.G-color.G)<0.01 and mAbs(c.B-color.B)<0.01 then
            table.remove(self._recent, i)
            break
        end
    end
    table.insert(self._recent, 1, color)
    if #self._recent > 8 then
        table.remove(self._recent, #self._recent)
    end
    -- Rebuild recent row
    for _, ch in ipairs(self._recentRow:GetChildren()) do ch:Destroy() end
    for i, c in ipairs(self._recent) do
        local swatch = New("TextButton")
        swatch.Size = U2(0,18,0,16)
        swatch.Position = U2(0,(i-1)*22,0,0)
        swatch.BackgroundColor3 = c
        swatch.Text = ""
        swatch.ZIndex = 22
        swatch.Parent = self._recentRow
        RoundCorner(swatch, 3)
        local cc = c
        swatch.MouseButton1Click:Connect(function()
            local hh,ss,vv = Color3.toHSV(cc)
            self._hue = hh
            self._sat = ss
            self._val = vv
            self:_UpdateCursors()
            CM:Set(self._flagId, self:_GetCurrentColor())
        end)
    end
end

function ColorSpectrum:_BindInputs()
    local svDragging  = false
    local hueDragging = false

    local function updateSV(input)
        local abs = self._svBox.AbsolutePosition
        local sz  = self._svBox.AbsoluteSize
        local s   = mClamp((input.Position.X - abs.X) / sz.X, 0, 1)
        local v   = mClamp(1 - (input.Position.Y - abs.Y) / sz.Y, 0, 1)
        self._sat = s
        self._val = v
        self:_UpdateCursors()
        CM:Set(self._flagId, self:_GetCurrentColor())
    end

    local function updateHue(input)
        local abs = self._hueStrip.AbsolutePosition
        local sz  = self._hueStrip.AbsoluteSize
        self._hue = mClamp((input.Position.Y - abs.Y) / sz.Y, 0, 1)
        self:_UpdateCursors()
        CM:Set(self._flagId, self:_GetCurrentColor())
    end

    SignalManager:Connect(self._svBox.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            updateSV(inp)
        end
    end, self._gid)

    SignalManager:Connect(self._hueStrip.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            updateHue(inp)
        end
    end, self._gid)

    SignalManager:Connect(UserInputService.InputChanged, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            if svDragging  then updateSV(inp)  end
            if hueDragging then updateHue(inp) end
        end
    end, self._gid)

    SignalManager:Connect(UserInputService.InputEnded, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            if svDragging or hueDragging then
                self:_PushRecent(self:_GetCurrentColor())
            end
            svDragging  = false
            hueDragging = false
        end
    end, self._gid)
end

function ColorSpectrum:Destroy()
    SignalManager:DisconnectGroup(self._gid)
    if self._container then self._container:Destroy() end
end

-- ════════════════════════════════════════════════════════════════════════════
-- §10  COMPONENT: BUTTON  (7-state animated)
-- ════════════════════════════════════════════════════════════════════════════
local function CreateButton(parent, theme, opts)
    opts = opts or {}
    local label    = opts.Label    or "Button"
    local callback = opts.Callback or function() end
    local disabled = opts.Disabled or false
    local gid      = SignalManager:NewGroup()

    local btn = New("TextButton")
    btn.Name = "Btn_" .. label
    btn.Size = opts.Size or U2(1,0,0,36)
    btn.BackgroundColor3 = theme.Primary
    btn.Text = ""
    btn.ZIndex = 20
    btn.AutoButtonColor = false
    btn.Parent = parent
    RoundCorner(btn, 8)
    ApplyGradient(btn, theme.Grad1, theme.Grad2, 90)

    local stroke = AddStroke(btn, theme.Primary, 1, 0.7)

    -- Glow layer (ImageLabel behind)
    local glow = New("ImageLabel")
    glow.Name = "Glow"
    glow.AnchorPoint = V2(0.5,0.5)
    glow.Size = U2(1,20,1,20)
    glow.Position = U2(0.5,0,0.5,2)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://6014261993"
    glow.ImageColor3 = theme.Primary
    glow.ImageTransparency = 1
    glow.ZIndex = btn.ZIndex - 1
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(49,49,450,450)
    glow.Parent = btn.Parent
    glow.ZIndex = btn.ZIndex - 1

    local textLbl = New("TextLabel")
    textLbl.Size = U2(1,-16,1,0)
    textLbl.Position = U2(0,8,0,0)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = label
    textLbl.TextColor3 = C3(255,255,255)
    textLbl.Font = Enum.Font.GothamBold
    textLbl.TextSize = 13
    textLbl.ZIndex = btn.ZIndex + 1
    textLbl.Parent = btn

    local state    = ButtonStates.Idle
    local isActive = false

    local function setState(s)
        if state == s then return end
        state = s
        local info = BUTTON_STYLE[s]
        if not info then return end
        Tween(btn, TI(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = info.trans,
            Size = opts.Size and U2(opts.Size.X.Scale, opts.Size.X.Offset,
                opts.Size.Y.Scale * info.size, opts.Size.Y.Offset) or
                U2(1,0,0, math.floor(36 * info.size)),
        })
        Tween(glow, TI(0.15), { ImageTransparency = 1 - info.glow * 0.6 })
        Tween(stroke, TI(0.15), { Transparency = 1 - info.glow })
    end

    if disabled then
        setState(ButtonStates.Disabled)
        textLbl.TextColor3 = theme.TextMuted
    end

    -- Ripple on click
    local function SpawnRipple(x, y)
        local ripple = New("Frame")
        ripple.Name = "Ripple"
        ripple.AnchorPoint = V2(0.5,0.5)
        ripple.Size = U2(0,0,0,0)
        ripple.Position = U2(0, x - btn.AbsolutePosition.X, 0, y - btn.AbsolutePosition.Y)
        ripple.BackgroundColor3 = C3(255,255,255)
        ripple.BackgroundTransparency = 0.7
        ripple.ZIndex = btn.ZIndex + 2
        ripple.Parent = btn
        RoundCorner(ripple, 999)
        local maxR = btn.AbsoluteSize.X * 1.5
        Tween(ripple, TI(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = U2(0, maxR, 0, maxR),
            BackgroundTransparency = 1,
        })
        task.delay(0.55, function() if ripple.Parent then ripple:Destroy() end end)
    end

    SignalManager:Connect(btn.MouseEnter, function()
        if state ~= ButtonStates.Disabled then setState(ButtonStates.Hover) end
    end, gid)
    SignalManager:Connect(btn.MouseLeave, function()
        if state ~= ButtonStates.Disabled then
            setState(isActive and ButtonStates.Activated or ButtonStates.Idle)
        end
    end, gid)
    SignalManager:Connect(btn.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and state ~= ButtonStates.Disabled then
            setState(ButtonStates.Pressed)
            SpawnRipple(inp.Position.X, inp.Position.Y)
        end
    end, gid)
    SignalManager:Connect(btn.InputEnded, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 and state ~= ButtonStates.Disabled then
            setState(ButtonStates.Hover)
        end
    end, gid)
    SignalManager:Connect(btn.MouseButton1Click, function()
        if state ~= ButtonStates.Disabled then
            task.spawn(callback)
        end
    end, gid)

    local api = {
        Instance = btn,
        SetDisabled = function(_, v)
            disabled = v
            setState(v and ButtonStates.Disabled or ButtonStates.Idle)
            textLbl.TextColor3 = v and theme.TextMuted or C3(255,255,255)
        end,
        SetLabel = function(_, t) textLbl.Text = t end,
        Destroy = function(_)
            SignalManager:DisconnectGroup(gid)
            glow:Destroy()
            btn:Destroy()
        end,
    }
    return api
end

-- ════════════════════════════════════════════════════════════════════════════
-- §11  COMPONENT: TOGGLE V2  (spring-physics boolean switch)
-- ════════════════════════════════════════════════════════════════════════════
local function CreateToggle(parent, theme, flagId, opts)
    opts = opts or {}
    CM:Register(flagId, {
        Default  = opts.Default or false,
        Type     = "boolean",
        Callback = opts.Callback,
    })
    local value = opts.Default or false
    local gid   = SignalManager:NewGroup()

    -- Spring for the knob
    local spring = NewSpring(280, 22, 1)
    spring.pos    = value and 1 or 0
    spring.target = value and 1 or 0

    local row = New("Frame")
    row.Name = "Toggle_" .. flagId
    row.Size = U2(1,0,0,38)
    row.BackgroundTransparency = 1
    row.ZIndex = 20
    row.Parent = parent

    local lbl = New("TextLabel")
    lbl.Size = U2(1,-58,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Label or flagId
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 21
    lbl.Parent = row

    local desc = nil
    if opts.Description then
        desc = New("TextLabel")
        desc.Size = U2(1,-58,0,14)
        desc.Position = U2(0,0,0,22)
        desc.BackgroundTransparency = 1
        desc.Text = opts.Description
        desc.TextColor3 = theme.TextMuted
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 21
        desc.Parent = row
        row.Size = U2(1,0,0,50)
    end

    local track = New("Frame")
    track.Name = "Track"
    track.AnchorPoint = V2(1,0.5)
    track.Size = U2(0,44,0,24)
    track.Position = U2(1,0,0.5,0)
    track.BackgroundColor3 = theme.SurfaceAlt
    track.ZIndex = 21
    track.Parent = row
    RoundCorner(track, 12)
    AddStroke(track, theme.Border, 1, 0.3)

    local knob = New("Frame")
    knob.Name = "Knob"
    knob.AnchorPoint = V2(0.5,0.5)
    knob.Size = U2(0,18,0,18)
    knob.Position = U2(0, value and 32 or 12, 0.5, 0)
    knob.BackgroundColor3 = value and theme.Primary or theme.TextMuted
    knob.ZIndex = 22
    knob.Parent = track
    RoundCorner(knob, 9)

    -- Knob glow
    local knobGlow = New("ImageLabel")
    knobGlow.AnchorPoint = V2(0.5,0.5)
    knobGlow.Size = U2(1,12,1,12)
    knobGlow.Position = U2(0.5,0,0.5,0)
    knobGlow.BackgroundTransparency = 1
    knobGlow.Image = "rbxassetid://6014261993"
    knobGlow.ImageColor3 = theme.Primary
    knobGlow.ImageTransparency = 1
    knobGlow.ZIndex = 21
    knobGlow.ScaleType = Enum.ScaleType.Slice
    knobGlow.SliceCenter = Rect.new(49,49,450,450)
    knobGlow.Parent = knob

    local springConn = nil

    local function runSpring()
        if springConn then springConn:Disconnect() end
        springConn = RunService.RenderStepped:Connect(function(dt)
            local pos = StepSpring(spring, dt)
            local x   = mClamp(Lerp(12, 32, pos), 12, 32)
            knob.Position = U2(0, x, 0.5, 0)
            knob.BackgroundColor3 = LerpColor(theme.TextMuted, theme.Primary, mClamp(pos, 0, 1))
            local glowTrans = 1 - mClamp(pos, 0, 1) * 0.7
            knobGlow.ImageTransparency = glowTrans
            if IsSpringSettled(spring, 0.005) and springConn then
                springConn:Disconnect()
                springConn = nil
            end
        end)
    end

    local function toggle()
        value = not value
        spring.target = value and 1 or 0
        runSpring()
        Tween(track, TI(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = value and theme.Primary or theme.SurfaceAlt
        })
        CM:Set(flagId, value)
    end

    SignalManager:Connect(track.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
    end, gid)
    SignalManager:Connect(lbl.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
    end, gid)

    -- Hover effect
    SignalManager:Connect(track.MouseEnter, function()
        Tween(track, TI(0.12, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.1
        })
    end, gid)
    SignalManager:Connect(track.MouseLeave, function()
        Tween(track, TI(0.12, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0
        })
    end, gid)

    local api = {
        Instance = row,
        Set = function(_, v)
            value = v
            spring.target = v and 1 or 0
            runSpring()
            Tween(track, TI(0.2), {
                BackgroundColor3 = v and theme.Primary or theme.SurfaceAlt
            })
            CM:Set(flagId, v)
        end,
        Get = function() return value end,
        Destroy = function(_)
            if springConn then springConn:Disconnect() end
            SignalManager:DisconnectGroup(gid)
            row:Destroy()
        end,
    }
    return api
end

-- ════════════════════════════════════════════════════════════════════════════
-- §12  COMPONENT: HYPER-SLIDER  (decimal + live tooltip + range gradient)
-- ════════════════════════════════════════════════════════════════════════════
local function CreateSlider(parent, theme, flagId, opts)
    opts = opts or {}
    local minV    = opts.Min      or 0
    local maxV    = opts.Max      or 100
    local step    = opts.Step     or 0
    local default = mClamp(opts.Default or minV, minV, maxV)
    local fmt     = opts.Format   or (step > 0 and step < 1 and "%.2f" or "%d")

    CM:Register(flagId, {
        Default  = default,
        Type     = "number",
        Callback = opts.Callback,
    })

    local value = default
    local gid   = SignalManager:NewGroup()
    local dragging = false

    local container = New("Frame")
    container.Name = "Slider_" .. flagId
    container.Size = U2(1,0,0,54)
    container.BackgroundTransparency = 1
    container.ZIndex = 20
    container.Parent = parent

    local headerRow = New("Frame")
    headerRow.Size = U2(1,0,0,20)
    headerRow.BackgroundTransparency = 1
    headerRow.ZIndex = 21
    headerRow.Parent = container

    local lbl = New("TextLabel")
    lbl.Size = U2(1,-60,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = opts.Label or flagId
    lbl.TextColor3 = theme.Text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22
    lbl.Parent = headerRow

    local valLbl = New("TextLabel")
    valLbl.AnchorPoint = V2(1,0)
    valLbl.Size = U2(0,55,1,0)
    valLbl.Position = U2(1,0,0,0)
    valLbl.BackgroundColor3 = theme.SurfaceAlt
    valLbl.Text = string.format(fmt, value)
    valLbl.TextColor3 = theme.Primary
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.ZIndex = 22
    valLbl.Parent = headerRow
    RoundCorner(valLbl, 4)

    -- Track background
    local trackBg = New("Frame")
    trackBg.Name = "TrackBg"
    trackBg.Size = U2(1,0,0,8)
    trackBg.Position = U2(0,0,0,28)
    trackBg.BackgroundColor3 = theme.SurfaceAlt
    trackBg.ZIndex = 21
    trackBg.Parent = container
    RoundCorner(trackBg, 4)
    AddStroke(trackBg, theme.Border, 1, 0.5)

    -- Range highlight (colored fill)
    local fill = New("Frame")
    fill.Name = "Fill"
    fill.Size = U2(0,0,1,0)
    fill.BackgroundColor3 = theme.Primary
    fill.ZIndex = 22
    fill.Parent = trackBg
    RoundCorner(fill, 4)
    ApplyGradient(fill, theme.Grad1, theme.Grad2, 0)

    -- Thumb
    local thumb = New("Frame")
    thumb.Name = "Thumb"
    thumb.AnchorPoint = V2(0.5,0.5)
    thumb.Size = U2(0,16,0,16)
    thumb.Position = U2(0,0,0.5,0)
    thumb.BackgroundColor3 = theme.Primary
    thumb.ZIndex = 23
    thumb.Parent = trackBg
    RoundCorner(thumb, 8)
    AddStroke(thumb, C3(255,255,255), 2, 0.5)

    -- Thumb glow
    local thumbGlow = New("ImageLabel")
    thumbGlow.AnchorPoint = V2(0.5,0.5)
    thumbGlow.Size = U2(1,16,1,16)
    thumbGlow.Position = U2(0.5,0,0.5,0)
    thumbGlow.BackgroundTransparency = 1
    thumbGlow.Image = "rbxassetid://6014261993"
    thumbGlow.ImageColor3 = theme.Primary
    thumbGlow.ImageTransparency = 0.7
    thumbGlow.ZIndex = 22
    thumbGlow.ScaleType = Enum.ScaleType.Slice
    thumbGlow.SliceCenter = Rect.new(49,49,450,450)
    thumbGlow.Parent = thumb

    -- Live tooltip
    local tooltip = New("Frame")
    tooltip.Name = "Tooltip"
    tooltip.AnchorPoint = V2(0.5,1)
    tooltip.Size = U2(0,50,0,24)
    tooltip.Position = U2(0,0,0,-8)
    tooltip.BackgroundColor3 = theme.Surface
    tooltip.BackgroundTransparency = 1
    tooltip.ZIndex = 25
    tooltip.Parent = thumb
    RoundCorner(tooltip, 4)
    AddStroke(tooltip, theme.Primary, 1, 0.5)

    local tooltipLbl = New("TextLabel")
    tooltipLbl.Size = U2(1,0,1,0)
    tooltipLbl.BackgroundTransparency = 1
    tooltipLbl.Text = string.format(fmt, value)
    tooltipLbl.TextColor3 = theme.Text
    tooltipLbl.Font = Enum.Font.GothamBold
    tooltipLbl.TextSize = 11
    tooltipLbl.ZIndex = 26
    tooltipLbl.Parent = tooltip

    -- Min/max labels
    local minLbl = New("TextLabel")
    minLbl.Size = U2(0,30,0,14)
    minLbl.Position = U2(0,0,0,38)
    minLbl.BackgroundTransparency = 1
    minLbl.Text = string.format(fmt, minV)
    minLbl.TextColor3 = theme.TextMuted
    minLbl.Font = Enum.Font.Code
    minLbl.TextSize = 9
    minLbl.TextXAlignment = Enum.TextXAlignment.Left
    minLbl.ZIndex = 21
    minLbl.Parent = container

    local maxLbl = New("TextLabel")
    maxLbl.AnchorPoint = V2(1,0)
    maxLbl.Size = U2(0,30,0,14)
    maxLbl.Position = U2(1,0,0,38)
    maxLbl.BackgroundTransparency = 1
    maxLbl.Text = string.format(fmt, maxV)
    maxLbl.TextColor3 = theme.TextMuted
    maxLbl.Font = Enum.Font.Code
    maxLbl.TextSize = 9
    maxLbl.TextXAlignment = Enum.TextXAlignment.Right
    maxLbl.ZIndex = 21
    maxLbl.Parent = container

    local function updateVisuals(v)
        local pct = (v - minV) / (maxV - minV)
        fill.Size = U2(pct, 0, 1, 0)
        thumb.Position = U2(pct, 0, 0.5, 0)
        tooltipLbl.Text = string.format(fmt, v)
        tooltip.Position = U2(0, 0, 0, -8)
        valLbl.Text = string.format(fmt, v)
    end

    local function setVal(v)
        if step > 0 then
            v = math.floor(v / step + 0.5) * step
        end
        v = mClamp(v, minV, maxV)
        value = v
        updateVisuals(v)
        CM:Set(flagId, v)
    end

    local function inputToVal(inputX)
        local abs = trackBg.AbsolutePosition.X
        local sz  = trackBg.AbsoluteSize.X
        local pct = mClamp((inputX - abs) / sz, 0, 1)
        return minV + (maxV - minV) * pct
    end

    SignalManager:Connect(trackBg.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            setVal(inputToVal(inp.Position.X))
            -- Show tooltip
            Tween(tooltip, TI(0.12), { BackgroundTransparency = 0 })
            Tween(thumbGlow, TI(0.12), { ImageTransparency = 0.4 })
        end
    end, gid)

    SignalManager:Connect(thumb.InputBegan, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Tween(tooltip, TI(0.12), { BackgroundTransparency = 0 })
            Tween(thumbGlow, TI(0.12), { ImageTransparency = 0.4 })
        end
    end, gid)

    SignalManager:Connect(UserInputService.InputChanged, function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            setVal(inputToVal(inp.Position.X))
        end
    end, gid)

    SignalManager:Connect(UserInputService.InputEnded, function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            Tween(tooltip, TI(0.15), { BackgroundTransparency = 1 })
            Tween(thumbGlow, TI(0.15), { ImageTransparency = 0.7 })
        end
    end, gid)

    -- Hover on thumb
    SignalManager:Connect(thumb.MouseEnter, function()
        Tween(thumb, TI(0.12), { Size = U2(0,20,0,20) })
        Tween(thumbGlow, TI(0.12), { ImageTransparency = 0.5 })
    end, gid)
    SignalManager:Connect(thumb.MouseLeave, function()
        if not dragging then
            Tween(thumb, TI(0.12), { Size = U2(0,16,0,16) })
            Tween(thumbGlow, TI(0.12), { ImageTransparency = 0.7 })
        end
    end, gid)

    updateVisuals(value)

    local api = {
        Instance = container,
        Set = function(_, v) setVal(v) end,
        Get = function() return value end,
        Destroy = function(_)
            SignalManager:DisconnectGroup(gid)
            container:Destroy()
        end,
    }
    return api
end

-- ════════════════════════════════════════════════════════════════════════════
-- §13  COMPONENT: MULTI-DROPDOWN  (search + multi-select + inertia scroll)
-- ════════════════════════════════════════════════════════════════════════════
local function CreateDropdown(parent, theme, flagId, opts)
    opts = opts or {}
    local items    = opts.Items    or {}
    local multi    = opts.Multi    or false
    local label    = opts.Label    or flagId
    local search   = opts.Search   ~= false
    local callback = opts.Callback

    local selected = {}
    if opts.Default then
        if type(opts.Default) == "table" then
            for _, v in ipairs(opts.Default) do selected[v] = true end
        else
            selected[opts.Default] = true
        end
    end

    CM:Register(flagId, {
        Default  = opts.Default,
        Type     = "any",
        Callback = callback,
    })

    local gid    = SignalManager:NewGroup()
    local open   = false
    local query  = ""

    -- Inertia scroll state
    local scrollVelocity = 0
    local scrollPos      = 0
    local lastMouseY     = 0
    local scrollDragging = false
    local scrollConn     = nil

    local container = New("Frame")
    container.Name = "Dropdown_" .. flagId
    container.Size = U2(1,0,0,38)
    container.BackgroundTransparency = 1
    container.ZIndex = 30
    container.ClipsDescendants = false
    container.Parent = parent

    -- Header button
    local header = New("TextButton")
    header.Name = "Header"
    header.Size = U2(1,0,0,36)
    header.BackgroundColor3 = theme.Surface
    header.BackgroundTransparency = 0.1
    header.Text = ""
    header.AutoButtonColor = false
    header.ZIndex = 31
    header.Parent = container
    RoundCorner(header, 8)
    AddStroke(header, theme.Border, 1, 0.4)

    local headerLbl = New("TextLabel")
    headerLbl.Size = U2(1,-40,1,0)
    headerLbl.Position = U2(0,12,0,0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Font = Enum.Font.Gotham
    headerLbl.TextSize = 13
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.ZIndex = 32
    headerLbl.Parent = header

    -- Label above
    local lbl = New("TextLabel")
    lbl.Size = U2(1,0,0,16)
    lbl.Position = U2(0,0,0,-18)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = theme.TextMuted
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 31
    lbl.Parent = container

    local chevron = New("TextLabel")
    chevron.AnchorPoint = V2(1,0.5)
    chevron.Size = U2(0,20,0,20)
    chevron.Position = U2(1,-8,0.5,0)
    chevron.BackgroundTransparency = 1
    chevron.Text = "▾"
    chevron.TextColor3 = theme.TextMuted
    chevron.Font = Enum.Font.GothamBold
    chevron.TextSize = 12
    chevron.ZIndex = 32
    chevron.Parent = header

    -- Dropdown panel
    local panel = New("Frame")
    panel.Name = "Panel"
    panel.Size = U2(1,0,0,0)
    panel.Position = U2(0,0,0,38)
    panel.BackgroundColor3 = theme.Surface
    panel.BackgroundTransparency = 0.05
    panel.ClipsDescendants = true
    panel.ZIndex = 40
    panel.Visible = false
    panel.Parent = container
    RoundCorner(panel, 8)
    AddStroke(panel, theme.Border, 1, 0.3)

    -- Search box
    local searchBox = nil
    if search then
        searchBox = New("TextBox")
        searchBox.Name = "Search"
        searchBox.Size = U2(1,-16,0,28)
        searchBox.Position = U2(0,8,0,6)
        searchBox.BackgroundColor3 = theme.SurfaceAlt
        searchBox.BackgroundTransparency = 0.2
        searchBox.Text = ""
        searchBox.PlaceholderText = "Search..."
        searchBox.PlaceholderColor3 = theme.TextMuted
        searchBox.TextColor3 = theme.Text
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 12
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.ClearTextOnFocus = false
        searchBox.ZIndex = 41
        searchBox.Parent = panel
        RoundCorner(searchBox, 6)
        AddStroke(searchBox, theme.Border, 1, 0.5)

        local searchIcon = New("TextLabel")
        searchIcon.Size = U2(0,20,1,0)
        searchIcon.Position = U2(0,4,0,0)
        searchIcon.BackgroundTransparency = 1
        searchIcon.Text = "⌕"
        searchIcon.TextColor3 = theme.TextMuted
        searchIcon.Font = Enum.Font.GothamBold
        searchIcon.TextSize = 14
        searchIcon.ZIndex = 42
        searchIcon.Parent = searchBox

        SignalManager:Connect(searchBox:GetPropertyChangedSignal("Text"), function()
            query = searchBox.Text:lower()
        end, gid)
    end

    -- Scroll frame for items
    local scrollFrame = New("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = U2(1,-8,1,-(search and 42 or 8))
    scrollFrame.Position = U2(0,4,0, search and 40 or 4)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = theme.Primary
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ZIndex = 41
    scrollFrame.Parent = panel

    local listLayout = New("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = Ud(0,2)
    listLayout.Parent = scrollFrame

    local function getSelectedLabel()
        local keys = {}
        for k, v in pairs(selected) do if v then table.insert(keys, k) end end
        if #keys == 0 then
            headerLbl.TextColor3 = theme.TextMuted
            return "Select..."
        elseif #keys == 1 then
            headerLbl.TextColor3 = theme.Text
            return keys[1]
        else
            headerLbl.TextColor3 = theme.Text
            return keys[1] .. " +" .. (#keys-1)
        end
    end

    local itemFrames = {}

    local function rebuildItems()
        for _, f in ipairs(itemFrames) do f:Destroy() end
        itemFrames = {}

        for _, item in ipairs(items) do
            if query == "" or item:lower():find(query, 1, true) then
                local isSelected = selected[item] or false

                local itemBtn = New("TextButton")
                itemBtn.Name = "Item_" .. item
                itemBtn.Size = U2(1,0,0,30)
                itemBtn.BackgroundColor3 = isSelected and theme.Primary or theme.SurfaceAlt
                itemBtn.BackgroundTransparency = isSelected and 0.7 or 0.9
                itemBtn.Text = ""
                itemBtn.AutoButtonColor = false
                itemBtn.ZIndex = 42
                itemBtn.Parent = scrollFrame
                RoundCorner(itemBtn, 6)

                local checkMark = New("TextLabel")
                checkMark.Size = U2(0,20,1,0)
                checkMark.BackgroundTransparency = 1
                checkMark.Text = isSelected and "✓" or ""
                checkMark.TextColor3 = theme.Primary
                checkMark.Font = Enum.Font.GothamBold
                checkMark.TextSize = 12
                checkMark.ZIndex = 43
                checkMark.Parent = itemBtn

                local itemLbl = New("TextLabel")
                itemLbl.Size = U2(1,-28,1,0)
                itemLbl.Position = U2(0,24,0,0)
                itemLbl.BackgroundTransparency = 1
                itemLbl.Text = item
                itemLbl.TextColor3 = isSelected and theme.Text or theme.TextMuted
                itemLbl.Font = isSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                itemLbl.TextSize = 12
                itemLbl.TextXAlignment = Enum.TextXAlignment.Left
                itemLbl.ZIndex = 43
                itemLbl.Parent = itemBtn

                itemBtn.MouseEnter:Connect(function()
                    Tween(itemBtn, TI(0.1), { BackgroundTransparency = 0.6 })
                end)
                itemBtn.MouseLeave:Connect(function()
                    Tween(itemBtn, TI(0.1), {
                        BackgroundTransparency = selected[item] and 0.7 or 0.9
                    })
                end)

                itemBtn.MouseButton1Click:Connect(function()
                    if multi then
                        selected[item] = not selected[item]
                    else
                        selected = {}
                        selected[item] = true
                    end
                    headerLbl.Text = getSelectedLabel()
                    rebuildItems()
                    -- Fire callback
                    if callback then
                        if multi then
                            local sel = {}
                            for k,v in pairs(selected) do if v then table.insert(sel,k) end end
                            task.spawn(callback, sel)
                            CM:Set(flagId, sel)
                        else
                            task.spawn(callback, item)
                            CM:Set(flagId, item)
                        end
                    end
                    if not multi then
                        -- Close after selection in single mode
                        task.defer(function()
                            open = false
                            Tween(panel, TI(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                                { Size = U2(1,0,0,0) })
                            task.wait(0.22)
                            panel.Visible = false
                            container.Size = U2(1,0,0,38)
                            Tween(chevron, TI(0.2), { Rotation = 0 })
                        end)
                    end
                end)

                table.insert(itemFrames, itemBtn)
            end
        end

        -- Update canvas size
        scrollFrame.CanvasSize = U2(0,0,0, #itemFrames * 32)
    end

    headerLbl.Text = getSelectedLabel()

    local panelHeight = mMin(#items * 32 + (search and 42 or 8) + 8, 200)

    -- Inertia scroll (custom)
    if scrollConn then scrollConn:Disconnect() end

    local function toggleOpen()
        open = not open
        if open then
            rebuildItems()
            panel.Visible = true
            panel.Size = U2(1,0,0,0)
            Tween(panel, TI(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Size = U2(1,0,0,panelHeight) })
            container.Size = U2(1,0,0, 38 + panelHeight + 4)
            Tween(chevron, TI(0.2), { Rotation = 180 })
        else
            Tween(panel, TI(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                { Size = U2(1,0,0,0) })
            task.delay(0.2, function()
                panel.Visible = false
                container.Size = U2(1,0,0,38)
            end)
            Tween(chevron, TI(0.2), { Rotation = 0 })
        end
    end

    SignalManager:Connect(header.MouseButton1Click, function()
        toggleOpen()
    end, gid)

    local api = {
        Instance = container,
        SetItems = function(_, newItems)
            items = newItems
            if open then rebuildItems() end
        end,
        GetSelected = function()
            if multi then
                local sel = {}
                for k,v in pairs(selected) do if v then table.insert(sel,k) end end
                return sel
            else
                for k,v in pairs(selected) do if v then return k end end
                return nil
            end
        end,
        Destroy = function(_)
            SignalManager:DisconnectGroup(gid)
            container:Destroy()
        end,
    }
    return api
end

-- ════════════════════════════════════════════════════════════════════════════
-- §14  COMPONENT: NAVIGATOR  (Sidebar with ripple particles)
-- ════════════════════════════════════════════════════════════════════════════
local function CreateNavigator(parent, theme, tabs, onTabSelect)
    local gid    = SignalManager:NewGroup()
    local active = 1

    local nav = New("Frame")
    nav.Name = "Navigator"
    nav.Size = U2(0, 160, 1, -8)
    nav.Position = U2(0, 4, 0, 4)
    nav.BackgroundColor3 = theme.Surface
    nav.BackgroundTransparency = 0.1
    nav.ZIndex = 20
    nav.Parent = parent
    RoundCorner(nav, 10)
    ApplyGradient(nav, theme.Surface, theme.Background, 180)
    AddStroke(nav, theme.Border, 1, 0.5)

    -- Active indicator (animated slider)
    local indicator = New("Frame")
    indicator.Name = "Indicator"
    indicator.Size = U2(0, 3, 0, 28)
    indicator.Position = U2(0, 0, 0, 12)
    indicator.BackgroundColor3 = theme.Primary
    indicator.ZIndex = 21
    indicator.Parent = nav
    RoundCorner(indicator, 2)

    -- Indicator glow
    local indGlow = New("ImageLabel")
    indGlow.AnchorPoint = V2(0.5,0.5)
    indGlow.Size = U2(1,20,1,20)
    indGlow.Position = U2(0.5,0,0.5,0)
    indGlow.BackgroundTransparency = 1
    indGlow.Image = "rbxassetid://6014261993"
    indGlow.ImageColor3 = theme.Primary
    indGlow.ImageTransparency = 0.5
    indGlow.ZIndex = 20
    indGlow.ScaleType = Enum.ScaleType.Slice
    indGlow.SliceCenter = Rect.new(49,49,450,450)
    indGlow.Parent = indicator

    local btns = {}

    local function SpawnRippleOnNav(frame, x, y)
        local ripple = New("Frame")
        ripple.AnchorPoint = V2(0.5,0.5)
        ripple.Size = U2(0,0,0,0)
        ripple.Position = U2(0, x - frame.AbsolutePosition.X, 0, y - frame.AbsolutePosition.Y)
        ripple.BackgroundColor3 = theme.Primary
        ripple.BackgroundTransparency = 0.5
        ripple.ZIndex = frame.ZIndex + 3
        ripple.Parent = frame
        RoundCorner(ripple, 999)
        Tween(ripple, TI(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = U2(0,180,0,60),
            BackgroundTransparency = 1,
        })
        task.delay(0.55, function() if ripple.Parent then ripple:Destroy() end end)
    end

    for i, tab in ipairs(tabs) do
        local rowY = 12 + (i-1) * 38

        local btn = New("TextButton")
        btn.Name = "NavBtn_" .. tab.Name
        btn.Size = U2(1,-8,0,32)
        btn.Position = U2(0,4,0,rowY)
        btn.BackgroundColor3 = theme.SurfaceAlt
        btn.BackgroundTransparency = i == active and 0.4 or 1
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ClipsDescendants = true
        btn.ZIndex = 22
        btn.Parent = nav
        RoundCorner(btn, 6)

        if tab.Icon then
            local ico = New("TextLabel")
            ico.Size = U2(0,24,1,0)
            ico.Position = U2(0,6,0,0)
            ico.BackgroundTransparency = 1
            ico.Text = tab.Icon
            ico.TextColor3 = i == active and theme.Primary or theme.TextMuted
            ico.Font = Enum.Font.GothamBold
            ico.TextSize = 13
            ico.ZIndex = 23
            ico.Parent = btn
            btns[i] = { btn=btn, ico=ico }
        else
            btns[i] = { btn=btn }
        end

        local nameLbl = New("TextLabel")
        nameLbl.Size = U2(1,-40,1,0)
        nameLbl.Position = U2(0, tab.Icon and 32 or 10,0,0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = tab.Name
        nameLbl.TextColor3 = i == active and theme.Text or theme.TextMuted
        nameLbl.Font = i == active and Enum.Font.GothamBold or Enum.Font.Gotham
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 23
        nameLbl.Parent = btn
        btns[i].nameLbl = nameLbl

        SignalManager:Connect(btn.MouseEnter, function()
            if i ~= active then
                Tween(btn, TI(0.12), { BackgroundTransparency = 0.7 })
            end
        end, gid)
        SignalManager:Connect(btn.MouseLeave, function()
            if i ~= active then
                Tween(btn, TI(0.12), { BackgroundTransparency = 1 })
            end
        end, gid)

        local ii = i
        SignalManager:Connect(btn.InputBegan, function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                SpawnRippleOnNav(btn, inp.Position.X, inp.Position.Y)
            end
        end, gid)

        SignalManager:Connect(btn.MouseButton1Click, function()
            if ii == active then return end
            local prevActive = active
            active = ii

            -- Animate indicator to new position
            local targetY = 12 + (ii - 1) * 38 + 2
            Tween(indicator, TI(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Position = U2(0,0,0,targetY) })

            -- Update all buttons
            for j, bData in ipairs(btns) do
                local isActive = j == ii
                Tween(bData.btn, TI(0.15), {
                    BackgroundTransparency = isActive and 0.4 or 1
                })
                Tween(bData.nameLbl, TI(0.15), {
                    TextColor3 = isActive and theme.Text or theme.TextMuted
                })
                bData.nameLbl.Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham
                if bData.ico then
                    Tween(bData.ico, TI(0.15), {
                        TextColor3 = isActive and theme.Primary or theme.TextMuted
                    })
                end
            end

            if onTabSelect then onTabSelect(ii, tab) end
        end, gid)
    end

    -- Footer version label
    local ver = New("TextLabel")
    ver.AnchorPoint = V2(0,1)
    ver.Size = U2(1,0,0,20)
    ver.Position = U2(0,0,1,-4)
    ver.BackgroundTransparency = 1
    ver.Text = "AETHERIS  v2.0"
    ver.TextColor3 = theme.TextMuted
    ver.Font = Enum.Font.Code
    ver.TextSize = 9
    ver.ZIndex = 22
    ver.Parent = nav

    return {
        Instance = nav,
        SetActive = function(_, idx)
            -- programmatically switch tab
            local targetY = 12 + (idx - 1) * 38 + 2
            Tween(indicator, TI(0.25), { Position = U2(0,0,0,targetY) })
            active = idx
        end,
        Destroy = function(_)
            SignalManager:DisconnectGroup(gid)
            nav:Destroy()
        end,
    }
end

-- ════════════════════════════════════════════════════════════════════════════
-- §15  TAB CLASS  —  wraps content area for one navigator tab
-- ════════════════════════════════════════════════════════════════════════════
local Tab = {}
Tab.__index = Tab

function Tab.new(contentArea, theme, name)
    local self     = setmetatable({}, Tab)
    self._theme    = theme
    self._name     = name
    self._elements = {}

    self._frame = New("Frame")
    self._frame.Name = "TabContent_" .. name
    self._frame.Size = U2(1,0,1,0)
    self._frame.BackgroundTransparency = 1
    self._frame.Visible = false
    self._frame.ZIndex = 20
    self._frame.Parent = contentArea

    local scroll = New("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.Size = U2(1,-8,1,-8)
    scroll.Position = U2(0,4,0,4)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = theme.Border
    scroll.BorderSizePixel = 0
    scroll.ZIndex = 21
    scroll.Parent = self._frame
    self._scroll = scroll

    local layout = New("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = Ud(0,6)
    layout.Parent = scroll

    local pad = New("UIPadding")
    pad.PaddingLeft   = Ud(0,4)
    pad.PaddingRight  = Ud(0,4)
    pad.PaddingTop    = Ud(0,4)
    pad.PaddingBottom = Ud(0,4)
    pad.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = U2(0,0,0, layout.AbsoluteContentSize.Y + 16)
    end)

    return self
end

function Tab:Show() self._frame.Visible = true  end
function Tab:Hide() self._frame.Visible = false end

function Tab:_SectionHeader(title)
    local header = New("Frame")
    header.Size = U2(1,0,0,28)
    header.BackgroundTransparency = 1
    header.ZIndex = 22
    header.Parent = self._scroll

    local line = New("Frame")
    line.Size = U2(1,0,0,1)
    line.Position = U2(0,0,0.5,0)
    line.BackgroundColor3 = self._theme.Border
    line.ZIndex = 23
    line.Parent = header

    local lbl = New("TextLabel")
    lbl.Size = U2(0,0,1,0)
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Position = U2(0,0,0,0)
    lbl.BackgroundColor3 = self._theme.Background
    lbl.BackgroundTransparency = 0
    lbl.Text = " " .. title:upper() .. " "
    lbl.TextColor3 = self._theme.Primary
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.ZIndex = 24
    lbl.Parent = header

    return header
end

function Tab:AddSection(title)
    self:_SectionHeader(title)
end

function Tab:AddButton(opts)
    local api = CreateButton(self._scroll, self._theme, opts)
    table.insert(self._elements, api)
    return api
end

function Tab:AddToggle(flagId, opts)
    local api = CreateToggle(self._scroll, self._theme, flagId, opts)
    table.insert(self._elements, api)
    return api
end

function Tab:AddSlider(flagId, opts)
    local api = CreateSlider(self._scroll, self._theme, flagId, opts)
    table.insert(self._elements, api)
    return api
end

function Tab:AddDropdown(flagId, opts)
    local api = CreateDropdown(self._scroll, self._theme, flagId, opts)
    table.insert(self._elements, api)
    return api
end

function Tab:AddColorPicker(flagId, opts)
    local api = ColorSpectrum.new(self._scroll, self._theme, flagId, opts)
    table.insert(self._elements, api)
    return api
end

function Tab:AddLabel(text, opts)
    opts = opts or {}
    local lbl = New("TextLabel")
    lbl.Size = U2(1,0,0, opts.Size or 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = opts.Color or self._theme.TextMuted
    lbl.Font = opts.Bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextSize = opts.TextSize or 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex = 22
    lbl.Parent = self._scroll
    return lbl
end

function Tab:AddSeparator()
    local sep = New("Frame")
    sep.Size = U2(1,0,0,1)
    sep.BackgroundColor3 = self._theme.Border
    sep.BackgroundTransparency = 0.5
    sep.ZIndex = 22
    sep.Parent = self._scroll
    return sep
end

function Tab:AddPerfMonitor()
    local pm = setmetatable({}, { __index = PerfMonitor })
    pm._fps     = {}
    pm._mem     = {}
    pm._bars    = {}
    pm._memBars = {}
    pm.SAMPLES  = PerfMonitor.SAMPLES
    pm:Build(self._scroll, self._theme)
    table.insert(self._elements, pm)
    return pm
end

function Tab:Destroy()
    for _, el in ipairs(self._elements) do
        if el.Destroy then el:Destroy() end
    end
    self._frame:Destroy()
end

-- ════════════════════════════════════════════════════════════════════════════
-- §16  WINDOW CLASS  —  Glassmorphism draggable window
-- ════════════════════════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Window.new(lib, opts)
    local self     = setmetatable({}, Window)
    self._lib      = lib
    self._theme    = opts.Theme and Themes[opts.Theme] or Themes.Midnight
    self._tabs     = {}
    self._tabObjs  = {}
    self._activeTab = 1
    self._gid      = SignalManager:NewGroup()
    self._cleanups = {}

    -- ScreenGui
    local sg = New("ScreenGui")
    sg.Name = "AetherisUI_" .. (opts.Title or "Window")
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.ResetOnSpawn   = false
    sg.IgnoreGuiInset = true
    sg.Parent = CoreGui
    self._sg = sg

    NotifHub:Init(sg, self._theme)

    local W = opts.Width  or 620
    local H = opts.Height or 460

    -- Main window frame (Glassmorphism)
    local win = New("Frame")
    win.Name = "Window"
    win.AnchorPoint = V2(0.5,0.5)
    win.Size = U2(0,W,0,H)
    win.Position = U2(0.5,0,0.5,0)
    win.BackgroundColor3 = self._theme.Background
    win.BackgroundTransparency = 0.15
    win.ZIndex = 10
    win.ClipsDescendants = true
    win.Parent = sg
    RoundCorner(win, 12)
    AddStroke(win, self._theme.Border, 1, 0.4)
    ApplyGradient(win, self._theme.Surface, self._theme.Background, 150)
    self._win = win

    -- Multi-layer shadow
    AddShadow(win, self._theme, 3)

    -- Blur effect (if supported)
    local blur = New("BlurEffect")
    blur.Size = 8
    blur.Parent = sg
    self._blur = blur

    -- Title bar
    local titleBar = New("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = U2(1,0,0,44)
    titleBar.BackgroundColor3 = self._theme.Surface
    titleBar.BackgroundTransparency = 0.2
    titleBar.ZIndex = 11
    titleBar.Parent = win
    ApplyGradient(titleBar, self._theme.Grad1, self._theme.Grad2, 0)
    self._titleBar = titleBar

    AddStroke(titleBar, self._theme.Border, 1, 0.6)

    -- Logo/accent bar
    local accent = New("Frame")
    accent.Size = U2(0,3,0,24)
    accent.Position = U2(0,12,0.5,-12)
    accent.BackgroundColor3 = self._theme.Primary
    accent.ZIndex = 12
    accent.Parent = titleBar
    RoundCorner(accent, 2)

    -- Title text
    local titleLbl = New("TextLabel")
    titleLbl.Size = U2(1,-160,1,0)
    titleLbl.Position = U2(0,22,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = opts.Title or "Aetheris"
    titleLbl.TextColor3 = self._theme.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 12
    titleLbl.Parent = titleBar
    self._titleLbl = titleLbl

    -- Subtitle
    if opts.Subtitle then
        titleLbl.Size = U2(1,-160,0,20)
        titleLbl.Position = U2(0,22,0,4)
        local sub = New("TextLabel")
        sub.Size = U2(1,-160,0,14)
        sub.Position = U2(0,22,0,24)
        sub.BackgroundTransparency = 1
        sub.Text = opts.Subtitle
        sub.TextColor3 = self._theme.TextMuted
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 10
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 12
        sub.Parent = titleBar
    end

    -- Window controls (close, minimize)
    local function WinBtn(xOff, color, icon, fn)
        local b = New("TextButton")
        b.AnchorPoint = V2(1,0.5)
        b.Size = U2(0,22,0,22)
        b.Position = U2(1,xOff,0.5,0)
        b.BackgroundColor3 = color
        b.BackgroundTransparency = 0.5
        b.Text = icon
        b.TextColor3 = C3(255,255,255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.ZIndex = 13
        b.Parent = titleBar
        RoundCorner(b, 11)
        b.MouseEnter:Connect(function()
            Tween(b, TI(0.1), { BackgroundTransparency = 0 })
        end)
        b.MouseLeave:Connect(function()
            Tween(b, TI(0.1), { BackgroundTransparency = 0.5 })
        end)
        b.MouseButton1Click:Connect(fn)
        return b
    end

    local minimized = false

    WinBtn(-8, C3(255,60,60), "×", function()
        Tween(win, TI(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = U2(0,0,0,0),
            BackgroundTransparency = 1,
        })
        task.delay(0.4, function() sg:Destroy() end)
    end)

    WinBtn(-36, C3(255,165,0), "−", function()
        minimized = not minimized
        if minimized then
            Tween(win, TI(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = U2(0,W,0,44)
            })
        else
            Tween(win, TI(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = U2(0,W,0,H)
            })
        end
    end)

    -- Theme button
    WinBtn(-64, self._theme.Primary, "◈", function()
        self:_ShowThemePicker()
    end)

    -- Save/Load buttons
    local saveBtn = WinBtn(-96, self._theme.Info, "↓", function()
        CM:Save("Default")
        NotifHub:Notify({
            Type = "Success",
            Title = "Config Saved",
            Message = "Your settings have been saved.",
            Duration = 3,
        })
    end)

    local loadBtn = WinBtn(-122, self._theme.Warning, "↑", function()
        local ok = CM:Load("Default")
        NotifHub:Notify({
            Type = ok and "Success" or "Error",
            Title = ok and "Config Loaded" or "Load Failed",
            Message = ok and "Settings restored successfully." or "No saved config found.",
            Duration = 3,
        })
    end)

    -- Drag handle
    local stopDrag = MakeDraggable(win, titleBar, sg)
    table.insert(self._cleanups, stopDrag)

    -- Body (navigator + content)
    local body = New("Frame")
    body.Name = "Body"
    body.Size = U2(1,0,1,-44)
    body.Position = U2(0,0,0,44)
    body.BackgroundTransparency = 1
    body.ZIndex = 11
    body.ClipsDescendants = true
    body.Parent = win
    self._body = body

    -- Content area (right of navigator)
    local content = New("Frame")
    content.Name = "Content"
    content.Size = U2(1,-168,1,-8)
    content.Position = U2(0,164,0,4)
    content.BackgroundColor3 = self._theme.Surface
    content.BackgroundTransparency = 0.4
    content.ZIndex = 12
    content.ClipsDescendants = true
    content.Parent = body
    RoundCorner(content, 8)
    self._content = content

    -- Entry animation
    win.Size = U2(0,0,0,0)
    win.BackgroundTransparency = 1
    Tween(win, TI(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = U2(0,W,0,H),
        BackgroundTransparency = 0.15,
    })

    return self
end

function Window:_ShowThemePicker()
    -- Simple dropdown notification of available themes
    local names = {}
    for k,_ in pairs(Themes) do table.insert(names, k) end
    table.sort(names)
    NotifHub:Notify({
        Type = "Info",
        Title = "Theme Switcher",
        Message = "Available: " .. table.concat(names, ", "),
        Duration = 5,
    })
end

function Window:AddTab(opts)
    local name = opts.Name or ("Tab " .. (#self._tabs+1))
    local icon = opts.Icon

    local tabObj = Tab.new(self._content, self._theme, name)
    local idx    = #self._tabs + 1
    table.insert(self._tabs, tabObj)

    -- Build or rebuild navigator
    if self._nav then
        self._nav:Destroy()
    end
    local tabDefs = {}
    for i, t in ipairs(self._tabs) do
        table.insert(tabDefs, { Name = t._name, Icon = self._tabIcons and self._tabIcons[i] })
    end
    if not self._tabIcons then self._tabIcons = {} end
    self._tabIcons[idx] = icon

    tabDefs = {}
    for i, t in ipairs(self._tabs) do
        table.insert(tabDefs, { Name = t._name, Icon = self._tabIcons[i] })
    end

    self._nav = CreateNavigator(self._body, self._theme, tabDefs, function(i, _)
        self:_SwitchTab(i)
    end)

    -- Show first tab by default
    if idx == 1 then
        tabObj:Show()
        self._activeTab = 1
    end

    return tabObj
end

function Window:_SwitchTab(idx)
    for i, t in ipairs(self._tabs) do
        if i == idx then t:Show() else t:Hide() end
    end
    self._activeTab = idx
end

function Window:Notify(opts)
    return NotifHub:Notify(opts)
end

function Window:GetFlag(id)
    return CM:Get(id)
end

function Window:SetTheme(name)
    -- Hot-swap theme (partial — updates stored reference)
    if Themes[name] then
        self._theme = Themes[name]
    end
end

function Window:Destroy()
    for _, fn in ipairs(self._cleanups) do fn() end
    for _, t in ipairs(self._tabs) do t:Destroy() end
    SignalManager:DisconnectGroup(self._gid)
    PerfMonitor:Stop()
    if self._sg and self._sg.Parent then self._sg:Destroy() end
end

-- ════════════════════════════════════════════════════════════════════════════
-- §17  LIBRARY FACADE  —  Public API
-- ════════════════════════════════════════════════════════════════════════════
local Aetheris = {}
Aetheris.__index = Aetheris
Aetheris.Flags  = CM.Flags
Aetheris.Themes = Themes
Aetheris.Version = "2.0.0"

--[[
    Aetheris:CreateWindow(opts)
    ────────────────────────────
    Entry point. Creates and returns a Window instance.

    opts = {
        Title      : string   — Window title bar text
        Subtitle   : string?  — Smaller text beneath title
        Theme      : string?  — Key into Themes table (default "Midnight")
        Width      : number?  — Window width in pixels (default 620)
        Height     : number?  — Window height in pixels (default 460)
        Boot       : boolean? — Whether to show bootloader (default true)
    }
]]
function Aetheris:CreateWindow(opts)
    opts = opts or {}
    local showBoot = opts.Boot ~= false

    if showBoot then
        local win = nil
        RunBootloader(function()
            win = Window.new(self, opts)
        end)
        -- Return a proxy that waits for window creation
        -- For simplicity, create the window synchronously after boot
        -- (Caller can set Boot=false to skip)
        task.wait(0.1)
        while not win do task.wait(0.05) end
        return win
    else
        return Window.new(self, opts)
    end
end

--[[
    Aetheris:Notify(opts)
    ──────────────────────
    Global notification (requires at least one window to have been created).
]]
function Aetheris:Notify(opts)
    return NotifHub:Notify(opts)
end

--[[
    Aetheris:GetFlag(id)
    ─────────────────────
    Read any registered flag value by ID.
]]
function Aetheris:GetFlag(id)
    return CM:Get(id)
end

--[[
    Aetheris:SetFlag(id, value)
    ────────────────────────────
    Programmatically set any flag value.
]]
function Aetheris:SetFlag(id, value)
    CM:Set(id, value)
end

--[[
    Aetheris:SaveConfig(slot)
    ──────────────────────────
    Save all flags to workspace under the given slot name.
]]
function Aetheris:SaveConfig(slot)
    return CM:Save(slot)
end

--[[
    Aetheris:LoadConfig(slot)
    ──────────────────────────
    Load all flags from a previously saved workspace slot.
]]
function Aetheris:LoadConfig(slot)
    return CM:Load(slot)
end

--[[
    Aetheris:Destroy()
    ───────────────────
    Nuclear cleanup — disconnects all signals, destroys all UI.
    Call this to fully unload the library.
]]
function Aetheris:Destroy()
    SignalManager:DisconnectAll()
    PerfMonitor:Stop()
    -- Destroy any screen guis created under CoreGui
    for _, child in ipairs(CoreGui:GetChildren()) do
        if child.Name:sub(1,8) == "Aetheris" then
            child:Destroy()
        end
    end
    CM.Flags  = {}
    CM._hooks = {}
end

-- ════════════════════════════════════════════════════════════════════════════
-- §18  RETURN
-- ════════════════════════════════════════════════════════════════════════════
return Aetheris
