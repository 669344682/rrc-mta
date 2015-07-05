addEvent("twsPlayerEnterGarage", true)
addEventHandler("twsPlayerEnterGarage", root,
	function( )
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

		-- Restore interior
		if exitToHotel then
			setElementData(client, "tws-oldInt", 15)
		else
			setElementData(client, "tws-oldInt", getElementInterior(client))
		end
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
	function(vehicleID)
		local currentVehicle = getPedOccupiedVehicle(client)
		if currentVehicle then
			destroyElement(currentVehicle)
		end
		local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(client, vehicleID, 290.00677490234, -1533.0416259766, 24.520421981812, 0, 0, 144)
		warpPedIntoVehicle(client, vehicle)
	end
)