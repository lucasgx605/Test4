-- GhostHub V4 - PC Estável
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
end)

local flying = false
local noclip = false
local speedOn = false
local flySpeed = 70

local gui = Instance.new("ScreenGui")
gui.Name = "GhostHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local function mkBtn(txt, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,140,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = gui
    return b
end

local flyBtn = mkBtn("FLY: OFF", 10)
local noclipBtn = mkBtn("NOCLIP: OFF", 55)
local speedBtn = mkBtn("SPEED: OFF", 100)

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(9e9,9e9,9e9)
bv.Velocity = Vector3.new(0,0,0)
bv.Parent = hrp

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
bg.CFrame = hrp.CFrame
bg.Parent = hrp

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
    bv.Enabled = flying
    bg.Enabled = flying
    if flying then
        humanoid.PlatformStand = true
    else
        humanoid.PlatformStand = false
        bv.Velocity = Vector3.new(0,0,0)
    end
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

RunService.Heartbeat:Connect(function()
    if speedOn and humanoid.WalkSpeed ~= 100 then
        humanoid.WalkSpeed = 100
    end
    if flying then
        bg.CFrame = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        local camCF = workspace.CurrentCamera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            bv.Velocity = move.Unit * flySpeed
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclip or flying then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end
end)

print("GhostHub V4 ON")
