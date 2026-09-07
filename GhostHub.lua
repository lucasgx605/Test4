-- GhostHub V3 - PC FIX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local noclip = false
local speedOn = false
local flySpeed = 60

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GhostHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local function btn(txt, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,140,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = txt
    b.Parent = gui
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.white
    return b
end

local flyBtn = btn("FLY: OFF", 10)
local noclipBtn = btn("NOCLIP: OFF", 55)
local speedBtn = btn("SPEED: OFF", 100)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
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

-- Anti-reset do jogo
RunService.Heartbeat:Connect(function()
    if speedOn and humanoid.WalkSpeed ~= 100 then
        humanoid.WalkSpeed = 100
    end
    -- FLY
    if flying then
        local cam = workspace.CurrentCamera.CFrame
        local dir = humanoid.MoveDirection -- funciona com WASD
        local vel = Vector3.new(0,0,0)
        
        if dir.Magnitude > 0 then
            vel = vel + cam.RightVector * dir.X
            vel = vel - Vector3.new(cam.LookVector.X, 0, cam.LookVector.Z).Unit * dir.Z * -1
            -- jeito mais simples e que funciona:
            vel = Vector3.new(cam.LookVector.X * -dir.Z, 0, cam.LookVector.Z * -dir.Z) + Vector3.new(cam.RightVector.X * dir.X, 0, cam.RightVector.Z * dir.X)
        end
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            vel = vel + Vector3.new(0,1,0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.S) and false then
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel = vel - Vector3.new(0,1,0)
        end

        if vel.Magnitude > 0 then
            hrp.Velocity = vel.Unit * flySpeed
        else
            hrp.Velocity = Vector3.new(0,0,0)
        end
        -- trava gravidade
        hrp.AssemblyLinearVelocity = hrp.Velocity
    end
end)

-- NOCLIP tem que ser no Stepped
RunService.Stepped:Connect(function()
    if noclip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

-- Mantem Velocity zerando a gravidade enquanto voa
RunService.RenderStepped:Connect(function()
    if flying then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

print("GhostHub V3 carregado")
