-- GhostHub by lucasgx605
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flying = false
local noclip = false
local flySpeed = 50

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GhostHub"

local function createBtn(text, posY)
    local b = Instance.new("TextButton", gui)
    b.Size = UDim2.new(0, 120, 0, 40)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    return b
end

local flyBtn = createBtn("FLY: OFF", 10)
local noclipBtn = createBtn("NOCLIP: OFF", 55)
local speedBtn = createBtn("SPEED: 16", 100)

local bv = Instance.new("BodyVelocity", hrp)
bv.MaxForce = Vector3.new(9e9,9e9,9e9)
bv.Velocity = Vector3.new(0,0,0)
bv.Enabled = false

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    bv.Enabled = flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

speedBtn.MouseButton1Click:Connect(function()
    if humanoid.WalkSpeed == 16 then
        humanoid.WalkSpeed = 100
        speedBtn.Text = "SPEED: 100"
    else
        humanoid.WalkSpeed = 16
        speedBtn.Text = "SPEED: 16"
    end
end)

RunService.Stepped:Connect(function()
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        bv.Velocity = move * flySpeed
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
end)
