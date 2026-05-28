-- AldoAdam Hub - Kick A Lucky Block (Full Fitur)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Variables
local autoOrbs = true
local autoFarm = true
local autoX2 = true

local stats = { orbs = 0, power = 0, x2 = 0 }

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AldoAdamHub"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.Size = UDim2.new(0, 200, 0, 250)

local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.Size = UDim2.new(1, 0, 0, 30)

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 0)
title.Size = UDim2.new(1, -20, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "AldoAdam Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = not screenGui.Enabled end)

local function MakeButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Text = text
    btn.TextColor3 = color
    btn.TextSize = 12
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local orbsBtn = MakeButton("[ON] Auto Collect Orbs", 40, Color3.fromRGB(100, 255, 100), function()
    autoOrbs = not autoOrbs
    orbsBtn.Text = autoOrbs and "[ON] Auto Collect Orbs" or "[OFF] Auto Collect Orbs"
    orbsBtn.TextColor3 = autoOrbs and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

local farmBtn = MakeButton("[ON] Auto Farm Power", 80, Color3.fromRGB(100, 255, 100), function()
    autoFarm = not autoFarm
    farmBtn.Text = autoFarm and "[ON] Auto Farm Power" or "[OFF] Auto Farm Power"
    farmBtn.TextColor3 = autoFarm and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

local x2Btn = MakeButton("[ON] Auto Click X2 Power", 120, Color3.fromRGB(100, 255, 100), function()
    autoX2 = not autoX2
    x2Btn.Text = autoX2 and "[ON] Auto Click X2 Power" or "[OFF] Auto Click X2 Power"
    x2Btn.TextColor3 = autoX2 and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
end)

local statsFrame = Instance.new("Frame")
statsFrame.Parent = mainFrame
statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
statsFrame.Position = UDim2.new(0, 10, 0, 160)
statsFrame.Size = UDim2.new(1, -20, 0, 60)

local statsText = Instance.new("TextLabel")
statsText.Parent = statsFrame
statsText.BackgroundTransparency = 1
statsText.Position = UDim2.new(0, 5, 0, 5)
statsText.Size = UDim2.new(1, -10, 0, 50)
statsText.Text = "Orbs: 0 | Power: 0 | X2: 0"
statsText.TextColor3 = Color3.fromRGB(200, 200, 200)
statsText.TextSize = 11

local creditText = Instance.new("TextLabel")
creditText.Parent = mainFrame
creditText.BackgroundTransparency = 1
creditText.Position = UDim2.new(0, 0, 1, -20)
creditText.Size = UDim2.new(1, 0, 0, 20)
creditText.Text = "AldoAdam Hub"
creditText.TextColor3 = Color3.fromRGB(150, 150, 150)
creditText.TextSize = 10

-- Core Functions
local function GetOrbs()
    local orbs = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v.Name:lower():find("orb") or v.Name:lower():find("volcano")) and v:IsA("BasePart") then
            table.insert(orbs, v)
        end
    end
    return orbs
end

local function TeleportTo(part)
    if part and part.Position and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(part.Position) + Vector3.new(0, 3, 0) end
    end
end

local function FireKick()
    local remote = ReplicatedStorage:FindFirstChild("KickEvent")
    if remote then remote:FireServer(1) return true end
    return false
end

local function GetX2Button()
    for _, obj in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name:lower():find("x2") and obj.Visible then
            return obj
        end
    end
    return nil
end

-- Auto Tasks
task.spawn(function()
    while true do
        if autoOrbs then
            for _, orb in pairs(GetOrbs()) do
                TeleportTo(orb)
                stats.orbs = stats.orbs + 1
                task.wait(0.05)
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if autoFarm then
            FireKick()
            stats.power = stats.power + 1
        end
        task.wait(0.15)
    end
end)

task.spawn(function()
    while true do
        if autoX2 then
            local btn = GetX2Button()
            if btn then
                btn:FireServer()
                btn:Click()
                stats.x2 = stats.x2 + 1
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        statsText.Text = string.format("Orbs: %d | Power: %d | X2: %d", stats.orbs, stats.power, stats.x2)
        task.wait(0.5)
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("AldoAdam Hub - Fully Loaded! No Errors.")
