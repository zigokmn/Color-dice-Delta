
--[[ Color Dice - 4 Dice Edition (Delta Executor) ]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")

local _wait  = (task and task.wait)  or wait
local _delay = (task and task.delay) or delay

local player = Players.LocalPlayer

local old = CoreGui:FindFirstChild("ColorDiceRoot")
    or player:WaitForChild("PlayerGui"):FindFirstChild("ColorDiceRoot")
if old then old:Destroy() end

local parentGui
pcall(function() if gethui then parentGui = gethui() end end)
if not parentGui then
    parentGui = player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "ColorDiceRoot"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 99999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui

local THEME = {
    bg      = Color3.fromRGB(24, 26, 33),
    panel2  = Color3.fromRGB(46, 50, 64),
    accent  = Color3.fromRGB(255, 176, 32),
    text    = Color3.fromRGB(240, 242, 248),
    subtext = Color3.fromRGB(150, 158, 178),
}

local DICE_COLORS = {
    Color3.fromRGB(255,  76,  76), Color3.fromRGB( 76, 132, 255),
    Color3.fromRGB( 76, 220, 128), Color3.fromRGB(255, 204,  56),
    Color3.fromRGB(198,  96, 255), Color3.fromRGB(255, 128, 196),
    Color3.fromRGB(  0, 226, 226), Color3.fromRGB(255, 150,  56),
    Color3.fromRGB(160, 255,  96), Color3.fromRGB( 96, 200, 255),
    Color3.fromRGB(255, 110, 180), Color3.fromRGB(120, 255, 210),
}
local DICE_FACES = {
    {5}, {1, 9}, {1, 5, 9}, {1, 3, 7, 9}, {1, 3, 5, 7, 9}, {1, 3, 4, 6, 7, 9},
}
local DICE_COUNT = 4
local DICE_SIZE  = 100

local function tween(obj, time, props, style, dir)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props)
    t:Play()
    return t
end

-- Klick-Handler fuer Maus UND Touch, mit Debounce
local function onClick(btn, fn)
    local last = 0
    local function handler()
        local now = os.clock()
        if now - last < 0.2 then return end
        last = now
        fn()
    end
    btn.MouseButton1Click:Connect(handler)
    btn.TouchTap:Connect(handler)
end

local lastColors = {}
local function pickColors()
    local pool = {}
    for i = 1, #DICE_COLORS do pool[i] = DICE_COLORS[i] end
    for i = #pool, 2, -1 do
        local j = math.random(1, i)
        pool[i], pool[j] = pool[j], pool[i]
    end
    local picked = { pool[1], pool[2], pool[3], pool[4] }
    if #lastColors == DICE_COUNT then
        local same = true
        for i = 1, DICE_COUNT do
            if picked[i] ~= lastColors[i] then same = false break end
        end
        if same then picked = { picked[2], picked[3], picked[4], picked[1] } end
    end
    lastColors = picked
    return picked
end

local SOUND_ROLL   = "rbxassetid://4612375238"
local SOUND_RESULT = "rbxassetid://6042053626"
local function playSound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = gui
    s:Play()
    _delay(3, function() s:Destroy() end)
end

-- ==== FENSTER (zuerst erstellen) ====
local win = Instance.new("Frame")
win.Name = "Window"
win.AnchorPoint = UDim2.new(0.5, 0, 0.5, 0)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.Size = UDim2.new(0, 520, 0, 460)
win.BackgroundColor3 = THEME.bg
win.BorderSizePixel = 0
win.Visible = false
win.ZIndex = 5
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 16)
local winStroke = Instance.new("UIStroke")
winStroke.Thickness = 2
winStroke.Color = Color3.fromRGB(62, 68, 86)
winStroke.Parent = win
local winGrad = Instance.new("UIGradient")
winGrad.Rotation = 90
winGrad.Color = ColorSequence.new(Color3.fromRGB(38, 42, 54), Color3.fromRGB(19, 21, 28))
winGrad.Parent = win

-- ==== ÖFFNEN/SCHLIESSEN LOGIK ====
local winOpen = false
local function setOpen(open)
    winOpen = open
    if open then
        win.Visible = true
        win.Size = UDim2.new(0, 460, 0, 405)
        tween(win, 0.22, { Size = UDim2.new(0, 520, 0, 460) },
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        local t = tween(win, 0.15, { Size = UDim2.new(0, 460, 0, 405) })
        t.Completed:Connect(function()
            if not winOpen then
                win.Visible = false
                win.Size = UDim2.new(0, 520, 0, 460)
            end
        end)
    end
end

-- ==== ÖFFNEN-BUTTON (sofort verbinden) ====
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 156, 0, 48)
openBtn.Position = UDim2.new(0, 20, 1, -68)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
openBtn.Text = "COLOR DICE"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 15
openBtn.TextColor3 = THEME.text
openBtn.BorderSizePixel = 0
openBtn.AutoButtonColor = false
openBtn.Active = true
openBtn.ZIndex = 20
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 12)
local openStroke = Instance.new("UIStroke")
openStroke.Color = THEME.accent
openStroke.Thickness = 2
openStroke.Transparency = 0.25
openStroke.Parent = openBtn
onClick(openBtn, function() setOpen(not winOpen) end)

-- Titelleiste
local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 44)
bar.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
bar.BackgroundTransparency = 0.1
bar.BorderSizePixel = 0
bar.ZIndex = 6
bar.Parent = win
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 16)
local barFix = Instance.new("Frame")
barFix.Size = UDim2.new(1, 0, 0, 14)
barFix.Position = UDim2.new(0, 0, 1, -14)
barFix.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
barFix.BackgroundTransparency = 0.1
barFix.BorderSizePixel = 0
barFix.ZIndex = 6
barFix.Parent = bar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "COLOR DICE"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 7
title.Parent = bar

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
titleGrad.Offset = Vector2.new(-1, 0)
titleGrad.Parent = title
TweenService:Create(
    titleGrad,
    TweenInfo.new(2.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
    { Offset = Vector2.new(1, 0) }
):Play()

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 76, 76)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 8
closeBtn.Parent = bar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
onClick(closeBtn, function() setOpen(false) end)

-- ==== ZIEHEN ====
local dragging, dragStart, startPos
bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = win.Position
    end
end)
bar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        win.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ==== WÜRFEL ====
local diceRow = Instance.new("Frame")
diceRow.Size = UDim2.new(1, -32, 0, DICE_SIZE + 14)
diceRow.Position = UDim2.new(0, 16, 0, 58)
diceRow.BackgroundTransparency = 1
diceRow.ZIndex = 6
diceRow.Parent = win

local rowLayout = Instance.new("UIListLayout")
rowLayout.FillDirection = Enum.FillDirection.Horizontal
rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
rowLayout.Padding = UDim.new(0, 14)
rowLayout.Parent = diceRow

local dice = {}
local function makeDice(index)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0, DICE_SIZE, 0, DICE_SIZE)
    holder.BackgroundTransparency = 1
    holder.LayoutOrder = index
    holder.ZIndex = 6
    holder.Parent = diceRow

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 12, 1, 12)
    glow.Position = UDim2.new(0, -6, 0, -6)
    glow.BackgroundColor3 = DICE_COLORS[1]
    glow.BackgroundTransparency = 0.75
    glow.BorderSizePixel = 0
    glow.ZIndex = 6
    glow.Parent = holder
    Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 22)

    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 3, 0, 5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 7
    shadow.Parent = holder
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 18)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 1, 0)
    body.BackgroundColor3 = DICE_COLORS[1]
    body.BorderSizePixel = 0
    body.ZIndex = 8
    body.Parent = holder
    Instance.new("UICorner", body).CornerRadius = UDim.new(0, 18)

    local grad = Instance.new("UIGradient")
    grad.Rotation = 90
    grad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(205, 205, 205))
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(1, 0.4),
    })
    grad.Parent = body

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.6
    stroke.Parent = body

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 20, 0, 20)
    grid.CellPadding = UDim2.new(0, 6, 0, 6)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = body

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = body

    local pips = {}
    for i = 1, 9 do
        local pip = Instance.new("Frame")
        pip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pip.BackgroundTransparency = 1
        pip.BorderSizePixel = 0
        pip.LayoutOrder = i
        pip.ZIndex = 9
        pip.Parent = body
        Instance.new("UICorner", pip).CornerRadius = UDim.new(1, 0)
        pips[i] = pip
    end

    local d = { holder = holder, glow = glow, body = body, pips = pips }
    dice[index] = d
    return d
end

for i = 1, DICE_COUNT do makeDice(i) end

local function renderFace(d, n)
    for i = 1, 9 do d.pips[i].BackgroundTransparency = 1 end
    for _, idx in ipairs(DICE_FACES[n]) do
        d.pips[idx].BackgroundTransparency = 0
    end
end

local startColors = pickColors()
for i, d in ipairs(dice) do
    d.body.BackgroundColor3 = startColors[i]
    d.glow.BackgroundColor3 = startColors[i]
    renderFace(d, math.random(1, 6))
end

-- ==== ANZEIGE ====
local sumLabel = Instance.new("TextLabel")
sumLabel.Size = UDim2.new(1, -32, 0, 38)
sumLabel.Position = UDim2.new(0, 16, 0, 186)
sumLabel.BackgroundTransparency = 1
sumLabel.Font = Enum.Font.GothamBold
sumLabel.TextSize = 27
sumLabel.TextColor3 = THEME.text
sumLabel.Text = "SUMME: --"
sumLabel.ZIndex = 6
sumLabel.Parent = win

local detailLabel = Instance.new("TextLabel")
detailLabel.Size = UDim2.new(1, -32, 0, 22)
detailLabel.Position = UDim2.new(0, 16, 0, 224)
detailLabel.BackgroundTransparency = 1
detailLabel.Font = Enum.Font.Gotham
detailLabel.TextSize = 16
detailLabel.TextColor3 = THEME.subtext
detailLabel.Text = "Druecke ROLL!"
detailLabel.ZIndex = 6
detailLabel.Parent = win

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -32, 0, 20)
statsLabel.Position = UDim2.new(0, 16, 0, 252)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 14
statsLabel.TextColor3 = THEME.subtext
statsLabel.Text = "Wuerfe: 0    Bester: 0    Schnitt: 0.0"
statsLabel.ZIndex = 6
statsLabel.Parent = win

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -48, 0, 1)
divider.Position = UDim2.new(0, 24, 0, 296)
divider.BackgroundColor3 = Color3.fromRGB(62, 68, 86)
divider.BorderSizePixel = 0
divider.ZIndex = 6
divider.Parent = win

local rollBtn = Instance.new("TextButton")
rollBtn.Size = UDim2.new(0, 300, 0, 50)
rollBtn.Position = UDim2.new(0.5, -150, 0, 322)
rollBtn.BackgroundColor3 = THEME.accent
rollBtn.Text = "ROLL"
rollBtn.Font = Enum.Font.GothamBold
rollBtn.TextSize = 20
rollBtn.TextColor3 = Color3.fromRGB(24, 26, 33)
rollBtn.BorderSizePixel = 0
rollBtn.AutoButtonColor = false
rollBtn.ZIndex = 7
rollBtn.Parent = win
Instance.new("UICorner", rollBtn).CornerRadius = UDim.new(0, 12)
local rollGrad = Instance.new("UIGradient")
rollGrad.Rotation = 90
rollGrad.Color = ColorSequence.new(Color3.fromRGB(255, 200, 90), Color3.fromRGB(255, 150, 20))
rollGrad.Parent = rollBtn

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 140, 0, 34)
resetBtn.Position = UDim2.new(0.5, -70, 0, 386)
resetBtn.BackgroundColor3 = THEME.panel2
resetBtn.Text = "RESET"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 14
resetBtn.TextColor3 = THEME.text
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false
resetBtn.ZIndex = 7
resetBtn.Parent = win
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 10)

local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function() tween(btn, 0.15, { BackgroundColor3 = hover }) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.15, { BackgroundColor3 = normal }) end)
end
addHover(rollBtn, THEME.accent, Color3.fromRGB(255, 200, 90))
addHover(resetBtn, THEME.panel2, Color3.fromRGB(58, 63, 80))
addHover(openBtn, Color3.fromRGB(30, 33, 42), Color3.fromRGB(40, 44, 56))

-- ==== LOGIK ====
local rolling = false
local stats = { rolls = 0, best = 0, total = 0 }

local function roll()
    if rolling then return end
    rolling = true
    rollBtn.Text = "..."
    playSound(SOUND_ROLL, 0.35, 1)

    local colors = pickColors()
    for i, d in ipairs(dice) do
        d.body.BackgroundColor3 = colors[i]
        d.glow.BackgroundColor3 = colors[i]
    end

    for _ = 1, 16 do
        for i, d in ipairs(dice) do
            renderFace(d, math.random(1, 6))
            d.holder.Rotation = math.random(-15, 15)
        end
        _wait(0.05)
    end

    local results = {}
    local sum = 0
    for i, d in ipairs(dice) do
        local f = math.random(1, 6)
        results[i] = f
        sum += f
        renderFace(d, f)
        tween(d.holder, 0.25, { Rotation = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        d.body.Size = UDim2.new(1.15, 0, 1.15, 0)
        d.body.Position = UDim2.new(-0.075, 0, -0.075, 0)
        tween(d.body, 0.3, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
        }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    stats.rolls += 1
    stats.total += sum
    if sum > stats.best then stats.best = sum end

    detailLabel.Text = table.concat(results, "   +   ")
    if sum == 24 then
        sumLabel.Text = "SUMME: 24  -  PERFEKT!"
    elseif sum == 4 then
        sumLabel.Text = "SUMME: 4  -  MINIMUM!"
    else
        sumLabel.Text = "SUMME: " .. sum
    end
    statsLabel.Text = string.format(
        "Wuerfe: %d    Bester: %d    Schnitt: %.1f",
        stats.rolls, stats.best, stats.total / stats.rolls)

    playSound(SOUND_RESULT, 0.4, 1)
    rollBtn.Text = "ROLL"
    rolling = false
end

onClick(rollBtn, roll)

onClick(resetBtn, function()
    stats.rolls, stats.best, stats.total = 0, 0, 0
    sumLabel.Text = "SUMME: --"
    detailLabel.Text = "Druecke ROLL!"
    statsLabel.Text = "Wuerfe: 0    Bester: 0    Schnitt: 0.0"
end)

-- ==== KEYBIND (Notfall, falls Klicks blockiert werden) ====
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setOpen(not winOpen)
    end
end)
