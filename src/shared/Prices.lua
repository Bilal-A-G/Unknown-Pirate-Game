local playerProfiles = game.ReplicatedStorage:WaitForChild("PlayerProfiles")
local boyancy = game.ReplicatedStorage:WaitForChild("Events").Boyancy
local ships = game.ReplicatedStorage:WaitForChild("Ships")
local shipInfo = require(game.ReplicatedStorage:WaitForChild("Common").Ship)
local economyInformation = {}

economyInformation.Prices = {

	TestShip = 1000,
	GrapeJuice = 300,
	Sugar = 15,
	Tea = 215,

}

economyInformation.Regions = {
	
	StartPort = {
		
		Sugar = -10,
		GrapeJuice = -100,
		Tea = 85,
		
	},
	
	MiddlePort = {

		Sugar = 15,
		GrapeJuice = -200,
		Tea = -165,

	},
	
	EndPort = {
		
		Sugar = -5,
		GrapeJuice = 300,
		Tea = -115,
		
	},
	
}

function economyInformation.GiveMoney(player, amount)
	local playerProfile = playerProfiles:FindFirstChild(player.UserId)
	if playerProfile then
		local doubloons = playerProfile.Doubloons
		doubloons.Value = doubloons.Value + amount
	end
end

function economyInformation.SubtractMoney(player, amount)
	local playerProfile = playerProfiles:FindFirstChild(player.UserId)
	if playerProfile then
		local doubloons = playerProfile.Doubloons
		if doubloons.Value >= amount then
			doubloons.Value = doubloons.Value - amount
			return true
		end
	end
	return false
end

function economyInformation.GiveItem(player, item)
	local playerProfile = playerProfiles:FindFirstChild(player.UserId)
	if playerProfile then
		local backpack = playerProfile.Backpack
		local backpackItem = backpack:FindFirstChild(item)
		if backpackItem then
			backpackItem.Value = backpackItem.Value + 1
		end
		if item == "TestShip" then
			local shipClone = ships.TestShip:Clone()
			shipClone.Parent = game.Workspace
			shipClone.Name = shipClone.Variables.ShipName.Value .. " " .. player.UserId
			playerProfile.Ship.Value = shipClone.Name
			shipInfo.CreateBodyMovers(shipClone)
			boyancy:Fire(shipClone, "Ship")
		end
	end
end

function economyInformation.RemoveItem(player, item)
	local playerProfile = playerProfiles:FindFirstChild(player.UserId)
	if playerProfile then
		local backpack = playerProfile.Backpack
		for i,v in pairs(backpack:GetChildren()) do
			if v.Name == item and v.Value > 0 then
				v.Value = v.Value - 1
				return true
			else
				return false
			end
		end
	end
end

return economyInformation