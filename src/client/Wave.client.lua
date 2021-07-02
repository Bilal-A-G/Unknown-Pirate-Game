local ocean = game.Workspace:FindFirstChild("Ocean")
local players = game:GetService("Players")
local player = players.LocalPlayer
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local chunks = require(game.ReplicatedStorage:WaitForChild("Common").Chunks)
local platform = game.Workspace.Platform.Part
local currentChunksTable = {}

local function LoadChunks()
    chunks:UpdateChunks(player)
end

local function TerminateChunks()
    print("Terminating Chunks")
    chunks:TerminateChunks(true)
    waves:Terminate()
end

LoadChunks()

