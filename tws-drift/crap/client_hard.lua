local mulMul = 0
local mulAdd = 0.005
local turnMultiplier = 0.001
local boostMultiplier = 0.004
local boostOffset = 0.005
local _, _, prevAngle = getElementRotation(localPlayer.vehicle)
local isDriftModeEnabled = true

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
		if not localPlayer.vehicle or not localPlayer.vehicle.onGround or not isDriftModeEnabled then
			return
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
		dxDrawLine3D(x, y, z, x + vx * 25, y + vy * 25, z + vz * 25, tocolor(255, 0, 0), 5)
		local angleRadians = angle / 180 * math.pi + math.pi / 2
		dxDrawLine3D(x, y, z, x + 5 * math.cos(angleRadians), y + 5 * math.sin(angleRadians), z, tocolor(255, 255, 0), 5)
		
		local diff = math.abs(angleDiff(direction, angle))
		local directionRadians = direction / 180 * math.pi + math.pi / 2
		local diffRadians = angleDiffRadians(directionRadians, angleRadians)
		if diff > 10 and diff < 90 then
			local mul = 1 + boostMultiplier * diff / 90 
			local boostX, boostY = vx * mul, vy * mul
			local boostLen = getDistanceBetweenPoints2D(0, 0, boostX, boostY)
			boostX = boostLen * math.cos(directionRadians + diffRadians * boostOffset)
			boostY = boostLen * math.sin(directionRadians + diffRadians * boostOffset)
			dxDrawLine3D(x, y, z, x + 25 * boostX, y + 25 * boostY, z, tocolor(255, 0, 255), 5)
			setElementVelocity(localPlayer.vehicle, boostX, boostY, vz)
		end
		prevAngle = angle
	end
)

addCommandHandler("drift", 
	function()
		isDriftModeEnabled = not isDriftModeEnabled
	end
)