addEvent("tws-onClientVehicleDamage", true)
addEventHandler("tws-onClientVehicleDamage", root,
	function()
		triggerClientEvent(root, "tws-updateVehicleComponentsDamage", source)
	end
)