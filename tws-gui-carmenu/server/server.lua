addEvent("tws-onCarmenuSelect", true)
addEventHandler("tws-onCarmenuSelect", resourceRoot, 
	function(vehicleID)
		if not vehicleID then
			return
		end
		if not isElement(client) then
			return
		end
		if client.vehicle then
			if client.vehicle:getData("tws-owner") ~= client:getData("tws-accountName") then
				return
			else
				if client.vehicle:getData("tws-vehicleID") == vehicleID then
					return
				end
				exports["tws-vehicles"]:returnVehicleToGarage(client.vehicle)
			end
		end
		local x, y, z = getElementPosition(client)
		local rx, ry, rz = getElementRotation(client)
		local vehicle, info = exports["tws-vehicles"]:spawnPlayerVehicle(client, vehicleID, x, y, z, 0, 0, rz)
		local response = {}
		if isElement(vehicle) then
			warpPedIntoVehicle(client, vehicle)
			response.success = true
		else
			response.success = false
			response.info = info
		end
		triggerClientEvent(client, "tws-onCarmenuServerSpawn", resourceRoot, response)
	end
)