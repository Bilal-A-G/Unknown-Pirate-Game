--Chunks table and a sub-table within called chunkTable
local chunks = {}
chunks.chunkTable = {}

--Gets a bunch of modules, an event, and runservice
local chunkSettings = require(game.ReplicatedStorage:WaitForChild("Common").ChunkSettings)
local waveSettings = require(game.ReplicatedStorage:WaitForChild("Common").WaveSettings)
local floatingEvent = game.ReplicatedStorage:WaitForChild("Events").FloatingPart
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local runService = game:GetService("RunService")
local chunkConnection
local renderDistance = chunkSettings.DrawDistance * 1.5

--Set array function within the chunks table that creates a 2d array (x and z values used as a key to access a chunk)
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

--Populates the chunk array, names the chunk, positions the chunk, creates a new wave instance, and runs update with that wave instance
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

--Creates a runservice loop which handles gerstner wave transformations for bones in the chunk, sets chunks as active or inactive based on distance from player, and caches the runservice loop for later use
function chunks:UpdateChunks(player)
    chunkConnection = runService.Stepped:Connect(function()
        local playerCharacter = player.Character
        local humanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")
        local playerPosition = humanoidRootPart.Position 
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

--Terminates the wave instance in the chunk if isActive is false or creates a new wave instance if isActive is true and runs update with that instance
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