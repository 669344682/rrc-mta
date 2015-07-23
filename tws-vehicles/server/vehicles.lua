-- Стандартная функция МТА
local _fixVehicle = fixVehicle

-- { [string vehicleOwner] = {table of vehicles where index is garageVehicleID} }
local spawnedVehicles = { }


-- Получает таблицу настроек автомобиля из гаража
function getPlayerGarageVehicleInfo(player, vehicleID)
	if not isElement(player) then
		return
	end
	if not vehicleID then
		return
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return false
	end
	local accountVehicles = fromJSON(getAccountData(account, "vehicles"))
	if not accountVehicles then
		return false
	end
	return accountVehicles[vehicleID]
end

-- Изменяет таблицу настроек автомобиля из гаража
function setPlayerGarageVehicleInfo(player, vehicleID, newInfo)
	if not isElement(player) then
		return false
	end
	if not vehicleID then
		return false
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return false
	end
	local accountVehicles = fromJSON(getAccountData(account, "vehicles"))
	if not accountVehicles then
		return false
	end
	if not accountVehicles[vehicleID] then
		return false
	end
	accountVehicles[vehicleID] = newInfo
	vehiclesJSON = toJSON(accountVehicles)
	if not vehiclesJSON then
		return false
	end
	setAccountData(account, "vehicles", vehiclesJSON)
	return true
end

function createVehicleTWS(...)
	local vehicle = createVehicle(...)
	setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
	setElementData(vehicle, "tws-owner", false)
	return vehicle
end

function applyInfoToVehicle(vehicle, vehicleInfo)
	-- Номера
	if vehicleInfo.number then	
		setVehicleNumberPlate(vehicle, vehicleInfo.number[1], vehicleInfo.number[2])
	end

	-- Тюнинг
	local tuningTable = vehicleInfo.tuning
	if not tuningTable then
		return
	end
	setElementData(vehicle, "tws-neon", tuningTable.neon)
	setElementData(vehicle, "tws-horn", tuningTable.horn)

	-- Хандлинг
	if vehicleInfo.handling then
		for k, v in pairs(vehicleInfo.handling) do
			setVehicleHandling(vehicle, k, v)
		end
	end
	-- Синхронизация 
	setElementData(vehicle, "tws-tuning", tuningTable)
	updateVehicleTuning(vehicle)
end

function returnVehicleToGarage(vehicle)
	local vehicleOwner = getVehicleOwner(vehicle)
	if not vehicleOwner then
		return
	end
	local ownerSpawnedVehicles = spawnedVehicles[vehicleOwner]
	if not ownerSpawnedVehicles then
		return
	end
	local vehicleID = getVehicleGarageID(vehicle)
	if not vehicleID then
		return
	end
	local vehicleElement = ownerSpawnedVehicles[vehicleID]
	if not isElement(vehicleElement) then
		return
	end

	local damageTable = {}
	damageTable.doors = {}
	damageTable.panels = {}
	if not isVehicleBlown(vehicle) then
		damageTable.health = getElementHealth(vehicle)
		if damageTable.health < 250 then
			damageTable.health = 250
		end
		for i = 0, 5 do
			damageTable.doors[i] = getVehicleDoorState(vehicle, i)
		end
		for i = 0, 6 do
			damageTable.panels[i] = getVehiclePanelState(vehicle, i)
		end
	else
		damageTable.health = 400
		for i = 0, 5 do
			damageTable.doors[i] = 4
		end
		for i = 0, 6 do
			damageTable.panels[i] = 3
		end
	end
	local currentInfo = getVehicleInfo(vehicle)
	currentInfo.damage = damageTable
	setVehicleInfo(vehicle, currentInfo)

	destroyElement(vehicle)
	spawnedVehicles[vehicleOwner][vehicleID] = nil
end

-- Добавляет автомобиль в гараж игрока (по таблице)
function addGarageVehicle(player, vehicleInfo)
	if not isElement(player) then
		return false
	end
	if not vehicleInfo then
		return false
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return false
	end
	local accountVehicles = fromJSON(getAccountData(account, "vehicles"))
	if not accountVehicles then
		return false
	end
	if not vehicleInfo.tuning then
		vehicleInfo.tuning = {}
	end
	table.insert(accountVehicles, vehicleInfo)
	local newID = #accountVehicles
	setAccountData(account, "vehicles", toJSON(accountVehicles))

	local accountName = getAccountName(account)

	--[[local path1 = "textures/" .. accountName .. "/hash" .. newID .. ".txt"
	if fileExists(path1) then
		fileDelete(path1)
	end
	local path2 = "textures/" .. accountName .. "/texture" .. newID .. ".png"	
	if fileExists(path2) then
		fileDelete(path2)
	end	]]
	return newID
end

function addShopVehicleToGarage(player, model, r, g, b)
	local vehicleNumber = generateRandomNumberPlate()
	local vehicleInfo = {
		model  = model,
		color  = {r, g, b},
		number = vehicleNumber,
		tuning = {}
	}
	return addGarageVehicle(player, vehicleInfo)
end

function getPlayerSpawnedVehicles(player)
	if not isElement(player) then
		return
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return
	end
	local accountName = getAccountName(account)

	if spawnedVehicles[accountName] then
		return spawnedVehicles[accountName] 
	else
		spawnedVehicles[accountName] = {}
	end
	return spawnedVehicles[accountName]
end

function isVehicleOwnedByPlayer(vehicle, player)
	if not isElement(player) then
		return
	end
	if not isElement(vehicle) then
		return
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return
	end
	local accountName = getAccountName(account)
	local vehicleOwner = getVehicleOwner(vehicle)
	if vehicleOwner == accountName then
		return true
	else
		return false
	end
end

function getVehicleOwner(vehicle)
	if not isElement(vehicle) then
		return
	end
	return getElementData(vehicle, "tws-owner")
end

function getVehicleGarageID(vehicle)
	if not isElement(vehicle) then
		return
	end
	return getElementData(vehicle, "tws-vehicle-id")
end

function getVehicleInfo(vehicle)
	local vehicleID = getVehicleGarageID(vehicle)
	if not vehicleID then
		--outputDebugString("1")
		return
	end
	local accountName = getVehicleOwner(vehicle)
	if not accountName then
		--outputDebugString("11")
		return
	end
	local account = getAccount(accountName)
	if not account then
		--outputDebugString("111")
		return
	end
	local vehiclesJSON = getAccountData(account, "vehicles")
	if not vehiclesJSON then
		--outputDebugString("1111")
		return
	end
	local playerVehicles = fromJSON(vehiclesJSON)
	if not playerVehicles then
		--outputDebugString("11111")
		return
	end
	local vehicleInfo = playerVehicles[vehicleID]
	if not vehicleInfo then
		--outputDebugString("111111")
		return
	end
	return vehicleInfo
end

function setVehicleInfo(vehicle, newInfo)
	if not isElement(vehicle) then
		return
	end
	if not newInfo then
		return
	end
	local vehicleID = getVehicleGarageID(vehicle)
	if not vehicleID then
		return
	end
	local accountName = getVehicleOwner(vehicle)
	if not accountName then
		return
	end
	local account = getAccount(accountName)
	if not account then
		return
	end
	local vehiclesJSON = getAccountData(account, "vehicles")
	if not vehiclesJSON then
		return
	end
	local playerVehicles = fromJSON(vehiclesJSON)
	if not playerVehicles then
		return
	end

	playerVehicles[vehicleID] = newInfo
	applyInfoToVehicle(vehicle, newInfo)

	vehiclesJSON = toJSON(playerVehicles)
	if not vehiclesJSON then
		return
	end
	setAccountData(account, "vehicles", vehiclesJSON)
	return true
end

function isPlayerVehicleSpawned(player, vehicleID) 
	local vehicles = getPlayerSpawnedVehicles(player)
	if vehicles[vehicleID] then
		return vehicles[vehicleID]
	else
		return false
	end
end

function fixVehicle(vehicle)
	_fixVehicle(vehicle)
	exports["tws-vehicles-textures"]:updateVehicleTexture(vehicle)
end

function fixGarageVehicle(player, vehicleID)
	if not isElement(player) then
		return false
	end
	if not vehicleID then
		return false
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return false
	end
	local accountName = getAccountName(account)

	-- Информаця о машине, которую нужно починить
	local vehicleInfo = getPlayerGarageVehicleInfo(player, vehicleID)
	if not vehicleInfo then
		return false, "nocar"
	end

	vehicleInfo.damage = {}
	vehicleInfo.damage.health = 1000
	vehicleInfo.damage.doors = nil
	vehicleInfo.damage.panels = nil

	return setPlayerGarageVehicleInfo(player, vehicleID, vehicleInfo)
end

function spawnPlayerVehicle(player, vehicleID, x, y, z, rx, ry, rz)
	if not isElement(player) then
		--outputChatBox(1)
		return false, "bad_player_element"
	end
	vehicleID = tonumber(vehicleID)
	outputChatBox(table.concat({x, y, z}))
	if not vehicleID then
		--outputChatBox(2)
		return false, "bad_vehicle_id"
	end
	if not x or not y or not z then
		--outputChatBox (3)
		return false, "bad_spawn_position"
	end
	if not rx or not ry or not rz then
		--outputChatBox (4)
		rx, ry, rz = 0, 0, 0
	end
	local account = getPlayerAccount(player)
	if isGuestAccount(account) then
		return false, "bad_account"
	end
	local accountName = getAccountName(account)
	local spawnedVehiclesTable = spawnedVehicles[accountName]

	-- Заспавнен ли автомобиль
	if spawnedVehiclesTable then
		if spawnedVehicles[accountName][vehicleID] then
			return false, "car_already_spawned"
		end
	else
		spawnedVehicles[accountName] = {}
	end

	-- Информаця о машине, которую нужно заспавнить
	local vehicleInfo = getPlayerGarageVehicleInfo(player, vehicleID)
	if not vehicleInfo then
		outputDebugString("No vehicle with ID=" .. tostring(vehicleID))
		return false, "no_such_car"
	end

	-- Удаление остальных машин
	for k,v in pairs(getPlayerSpawnedVehicles(player)) do
		returnVehicleToGarage(v)
	end

	-- Спавн автомобиля	
	local playerID = getElementData(player, "tws-id")
	if not playerID then
		playerID = 1
	end
	local spawnX, spawnY, spawnY = x, y, z

	-- Фикс проваливающихся колес при спавне
	-- Если спавнить машину с измененным хандлингом рядом с другим игроком, 
	-- колеса машины игрока проваливаются под землю
	-- spawnX = 2500 + playerID * 250, 0, 0
	local vehicle = createVehicleTWS(vehicleInfo.model, spawnX, spawnY, spawnY, rx, ry, rz, " ")
	applyInfoToVehicle(vehicle, vehicleInfo)
	-- setElementPosition(vehicle, x, y, z)

	-- Название аккаунта владельца
	setElementData(vehicle, "tws-owner", accountName)

	local player = getAccountPlayer(account)
	if isElement(player) then
		setElementData(vehicle, "tws-ownerName", getPlayerName(player))
	else
		setElementData(vehicle, "tws-ownerName", accountName)
	end
	spawnedVehicles[accountName][vehicleID] = vehicle
	-- Номер машины в гараже
	setElementData(vehicle, "tws-vehicle-id", vehicleID)

	-- Повреждения
	if vehicleInfo.damage then
		if vehicleInfo.damage.health then
			setElementHealth(vehicle, vehicleInfo.damage.health)
		end

		if vehicleInfo.damage.doors then
			for k,v in pairs(vehicleInfo.damage.doors) do
				setVehicleDoorState(vehicle, k, v)
			end
		end

		if vehicleInfo.damage.panels then
			for k,v in pairs(vehicleInfo.damage.panels) do
				setVehiclePanelState(vehicle, k, v)
			end
		end
	end
	return vehicle
end

addEventHandler("onVehicleExplode", root, 
	function()
		setTimer(returnVehicleToGarage, 5000, 1, source)
	end
)

addEventHandler("onVehicleEnter", root,
	function()
		local accountName = getElementData(source, "tws-owner")
		if not accountName then
			return
		end
		local account = getAccount(accountName)
		if not account then
			return
		end
		local player = getAccountPlayer(account)
		if not isElement(player) then
			return
		end
		local name = getPlayerName(player)
		setElementData(source, "tws-ownerName", name)
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for k, v in pairs(spawnedVehicles) do
			for _, vehicle in pairs(v) do
				returnVehicleToGarage(vehicle)
			end
		end
	end
)