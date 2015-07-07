tuningVehicle = {}
tuningVehicle.vehicle = nil
tuningVehicle.info = {}
tuningVehicle.tuning = {}

local oldPosition = {}
local oldRotation = {}
local oldDoors = {}
local oldPanels = {}
local oldHealth = 0

local vehicleInfo = {}
local vehicleTuning = {}
local vehicleHandling = {}

function tuningVehicle.start(info)
	local vehicle = localPlayer.vehicle 
	if not isElement(vehicle) then 
		outputDebugString("tuningVehicle == nil")
		return
	end	
	tuningVehicle.vehicle = vehicle
	
	-- Позиция на момент входа в тюнинг
	oldPosition = {getElementPosition(vehicle)}
	oldRotation = {getElementRotation(vehicle)}

	-- Перемещение машины в тюнинг
	setElementPosition(vehicle, unpack(tuning.position))
	setElementRotation(vehicle, unpack(tuning.rotation))
	setElementVelocity(vehicle, 0, 0, 0)
	setVehicleTurnVelocity(vehicle, 0, 0, 0)
	setElementDimension(vehicle, getElementDimension(localPlayer))
	setElementInterior(vehicle, getElementInterior(localPlayer))
	setVehicleEngineState(vehicle, false)
	setVehicleColor(vehicle, 255, 255, 255)

	-- Фикс подвески
	setElementVelocity(vehicle, 0, 0, -0.01)

	-- Визуальная починка автомобиля
	for i = 0, 5 do
		oldDoors[i] = getVehicleDoorState(vehicle, i)
		setVehicleDoorState(vehicle, i, 0)
	end
	for i = 0, 6 do
		oldPanels[i] = getVehiclePanelState(vehicle, i)
		setVehiclePanelState(vehicle, i, 0)
	end
	oldHealth = getElementHealth(vehicle)
	setElementHealth(vehicle, 1000)


	if not info then
		info = {}
	end
	if not info.tuning then
		info.tuning = {}
	end
	if not info.handling then
		info.handling = {}
	end

	tuningVehicle.info = info
	tuningVehicle.tuning = tuningVehicle.info.tuning
	tuningVehicle.handling = tuningVehicle.info.handling

	vehicleInfo = deepcopy(info)
	vehicleTuning = vehicleInfo.tuning
	vehicleHandling = vehicleInfo.handling
end

function tuningVehicle.stop()
	local vehicle = tuningVehicle.vehicle

	-- Восстановление позиции
	setElementPosition(vehicle, unpack(oldPosition))
	setElementRotation(vehicle, unpack(oldRotation))
	setElementDimension(vehicle, getElementDimension(localPlayer))
	setElementInterior(vehicle, getElementInterior(localPlayer))
	setVehicleEngineState(vehicle, true)

	-- Восстановление повреждений
	for i = 0, 5 do
		setVehicleDoorState(vehicle, i, oldDoors[i])
	end
	for i = 0, 6 do
		setVehiclePanelState(vehicle, i, oldPanels[i])
	end
	setElementHealth(vehicle, oldHealth)
end

function tuningVehicle.getVehicleInfo()
	vehicleInfo.tuning = vehicleTuning
	return vehicleInfo
end

function tuningVehicle.setTuning(key, value)
	vehicleTuning[key] = value
	tuningVehicle.tuning[key] = value
end

function tuningVehicle.getOldTuning(key)
	return vehicleTuning[key]
end

function tuningVehicle.restoreTuning(key)
	tuningVehicle.tuning[key] = vehicleTuning[key]
end

function tuningVehicle.setHandling(key, value)
	vehicleHandling[key] = value
	tuningVehicle.handling[key] = value
	triggerServerEvent("tws-setVehicleHandling", resourceRoot, key, value)
end

function tuningVehicle.previewHandling(key, value)
	tuningVehicle.handling[key] = value
	triggerServerEvent("tws-setVehicleHandling", resourceRoot, key, value)
end

function tuningVehicle.restoreHandling(key)
	tuningVehicle.handling[key] = vehicleHandling[key]
	local value = vehicleHandling[key]
	if not value then
		value = "original"
	end
	triggerServerEvent("tws-setVehicleHandling", resourceRoot, key, value)
end