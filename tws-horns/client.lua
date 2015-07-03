local hornsCount = 2 
local hornKey = "h" 
local isCustomHornActive = false
local hornVehicle = nil
local myHornSound = nil
local canHorn = true

local function honk(vehicle, isLocal)
	local hornID = getElementData(vehicle, "tws-horn")
	if not hornID then
		return
	end
	hornID = tonumber(hornID)
	if hornID < 1 or hornID > hornsCount then
		return
	end

	local x, y, z = getElementPosition(vehicle)
	
	local sound = playSound3D("sounds/horn" .. hornID .. ".wav", x, y, z)
	attachElements(sound, vehicle)
	if isLocal then
		canHorn = false
		addEventHandler("onClientSoundStopped", sound, 
			function()
				canHorn = true
			end
		)
	end
end

addEvent("tws-hornSync", true)
addEventHandler("tws-hornSync", root,
	function()
		if not isElement(source) then
			return
		end
		-- if local player is driver
		if getVehicleOccupant(source) == localPlayer then
			return
		end
		honk(source)
	end
)

addEventHandler("onClientKey", root,
	function(key, isPressed)
		if key ~= hornKey or not isPressed or not isCustomHornActive or not hornVehicle or not canHorn then
			return
		end
		triggerServerEvent("tws-hornSyncClient", hornVehicle)
		honk(hornVehicle, true)
	end
)

function updateHorn(vehicle)
	local horn = getElementData(vehicle, "tws-horn")
	if not horn then
		toggleControl("horn", true)
		isCustomHornActive = false
		hornVehicle = nil
		return
	else
		toggleControl("horn", false)
		isCustomHornActive = true
		hornVehicle = vehicle
	end
end

addEventHandler("onClientPlayerVehicleEnter", localPlayer, 
	function(vehicle, seat)
		if seat ~= 0 then
			return
		end
		updateHorn(vehicle)
	end
)

addEventHandler("onClientPlayerVehicleExit", localPlayer, 
	function(vehicle)
		toggleControl("horn", true)
		isCustomHornActive = false
		hornVehicle = nil
	end
)

function setVehicleHorn(vehicle, horn)
	if not isElement(vehicle) then
		return
	end
	setElementData(vehicle, "tws-horn", horn, false)
	updateHorn(vehicle)
end

addEvent("tws-updateHorn", true)
addEventHandler("tws-updateHorn", resourceRoot, updateHorn)