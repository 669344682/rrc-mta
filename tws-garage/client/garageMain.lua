garageMain = {}
garageMain.isActive = false

local garagePos = {312.83554077148, -1499.7497558594, 104.2	}
local garageRot = {0, 0, 325.4970703125}

local garageExitPos = {0, 0, 10}
local oldTime = {}

local vehicleEntered = false

addEvent("twsGarageEnter", true)
addEventHandler("twsGarageEnter", root, 
	function(dimension, playerVehicles)
		vehicleEntered = getPedOccupiedVehicle(localPlayer)
		if isElement(vehicleEntered) then
			setElementPosition(vehicleEntered, 312.83554077148, -1499.7497558594, 154.49007415771)
			setElementFrozen(vehicleEntered, true)
		else
			setElementFrozen(localPlayer, true)
			setElementPosition(localPlayer, 312.83554077148, -1499.7497558594, 154.49007415771)
		end

		exports["tws-camera"]:startGarageCamera(unpack(garagePos))
		garageVehicles.init(dimension, playerVehicles, garagePos, garageRot)
		garageGUI.isEnabled = true
		exports["tws-utils"]:toggleHUD(false)

		garageMain.isActive = true
		fadeCamera(true, 1)
		-- Time
		exports["tws-time"]:freezeWorldTimeAt(12, 0)
	end
)

local function getPlayerOrVehicle()
	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then 
		return veh
	end
	return localPlayer
end

local function getVehicleOccupantsCount()
	local veh = getPedOccupiedVehicle(localPlayer)
	
	if veh then 
		local count = 0
		for id,occupant in pairs(getVehicleOccupants(veh)) do
			if (occupant and getElementType(occupant) == "player") then
				count = count + 1
			end
		end
		return count
	end
	return 0
end

addEvent("twsGarageLeave", true)
addEventHandler("twsGarageLeave", root, 
	function(id)
		exports["tws-camera"]:resetCamera()
		garageVehicles.destroy()
		garageGUI.isEnabled = false
		garageMain.isActive = false

		setElementFrozen(localPlayer, false)
		if not id then
			if isElement(vehicleEntered) then
				setElementFrozen(vehicleEntered, false)
				setElementPosition(vehicleEntered, unpack(garageExitPos))
			else
				setElementPosition(localPlayer, unpack(garageExitPos))
			end
		else
			triggerServerEvent("twsClientGarageTakeCar", resourceRoot, garageVehicles.getVehicleID(), unpack(garageExitPos))
		end
		exports["tws-utils"]:toggleHUD(true)
		exports["tws-time"]:unfreezeWorldTime()
		setTimer(function() fadeCamera(true, 1) end, math.max(getPlayerPing(localPlayer) * 2, 50), 1)  
	end
)


function clientEnterGarage(exitPos, exitInt)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if isElement(vehicle) then
		local owner = getElementData(vehicle, "tws-owner")
		if not owner or owner ~= getElementData(localPlayer, "tws-accountName") then
			outputChatBox("Нельзя попасть в гараж, находясь в чужой машине. Выйдите из машины и попытайтесь ещё раз")
			return
		end
	end 
	if getVehicleOccupantsCount() > 1 then
		outputChatBox("В гараж с пассажирами нельзя!")
		return
	end
	exitPos = {getElementPosition(localPlayer)}
	exitInt = getElementInterior(localPlayer)
	if exitInt ~= 0 then
		outputChatBox("В гараж можно попасть только находясь на улице")
		return
	end
	fadeCamera(false, 1)
	setTimer(function()
			triggerServerEvent("twsPlayerEnterGarage", resourceRoot)
		end, 1000, 1)

	garageExitPos = exitPos
end

addEventHandler("onClientKey", root, 
	function(button, press)
		if not press or not garageMain.isActive or isChatBoxInputActive() then
			return
		end
		if button == "enter" then
			fadeCamera(false, 1)
			local info = garageVehicles.getVehicleInfo()
			if info.spawned then
				outputChatBox("Машины нет в гараже")
				return
			end

			
			setTimer(function()
				triggerServerEvent("twsClientGarageLeave", resourceRoot, garageVehicles.getVehicleID())
			end, 1000, 1)
		elseif button == "backspace" then
			fadeCamera(false, 1)
			setTimer(function()
				triggerServerEvent("twsClientGarageLeave", resourceRoot)
			end, 1000, 1)
		end
	end
)