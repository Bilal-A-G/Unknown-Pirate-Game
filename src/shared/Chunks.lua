local chunks = {}
chunks.chunkTable = {}

local chunkSettings = require(game.ReplicatedStorage:WaitForChild("Common").ChunkSettings)
local runService = game:GetService("RunService")
local chunkConnection

function chunks:UpdateChunks(playerPosition)
    chunkConnection = runService.Stepped:Connect(function()
        if #chunks.chunkTable == 0 then
            local initialChunk = chunkSettings.ChunkTemplate:Clone()
            initialChunk.Parent = chunkSettings.ChunkDirectory
            table.insert(chunks.chunkTable, initialChunk)
        elseif #chunks.chunkTable > 0 then
            print("More than one chunk active")
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