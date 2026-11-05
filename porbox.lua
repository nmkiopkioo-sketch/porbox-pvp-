-- ==============================================================================
-- Project Name: เรื่องโปร Hub | ProScript [V4 - Universal Mobile & PC Edition]
-- Target: PorZ / Zombie Survival & PvP (All Features Enabled for Mobile & PC)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Runtime Configuration State
local Config = {
    Enabled = true,
    Boxes = true,
    HealthBar = true,
    Tracers = true,
    Names = true,
    Zombies = true,
    DroppedItems = true,
    AntiBan = true
}

-- Color Palette (Green & Black UI + High-Contrast ESP Colors)
local Theme = {
    Primary = Color3.fromRGB(0, 255, 110),
    DarkBg = Color3.fromRGB(14, 18, 14),
    ElementBg = Color3.fromRGB(24, 32, 24),
    Text = Color3.fromRGB(240, 255, 240),
    ZombieColor = Color3.fromRGB(255, 165, 0),
    ItemColor = Color3.fromRGB(0, 240, 255)
}

-- Clean up any existing GUI instances or previous script loops
if getgenv and getgenv().ProScriptCleanup then
    pcall(getgenv().ProScriptCleanup)
end

local function DestroyStuckGuis()
    local targets = { CoreGui, LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") }
    if gethui then
        pcall(function() table.insert(targets, gethui()) end)
    end
    for _, parent in ipairs(targets) do
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == "ProScriptHub" or child.Name == "ProScriptESP" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    if cleardrawcache then
        pcall(cleardrawcache)
    end
end

DestroyStuckGuis()

-- Resolve optimal GUI container for both Mobile and Desktop executors
local function GetSafeGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return CoreGui
    end)
    if ok and res then return res end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Universal Clipboard Helper for Mobile & PC Executors
local function CopyToClipboard(text)
    local copyFunc = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if copyFunc then
        return pcall(copyFunc, tostring(text))
    end
    return false
end

-- Create Root ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProScriptHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GetSafeGuiParent()

-- Dedicated Native GUI Container for ESP Nodes
local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPContainer"
ESPContainer.Parent = ScreenGui

-- Floating Quick-Toggle Button for Mobile & PC
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatToggle"
FloatBtn.Parent = ScreenGui
FloatBtn.BackgroundColor3 = Theme.DarkBg
FloatBtn.Position = UDim2.new(0, 16, 0.5, -24)
FloatBtn.Size = UDim2.new(0, 48, 0, 48)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Text = "โปร"
FloatBtn.TextColor3 = Theme.Primary
FloatBtn.TextSize = 14
FloatBtn.AutoButtonColor = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Theme.Primary
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

-- Main Hub Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Theme.DarkBg
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 370, 0, 320)
MainFrame.Active = true

-- Responsive UIScale for Smaller Mobile Screens
local UIScale = Instance.new("UIScale")
UIScale.Parent = MainFrame

local function UpdateResponsiveScale()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    local vp = Camera.ViewportSize
    if vp.Y < 450 then
        UIScale.Scale = math.clamp(vp.Y / 420, 0.72, 1)
    else
        UIScale.Scale = 1
    end
end
UpdateResponsiveScale()

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Theme.Primary
UIStroke.Thickness = 1.8
UIStroke.Parent = MainFrame

-- Top Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Theme.ElementBg
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 42)
Header.Active = true

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(1, -95, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "เรื่องโปร Hub | ProScript [Mobile & PC]"
TitleLabel.TextColor3 = Theme.Primary
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 40)
MinimizeBtn.Position = UDim2.new(1, -72, 0.5, -14)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Theme.Text
MinimizeBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Close / Full Unload Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 35, 35)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Scrollable Controls Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Parent = MainFrame
ContentContainer.Active = true
ContentContainer.BackgroundColor3 = Color3.fromRGB(18, 24, 18)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Theme.Primary
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Event Connection Storage
local Connections = {}
table.insert(Connections, Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateResponsiveScale))

-- Cross-Platform Button Input Handler (Prevents Scroll Misfires & Double Toggles on Mobile)
local function BindButton(button, callback)
    local lastTrigger = 0
    local pressStartPos = nil

    local function Trigger()
        local now = os.clock()
        if now - lastTrigger < 0.25 then return end
        lastTrigger = now
        task.spawn(callback)
    end

    table.insert(Connections, button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressStartPos = input.Position
        end
    end))

    table.insert(Connections, button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if pressStartPos and (input.Position - pressStartPos).Magnitude <= 12 then
                Trigger()
            end
            pressStartPos = nil
        end
    end))

    table.insert(Connections, button.Activated:Connect(Trigger))
end

-- Cross-Platform Dragging Handler for Touch & Mouse
local function MakeDraggable(dragHandle, targetFrame)
    local dragging = false
    local dragInput, dragStart, startPos

    table.insert(Connections, dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end))

    table.insert(Connections, dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))

    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end))
end

MakeDraggable(Header, MainFrame)
MakeDraggable(FloatBtn, FloatBtn)

-- Minimize & Floating Toggle Logic
local isMinimized = false
BindButton(MinimizeBtn, function()
    isMinimized = not isMinimized
    ContentContainer.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 370, 0, 42) or UDim2.new(0, 370, 0, 320)
    MinimizeBtn.Text = isMinimized and "+" or "-"
end)

BindButton(FloatBtn, function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- UI Builders
local function CreateLabel(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = ContentContainer
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = color or Theme.Primary
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function CreateToggle(name, default, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ContentContainer
    ToggleBtn.BackgroundColor3 = Theme.ElementBg
    ToggleBtn.Size = UDim2.new(1, 0, 0, 34)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.Text = "  " .. name
    ToggleBtn.TextColor3 = Theme.Text
    ToggleBtn.TextSize = 12
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleBtn

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Parent = ToggleBtn
    StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
    StatusIndicator.Position = UDim2.new(1, -10, 0.5, 0)
    StatusIndicator.Size = UDim2.new(0, 16, 0, 16)
    StatusIndicator.BackgroundColor3 = default and Theme.Primary or Color3.fromRGB(65, 65, 65)

    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(1, 0)
    StatusCorner.Parent = StatusIndicator

    local state = default
    BindButton(ToggleBtn, function()
        state = not state
        StatusIndicator.BackgroundColor3 = state and Theme.Primary or Color3.fromRGB(65, 65, 65)
        callback(state)
    end)
end

-- Build Menu Items
CreateLabel(" --- [ ระบบมองทะลุและ ESP ทั้งหมด ] ---", Theme.Primary)
CreateToggle("เปิดใช้งาน ESP ทั้งหมด", Config.Enabled, function(v) Config.Enabled = v end)
CreateToggle("กรอบผู้เล่น & ชื่อระยะทาง", Config.Boxes, function(v) Config.Boxes = v; Config.Names = v end)
CreateToggle("แสดงหลอดเลือด & ตัวเลข HP", Config.HealthBar, function(v) Config.HealthBar = v end)
CreateToggle("เส้นนำทางผู้เล่น (Tracers)", Config.Tracers, function(v) Config.Tracers = v end)
CreateToggle("มองซอมบี้ปกติ (กรอบสีส้ม + HP)", Config.Zombies, function(v) Config.Zombies = v end)
CreateToggle("มองของที่ตก / ไอเทมดรอป (สีฟ้า)", Config.DroppedItems, function(v) Config.DroppedItems = v end)

CreateLabel(" --- [ ระบบความปลอดภัย ] ---", Theme.Primary)
CreateToggle("ระบบกันแบน (Anti-Ban Safeguard)", Config.AntiBan, function(v) Config.AntiBan = v end)

CreateLabel(" --- [ เครดิต & ชุมชนเรื่องโปร ] ---", Theme.Primary)

local YoutubeBtn = Instance.new("TextButton")
YoutubeBtn.Parent = ContentContainer
YoutubeBtn.BackgroundColor3 = Theme.ElementBg
YoutubeBtn.Size = UDim2.new(1, 0, 0, 34)
YoutubeBtn.Font = Enum.Font.GothamBold
YoutubeBtn.Text = "  📺 YouTube: เรื่องโปร (แตะเพื่อคัดลอก)"
YoutubeBtn.TextColor3 = Color3.fromRGB(255, 95, 95)
YoutubeBtn.TextSize = 12
YoutubeBtn.TextXAlignment = Enum.TextXAlignment.Left

local YtCorner = Instance.new("UICorner")
YtCorner.CornerRadius = UDim.new(0, 6)
YtCorner.Parent = YoutubeBtn

BindButton(YoutubeBtn, function()
    if CopyToClipboard("เรื่องโปร") then
        TitleLabel.Text = "คัดลอกชื่อช่อง YouTube สำเร็จ!"
    else
        TitleLabel.Text = "YouTube: เรื่องโปร"
    end
    task.wait(1.5)
    TitleLabel.Text = "เรื่องโปร Hub | ProScript [Mobile & PC]"
end)

local CreditBtn = Instance.new("TextButton")
CreditBtn.Parent = ContentContainer
CreditBtn.BackgroundColor3 = Theme.ElementBg
CreditBtn.Size = UDim2.new(1, 0, 0, 34)
CreditBtn.Font = Enum.Font.GothamBold
CreditBtn.Text = "  💬 Discord: https://discord.gg/gZpkSgmR8"
CreditBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
CreditBtn.TextSize = 12
CreditBtn.TextXAlignment = Enum.TextXAlignment.Left

local CreditCorner = Instance.new("UICorner")
CreditCorner.CornerRadius = UDim.new(0, 6)
CreditCorner.Parent = CreditBtn

BindButton(CreditBtn, function()
    if CopyToClipboard("https://discord.gg/gZpkSgmR8") then
        TitleLabel.Text = "คัดลอกลิงก์ Discord สำเร็จ!"
    else
        TitleLabel.Text = "Discord: discord.gg/gZpkSgmR8"
    end
    task.wait(1.5)
    TitleLabel.Text = "เรื่องโปร Hub | ProScript [Mobile & PC]"
end)

-- Dynamic Anti-Ban Protection (Safe across both Mobile & PC Executors)
pcall(function()
    local mt = getrawmetatable and getrawmetatable(game)
    if mt and setreadonly then
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        local wrap = newcclosure or function(f) return f end
        mt.__namecall = wrap(function(self, ...)
            if Config.AntiBan then
                local method = getnamecallmethod and getnamecallmethod()
                if method == "Kick" or method == "Ban" then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- ==============================================================================
-- Universal Native GUI ESP Engine (Accurate Alignment on Mobile & Desktop)
-- ==============================================================================
local ActiveESP = {}

local function CreateESPNode(target)
    local holder = Instance.new("Frame")
    holder.Name = "ESPNode"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 1, 0)
    holder.Visible = false
    holder.Parent = ESPContainer

    -- Bounding Box Frame
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = holder

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Theme.Primary
    boxStroke.Parent = box

    -- Health Bar Background & Fill
    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    hpBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hpBg.BorderSizePixel = 1
    hpBg.Visible = false
    hpBg.Parent = holder

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg

    -- Title / Distance Label
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Theme.Text
    label.TextStrokeTransparency = 0.15
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Size = UDim2.new(0, 220, 0, 18)
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Visible = false
    label.Parent = holder

    -- Numeric HP Label
    local hpText = Instance.new("TextLabel")
    hpText.BackgroundTransparency = 1
    hpText.Font = Enum.Font.GothamBold
    hpText.TextSize = 11
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextStrokeTransparency = 0.15
    hpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpText.Size = UDim2.new(0, 80, 0, 15)
    hpText.TextXAlignment = Enum.TextXAlignment.Left
    hpText.Visible = false
    hpText.Parent = holder

    -- 2D Tracer Line Frame
    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = Theme.Primary
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = false
    tracer.Parent = holder

    ActiveESP[target] = {
        Holder = holder,
        Box = box,
        BoxStroke = boxStroke,
        HpBg = hpBg,
        HpFill = hpFill,
        Label = label,
        HpText = hpText,
        Tracer = tracer
    }
    return ActiveESP[target]
end

local function RemoveESPNode(target)
    local node = ActiveESP[target]
    if node then
        if node.Holder then
            pcall(function() node.Holder:Destroy() end)
        end
        ActiveESP[target] = nil
    end
end

local function ClearAllESP()
    for target, _ in pairs(ActiveESP) do
        RemoveESPNode(target)
    end
    if ESPContainer then
        ESPContainer:ClearAllChildren()
    end
end

-- Complete Unload Routine
local isUnloaded = false
local function FullUnload()
    if isUnloaded then return end
    isUnloaded = true
    Config.Enabled = false

    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(Connections)

    ClearAllESP()
    DestroyStuckGuis()
    pcall(function() ScreenGui:Destroy() end)
end

if getgenv then
    getgenv().ProScriptCleanup = FullUnload
end

BindButton(CloseBtn, FullUnload)

-- Helper: Get Accurate Model Center & Alive Status for Zombies
local function EvaluateZombieStatus(enemy)
    if not enemy or not enemy.Parent then return false, nil, nil, nil end

    local root = enemy:FindFirstChild("HumanoidRootPart")
        or enemy.PrimaryPart
        or enemy:FindFirstChild("UpperTorso")
        or enemy:FindFirstChild("Torso")
        or enemy:FindFirstChild("Head")
        or enemy:FindFirstChildWhichIsA("BasePart", true)

    if not root or not root.Parent then return false, nil, nil, nil end

    -- Read Health & State Attributes
    local attrHealth = enemy:GetAttribute("Health") or enemy:GetAttribute("HP") or root:GetAttribute("Health")
    local attrMaxHealth = enemy:GetAttribute("MaxHealth") or enemy:GetAttribute("MaxHP") or root:GetAttribute("MaxHealth")
    local attrDead = enemy:GetAttribute("Dead") or enemy:GetAttribute("IsDead") or enemy:GetAttribute("Destroyed")
    local attrState = enemy:GetAttribute("State") or enemy:GetAttribute("AIState")

    if attrDead == true then return false, nil, nil, nil end
    if type(attrState) == "string" then
        local st = attrState:lower()
        if st:find("dead") or st:find("corpse") or st:find("death") then
            return false, nil, nil, nil
        end
    end
    if type(attrHealth) == "number" and attrHealth <= 0 then
        return false, nil, nil, nil
    end

    local hum = enemy:FindFirstChildOfClass("Humanoid")
    local curHp, maxHp = attrHealth, attrMaxHealth

    if hum then
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
            return false, nil, nil, nil
        end
        curHp = curHp or hum.Health
        maxHp = maxHp or hum.MaxHealth
    end

    local nameLower = enemy.Name:lower()
    if nameLower:find("corpse") or nameLower:find("dead") or nameLower:find("ragdoll") then
        return false, nil, nil, nil
    end

    -- Ignore flat ragdolled corpses without active health
    if not hum and not attrHealth then
        if root.CFrame.UpVector.Y < 0.25 then
            return false, nil, nil, nil
        end
    end

    -- Calculate geometric bounding center for accurate box alignment
    local centerPos = root.Position
    if enemy:IsA("Model") then
        local ok, cf = pcall(function() return enemy:GetBoundingBox() end)
        if ok and cf then
            centerPos = cf.Position
        end
    end

    return true, centerPos, curHp, maxHp
end

-- Helper: Get Position and Display Name of Dropped Items
local function EvaluateDroppedItem(item)
    if not item or not item.Parent then return nil, nil end

    local part = nil
    if item:IsA("BasePart") then
        part = item
    elseif item:IsA("Model") then
        part = item.PrimaryPart or item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart", true)
    else
        part = item:FindFirstChildWhichIsA("BasePart", true)
    end

    local pos = nil
    if part then
        pos = part.Position
    elseif item:IsA("Model") then
        local ok, pivot = pcall(function() return item:GetPivot() end)
        if ok and pivot then pos = pivot.Position end
    end

    if not pos then return nil, nil end

    local itemName = item:GetAttribute("ItemName")
        or item:GetAttribute("DisplayName")
        or item:GetAttribute("Name")
        or item:GetAttribute("ItemId")

    if not itemName then
        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and prompt.ObjectText ~= "" then
            itemName = prompt.ObjectText
        elseif prompt and prompt.ActionText ~= "" and prompt.ActionText ~= "Pick Up" then
            itemName = prompt.ActionText
        end
    end

    if not itemName then
        itemName = item.Name:gsub("Model", ""):gsub("Drop", ""):gsub("_", " ")
        if itemName == "" or itemName == " " then
            itemName = "Item"
        end
    end

    return pos, tostring(itemName)
end

-- Helper: Render 2D Tracer Line
local function UpdateTracerLine(tracerFrame, fromX, fromY, toX, toY, color)
    local dx = toX - fromX
    local dy = toY - fromY
    local dist = math.sqrt(dx * dx + dy * dy)
    local cx = (fromX + toX) / 2
    local cy = (fromY + toY) / 2
    local angle = math.deg(math.atan2(dy, dx))

    tracerFrame.Position = UDim2.new(0, cx, 0, cy)
    tracerFrame.Size = UDim2.new(0, dist, 0, 1.5)
    tracerFrame.Rotation = angle
    tracerFrame.BackgroundColor3 = color
    tracerFrame.Visible = true
end

-- Main ESP Update Loop
table.insert(Connections, RunService.RenderStepped:Connect(function()
    if isUnloaded or not Config.Enabled then
        ClearAllESP()
        return
    end

    Camera = Workspace.CurrentCamera
    if not Camera then return end

    local ValidTargets = {}
    local viewportSize = Camera.ViewportSize

    -- 1. PLAYER ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent == Players and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                ValidTargets[player] = true
                local node = ActiveESP[player] or CreateESPNode(player)

                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    node.Holder.Visible = true

                    local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3.2, 0))
                    local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.6, 0))

                    local height = math.max(math.abs(bottomPos.Y - topPos.Y), 20)
                    local width = height * 0.65
                    local boxX = screenPos.X - (width / 2)
                    local boxY = topPos.Y

                    -- Box
                    if Config.Boxes then
                        node.Box.Position = UDim2.new(0, boxX, 0, boxY)
                        node.Box.Size = UDim2.new(0, width, 0, height)
                        node.BoxStroke.Color = Theme.Primary
                        node.Box.Visible = true
                    else
                        node.Box.Visible = false
                    end

                    -- Health Bar
                    if Config.HealthBar then
                        local maxHp = math.max(hum.MaxHealth, 1)
                        local curHp = math.clamp(hum.Health, 0, maxHp)
                        local ratio = curHp / maxHp
                        local hpColor = Color3.fromHSV(ratio * 0.33, 1, 1)

                        node.HpBg.Position = UDim2.new(0, boxX - 6, 0, boxY)
                        node.HpBg.Size = UDim2.new(0, 3, 0, height)
                        node.HpBg.Visible = true

                        node.HpFill.Position = UDim2.new(0, 0, 1 - ratio, 0)
                        node.HpFill.Size = UDim2.new(1, 0, ratio, 0)
                        node.HpFill.BackgroundColor3 = hpColor

                        node.HpText.Text = string.format("%d HP", math.floor(curHp))
                        node.HpText.Position = UDim2.new(0, boxX + width + 4, 0, boxY)
                        node.HpText.TextColor3 = hpColor
                        node.HpText.Visible = true
                    else
                        node.HpBg.Visible = false
                        node.HpText.Visible = false
                    end

                    -- Player Name & Distance
                    if Config.Names then
                        local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                        node.Label.Text = string.format("%s [%dm]", player.DisplayName, dist)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, boxY - 3)
                        node.Label.TextColor3 = Theme.Text
                        node.Label.Visible = true
                    else
                        node.Label.Visible = false
                    end

                    -- Tracer Line
                    if Config.Tracers then
                        UpdateTracerLine(node.Tracer, viewportSize.X / 2, viewportSize.Y, screenPos.X, boxY + height, Theme.Primary)
                    else
                        node.Tracer.Visible = false
                    end
                else
                    node.Holder.Visible = false
                end
            end
        end
    end

    -- 2. UNIFIED ZOMBIE ESP (Deduplicates EnemyVisuals & EnemyActors so tags never overlap)
    if Config.Zombies then
        local enemyFolders = {
            Workspace:FindFirstChild("EnemyVisuals"),
            Workspace:FindFirstChild("EnemyActors")
        }
        local seenPositions = {}

        for _, folder in ipairs(enemyFolders) do
            if folder then
                for _, enemy in ipairs(folder:GetChildren()) do
                    local isAlive, centerPos, curHp, maxHp = EvaluateZombieStatus(enemy)
                    if isAlive and centerPos then
                        -- Prevent duplicate ESP when the same zombie exists in both EnemyVisuals and EnemyActors
                        local isDuplicate = false
                        for _, existingPos in ipairs(seenPositions) do
                            if (existingPos - centerPos).Magnitude < 2.5 then
                                isDuplicate = true
                                break
                            end
                        end

                        if not isDuplicate then
                            table.insert(seenPositions, centerPos)
                            ValidTargets[enemy] = true
                            local node = ActiveESP[enemy] or CreateESPNode(enemy)

                            local screenPos, onScreen = Camera:WorldToViewportPoint(centerPos)
                            if onScreen then
                                node.Holder.Visible = true
                                local dist = math.floor((Camera.CFrame.Position - centerPos).Magnitude)
                                local hpStr = ""
                                if curHp and maxHp and maxHp > 0 then
                                    hpStr = string.format(" [%d/%d HP]", math.floor(curHp), math.floor(maxHp))
                                elseif curHp then
                                    hpStr = string.format(" [%d HP]", math.floor(curHp))
                                end

                                local topPos = Camera:WorldToViewportPoint(centerPos + Vector3.new(0, 3.0, 0))
                                local bottomPos = Camera:WorldToViewportPoint(centerPos - Vector3.new(0, 3.2, 0))
                                local height = math.max(math.abs(bottomPos.Y - topPos.Y), 18)
                                local width = height * 0.65
                                local boxX = screenPos.X - (width / 2)
                                local boxY = topPos.Y

                                node.Box.Position = UDim2.new(0, boxX, 0, boxY)
                                node.Box.Size = UDim2.new(0, width, 0, height)
                                node.BoxStroke.Color = Theme.ZombieColor
                                node.Box.Visible = true

                                node.Label.TextSize = 12
                                node.Label.TextColor3 = Theme.ZombieColor
                                node.Label.Text = string.format("🧟 [ซอมบี้]%s (%dm)", hpStr, dist)
                                node.Label.Position = UDim2.new(0, screenPos.X, 0, boxY - 3)
                                node.Label.Visible = true

                                node.HpBg.Visible = false
                                node.HpText.Visible = false
                                node.Tracer.Visible = false
                            else
                                node.Holder.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end

    -- 3. DROPPED ITEMS ESP
    if Config.DroppedItems then
        local droppedFolder = Workspace:FindFirstChild("DroppedItems")
        if droppedFolder then
            for _, item in ipairs(droppedFolder:GetChildren()) do
                local itemPos, itemName = EvaluateDroppedItem(item)
                if itemPos then
                    ValidTargets[item] = true
                    local node = ActiveESP[item] or CreateESPNode(item)

                    local screenPos, onScreen = Camera:WorldToViewportPoint(itemPos)
                    if onScreen then
                        node.Holder.Visible = true
                        local dist = math.floor((Camera.CFrame.Position - itemPos).Magnitude)

                        node.Box.Visible = false
                        node.HpBg.Visible = false
                        node.HpText.Visible = false
                        node.Tracer.Visible = false

                        node.Label.TextSize = 12
                        node.Label.TextColor3 = Theme.ItemColor
                        node.Label.Text = string.format("📦 [%s] (%dm)", itemName, dist)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                        node.Label.Visible = true
                    else
                        node.Holder.Visible = false
                    end
                end
            end
        end
    end

    -- 4. Clean up Despawned, Dead, or Disabled Targets Immediately
    for target, _ in pairs(ActiveESP) do
        if not ValidTargets[target] then
            RemoveESPNode(target)
        end
    end
end))