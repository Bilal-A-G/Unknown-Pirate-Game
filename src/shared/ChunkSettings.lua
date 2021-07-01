local chunkSettings = {
    ChunkDirectory = game.Workspace.Ocean,
    ChunkTemplate = game.ReplicatedStorage:WaitForChild("Chunks").OceanPlane,
    
    DrawDistance = 2000,
    ChunkSize = 2000,
}

return chunkSettings