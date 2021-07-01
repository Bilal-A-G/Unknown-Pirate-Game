local ocean = game.Workspace:FindFirstChild("Ocean")
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local chunks = require(game.ReplicatedStorage:WaitForChild("Common").Chunks)
local currentChunksTable = {}

local function CreateWaves()
    for i,v in pairs(ocean:GetChildren())  do
        local name = v.Name .. i
        waves.New(name, v)
        table.insert(currentChunksTable, name)
    end
end

local function UpdateWaves()
    for i = 1, #currentChunksTable  do
        waves:Update(currentChunksTable[i])
    end
end

local function LoadChunks()
    chunks:UpdateChunks()
    wait(0.1)
    CreateWaves()
    UpdateWaves()
end

local function TerminateChunks()
    print("Terminating Chunks")
    chunks:TerminateChunks(true)
    waves:Terminate()
end

LoadChunks()

