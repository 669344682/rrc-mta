addEvent("tws-onClientRequireVehicleTexture", true)
addEventHandler("tws-onClientRequireVehicleTexture", root, function()
	
end)

function updateVehicleTexture(vehicle)
	triggerClientEvent("tws-onServerUpdateVehicleTexture", vehicle)
end