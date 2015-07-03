tuning = {}
-- Находится ли игрок в тюнинге
tuning.isActive = false
-- Координаты тюнинга
tuning.position = {1399.3038330078, -25.179975509644, 938.18896484375}
-- Угол поворота автомобиля
tuning.rotation = {0, 0, 0}

local enterColshape = nil

tuning.isLocked = false

-- TODO
local oldWeather = 0

-- Custom events
addEvent("tws-clientTuningEnter", true)
addEvent("tws-clientTuningExit", true)

local function onClientTuningEnter(isSuccess, info)
	if not isSuccess then
		outputChatBox(tostring(info), 255, 0, 0)
		toggleAllControls(true, true)
		fadeCamera(true)
		tuning.isActive = false
		return
	end
	-- Запуск тюнинга
	tuningVehicle.start(info)
	tuningCamera.start()
	tuningTexture.start()
	screens.start()
	fadeCamera(true)

	if isElement(enterColshape) then
		setElementData(enterColshape, "tws-colshapeEnabled", false)
	end

	exports["tws-time"]:freezeWorldTimeAt(12, 0)
	oldWeather = getWeather()
	setWeather(0)
end
addEventHandler("tws-clientTuningEnter", resourceRoot, onClientTuningEnter)

local function onClientTuningExit()
	exports["tws-time"]:unfreezeWorldTime()
	-- Выход из тюнинга
	if isElement(enterColshape) then
		setElementData(enterColshape, "tws-colshapeEnabled", false)
	end
	
	setWeather(oldWeather)

	screens.stop()
	tuningCamera.stop()
	tuningVehicle.stop()
	fadeCamera(true)
end
addEventHandler("tws-clientTuningExit", resourceRoot, onClientTuningExit)

function tuningEnter(colshape)
	if tuning.isLocked then
		outputChatBox("Тюнинг временно недоступен. Попробуйте позже", 255, 0, 0)
		return
	end
	if tuning.isActive then
		outputChatBox("Вы уже в тюнинге", 255, 0, 0)
		return
	end
 
	-- Vehicle
	local vehicle = localPlayer.vehicle
	if not isElement(vehicle) then
		outputChatBox("Чтобы попасть в тюнинг, нужно находиться в автомобиле.", 255, 0, 0)
		return
	end

	-- Проверка принадлежности автомобиля игроку
	local vehicleOwner = vehicle:getData("tws-owner")
	local accountName = localPlayer:getData("tws-accountName")
	if not vehicleOwner or not accountName or vehicleOwner ~= accountName then
		outputChatBox("Этот автомобиль не принадлежит вам! Вы не можете его тюнинговать.", 255, 0, 0)
		return
	end

	-- Пассажиры
	if getVehicleOccupantsCount() > 1 then
		outputChatBox("В тюнинг с пассажирами нельзя!", 255, 0, 0)
		return
	end

	-- Вход в тюнинг
	fadeCamera(false)
	setTimer(
		function(vehicle)
			if isElement(vehicle) then
				triggerServerEvent("tws-serverTuningEnter", resourceRoot)
			else
				toggleAllControls(true, true)
				fadeCamera(true)
				tuning.isActive = false
			end
		end,
	1000, 1, vehicle)
	tuning.isActive = true

	if colshape then
		enterColshape = colshape
		setElementData(enterColshape, "tws-colshapeEnabled", false)
	end

	setElementVelocity(vehicle, 0, 0, 0)
	toggleAllControls(false, true, false)
end

function tuningExit()
	-- Начало выхода из тюнинга
	if not tuning.isActive then
		outputChatBox("Вы не в тюнинге", 255, 0, 0)
		return
	end
	
	tuning.isActive = false
	
	tuningTexture.stop()
	local vehicleInfo = tuningVehicle.getVehicleInfo()
	fadeCamera(false)
	setTimer(triggerLatentServerEvent, 1000, 1, "tws-serverTuningExit", 5000000, resourceRoot, vehicleInfo)
	toggleAllControls(true, true)
	if isElement(enterColshape) then
		setGarageOpen(getElementData(enterColshape, "tws-garageID"), true)
	end
end

addCommandHandler("tuning", function() if not tuning.isActive then tuningEnter() end end)

addEvent("tws-tuningForceExit", true)
addEventHandler("tws-tuningForceExit", root,
	function()
		tuningExit()
		tuning.isLocked = true
	end
)