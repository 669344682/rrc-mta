local function getPreviewImagePath(accountName, vehicleID)
	return "previews/" .. tostring(accountName) .."/" .. tostring(vehicleID) .. ".jpeg"
end

addEvent("tws-updateVehiclePreview", true)
addEventHandler("tws-updateVehiclePreview", resourceRoot, function(texturePixels)
	local accountName = client:getData("tws-accountName")
	if not accountName then
		return
	end
	local vehicle = client.vehicle
	if not isElement(vehicle) then
		return
	end

	-- Является ли игрок владельцем автомобиля
	local vehicleOwner = vehicle:getData("tws-owner")
	if vehicleOwner ~= accountName then
		return
	end
	local vehicleID = vehicle:getData("tws-vehicle-id")

	-- Сохранение изображения
	local f = fileCreate(getPreviewImagePath(accountName, vehicleID))
	fileWrite(f, texturePixels)
	fileClose(f)
end)

addEvent("tws-requireVehiclesPreviews", true)
addEventHandler("tws-requireVehiclesPreviews", root,
	function()
		local account = getPlayerAccount(client)
		if isGuestAccount(account) then
			return
		end
		local accountName = client:getData("tws-accountName")
		if not accountName then
			return
		end

		local vehiclesJSON = getAccountData(account, "vehicles") 
		if not vehiclesJSON then
			return
		end
		local vehiclesList = fromJSON(vehiclesJSON) 
		if not vehiclesList then
			return
		end
		local texturesList = {}
		for i = 1, #vehiclesList do
			local path = getPreviewImagePath(accountName, i)
			local textureData
			if fileExists(path) then
				local f = fileOpen(path)
				textureData = fileRead(f, fileGetSize(f))
				fileClose(f) 
			end
			table.insert(texturesList, {name = exports["tws-vehicles"]:getVehicleNameFromModel(vehiclesList[i].model), texture = textureData})
		end

		triggerLatentClientEvent(client, "tws-vehiclesPreviewsDownloaded", 5000000, resourceRoot, texturesList)
	end
)