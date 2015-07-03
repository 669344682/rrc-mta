function updateVehicleTuning(vehicle)
	triggerClientEvent("tws-updatePlayerVehicleTuning", vehicle)
end

addEvent("tws-requireTuningSync", true)
addEventHandler("tws-requireTuningSync", root, 
	function()
		triggerClientEvent(client, "tws-tuningSync", resourceRoot)
	end
)