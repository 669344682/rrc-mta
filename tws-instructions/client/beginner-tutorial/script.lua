addEvent("instructions.serverBeginningMapRoot", true)
addEvent("tws-race.onRaceStart", true)
addEvent("tws-race.onClientFinished", true)

addEventHandler("instructions.serverBeginningMapRoot", resourceRoot,
	function(mapRoot, dimension)
		mapRoot.dimension = dimension

		startBeginnerTutorial()

		setTimer(setElementFrozen, 1000, 1, localPlayer, false)

		addEventHandler("onClientVehicleEnter", root, vehicleEnter)
		addEventHandler("tws-race.onRaceStart", root, beginnerRaceStart)
		addEventHandler("tws-race.onClientFinished", root, beginnerRaceClientFinish)
	end
) 

-- колшейп для ускорения авто на прыжке
local colshapeBoost = createColSphere(5283.656, -1899.123, 16.992, 10)

function colshapeHitBoost(hitElement)
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
	-- оповещаем игрока
	startInstruction("welcoming")

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

	-- спавним бота (bot_playback.lua)
	spawnBotVehicle()
end

addCommandHandler("startbot",
	function()
		local checkpoints = {
			{x = 5288.9560546875, y = -1993.2817382813, z = 14.990927696228, size = 7.5},
			{x = 5293.912109375, y = -1769.0061035156, z = 14.957134246826, size = 6.875},
			{x = 5304.9907226563, y = -1601.3692626953, z = 14.869832038879, size = 6.25},
			{x = 5304.8559570313, y = -1444.3395996094, z = 16.201105117798, size = 5.625},
			{x = 5303.9506835938, y = -1344.0042724609, z = 17.997995376587, size = 5},
			{x = 5365.96875, y = -1325.3557128906, z = 18.406421661377, size = 5},
			{x = 5549.4755859375, y = -1324.7257080078, z = 24.93496131897, size = 5},
			{x = 5565.4375, y = -1492.5257568359, z = 15.139458656311, size = 5},
			{x = 5484.486328125, y = -1511.0135498047, z = 18.032762527466, size = 5},
			{x = 5455.2021484375, y = -1595.1390380859, z = 15.581387519836, size = 5},
			{x = 5384.0727539063, y = -1621.8763427734, z = 14.873597145081, size = 5},
			{x = 5270.2250976563, y = -1621.3020019531, z = 14.88893032074, size = 5},
			{x = 5196.1577148438, y = -1621.9755859375, z = 15.167591094971, size = 5},
			{x = 5180.7700195313, y = -1671.8458251953, z = 14.99942111969, size = 5},
			{x = 5207.5454101563, y = -1700.5142822266, z = 14.943380355835, size = 5},
			{x = 5288.0522460938, y = -1701.3286132813, z = 14.930438995361, size = 5},
			{x = 5305.3203125, y = -1676.6082763672, z = 14.925696372986, size = 5},
			{x = 5321.2407226563, y = -1620.5961914063, z = 14.931865692139, size = 5},
			{x = 5487.1015625, y = -1620.5659179688, z = 15.163824081421, size = 5},
		}

		triggerServerEvent("instructions.createRace", resourceRoot, checkpoints)
	end
)

function beginnerRaceStart(race)
	if race.id == localPlayer:getData("raceID") then
		removeEventHandler("tws-race.onRaceStart", root, beginnerRaceStart)
		startBot()

		addEventHandler("onClientColShapeHit", root, colshapeHitBoost)
	end
end

function beginnerRaceClientFinish()
	removeEventHandler("tws-race.onClientFinished", root, beginnerRaceClientFinish)
	removeEventHandler("onClientColShapeHit", root, colshapeHitBoost)

	outputChatBox("FINISH!")
end

function beginnerTutorialEnd()
	removeEventHandler("onClientVehicleEnter", root, vehicleEnter)
	removeEventHandler("tws-race.onClientFinished", root, beginnerRaceClientFinish)
	removeEventHandler("onClientColShapeHit", root, colshapeHitBoost)

	triggerServerEvent("onClientBeginnerTutorialComplete", resourceRoot)
end

function vehicleEnter()
	local beginnerPlayer = source:getData("instructions.beginnerPlayer")
	if beginnerPlayer == localPlayer then
		source.frozen = false
		removeEventHandler("onClientVehicleEnter", root, vehicleEnter)
	end
end