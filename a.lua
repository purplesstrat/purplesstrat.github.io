-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Window = Library:NewWindow("RaveMVSD")

-- Tabs
local AutoFarmTab = Window:NewSection("AutoFarm")
local KillingTab = Window:NewSection("Kill")
local MainStuffTab = Window:NewSection("Main")
local ESPTab = Window:NewSection("ESP")

local autofarmRunning = false

AutoFarmTab:CreateToggle("Auto Farm", function(value)
    autofarmRunning = value

    if value then
        task.spawn(function()
            while autofarmRunning do
                kill_all()

                local char = game.Players.LocalPlayer.Character
                if char and char.PrimaryPart then
                    for i = 1, 50 do
                        if not autofarmRunning then return end
                        char:PivotTo(CFrame.new(0, 0, 0))
                        task.wait()
                    end
                end

                task.wait()
            end
        end)
    else
        -- Teleport to (-32, -118, 37) when turning off
        local char = game.Players.LocalPlayer.Character
        if char and char.PrimaryPart then
            char:PivotTo(CFrame.new(-32, -118, 37))
        end
    end
end)


-- Kill All Function
function kill_all()
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:FindFirstChild("Fire") then
            LocalPlayer.Character.Humanoid:EquipTool(v)
            break
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        task.spawn(function()
            pcall(function()
                local Vec1 = Vector3.new(-186.466, 49.75, math.random(-49.32, 49.48))
                local Vec2 = Vector3.new(-254.478, 68.999, math.random(-49.32, 49.48))
                local Vec3 = v.Character and v.Character:FindFirstChild("LowerTorso")
                local Vec4 = Vector3.new(-222.701, 60.865, math.random(-49.32, 49.48))
                if Vec3 then
                    ReplicatedStorage.Remotes.ShootGun:FireServer(Vec1, Vec2, Vec3, Vec4)
                end
            end)
        end)
    end
end

-- Kill All Button
KillingTab:CreateButton("Kill All", function()
    kill_all()
end)

-- Auto Kill All
local autoKill = false
KillingTab:CreateToggle("Auto Kill All", function(value)
    autoKill = value
    if value then
        task.spawn(function()
            while autoKill do
                kill_all()
                task.wait(1)
            end
        end)
    end
end)

-- Hitbox Expander
function hitbox(size)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local sameTeam = (LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team)
            if not sameTeam then
                local root = player.Character.HumanoidRootPart
                root.Size = Vector3.new(size, size, size)
                root.Transparency = 0.5
                root.Material = Enum.Material.Neon
                root.BrickColor = BrickColor.Red()
                root.CanCollide = false
            end
        end
    end
end

MainStuffTab:CreateTextbox("Hitbox", function(text)
    local val = tonumber(text) or 10
    while task.wait() do
    hitbox(val)
        end
end)

-- WalkSpeed Spoofer (Client Only)
cloneref = cloneref or function(o) return o end
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldindex = mt.__index
mt.__index = newcclosure(function(self, b)
    if b == 'WalkSpeed' then
        return 16
    end
    return oldindex(self, b)
end)

MainStuffTab:CreateTextbox("WalkSpeed", function(text)
    local val = tonumber(text) or 16
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = val
    end
end)

-- Infinite Jump
local infJumpConnection
MainStuffTab:CreateToggle("Infinite Jump", function(value)
    if value then
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConnection then
            infJumpConnection:Disconnect()
            infJumpConnection = nil
        end
    end
end)

-- XCT ESP
ESPTab:CreateButton("XCT ESP", function()
    local function ApplyESP(v)
        if v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
            local hum = v.Character.Humanoid
            hum.NameDisplayDistance = 9e9
            hum.NameOcclusion = Enum.NameOcclusion.NoOcclusion
            hum.HealthDisplayDistance = 9e9
            hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
            hum.Health = hum.Health -- trigger changed
        end
    end

    for _, v in pairs(Players:GetPlayers()) do
        ApplyESP(v)
        v.CharacterAdded:Connect(function()
            task.wait(0.33)
            ApplyESP(v)
        end)
    end

    Players.PlayerAdded:Connect(function(v)
        ApplyESP(v)
        v.CharacterAdded:Connect(function()
            task.wait(0.33)
            ApplyESP(v)
        end)
    end)
end)

-- Skeleton ESP
ESPTab:CreateButton("Skeleton ESP", function()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()


local Skeletons = {}
for _, Player in next, game.Players:GetChildren() do
	table.insert(Skeletons, Library:NewSkeleton(Player, true));
end
game.Players.PlayerAdded:Connect(function(Player)
	table.insert(Skeletons, Library:NewSkeleton(Player, true));
end)
end)

-- Radar ESP
ESPTab:CreateButton("Radar ESP", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Eazvy/UILibs/refs/heads/main/ESP/Radar/Example"))()
end)

-- Chams ESP
ESPTab:CreateButton("Chams ESP", function()
    local Players = game:GetService("Players")

local function highlightPlayer(player)
  local highlight = Instance.new("Highlight")
  highlight.Parent = player.Character
  highlight.FillColor = Color3.fromRGB(255, 0, 0)
  highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
end

for _, player in ipairs(Players:GetPlayers()) do
  highlightPlayer(player)
end
end)
