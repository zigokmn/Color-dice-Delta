# Color-dice-Delta
Color-dice-delta
--[[
    Color Dice Script (Delta Executor Edition)
    Style: gperya.neocities.org (colorful retro tile dice)
    Author: Venice
    Compatible: Delta Executor / Luau
--]]

-- ==== SERVICES ====
local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- ==== CLEANUP ====
if CoreGui:FindFirstChild("ColorDiceGUI") then
    CoreGui.ColorDiceGUI:Destroy()
end
if player:WaitForChild("PlayerGui"):FindFirstChild("ColorDiceGUI") then
    player.PlayerGui.ColorDiceGUI:Destroy()
end

-- ==== CONFIG ====
local DICE_COLORS = {
    Color3.fromRGB(255, 60, 60),   -- rot
    Color3.fromRGB(60, 120, 255),  -- blau
    Color3.fromRGB(60, 220, 120),  -- grün
    Color3.fromRGB(255, 200, 50),  -- gelb
    Color3.fromRGB(200, 80, 255),  -- lila
    Color3.fromRGB(255, 130, 200), -- pink
    Color3.fromRGB(0, 230, 230),   -- cyan
    Color3.fromRGB(255, 150, 40),  -- orange
}

local DICE_FACES = {
    -- Pip-Positionen für Würfelseite 1..6 (auf 3x3 Raster)
    {5},                    -- 1
    {1, 9},                 -- 2
    {1, 5, 9},              -- 3
    {1, 3, 7, 9},           -- 4
    {1, 3, 5, 7, 9},        -- 5
    {1, 3, 4, 6, 7, 9},     -- 6
}

-- ==== GUI ====
local gui = Instance.new("ScreenGui")
gui.Name = "ColorDiceGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = (RunService:IsStudio() and player:WaitForChild("PlayerGui")) or CoreGui

-- Hintergrund-Frame (retro Papier-Look)
local bg = Instance.new("Frame")
bg.Name = "Background"
bg.Size = UDim2.new(0, 360, 0, 420)
bg.Position = UDim2.new(0.5, -180, 0.5, -210)
bg.BackgroundColor3 = Color3.fromRGB(245, 240, 220)
bg.BorderSizePixel = 0
bg.Parent = gui
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)

local bgStroke = Instance.new("UIStroke")
bgStroke.Thickness = 3
bgStroke.Color = Color3.fromRGB(30, 30, 30)
bgStroke.Parent = bg

-- Drag-Bar
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 34)
dragBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dragBar.BorderSizePixel = 0
dragBar.Parent = bg
local dragCorner = Instance.new("UICorner", dragBar)
dragCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "COLOR DICE"
title.Font = Enum.Font.Code
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245, 240, 220)
title.Parent = dragBar

-- Drag-Logik
local dragging, dragStart, startPos
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = bg.Position
    end
end)
dragBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        bg.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Würfel-Container
local diceFrame = Instance.new("Frame")
diceFrame.Size = UDim2.new(0, 240, 0, 240)
diceFrame.Position = UDim2.new(0.5, -120, 0, 60)
diceFrame.BackgroundColor3 = DICE_COLORS[1]
diceFrame.BorderSizePixel = 0
diceFrame.Parent = bg
Instance.new("UICorner", diceFrame).CornerRadius = UDim.new(0, 20)

local diceStroke = Instance.new("UIStroke")
diceStroke.Thickness = 4
diceStroke.Color = Color3.fromRGB(30, 30, 30)
diceStroke.Parent = diceFrame

-- Pip-Grid (3x3)
local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 60, 0, 60)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = diceFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = diceFrame

local pips = {}
for i = 1, 9 do
    local pip = Instance.new("Frame")
    pip.Name = "Pip" .. i
    pip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pip.BackgroundTransparency = 1
    pip.BorderSizePixel = 0
    pip.LayoutOrder = i
    pip.Parent = diceFrame
    Instance.new("UICorner", pip).CornerRadius = UDim.new(1, 0)
    pips[i] = pip
end

-- Ergebnis-Label
local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(1, 0, 0, 30)
resultLabel.Position = UDim2.new(0, 0, 1, -75)
resultLabel.BackgroundTransparency = 1
resultLabel.Font = Enum.Font.Code
resultLabel.TextSize = 22
resultLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
resultLabel.Text = "Drücke ROLL!"
resultLabel.Parent = bg

-- Roll-Button
local rollBtn = Instance.new("TextButton")
rollBtn.Size = UDim2.new(0, 240, 0, 40)
rollBtn.Position = UDim2.new(0.5, -120, 1, -40)
rollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rollBtn.Text = "ROLL"
rollBtn.Font = Enum.Font.Code
rollBtn.TextSize = 20
rollBtn.TextColor3 = Color3.fromRGB(245, 240, 220)
rollBtn.BorderSizePixel = 0
rollBtn.Parent = bg
Instance.new("UICorner", rollBtn).CornerRadius = UDim.new(0, 10)

-- ==== LOGIK ====
local rolling = false

local function renderFace(n)
    for i = 1, 9 do
        pips[i].BackgroundTransparency = 1
    end
    for _, idx in ipairs(DICE_FACES[n]) do
        pips[idx].Background
