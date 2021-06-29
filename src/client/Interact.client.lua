local buyingSpawning = game.ReplicatedStorage:WaitForChild("Events").BuyingSpawning
local sellingDeleting = game.ReplicatedStorage:WaitForChild("Events").SellingDeleting
local userInputService = game:GetService("UserInputService")
local captainEvent = game.ReplicatedStorage:WaitForChild("Events").CaptainShip
local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local playerProfile = game.ReplicatedStorage:WaitForChild("PlayerProfiles"):WaitForChild(players.LocalPlayer.UserId)
local ship = playerProfile.Ship


local function GetMousePoint(X, Y)
	local RayMag1 = camera:ScreenPointToRay(X, Y)
	local NewRay = Ray.new(RayMag1.Origin, RayMag1.Direction * 100000000)
	local Target, Position = workspace:FindPartOnRay(NewRay, players.LocalPlayer.Character)
	return Target, Position
end

userInputService.InputBegan:Connect(function(input)
	local userInputType = input.UserInputType
	local mouse1 = Enum.UserInputType.MouseButton1
	local mouse2 = Enum.UserInputType.MouseButton2
	if userInputType == mouse1 or userInputType == mouse2 then
		local mouseLocation = userInputService:GetMouseLocation()
		local target, position = GetMousePoint(mouseLocation.X, mouseLocation.Y)
		if target and target:FindFirstChild("Item") then
			if userInputType == mouse1 then
				buyingSpawning:FireServer(target:FindFirstChild("Item").Value, target.Parent.Name)
			end
			if userInputType == mouse2 then
				sellingDeleting:FireServer(target:FindFirstChild("Item").Value, target.Parent.Name)
			end
		end
	elseif userInputType == Enum.UserInputType.Keyboard then
		if ship.Value ~= "None" and ship.Using.Value == true then
			captainEvent:FireServer("ControlShip", game.Workspace:FindFirstChild(ship.Value), input.KeyCode)
		end
	end
end)