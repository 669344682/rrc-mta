function decodeVehicleFiles(resource)
	local name = getResourceName(resource)
	--decodeVehicleResource(name)
	--outputDebugString("Decoded " .. tostring(name))
end
addEventHandler("onClientResourceStart", root, decodeVehicleFiles)