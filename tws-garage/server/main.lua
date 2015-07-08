addEvent("twsPlayerEnterGarage", true)
addEventHandler("twsPlayerEnterGarage", root,
	function()
		local playerAccount = getPlayerAccount(client)
		if isGuestAccount(playerAccount) then
			return false
		end
		local garageDimension = exports["tws-main"]:getPlayerID(client)

		local currentVehicle = client.vehicle
		if isElement(currentVehicle) and exports["tws-vehicles"]:isVehicleOwnedByPlayer(currentVehicle, client) then
			removePedFromVehicle(client)
			exports["tws-vehicles"]:returnVehicleToGarage(currentVehicle)
		end

		local playerVehicles = fromJSON(getAccountData(playerAccount, "vehicles"))
		if playerVehicles then
			local spawnedVehicles = exports["tws-vehicles"]:getPlayerSpawnedVehicles(client)
			for k,v in pairs(spawnedVehicles) do
				playerVehicles[k].spawned = true
			end
		end
		
		client:setData("tws-garage-oldInterior", client.interior)
		client:setData("tws-garage-oldDimension", client.dimension)
		client.interior = 0
		client.dimension = garageDimension

		client:setData(	"tws-inGarage", true)
		
		triggerClientEvent(client, "twsGarageEnter", resourceRoot, garageDimension, toJSON(playerVehicles), exitToHotel)
	end
)

addEvent("twsClientGarageLeave", true)
addEventHandler("twsClientGarageLeave", root, 
	function(vehicleID)
		if client:getData("tws-inGarage") == false then
			return false
		end

		local dimension = client:getData("tws-garage-oldDimension")
		if dimension then
			client.dimension = dimension
		end

		client.interior = 0
		if vehicleID then
			client.interior = 0
		else
			local interior = client:getData("tws-garage-oldInterior")
			if interior then
				client.interior = interior
			end
		end
		triggerClientEvent(client, "twsGarageLeave", resourceRoot, vehicleID)
		client:setData("tws-inGarage", false)
	end
)

addEvent("twsClientGarageTakeCar", true)
addEventHandler("twsClientGarageTakeCar", root, 
	function(vehicleID, x, y, z)
		local currentVehicle = client.vehicle
		if currentVehicle then
			destroyElement(currentVehicle)
		end
		setElementPosition(client, x, y, z)
		local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(client, vehicleID, x, y, z, 0, 0, r)
		removePedFromVehicle(client)
		warpPedIntoVehicle(client, vehicle)
		setCameraTarget(client)
	end
)

addEvent("twsClientGarageFixCar", true)
addEventHandler("twsClientGarageFixCar", resourceRoot,
	function(vehicleID, price)
		local playerMoney = client:getData("tws-money")
		if not playerMoney then
			outputChatBox("Вы не залогинены", client, 255, 0, 0)
			return
		end
		if playerMoney < price then
			outputChatBox("У вас недостаточно денег для починки автомобиля. Требуется $" .. tostring(price), client, 255, 0, 0)
			return
		end
		
		if exports["tws-vehicles"]:fixGarageVehicle(client, vehicleID) then
			outputChatBox("Автомобиль отремонтирован", client, 0, 255, 0)
			exports["tws-main"]:takePlayerMoney(client, price)
		else
			outputChatBox("Не удалось починить автомобиль", client, 255, 0, 0)
		end
	end
)