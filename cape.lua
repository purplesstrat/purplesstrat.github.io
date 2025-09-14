local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lplr = Players.LocalPlayer
local char = lplr.Character or lplr.CharacterAdded:Wait()

local humanoid = char:WaitForChild("Humanoid")
local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")

-- Create cape part
local CapeP = Instance.new("Part")
CapeP.Name = "Cape"
CapeP.Anchored = false
CapeP.CanCollide = false
CapeP.Material = Enum.Material.Forcefield
CapeP.Size = Vector3.new(0.2,0.2,0.2)
CapeP.Parent = char

-- Block mesh for scaling
local msh = Instance.new("BlockMesh", CapeP)
msh.Scale = Vector3.new(9,17.5,0.5)

-- Decal
local decal = Instance.new("Decal", CapeP)
decal.Face = Enum.NormalId.Back
decal.Transparency = torso.Transparency

-- Motor to attach cape
local motor = Instance.new("Motor", CapeP)
motor.Part0 = CapeP
motor.Part1 = torso
motor.MaxVelocity = 0.01
motor.C0 = CFrame.new(0,1.75,0) * CFrame.Angles(0,math.rad(90),0)
motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)

-- Rainbow color
local hue = 0
RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.2) % 1
    CapeP.Color = Color3.fromHSV(hue, 1, 1)
end)

-- Cape waving
local wave = false
spawn(function()
    while CapeP.Parent == char do
        wait(1/44)
        decal.Transparency = torso.Transparency
        local ang = 0.1
        local oldmag = torso.Velocity.Magnitude
        local mv = 0.002
        if wave then
            ang = ang + ((torso.Velocity.Magnitude/10) * 0.05) + 0.05
            wave = false
        else
            wave = true
        end
        ang = ang + math.min(torso.Velocity.Magnitude/11, 0.5)
        motor.MaxVelocity = math.min((torso.Velocity.Magnitude/111), 0.04) + mv
        motor.DesiredAngle = -ang
        if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
            motor.MaxVelocity = 0.04
        end
        repeat wait() until math.abs(motor.CurrentAngle - motor.DesiredAngle) < 0.01 or math.abs(torso.Velocity.Magnitude - oldmag) >= (torso.Velocity.Magnitude/10) + 1
        if torso.Velocity.Magnitude < 0.1 then
            wait(0.1)
        end
    end
end)
