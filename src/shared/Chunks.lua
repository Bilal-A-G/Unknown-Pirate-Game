local chunks = {}
chunks.chunkTable = {}

local chunkSettings = require(game.ReplicatedStorage:WaitForChild("Common").ChunkSettings)
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
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

function chunks.CreateChunk(x, z)
    local chunk = chunkSettings.ChunkTemplate:Clone()
    chunks.SetArray(x, z, chunk)
    chunk.Parent = chunkSettings.ChunkDirectory

    local calculatedPosition = Vector2.new(x, z) * chunkSettings.ChunkSize
    chunk.Position = Vector3.new(calculatedPosition.X, 0, calculatedPosition.Y)
    chunk.Name = chunkSettings.ChunkName .. x .. z 
    
    waves.New(chunk.Name, chunk)
    waves:Update(chunk.Name)
end

function chunks:UpdateChunks(player)
    chunkConnection = runService.Stepped:Connect(function()
        local playerCharacter = player.Character

        local playerPosition = playerCharacter:FindFirstChild("HumanoidRootPart").Position 
        local chunksVisible = math.round(chunkSettings.DrawDistance / chunkSettings.ChunkSize)

        local currentChunkX = math.round(playerPosition.X / chunkSettings.ChunkSize)
        local currentChunkZ = math.round(playerPosition.Z / chunkSettings.ChunkSize)

        for x = -chunksVisible, chunksVisible do
            for z = -chunksVisible, chunksVisible do
                local indexX = currentChunkX + z
                local indexZ = currentChunkZ + x
                if not chunkSettings.ChunkDirectory:FindFirstChild(chunkSettings.ChunkName .. indexX .. indexZ) then
                    chunks.CreateChunk(indexX, indexZ)
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