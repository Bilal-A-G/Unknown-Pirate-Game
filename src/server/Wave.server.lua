local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local floatingEvent = game.ReplicatedStorage:WaitForChild("Events").FloatingPart 

floatingEvent.OnServerEvent:Connect(function(player, waveName, part)
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait()
    end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("VectorForce") then
        waves.SimulatePhysics(waveName, part)
    end
end)