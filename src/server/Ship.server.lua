local shipEvent = game.ReplicatedStorage:WaitForChild("Events").CaptainShip
local shipInfo = require(game.ReplicatedStorage:WaitForChild("Modules").Ship)

shipEvent.OnServerEvent:Connect(function(player, request, ship, input)
	if request == "SetCaptain" then
		local pass = shipInfo.ValidateCaptain(player, ship)
		if pass then
			shipInfo.FreezePlayer(player, true)
		end
	elseif request == "ControlShip" then
		shipInfo.ControlShip(ship, input)
	end
end)
