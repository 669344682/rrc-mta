function setVehicleTuningComponentLevel(vehicle, name, level)
	if not isElement(vehicle) then
		return
	end
	if not name or not level then
		return
	end
	setElementData(vehicle, name .. "-level", level)
	triggerClientEvent(root, "tws-updateVehicleComponents", vehicle, name, level)
end