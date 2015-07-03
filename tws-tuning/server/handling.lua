-- TODO: Implement handling preview and saving

-- function 
-- 	setVehicleHandling ( element theVehicle, string property, var value )


-- suspensionForceLevel (< 1)
-- suspensionBias (>= 0.5)
-- centerOfMass (по х ниже, чем была, несильно)

addEvent("tws-setVehicleHandling", true)
addEventHandler("tws-setVehicleHandling", resourceRoot,
	function(property, value)
		local vehicle = getPedOccupiedVehicle(client)
		if not isElement(vehicle) then
			return
		end
		if value == "original" then
			setVehicleHandling(vehicle, property, getOriginalHandling(getElementModel(vehicle))[property])
		else
			setVehicleHandling(vehicle, property, value)
		end
		--outputDebugString("asd: " .. tostring(setVehicleHandling(vehicle, property, value)))
	end
)