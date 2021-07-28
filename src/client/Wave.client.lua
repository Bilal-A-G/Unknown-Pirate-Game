local players = game:GetService("Players")
local player = players.LocalPlayer
local chunks = require(game.ReplicatedStorage:WaitForChild("Common").Chunks)
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local floatingEvent = game.ReplicatedStorage:WaitForChild("Events").FloatingPart
local part = game.Workspace:FindFirstChild("SSPhysics")

chunks:UpdateChunks(player)
waves.SimulatePhysics("OceanPlane00", part)
floatingEvent:FireServer(part)

