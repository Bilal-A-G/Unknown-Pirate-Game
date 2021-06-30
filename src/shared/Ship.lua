local shipInfo = {}
local playerprofiles = game.ReplicatedStorage:WaitForChild("PlayerProfiles")

function shipInfo.ValidateCaptain(player, ship)
	local helm = ship:FindFirstChild("Helm")
	local variables = ship.Variables
	local captainId = variables.CaptainId
	if (helm.Position - player.Character.RightFoot.Position).Magnitude <= 6 and captainId.Value == 0 then
		captainId.Value = player.UserId
		playerprofiles:FindFirstChild(player.UserId).Ship.Using.Value = true
		return true
	else
		return false
	end
end

function shipInfo.CreateBodyMovers(ship)
	local ballast = ship:FindFirstChild("Ballast")
	
	local shipScript = script.ShipMoving:Clone()
	shipScript.Parent = ship
	
	local bodyPosition = Instance.new("BodyPosition", ballast)
	bodyPosition.Name = "ShipPosition"
	bodyPosition.MaxForce = Vector3.new(math.huge, 0, 0)
	bodyPosition.Position = ballast.Position

	local bodyGyro = Instance.new("BodyGyro", ballast)
	bodyGyro.Name = "ShipGyro"
	bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
	bodyGyro.CFrame = ballast.CFrame
end

function shipInfo.ControlShip(ship, input)
	local ballast = ship:FindFirstChild("Ballast")
	local variables = ship.Variables
	
	local bodyPosition = ballast.ShipPosition
	local bodyGyro = ballast.ShipGyro
	local forwardsForce = variables.Speed
	local rotationForce = variables.CurrentTurning
	
	if input == Enum.KeyCode.W then
		if forwardsForce.Value < variables.MaxSpeed.Value then
			forwardsForce.Value = forwardsForce.Value + variables.SpeedIncrement.Value
		end
	elseif input == Enum.KeyCode.S then
		if forwardsForce.Value > -variables.MaxSpeed.Value then
			forwardsForce.Value = forwardsForce.Value - variables.SpeedIncrement.Value
		end
	elseif input == Enum.KeyCode.A then
		if rotationForce.Value < variables.MaxTurning.Value then
			rotationForce.Value = rotationForce.Value + variables.TurningRate.Value
		end
	elseif input == Enum.KeyCode.D then
		if rotationForce.Value > -variables.MaxTurning.Value then
			rotationForce.Value = rotationForce.Value - variables.TurningRate.Value
		end
	end
end

function shipInfo.FreezePlayer(player, boolean)
	local character = player.Character
	local humanoid = character.Humanoid
	wait(0.2)
	if boolean == true then
		humanoid.WalkSpeed = 0
		humanoid.JumpHeight = 0
	else
		humanoid.WalkSpeed = 16
		humanoid.JumpHeight = 7.2		
	end
end

return shipInfo
