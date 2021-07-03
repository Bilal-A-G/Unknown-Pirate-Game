local players = game:GetService("Players")
local player = players.LocalPlayer
local chunks = require(game.ReplicatedStorage:WaitForChild("Common").Chunks)

chunks:UpdateChunks(player)
game.ReplicatedStorage:WaitForChild("Events").FloatingPart:FireServer("OceanPlane00", game.Workspace.Part)

