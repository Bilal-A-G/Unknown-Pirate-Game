local ocean = game.Workspace:FindFirstChild("OceanPlane")
local oceanBones = ocean:GetChildren()
local runService = game:GetService("RunService")
local waveSettings = require(game.ReplicatedStorage:WaitForChild("Common").WaveSettings)
local clock = require(game.ReplicatedStorage:WaitForChild("Common").Clock)
local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character
if not character or character == nil then
    character = player.CharacterAdded:Wait()
end

clock:Initialize()
print("Initialized")

local function SinesApproximation(point)
    local wavelength = waveSettings.Calm_Wave.Wavelength
    local amplitude = waveSettings.Calm_Wave.Amplitude
    local speed = waveSettings.Calm_Wave.Speed
    local windDirection = waveSettings.Calm_Wave.WindDirection

    local w = 2/wavelength
    local phaseConstant = speed * w

    return amplitude * math.sin(windDirection:Dot(point) * w + clock:GetTime() * phaseConstant)
end

runService.Stepped:Connect(function()
     for i,v in pairs(oceanBones) do
        if v:IsA("Bone") then
            local boneHeight = SinesApproximation(Vector2.new(v.Position.X, v.Position.Z))
            v.Position = Vector3.new(v.Position.X, boneHeight, v.Position.Z)
        end
     end   
end)