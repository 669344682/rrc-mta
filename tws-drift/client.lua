local mulMul = 0
local prevAngle = 0

if isElement(localPlayer.vehicle) then
	local _, _, prevAngle = getElementRotation(localPlayer.vehicle)
end

local isDriftModeEnabled = false

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function angleDiff(a1, a2)
	local diff = a2 - a1
	while diff < -180 do diff = diff + 360 end
	while diff > 180 do diff = diff - 360 end
	return diff
end

function angleDiffRadians(a1, a2)
	local diff = a2 - a1
	while diff < -math.pi do diff = diff + math.pi * 2 end
	while diff > math.pi do diff = diff - math.pi * 2 end
	return diff
end

addEventHandler("onClientPreRender", root,
	function()
		if not localPlayer.vehicle or not localPlayer.vehicle.onGround or not getElementData(localPlayer.vehicle, "tws-driftMode") then
			return
		end
		if getElementSpeed(localPlayer.vehicle, "km/h") < 30 then
			return
		end

		-- Settings
		-- Дефолтные настройки
		local mulAdd = DriftConfig[0].mulAdd
		local turnMultiplier = DriftConfig[0].turnMultiplier
		local boostMultiplier = DriftConfig[0].boostMultiplier
		local boostOffset = DriftConfig[0].boostOffset

		-- Специальные настройки для модели, если есть
		local modelID = getElementModel(localPlayer.vehicle)
		if DriftConfig[modelID] then
			mulAdd = DriftConfig[modelID].mulAdd
			turnMultiplier = DriftConfig[modelID].turnMultiplier
			boostMultiplier = DriftConfig[modelID].boostMultiplier
			boostOffset = DriftConfig[modelID].boostOffset
		end

		-- TURN VELOCITY
		if not getControlState("brake_reverse") then
			local tx, ty, tz = getVehicleTurnVelocity(localPlayer.vehicle)
			local dir = 0
			if getControlState("vehicle_left") then
				dir = 1
				mulMul = math.min(mulMul + mulAdd, 1)
			elseif getControlState("vehicle_right") then
				dir = -1
				mulMul = math.min(mulMul + mulAdd, 1)
			else
				mulMul = math.max(mulMul - mulAdd * 3, 0)
			end

			setVehicleTurnVelocity(localPlayer.vehicle, tx, ty, tz + turnMultiplier * dir * mulMul)
		end

		-- VELOCITY BOOST
		local _, _, angle = getElementRotation(localPlayer.vehicle) 

		local vx, vy, vz = getElementVelocity(localPlayer.vehicle)
		local direction = findRotation(0, 0, vx, vy)
		direction = (direction + 180) % 360 - 180
		angle = (angle + 180) % 360 - 180
		local x, y, z = getElementPosition(localPlayer.vehicle)
		--dxDrawLine3D(x, y, z, x + vx * 25, y + vy * 25, z + vz * 25, tocolor(255, 0, 0), 5)
		local angleRadians = angle / 180 * math.pi + math.pi / 2
		--dxDrawLine3D(x, y, z, x + 5 * math.cos(angleRadians), y + 5 * math.sin(angleRadians), z, tocolor(255, 255, 0), 5)
		
		local diff = math.abs(angleDiff(direction, angle))
		local directionRadians = direction / 180 * math.pi + math.pi / 2
		local diffRadians = angleDiffRadians(directionRadians, angleRadians)
		if diff > 10 and diff < 90 then
			local mul = 1 + boostMultiplier * diff / 90 
			local boostX, boostY = vx * mul, vy * mul
			local boostLen = getDistanceBetweenPoints2D(0, 0, boostX, boostY)
			boostX = boostLen * math.cos(directionRadians + diffRadians * boostOffset)
			boostY = boostLen * math.sin(directionRadians + diffRadians * boostOffset)
			--dxDrawLine3D(x, y, z, x + 25 * boostX, y + 25 * boostY, z, tocolor(255, 0, 255), 5)
			setElementVelocity(localPlayer.vehicle, boostX, boostY, vz)
		end
		prevAngle = angle
	end
)

function toggleDriftMode()
	if not isElement(localPlayer.vehicle) then
		outputChatBox("Вы должны находитья в автомобиле, чтобы включить дрифт-режим!", 255, 0, 0, true)
		return
	end
	local isEnabled = getElementData(localPlayer.vehicle, "tws-driftMode")
	if isEnabled == nil then
		isEnabled = false
	end
	if isEnabled then
		isEnabled = true
	end

	isEnabled = not isEnabled
	setElementData(localPlayer.vehicle, "tws-driftMode", isEnabled)
	if isEnabled then
		outputChatBox("Дрифт-режим был включен", 0, 255, 0, true)
	else
		outputChatBox("Дрифт-режим был выключен", 0, 255, 0, true)
	end
end

addCommandHandler("drift", 
	function()
		toggleDriftMode()
	end
)