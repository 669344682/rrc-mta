function getPlayerOrVehicle()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then 
		return veh
	end
	return localPlayer
end

function getVehicleOccupantsCount()
	local veh = getPedOccupiedVehicle(localPlayer)
	
	if veh then 
		local count = 0
		for id,occupant in pairs(getVehicleOccupants(veh)) do
			if (occupant and getElementType(occupant) == "player") then
				count = count + 1
			end
		end
		return count
	end
	return 0
end