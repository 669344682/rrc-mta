addEvent("tws-serverTuningEnter", true)
addEvent("tws-serverTuningExit", true)
addEvent("tws-serverTuningBuyItem", true)

function playerTuningEnter(player)
	if not isElement(player) then
		return false
	end

	-- Check vehicle
	local vehicle = player.vehicle
	if not isElement(vehicle) then
		triggerClientEvent(player, "tws-clientTuningEnter", resourceRoot, false, "Вы должны находиться в автомобиле")
		return false
	end

	-- Vehicle info table from player's account
	local vehicleInfo = exports["tws-vehicles"]:getVehicleInfo(vehicle)
	if not vehicleInfo then
		triggerClientEvent(player, "tws-clientTuningEnter", resourceRoot, false, "Не удалось войти в тюнинг")
		return false
	end

	-- Перемещение игрока в тюнинг
	local dim = exports["tws-main"]:getPlayerID(player)
	player:setInterior(1)
	player:setDimension(dim)
	vehicle:setInterior(1)
	vehicle:setDimension(dim)

	triggerClientEvent(player, "tws-clientTuningEnter", resourceRoot, true, vehicleInfo)
end

function playerTuningExit(player, vehicle, vehicleInfo)
	-- Перемещение игрока на улицу
	player:setInterior(0)
	player:setDimension(0)
	triggerClientEvent(player, "tws-clientTuningExit", resourceRoot)
	
	-- Vehicle check
	if not isElement(vehicle) then
		vehicle = player.vehicle
	end
	if not isElement(vehicle) then
		return
	end
	vehicle:setInterior(0)
	vehicle:setDimension(0)
	-- Обновление машины
	exports["tws-vehicles"]:setVehicleInfo(vehicle, vehicleInfo)
end

-- Клиентские события для входа в тюнинг
addEventHandler("tws-serverTuningEnter", root, 
	function()
		playerTuningEnter(client)
	end
)

addEventHandler("tws-serverTuningExit", root,
	function(vehicleInfo, textureData)
		playerTuningExit(client, nil, vehicleInfo, textureData)
	end
)

addEventHandler("tws-serverTuningBuyItem", resourceRoot,
	function(price)
		if not client:getData("tws-accountName") or not client:getData("tws-money") or not price or price == nil then
			triggerClientEvent(client, "tws-clientTuningBuyItem", resourceRoot, false)
		end
		local isSuccess = false
		if client:getData("tws-money") >= price then
			exports["tws-main"]:takePlayerMoney(client, price)
			isSuccess = true
		end
		triggerClientEvent(client, "tws-clientTuningBuyItem", resourceRoot, isSuccess)
	end
)