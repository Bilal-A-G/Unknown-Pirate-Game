local chunks = {}
chunks.chunkTable = {}

local chunkSettings = require(game.ReplicatedStorage:WaitForChild("Common").ChunkSettings)
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local runService = game:GetService("RunService")
local chunkConnection
local renderDistance = chunkSettings.DrawDistance * 1.5

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
    chunk.Name = chunkSettings.ChunkName .. x .. z 

    local calculatedPosition = Vector2.new(x, z) * chunkSettings.ChunkSize
    chunk.Position = Vector3.new(calculatedPosition.X, 0, calculatedPosition.Y)

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
                local currentChunkInDirectory = chunkSettings.ChunkDirectory:FindFirstChild(chunkSettings.ChunkName .. indexX .. indexZ)
                if not currentChunkInDirectory then
                    chunks.CreateChunk(indexX, indexZ)
                end
            end
        end

        for i = 1, #chunkSettings.ChunkDirectory:GetChildren()  do
            if (chunkSettings.ChunkDirectory:GetChildren()[i].Position - playerPosition).Magnitude > renderDistance then
                chunks.SetActive(false, chunkSettings.ChunkDirectory:GetChildren()[i])
            elseif (chunkSettings.ChunkDirectory:GetChildren()[i].Position - playerPosition).Magnitude <= renderDistance then
                chunks.SetActive(true, chunkSettings.ChunkDirectory:GetChildren()[i])
            end
        end
    end)
end

function chunks.SetActive(isActive, chunk)
    local decal = chunk:FindFirstChild("Decal")
    if isActive and chunk then
        if chunk.Transparency == 1 and decal.Transparency == 1 then
            decal.Transparency = 0.2
            chunk.Transparency = 0
            waves.New(chunk.Name, chunk)
            waves:Update(chunk.Name)
        end
    elseif not isActive and chunk then
        decal.Transparency = 1
        chunk.Transparency = 1
        waves:Terminate(chunk.Name)
    end
end

return chunks