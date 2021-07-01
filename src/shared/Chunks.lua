local chunks = {}
chunks.chunkTable = {}

local chunkSettings = require(game.ReplicatedStorage:WaitForChild("Common").ChunkSettings)
local runService = game:GetService("RunService")
local chunkConnection

function chunks.SetArray(row, column, value)
    for x = -row, row do
        if chunks.chunkTable[x] == nil then
            chunks.chunkTable[x] = {}
        end
        for z = -column, column  do
            if chunks.chunkTable[x][z] == nil then
                chunks.chunkTable[x][z] = value
            end
        end
    end
end

function chunks.CreateChunk(x, z, playerPosition)
    local chunk = chunkSettings.ChunkTemplate:Clone()
    chunks.SetArray(x, z, chunk)
    chunk.Parent = chunkSettings.ChunkDirectory

    local calculatedPosition = Vector2.new(x, z) * chunkSettings.ChunkSize + Vector2.new(playerPosition.X, playerPosition.Z)
    chunk.Position = Vector3.new(calculatedPosition.X, 0, calculatedPosition.Y)
    chunk.Name = chunk.Name .. ": " .. x .. " " .. z 
end

function chunks:UpdateChunks(playerPosition)
    chunkConnection = runService.Stepped:Connect(function()
        local chunksVisible = math.round(chunkSettings.DrawDistance / chunkSettings.ChunkSize)
        for x = -chunksVisible, chunksVisible do
            for z = -chunksVisible, chunksVisible do
                if chunks.chunkTable[x] == nil or chunks.chunkTable[x][z] == nil then
                    chunks.CreateChunk(x,z, playerPosition)
                end
            end
        end
    end)
end

function chunks:TerminateChunks(destroyChunks)
    chunkConnection:Disconnect()
    if destroyChunks then
        for i = 1 ,#chunks.chunkTable  do
            chunks.chunkTable[i]:Destroy()
            table.remove(chunks.chunkTable, i)
        end
    end
end


return chunks