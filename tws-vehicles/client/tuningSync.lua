function updateVehicleTuning(vehicle, tuningTable)
	if not tuningTable then
		tuningTable = getElementData(vehicle, "tws-tuning")
	end
	if not tuningTable then
		return
	end

	local neon = tuningTable.neon
	if neon then
		exports["tws-neon"]:setVehicleNeon(vehicle, unpack(neon))
	else
		exports["tws-neon"]:setVehicleNeon(vehicle)
	end
	-- Спойлер
	if tuningTable.spoiler then
		exports["tws-spoilers"]:setVehicleSpoiler(vehicle, tuningTable.spoiler.id)
		exports["tws-spoilers"]:setVehicleSpoilerColor(vehicle, unpack(tuningTable.spoiler.color))
		exports["tws-spoilers"]:setVehicleSpoilerType(vehicle, tuningTable.spoiler.type)
	else
		exports["tws-spoilers"]:removeVehicleSpoiler(vehicle)
	end
	-- Тонировка
	if tuningTable.windows then
		exports["tws-vehicles"]:setVehicleWindowsLevel(vehicle, tuningTable.windows)
	else
		exports["tws-vehicles"]:setVehicleWindowsLevel(vehicle, 0)
	end
	-- Колеса
	if tuningTable.wheels then
		exports["tws-wheels"]:setVehicleWheels(vehicle, tuningTable.wheels.id)
		exports["tws-wheels"]:setVehicleWheelsColor(vehicle, unpack(tuningTable.wheels.color))
	else
		exports["tws-wheels"]:resetVehicleWheels(vehicle)
		exports["tws-wheels"]:setVehicleWheelsColor(vehicle, 255, 255, 255)
	end	
end

addEvent("tws-updatePlayerVehicleTuning", true)
addEventHandler("tws-updatePlayerVehicleTuning", root, 
	function() 
		updateVehicleTuning(source)
	end
)

local function applyAllVehiclesTuning()
	for i,v in ipairs(getElementsByType("vehicle")) do
		updateVehicleTuning(v)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("tws-requireTuningSync", resourceRoot)
		setTimer(
			function()
				triggerServerEvent("tws-requireTuningSync", resourceRoot)
			end, 
		10000, 3)
	end
)
addEvent("tws-tuningSync", true)
addEventHandler("tws-tuningSync", root,
	function()
		applyAllVehiclesTuning()
	end
)