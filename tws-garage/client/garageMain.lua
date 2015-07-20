garageMain = {}
-- Находится ли игрок в гараже
garageMain.isActive = false
-- Место нахождения машины в гараже и угол поворота
garageMain.position = {312.83554077148, -1499.7497558594, 104.2}
garageMain.rotation = {0, 0, 325.4970703125}
-- Координаты входа в гараж
garageMain.enterPosition = {0, 0, 0}
garageMain.enterRotation = {0, 0, 0}

addEvent("tws-clientGarageEnter", true)
addEvent("tws-clientGarageExit", true)

local function onClientGarageEnter(isSuccess, data, vehicleToShow)
	-- В случае ошибки "data" - описание ошибки
	-- В случае успешного входа в гараж "data" - массив машин игрока
	if not isSuccess or (isSuccess and not data) then
		-- Отмена входа в гараж при ошибке
		if not data or type(data) ~= "string" then
			data = ""
		end
		outputChatBox("Не удалось войти в гараж. " .. data, 255, 0, 0)
		fadeCamera(true, 1)
		localPlayer.frozen = false
		return
	end
	local playerVehiclesTable = data

	localPlayer:setPosition(unpack(garageMain.position))
	localPlayer.position = localPlayer.position + Vector3(0, 0, 10)
	localPlayer.frozen = true

	-- Камера
	exports["tws-camera"]:startGarageCamera(unpack(garageMain.position))
	-- Отключение HUD
	exports["tws-utils"]:toggleHUD(false)
	-- Заморозка времени
	exports["tws-time"]:freezeWorldTimeAt(12, 0)

	-- Инициализация гаража
	garageGUI.isEnabled = true
	garageMain.isActive = true
	garageVehicles.init(playerVehiclesTable, garageMain.position, garageMain.rotation)
	garageVehicles.showVehicle(vehicleToShow)
	fadeCamera(true, 1)

	if isElement(localPlayer.vehicle) then
		outputChatBox("fix0")
		local fixCamera = function()
			outputChatBox("fix")
			exports["tws-camera"]:resetCamera()
			exports["tws-camera"]:startGarageCamera(unpack(garageMain.position))
			removeEventHandler("onClientPlayerVehicleExit", localPlayer.vehicle, fixCamera)
		end
		addEventHandler("onClientPlayerVehicleExit", localPlayer.vehicle, fixCamera)
	end
end
addEventHandler("tws-clientGarageEnter", resourceRoot, onClientGarageEnter)

local function onClientGarageExit()
	exports["tws-camera"]:resetCamera()
	exports["tws-utils"]:toggleHUD(true)
	exports["tws-time"]:unfreezeWorldTime()

	garageVehicles.destroy()
	garageGUI.isEnabled = false
	garageMain.isActive = false

	setCameraTarget(localPlayer) 

	setTimer(function() fadeCamera(true, 1) end, math.max(getPlayerPing(localPlayer) * 2, 50), 1) 
	setTimer(function() 
		localPlayer.frozen = false
	end, 900, 1)
end
addEventHandler("tws-clientGarageExit", resourceRoot, onClientGarageExit)

-- Exported
function clientEnterGarage()
	local accountName = localPlayer:getData("tws-accountName")
	if not accountName then
		outputChatBox("Вы должны быть залогинены, чтобы попасть в гараж", 255, 0, 0)
		return false
	end
	if isElement(localPlayer.vehicle) then
		local vehicleOwner = getElementData(localPlayer.vehicle, "tws-owner")
		if not vehicleOwner or vehicleOwner ~= accountName then
			outputChatBox("Нельзя попасть в гараж, находясь в чужой машине. Выйдите из машины и попытайтесь ещё раз", 255, 0, 0)
			return false
		end
	end 
	if getVehicleOccupantsCount() > 1 then
		outputChatBox("В гараж с пассажирами нельзя!")
		return false
	end
	if localPlayer.interior ~= 0 or localPlayer.dimension ~= 0 then
		outputChatBox("В гараж можно попасть только находясь на улице", 255, 0, 0)
		return false
	end

	fadeCamera(false, 1)
	setTimer(triggerServerEvent, 1000, 1, "tws-serverGarageEnter", resourceRoot, garageMain.position)
	return true
end

function clientExitGarage(selectedVehicleID)
	fadeCamera(false, 1)
	setTimer(triggerServerEvent, 1000, 1, "tws-serverGarageExit", resourceRoot, selectedVehicleID)
end

addEventHandler("onClientKey", root, 
	function(button, press)
		if not press or not garageMain.isActive or isChatBoxInputActive() then
			return
		end
		if button == "enter" then
			local info = garageVehicles.getVehicleInfo()
			if info.spawned then
				outputChatBox("Выбранной машины нет в гараже", 255, 0, 0)
				return
			end

			clientExitGarage(garageVehicles.getVehicleID())
		elseif button == "backspace" then
			clientExitGarage()
		end
	end
)

addCommandHandler("garage", clientEnterGarage)