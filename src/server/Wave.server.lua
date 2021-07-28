-- Gets the waves module and the floatingpart event
local waves = require(game.ReplicatedStorage:WaitForChild("Common").Waves)
local floatingEvent = game.ReplicatedStorage:WaitForChild("Events").FloatingPart 

--When the floatingpart event is triggered, set the SS Physics' network ownership to the player (This is done so I can see the boat move in the server view)
floatingEvent.OnServerEvent:Connect(function(player, waveName, part)
    game.Workspace:FindFirstChild("SSPhysics"):SetNetworkOwner(player)
    print("Set network ownership")
    --local character = player.Character
    --if not character then
        --character = player.CharacterAdded:Wait()
    --end
    --local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    --if humanoidRootPart and not humanoidRootPart:FindFirstChild("VectorForce") then
        --waves.SimulatePhysics(waveName, part)
    --end
end)