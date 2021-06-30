local ocean = game.Workspace:FindFirstChild("OceanPlane")
local ocean2 = game.Workspace:FindFirstChild("OceanPlane2")
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)

waves.New("My First Wave", ocean)
waves.New("My Second Wave", ocean2)

waves:Update("My First Wave")
waves:Update("My Second Wave")
