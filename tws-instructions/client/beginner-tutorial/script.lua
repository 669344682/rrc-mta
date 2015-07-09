addCommandHandler("beginning", 
	function()
		startInstruction("beginning")
	end
)

addEvent("instructions.serverBeginningMapRoot", true)
addEventHandler("instructions.serverBeginningMapRoot", resourceRoot,
	function(mapRoot, dimension)
		mapRoot.dimension = dimension

		startBeginnerTutorial()
	end
) 

local function toggleFog(state)
	if state then
		setFogDistance(50)
		setFarClipDistance(175)
	else
		setFogDistance(300)
		setFarClipDistance(500)
	end
end

function boostVehicle(vehicle)
	local boostSpeed = 150
	local step = 1
	local function boosting()
		local speed = getElementSpeed(vehicle, "km/h")

		if speed >= boostSpeed then
			removeEventHandler("onClientRender", root, boosting)
			return
		end

		if speed > 10 then
			setElementSpeed(vehicle, "km/h", speed + step)
		end
	end
	addEventHandler("onClientRender", root, boosting)
end


function startBeginnerTutorial()
	-- создаем грузовики в начале гонки для прыжка
	local packers = {}
	packers[1] = createVehicle(443, 5279.7426757813, -1895.9191894531, 16.135282516479)
	packers[2] = createVehicle(443, 5288.0126953125, -1895.9189453125, 16.135282516479)

	for _, packer in ipairs(packers) do
		packer.collisions = false
		packer.frozen = true
		packer.dimension = localPlayer.dimension
	end

	-- туман
	toggleFog(true)

	-- колшейпы для ускорения авто на прыжке
	local colshapeBoost = createColSphere(5283.656, -1899.123, 16.992, 10)

	local function colShapeHit(hitElement)
		if not (source == colshapeBoost) then
			return
		end

		if hitElement.type == "vehicle" and hitElement ~= localPlayer.vehicle then
			local ped = getVehicleOccupant(hitElement)
			if ped then
				boostVehicle(hitElement)
			end
		elseif hitElement == localPlayer.vehicle then
			boostVehicle(hitElement)
		end
		
	end
	addEventHandler("onClientColShapeHit", root, colShapeHit)

	-- начальная позиция бота
	local botStartPosition = {x = 5305.318359375, y = -2082.5686035156, z = 15.004985809326}

end