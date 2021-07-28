local buyingSpawning = game.ReplicatedStorage:WaitForChild("Events").BuyingSpawning
local sellingDeleting = game.ReplicatedStorage:WaitForChild("Events").SellingDeleting
local playerProfiles = game.ReplicatedStorage:WaitForChild("PlayerProfiles")
local prices = require(game.ReplicatedStorage:WaitForChild("Common").Prices)

--Economy stuff, also not relevant
buyingSpawning.OnServerEvent:Connect(function(player, item, region)
	local itemPrice = prices["Prices"][item]
	if item ~= "TestShip" then
		itemPrice = itemPrice + prices["Regions"][region][item]
	end
	local transaction = false
	if itemPrice then
		transaction = prices.SubtractMoney(player, itemPrice)
	end
	if transaction == true then
		prices.GiveItem(player, item)
	end
end)

sellingDeleting.OnServerEvent:Connect(function(player, item, region)
	if item ~= "TestShip" then
		print("Got event")
		local itemPrice = prices["Prices"][item]
		local regionalModifier = prices["Regions"][region][item]
		local totalPrice = itemPrice + regionalModifier - ((itemPrice + regionalModifier) * 0.1)
		local transaction = false
		if totalPrice then
			transaction = prices.RemoveItem(player, item)
		end
		if transaction == true then
			prices.GiveMoney(player, totalPrice)
		end
	end
end)