twsComponents = {}
twsComponents["tws-fbump"] = {"panel", 5}
twsComponents["tws-boot"] = {"door", 1}

local lastCollisionVehicle = nil

function hideAll(vehicle, name)
	local components = getVehicleComponents(vehicle)
	for n,visible in pairs(components) do
		if string.find(tostring(n), name, 1, true) then
			setVehicleComponentVisible(vehicle, n, false)
		end
	end
end

function updateComponentDamage(vehicle, name)
	if not isElement(vehicle) then
		return
	end
	local cmp = twsComponents[name]
	if not cmp then
		return
	end
	local componentLevel = getElementData(vehicle, name .. "-level")
	if not componentLevel then
		return
	end
	local componentState = "ok"
	if cmp[1] == "panel" then
		local state = getVehiclePanelState(vehicle, cmp[2])
		if state == 0 then
			componentState = "ok"
		elseif state == 3 then
			componentState = "missing"
		else
			componentState = "damaged"
		end
	elseif cmp[1] == "door" then
		local state = getVehicleDoorState(vehicle, cmp[2])
		if state == 0 or state == 1 then
			componentState = "ok"
		elseif state == 4 then
			componentState = "missing"
		else
			componentState = "damaged"
		end
	end

	local fullName = name .. "-" .. componentLevel

	local goodVisible = false
	local damagedVisible = false

	if componentState == "ok" then
		goodVisible = true
	elseif componentState == "damaged" then
		damagedVisible = true
	end

	setVehicleComponentVisible(vehicle, fullName, goodVisible)
	local r = setVehicleComponentVisible(vehicle, fullName .. "-dam", damagedVisible)
	if not goodVisible and not r then
		--outputDebugString("WARNING: No -dam component for " .. fullName)
		setVehicleComponentVisible(vehicle, fullName, true)
	end
end


function updateAllComponentsDamage(vehicle)
	for k, v in pairs(twsComponents) do
		updateComponentDamage(vehicle, k)
	end
end

setTimer(function()
	if isElement(lastCollisionVehicle) then
		triggerServerEvent("tws-onClientVehicleDamage", lastCollisionVehicle)
		updateAllComponentsDamage(source)
		lastCollisionVehicle = nil
	end
end, 200, 0)

addEventHandler("onClientVehicleCollision", root,
	function()
		lastCollisionVehicle = source
	end
)

addEventHandler("onClientVehicleDamage", root,
	function()
		lastCollisionVehicle = source
		updateAllComponentsDamage(source)
	end
)

addEvent("tws-updateVehicleComponents", true)
addEventHandler("tws-updateVehicleComponents", root,
	function(name, level)
		hideAll(source, name)

		local fullName = name .. "-" .. tostring(level)
		updateComponentDamage(source, name)
	end
)

addEvent("tws-updateVehicleComponentsDamage", true)
addEventHandler("tws-updateVehicleComponentsDamage", root,
	function()
		updateAllComponentsDamage(source)
	end
)

function setVehicleTuningComponentLevel(vehicle, name, level)
	if not isElement(vehicle) then
		return
	end
	if not name or not level then
		return
	end
	setElementData(vehicle, name .. "-level", level, false)
	setTimer(
		function()
			if isElement(vehicle) then
				triggerEvent("tws-updateVehicleComponents", vehicle, name, level)
			end
		end,
	100, 1)
end