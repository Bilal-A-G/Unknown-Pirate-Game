local captainEvent = game.ReplicatedStorage:WaitForChild("Common").CaptainShip
local ships = game.Workspace
local player = game.Players.LocalPlayer
local character = player.Character
if not character then
	character = player.CharacterAdded:Wait()
end
local rightFoot = character:WaitForChild("RightFoot")
local debounce = false
local userInputService = game:GetService("UserInputService")

rightFoot.Touched:Connect(function(hit)
	if debounce == false then
		debounce = true
		for i,v in pairs(ships:GetChildren()) do
			if v:FindFirstChild("Helm") then
				if v:FindFirstChild("Helm") == hit then
					if v.Variables.CaptainId.Value == 0 then
						captainEvent:FireServer("SetCaptain", v)
					end
				end
			end
		end
		debounce = false
	end
end)