local players = game:GetService("Players")
local player = players.LocalPlayer
local chunks = require(game.ReplicatedStorage:WaitForChild("Common").Chunks)
local floatingEvent = game.ReplicatedStorage:WaitForChild("Events").FloatingPart
local part = game.Workspace:FindFirstChild("SS Physics")

chunks:UpdateChunks(player)
floatingEvent:FireServer("OceanPlane00", part)

