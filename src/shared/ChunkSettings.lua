local chunkSettings = {
    ChunkDirectory = game.Workspace.Ocean,
    ChunkTemplate = game.ReplicatedStorage:WaitForChild("Chunks").OceanPlane,
    ChunkName = "OceanPlane",

    DrawDistance = 2000,
    ChunkSize = 2000,
}

return chunkSettings