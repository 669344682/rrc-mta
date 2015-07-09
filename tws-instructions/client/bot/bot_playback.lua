local vehicle

function startBot()
	local VEHICLE_MODEL = 587
	local SPEED_SENSIVITY = 30
	local TURNING_STRENGTH = 0.4
	local BRAKING_STRENGTH = 0.2
	local ANGLE_DEADZONE = 0.1 -- from 0 to 40
	local BREAKING_PERIOD = 100
	local GOING_BACKWARDS_TIME = 1000
	local COLSHAPE_RADIUS = 12

	for index, values in ipairs(RECORDING_DATA) do
		recording_colshapes[index] = createColSphere(values.x, values.y, values.z, COLSHAPE_RADIUS)
		recording_colshapes[index]:setData("speed", values.speed)
	end

	for i, colshape in ipairs(recording_colshapes) do
		if recording_colshapes[i + 1] then
			colshape:setData("recording.nextcolshape", recording_colshapes[i + 1])
		end
	end

	local colshapes = recording_colshapes
	local ped, target
	local frameCounter = 0
	local target_last
	local wallCounter = 0
	local isReversed = false
	local badTries = 0
	local isBotStucked = false
	local distance_last
	local distance_frameCounter = 0
	local forcedDirection = nil
	local breakingPeriod
	local forcedSpeedValue

	if colshapes[1] and colshapes[2] then
		local x1, y1 = colshapes[1].position.x, colshapes[1].position.y
		local x2, y2 = colshapes[2].position.x, colshapes[2].position.y

		local angle = math.atan2((y2 - y1), (x2 - x1)) * 180 / math.pi

		vehicle = createVehicle(VEHICLE_MODEL, colshapes[1].position, 0, 0, angle - 90)
		vehicle.position = vehicle.position - vehicle.matrix.forward * (COLSHAPE_RADIUS + 2)
		vehicle.dimension = localPlayer.dimension
		vehicle.overrideLights = 2

		ped = createPed(0, vehicle.position)
		ped:warpIntoVehicle(vehicle)
		ped.dimension = localPlayer.dimension

		target = colshapes[1]
	end

	local function clientRender()
		if not ped then
			return
		end

		-- RESET CONTROLS
		ped:setAnalogControlState("vehicle_right", 0)
		ped:setAnalogControlState("vehicle_left", 0)
		ped:setAnalogControlState("accelerate", 0)
		ped:setAnalogControlState("brake_reverse", 0)	

		if not vehicle then
			return
		end

		if not target then
			removeEventHandler("onClientRender", root, clientRender)
			return
		else
			if not isElement(target) then
				target = nil
				return
			end
		end

		if vehicle:isWithinColShape(target) then
			target = target:getData("recording.nextcolshape")
		end

		if not target then
			return
		else
			if not isElement(target) then
				target = nil
				return
			end
		end

		-- THE CASE OF DRIVING TO THE WALL
		if isBotStucked then
			isBotStucked = false

			vehicle.position = target.position + Vector3(0, 0, 1)

			local target_next = target:getData("recording.nextcolshape")

			local x1, y1 = target.position.x, target.position.y
			local x2, y2 = target_next.position.x, target_next.position.y

			local angle = math.atan2((y2 - y1), (x2 - x1)) * 180 / math.pi

			vehicle:setRotation(0, 0, angle - 90)
		end

		local vehicleSpeed = getElementSpeed(vehicle, 1)

		if not isReversed and frameCounter > 20 then
			forcedDirection = nil
			if target_last then
				if (vehicleSpeed < 10) and (target_last == target) then
					wallCounter = wallCounter + 1

					if (wallCounter % 5) == 0 then
						if (wallCounter / 5) > 3 then
							--outputChatBox("BOT: FUCK THIS SHIT, I'M DONE.", 255, 255, 255)
							wallCounter = 0
							isBotStucked = true
							return
						end



						isReversed = true

						setTimer(
							function()
								frameCounter = -(120 * (wallCounter / 5))
								isReversed = false
								forcedDirection = true
							end, GOING_BACKWARDS_TIME * (wallCounter / 5), 1
						)
					end
				else
					wallCounter = 0
				end
			end
			target_last = target
			frameCounter = 0
		end
		frameCounter = frameCounter + 1

		-- CONTROLLING THE STEERING WHEEL

		local x1, y1, x2, y2, angle, angle1, angle2, sign
		local turnValue = 0
		local shouldBrake = false

		x1, y1 = vehicle.position.x, vehicle.position.y
		x2, y2 = target.position.x, target.position.y
		angle1 = math.atan2((y2 - y1), (x2 - x1)) * 180 / math.pi

		x1, y1 = vehicle.position.x, vehicle.position.y
		x2, y2 = vehicle.position.x + vehicle.matrix.forward.x, vehicle.position.y + vehicle.matrix.forward.y
		angle2 = math.atan2((y2 - y1), (x2 - x1)) * 180 / math.pi

		angle = (angle2 - angle1) % 360
		angle = angle > 180 and -(360 - angle) or angle

		if math.abs(angle) > 100 and not isReversed then
			shouldBrake = true
		end


		if angle >= 0 then
			sign = isReversed and -1 or 1
		else
			sign = isReversed and 1 or -1
		end

		angle = math.abs(angle) > 40 and 40 or math.abs(angle)

		turnValue = angle / 40
		turnValue = turnValue < ANGLE_DEADZONE and 0 or turnValue + TURNING_STRENGTH
		turnValue = turnValue < 1 and turnValue or 1

		if sign > 0 then
			ped:setAnalogControlState("vehicle_right", turnValue)
		else
			ped:setAnalogControlState("vehicle_left", turnValue)
		end

		-- CONTROLLING THE CAR SPEED

		local targetSpeed, speedDifference, speedValue, direction

		targetSpeed = getElementData(target, "speed") < 20 and 20 or getElementData(target, "speed")
		speedDifference = targetSpeed - vehicleSpeed

		if speedDifference >= 0 then
			direction = true
		else
			direction = false
		end

		if shouldBrake and vehicleSpeed > 50 then
			direction = false
			forcedSpeedValue = 0.7
		end

		if isReversed then
			direction = false
		end

		if forcedDirection ~= nil then
			direction = forcedDirection
		end

		speedValue = forcedSpeedValue or (direction and 1 or math.abs(speedDifference / SPEED_SENSIVITY) + BRAKING_STRENGTH)
		speedValue = forcedSpeedValue or (speedValue < 1 and speedValue or 1)

		if direction then
			ped:setAnalogControlState("accelerate", speedValue)
		else
			ped:setAnalogControlState("brake_reverse", speedValue)
		end
	end

	addEventHandler("onClientRender", root, clientRender)
end

addCommandHandler("startbot",
	function()
		startBot()
	end
)
--[[
addEventHandler("onClientRender", root,
	function()
		if not vehicle then
			return
		end

		if not target then
			return
		end

		dxDrawLine3D(vehicle.position, target.position, tocolor(255, 0, 0), 5)
		--dxDrawLine3D(vehicle.position, vehicle.position + vehicle.matrix.forward * 5, tocolor(0, 255, 255), 5)

		for index, colshape in ipairs(colshapes) do
			local nextColshape = colshapes[index + 1]
			if nextColshape then
				dxDrawLine3D(colshape.position, nextColshape.position, tocolor(0, 255, 0), 3)
			end
		end
	end
)
]]--
addCommandHandler("attach",
	function()
		if not localPlayer.vehicle then
			return
		end

		localPlayer.vehicle.position = vehicle.position + Vector3(0, 0, 1)
		localPlayer.vehicle:attach(vehicle, 0, 0, 0.2)
		localPlayer.vehicle.alpha = 0
		localPlayer.vehicle.engineState = false
		
		setCameraClip(true, false)
	end
)

addCommandHandler("detach",
	function()
		if not localPlayer.vehicle then
			return
		end

		localPlayer.vehicle:detach()
		localPlayer.vehicle.alpha = 255
		localPlayer.vehicle.position = vehicle.position + Vector3(0, 0, 1)
		localPlayer.vehicle.engineState = true

		setCameraClip(true, true)
	end
)