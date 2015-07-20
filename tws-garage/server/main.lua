addEvent("tws-serverGarageEnter", true)
addEvent("tws-serverGarageExit", true)

addEventHandler("tws-serverGarageEnter", resourceRoot,
	function(garagePosition)
		local playerAccount = getPlayerAccount(client)
		if isGuestAccount(playerAccount) then
			triggerClientEvent(player, "tws-clientGarageEnter", resourceRoot, false, "Вы не залогинены")
			return
		end
		-- Массив машин игрока
		local playerVehiclesJSON = getAccountData(playerAccount, "vehicles")
		if not playerVehiclesJSON then
			triggerClientEvent(player, "tws-clientGarageEnter", resourceRoot, false, "Не удалось получить список ваших автомобилей")
			return
		end

		-- Координаты игрока перед входом в гараж
		local garageEnterInfo = {
			position = client.position,
			rotation = client.rotation
		}

		local vehicleToShow = 1

		if isElement(client.vehicle) then
			-- Если игрок в машине, запоминаем координаты машины
			garageEnterInfo.position = client.vehicle.position
			garageEnterInfo.rotation = client.vehicle.rotation

			-- Если игрок в машине, принадлежащей ему, отправляем её в гараж
			if exports["tws-vehicles"]:isVehicleOwnedByPlayer(client.vehicle, client) then
				vehicleToShow = exports["tws-vehicles"]:getVehicleGarageID(client.vehicle)
				exports["tws-vehicles"]:returnVehicleToGarage(client.vehicle)
				removePedFromVehicle(client)
			end
		end

		local playerVehiclesTable = fromJSON(playerVehiclesJSON)
		if playerVehiclesTable then
			local spawnedVehicles = exports["tws-vehicles"]:getPlayerSpawnedVehicles(client)
			for k,v in pairs(spawnedVehicles) do
				playerVehiclesTable[k].spawned = true
			end
		else
			triggerClientEvent(player, "tws-clientGarageEnter", resourceRoot, false, "Ошибка получения списка ваших автомобилей")
			return
		end

		-- Кладём координаты в дату
		client:setData("tws-garageEnterInfo", garageEnterInfo)

		client:setData("tws-inGarage", true)
		client.interior = 0
		client.dimension = exports["tws-main"]:getPlayerID(client)
		client:setPosition(unpack(garagePosition))
		client.position = client.position + Vector3(0, 0, 10)

		triggerClientEvent(client, "tws-clientGarageEnter", resourceRoot, true, toJSON(playerVehiclesTable), vehicleToShow)
	end
)

addEventHandler("tws-serverGarageExit", resourceRoot,
	function(selectedVehicleID)
		if client:getData("tws-inGarage") == false then
			return
		end

		client:setData("tws-inGarage", false)
		client.dimension = 0
		client.interior = 0

		if selectedVehicleID then
			local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(client, selectedVehicleID, 0, 0, 0)
			removePedFromVehicle(client)
			warpPedIntoVehicle(client, vehicle)
			setCameraTarget(client)
		end

		local garageEnterInfo = client:getData("tws-garageEnterInfo")
		if not garageEnterInfo then
			garageEnterInfo = {position: Vector3(0, 0, 0), rotation: Vector3(0, 0, 0)}
		end

		if isElement(client.vehicle) then
			client.vehicle.position = garageEnterInfo.position
			client.vehicle.rotation = garageEnterInfo.rotation
		else
			client.position = garageEnterInfo.position
			client.rotation = garageEnterInfo.rotation
		end

		triggerClientEvent(client, "tws-clientGarageExit", resourceRoot)
	end
)