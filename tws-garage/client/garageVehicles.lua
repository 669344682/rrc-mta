local MAX_FIX_PRICE = 5000

garageVehicles = {}
local vehicle
local vehicleID = 1
local vehicles = {}
garageVehicles.vehicleName = ""
garageVehicles.isBroken = false
garageVehicles.fixPrice = 0

function garageVehicles.getVehicleID()
	return vehicleID
end

function garageVehicles.getVehicleInfo()
	local info = vehicles[vehicleID]
	if not info then
		return false
	end
	return info
end

function garageVehicles.init(playerVehicles, pos, rot)
	if not playerVehicles then
		outputDebugString("Vehicles list is nil")
		vehicles = {}
		return
	end
	playerVehicles = fromJSON(playerVehicles)
	if not playerVehicles then
		outputDebugString("JSON decoding error")
		return 
	end
	vehicles = playerVehicles
	if #vehicles == 0 then
		outputDebugString("Vehicles list is empty")
		return
	end
	for k,v in pairs(vehicles) do
		if not v.color then
			vehicles[k].color = {255, 255, 255}
		end
	end
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
	vehicle = createVehicle(411, unpack(pos))
	setElementRotation(vehicle, unpack(rot))
	setElementDimension(vehicle, localPlayer.dimension)
	setVehicleColor(vehicle, 255, 255, 255)
	vehicleID = 1

	setTimer(garageVehicles.updateVehicle, 100, 1)
end

function garageVehicles.updateVehicle()
	local info = vehicles[vehicleID]
	if not info then
		return false
	end
	if info.spawned then
		garageGUI.drawSpawned = true
		setElementAlpha(vehicle, 0)
	else
		garageGUI.drawSpawned = false
		setElementAlpha(vehicle, 255)
	end
	setElementModel(vehicle, info.model)
	setVehicleColor(vehicle, 255, 255, 255)
	
	-- Текстура
	--exports["tws-vehicles"]:redrawVehicleTexture(vehicle, info.tuning)
	setElementData(vehicle, "tws-tuning", info.tuning)
	exports["tws-vehicles-textures"]:updateVehicleTexture(vehicle)
	-- Тюнинг
	exports["tws-vehicles"]:updateVehicleTuning(vehicle, info.tuning)
	-- Номер
	if info.number then
		exports["tws-vehicles"]:setVehicleNumberPlate(vehicle, info.number[1], info.number[2])
	end
	vehicle:setData("tws-spoiler-level", 0)

	garageVehicles.vehicleName = exports["tws-vehicles"]:getVehicleNameFromModel(info.model)
	if info.tuning.neon then
		exports["tws-neon"]:setVehicleNeon(vehicle, unpack(info.tuning.neon))
	end

	fixVehicle(vehicle)
	if info.damage then
		if info.damage.health then
			setElementHealth(vehicle, info.damage.health)
		end

		if info.damage.doors then
			for k,v in pairs(info.damage.doors) do
				setVehicleDoorState(vehicle, k, v)
			end
		end

		if info.damage.panels then
			for k,v in pairs(info.damage.panels) do
				setVehiclePanelState(vehicle, k, v)
			end
		end
	end
	garageVehicles.fixPrice = 0
	local vehicleHealth = getElementHealth(vehicle)
	if vehicleHealth < 1000 then
		garageVehicles.isBroken = true
		local maxHealth = 1000 - 250
		garageVehicles.fixPrice = math.floor(((1 - (vehicleHealth - 250) / maxHealth) * MAX_FIX_PRICE) / 100) * 100
	else
		garageVehicles.isBroken = false
	end
end

function garageVehicles.fixVehicle()
	if not garageVehicles.isBroken then
		return
	end
	fixVehicle(vehicle)
	triggerServerEvent("twsClientGarageFixCar", resourceRoot, vehicleID, garageVehicles.fixPrice)
	garageVehicles.isBroken = false
	garageVehicles.fixPrice = 0
	local info = vehicles[vehicleID]
	if not info then
		return false
	end
	info.damage = nil
end

function garageVehicles.showVehicle(id)
	if not garageMain.isActive then
		return 
	end
	vehicleID = id
	if vehicleID > #vehicles then
		vehicleID = #vehicles
	end
	if vehicleID < 1 then
		vehicleID = 1
	end
	garageVehicles.updateVehicle()
end

function garageVehicles.next()
	if not garageMain.isActive then
		return 
	end
	vehicleID = vehicleID + 1
	if vehicleID > #vehicles then
		vehicleID = 1
	end
	garageVehicles.updateVehicle()
end
bindKey("arrow_r", "down", garageVehicles.next)

function garageVehicles.prev()
	if not garageMain.isActive then
		return 
	end
	vehicleID = vehicleID - 1
	if vehicleID < 1 then
		vehicleID = #vehicles
	end
	garageVehicles.updateVehicle()
end
bindKey("arrow_l", "down", garageVehicles.prev)

function garageVehicles.destroy()
	if isElement(vehicle) then
		destroyElement(vehicle)
	end
end