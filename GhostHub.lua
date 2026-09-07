-- GhostHub V6 - Painel + TP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
    if flying then bv.Parent = hrp; bg.Parent = hrp end
end)

local flying = false
local noclip = false
local speedOn = false
local flySpeed = 70
local panelOpen = true

local function findPlayer(txt)
    txt = string.lower(txt)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and (string.sub(string.lower(plr.Name),1,#txt)==txt or string.sub(string.lower(plr.DisplayName),1,#txt)==txt) then
            return plr
        end
    end
    return nil
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GhostHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0,220,0,430)
main.Position = UDim2.new(0,10,0,10)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "GHOSTHUB V6"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Parent = main

local function mkBtn(txt, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,200,0,32)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local flyBtn = mkBtn("FLY: OFF", 40)
local noclipBtn = mkBtn("NOCLIP: OFF", 78)
local speedBtn = mkBtn("SPEED: OFF", 116)
local killAllBtn = mkBtn("KILL ALL SERVER", 154)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0,200,0,32)
nameBox.Position = UDim2.new(0,10,0,196)
nameBox.PlaceholderText = "Nome do player"
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.Parent = main

local killBtn = mkBtn("KILL PLAYER", 236)
local tpToBtn = mkBtn("TP ATE PLAYER", 274)
local bringBtn = mkBtn("TRAZER PLAYER", 312)
local tpSpawnBtn = mkBtn("TP SPAWN", 350)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,60,0,30)
toggleBtn.Position = UDim2.new(0,10,0,450)
toggleBtn.Text = "ON/OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = gui
toggleBtn.MouseButton1Click:Connect(function()
    panelOpen = not panelOpen
    main.Visible = panelOpen
end)

-- Fly
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9,9e9,9e9)
bv.Enabled = false
bv.Parent = hrp
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
bg.Enabled = false
bg.Parent = hrp

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
    bv.Enabled = flying; bg.Enabled = flying
    humanoid.PlatformStand = flying
    if not flying then bv.Velocity = Vector3.new(0,0,0) end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "SPEED: ON" or "SPEED: OFF"
    humanoid.WalkSpeed = speedOn and 100 or 16
end)

killAllBtn.MouseButton1Click:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
end)

killBtn.MouseButton1Click:Connect(function()
    local t = findPlayer(nameBox.Text)
    if t and t.Character and t.Character:FindFirstChild("Humanoid") then
        t.Character.Humanoid.Health = 0
    end
end)

tpToBtn.MouseButton1Click:Connect(function()
    local t = findPlayer(nameBox.Text)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end)

bringBtn.MouseButton1Click:Connect(function()
    local t = findPlayer(nameBox.Text)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        t.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0,3,3)
    end
end)

tpSpawnBtn.MouseButton1Click:Connect(function()
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0) end
end)

RunService.Heartbeat:Connect(function()
    if speedOn and humanoid.WalkSpeed ~= 100 then humanoid.WalkSpeed = 100 end
    if flying then
        bg.CFrame = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        local cam = workspace.CurrentCamera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        bv.Velocity = move.Magnitude>0 and move.Unit*flySpeed or Vector3.new(0,0,0)
    end
end)

RunService.Stepped:Connect(function()
    if noclip or flying then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
        end
    end
end)
