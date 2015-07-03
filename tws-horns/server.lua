addEvent("tws-hornSyncClient", true)
addEventHandler("tws-hornSyncClient", root,
	function()
		triggerClientEvent("tws-hornSync", source)
	end
)

function setVehicleHorn(vehicle, horn)
	if not horn then
		return
	end
	if not isElement(vehicle) then
		return
	end
	setElementData(vehicle, "tws-horn", horn)
	triggerClientEvent(client, "tws-updateHorn", resourceRoot, vehicle)
end