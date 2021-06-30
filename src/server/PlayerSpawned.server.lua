local players = game:GetService("Players")

local playerProfiles = game.ReplicatedStorage:WaitForChild("PlayerProfiles")
local prices = require(game.ReplicatedStorage:WaitForChild("Common").Prices)

players.PlayerAdded:Connect(function(player)
	local profile = Instance.new("Folder", playerProfiles)
	profile.Name = player.UserId
	local doubloons = Instance.new("IntValue", profile)
	doubloons.Value = 1500
	doubloons.Name = "Doubloons"
	local backpack = Instance.new("Folder", profile)
	backpack.Name = "Backpack"
	local ship = Instance.new("StringValue", profile)
	ship.Name = "Ship"
	ship.Value = "None"
	local usingShip = Instance.new("BoolValue", ship)
	usingShip.Name = "Using"
	for i,v in pairs(prices["Prices"]) do
		local intValue = Instance.new("IntValue", backpack)
		intValue.Name = i
		intValue.Value = 0
	end
end)

players.PlayerRemoving:Connect(function(player)
	if playerProfiles:FindFirstChild(player.UserId) then
		playerProfiles:FindFirstChild(player.UserId):Destroy()
	end
end)
