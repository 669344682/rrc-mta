addEvent("twsPlayerEnterGarage", true)
addEventHandler("twsPlayerEnterGarage", root,
	function()
		local playerAccount = getPlayerAccount(client)
		if isGuestAccount(playerAccount) then
			return false
		end
		local garageDimension = exports["tws-main"]:getPlayerID(client)

		local currentVehicle = getPedOccupiedVehicle(client)
		local exitToHotel = false
		if exports["tws-vehicles"]:isVehicleOwnedByPlayer(currentVehicle, client) then
			removePedFromVehicle(client)
			exports["tws-vehicles"]:returnVehicleToGarage(currentVehicle)
			exitToHotel = true
		end

		local playerVehicles = fromJSON(getAccountData(playerAccount, "vehicles"))
		if playerVehicles then
			local spawnedVehicles = exports["tws-vehicles"]:getPlayerSpawnedVehicles(client)
			for k,v in pairs(spawnedVehicles) do
				playerVehicles[k].spawned = true
			end
		end
		
		setElementDimension(client, garageDimension)
		setElementData(client, "tws-inGarage", true)
		
		setElementData(client, "tws-oldInt", getElementInterior(client))
		setElementInterior(client, 0)

		triggerClientEvent(client, "twsGarageEnter", resourceRoot, garageDimension, toJSON(playerVehicles), exitToHotel)
	end
)

addEvent("twsClientGarageLeave", true)
addEventHandler("twsClientGarageLeave", root, 
	function(vehicleID)
		if getElementData(client, "tws-inGarage") == false then
			return false
		end

		setElementDimension(client, 0)

		setElementInterior(client, 0)
		if vehicleID then
			setElementInterior(client, 0)
		else
			setElementInterior(client, getElementData(client, "tws-oldInt"))
		end
		triggerClientEvent(client, "twsGarageLeave", resourceRoot, vehicleID)
		setElementData(client, "tws-inGarage", false)	
	end
)

addEvent("twsClientGarageTakeCar", true)
addEventHandler("twsClientGarageTakeCar", root, 
	function(vehicleID, x, y, z)
		local currentVehicle = getPedOccupiedVehicle(client)
		if currentVehicle then
			destroyElement(currentVehicle)
		end
		setElementPosition(client, x, y, z)
		local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(client, vehicleID, x, y, z, 0, 0, r)
		removePedFromVehicle(client)
		warpPedIntoVehicle(client, vehicle)
	end
)