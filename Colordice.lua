--[[ Color Dice - Delta Executor Edition ]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

local player = Players.LocalPlayer

local old = CoreGui:FindFirstChild("ColorDiceRoot")
    or player:WaitForChild("PlayerGui"):FindFirstChild("ColorDiceRoot")
if old then old:Destroy() end

local parentGui
pcall(function() if gethui then parentGui = gethui() end end)
if not parentGui then
    parentGui = (RunService:IsStudio() and player:WaitForChild("PlayerGui")) or CoreGui
end

local gui = Instance.new("ScreenGui")
gui.Name = "ColorDiceRoot"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui

local DICE_COLORS = {
    Color3.fromRGB(255, 60, 60), Color3.fromRGB(60, 120, 255),
    Color3.fromRGB(60, 220, 120), Color3.fromRGB(255, 200, 50),
    Color3.fromRGB(200, 80, 255), Color3.fromRGB(255, 130, 200),
    Color3.fromRGB(0, 230, 230), Color3.fromRGB(255, 150, 40),
}
local DICE_FACES = { {5},{1,9},{1,5,9},{1,3,7,9},{1,3,5,7,9},{1,3,4,6,7,9} }

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 44)
openBtn.Position = UDim2.new(0, 20, 1, -64)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openBtn.Text = "Color Dice"
openBtn.Font = Enum.Font.Code
openBtn.TextSize = 16
openBtn.TextColor3 = Color3.fromRGB(245, 240, 220)
openBtn.BorderSizePixel = 0
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 340, 0, 400)
win.Position = UDim2.new(0.5, -170, 0.5, -200)
win.BackgroundColor3 = Color3.fromRGB(245, 240, 220)
win.BorderSizePixel = 0
win.Visible = false
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 12)
local winStroke = Instance.new("UIStroke")
winStroke.Thickness = 3
winStroke.Color = Color3.fromRGB(30, 30, 30)
winStroke.Parent = win

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 34)
bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bar.BorderSizePixel = 0
bar.Parent = win
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "COLOR DICE"
title.Font = Enum.Font.Code
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(245, 240, 220)
title.Parent = bar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Code
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = bar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

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

local diceFrame = Instance.new("Frame")
diceFrame.Size = UDim2.new(0, 220, 0, 220)
diceFrame.Position = UDim2.new(0.5, -110, 0, 50)
diceFrame.BackgroundColor3 = DICE_COLORS[1]
diceFrame.BorderSizePixel = 0
diceFrame.Parent = win
Instance.new("UICorner", diceFrame).CornerRadius = UDim.new(0, 20)
local diceStroke = Instance.new("UIStroke")
diceStroke.Thickness = 4
diceStroke.Color = Color3.fromRGB(30, 30, 30)
diceStroke.Parent = diceFrame

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 55, 0, 55)
grid.CellPadding = UDim2.new(0, 8, 0, 8)
grid.Parent = diceFrame
local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingLeft = UDim.new(0, 10)
pad.Parent = diceFrame

local pips = {}
for i = 1, 9 do
    local pip = Instance.new("Frame")
    pip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pip.BackgroundTransparency = 1
    pip.BorderSizePixel = 0
    pip.LayoutOrder = i
    pip.Parent = diceFrame
    Instance.new("UICorner", pip).CornerRadius = UDim.new(1, 0)
    pips[i] = pip
end

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, 0, 0, 28)
resultLabel.Position = UDim2.new(0, 0, 1, -68)
resultLabel.BackgroundTransparency = 1
resultLabel.Font = Enum.Font.Code
resultLabel.TextSize = 20
resultLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
resultLabel.Text = "Druecke ROLL!"
resultLabel.Parent = win

local rollBtn = Instance.new("TextButton")
rollBtn.Size = UDim2.new(0, 220, 0, 40)
rollBtn.Position = UDim2.new(0.5, -110, 1, -44)
rollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rollBtn.Text = "ROLL"
rollBtn.Font = Enum.Font.Code
rollBtn.TextSize = 20
rollBtn.TextColor3 = Color3.fromRGB(245, 240, 220)
rollBtn.BorderSizePixel = 0
rollBtn.Parent = win
Instance.new("UICorner", rollBtn).CornerRadius = UDim.new(0, 10)

-- ==== LOGIK ====
local rolling = false

local function renderFace(n)
    for i = 1, 9 do pips[i].BackgroundTransparency = 1 end
    for _, idx in ipairs(DICE_FACES[n]) do
        pips[idx].BackgroundTransparency = 0
    end
end

local function roll()
    if rolling then return end
    rolling = true
    rollBtn.Text = "..."
    resultLabel.Text = "Roll
