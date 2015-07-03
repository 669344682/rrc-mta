-- jetpack
addEventHandler("onClientKey", root,
	function(key, state)
		if not localPlayer:getData("jetpackHotkey") then
			return
		end

		if key == string.lower(localPlayer:getData("jetpackHotkey")) and state == true then
			triggerServerEvent("donatAction", resourceRoot, "jetpack")
		end
	end
)

-- godmode
addEventHandler("onClientPlayerDamage", localPlayer,
	function()
		if localPlayer:getData("godmode") then
			cancelEvent()
		end
	end
)
addEventHandler("onClientRender", root,
	function()
		if not localPlayer.vehicle then
			return
		end

		if not localPlayer:getData("godmode") then
			return
		end

		if localPlayer.vehicle:getOccupant(0) ~= localPlayer then
			return
		end

		if localPlayer.vehicle.health <= 300 then
			localPlayer.vehicle.health = 300
		end
	end
)

-- waterhovering
local bin = createVehicle(572, 0, 0, 0) bin.alpha = 0 bin.collisions = false bin.dimension = -1337
local vehicleWasUnderwater = false
function checkingIfVehicleOnWater()
	if not localPlayer:getData("waterHovering") then
		if isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", false)
			
			if localPlayer.vehicle then
				localPlayer.vehicle:setData("waterHovering", false)
			end
		end

		return
	end

	local vehicle = localPlayer.vehicle

	if not vehicle then
		if isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", false)
		end

		return 
	end

	if localPlayer.vehicle:getOccupant(0) ~= localPlayer then
		return
	end

	bin.position = localPlayer.vehicle.position - Vector3(0, 0, 2)
	bin.health = 1000

	if vehicle.inWater then
		setElementVelocity(vehicle, 0, 0, 0.05)
		vehicleWasUnderwater = true
	end

	if bin.inWater then
		if vehicleWasUnderwater then
			vehicle.engineState = true
			vehicleWasUnderwater = false
		end
		
		if not isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", true)
			vehicle:setData("waterHovering", true)
		end
	else
		if isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", false)
			vehicle:setData("waterHovering", false)
		end
	end
end

function synchronizing()
	local vehicle = localPlayer.vehicle

	if not vehicle then
		if isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", false)
		end

		return 
	end

	if localPlayer.vehicle:getOccupant(0) == localPlayer then
		return
	end

	local data = vehicle:getData("waterHovering")
	if data then
		if not isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", true)
		end
	else
		if isWorldSpecialPropertyEnabled("hovercars") then
			setWorldSpecialPropertyEnabled("hovercars", false)
		end
	end
end
setTimer(synchronizing, 200, 0)
addEventHandler("onClientRender", root, checkingIfVehicleOnWater)