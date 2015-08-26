addEvent("onClientBeginnerTutorialComplete", true)
addEvent("instructions.createRace", true)

local mapPath, mapRoot
local beginning = {}

mapPath = "stuff/new-town.map"
mapRoot = resource:getMapRootElement(mapPath)
mapRoot.dimension = -1

beginning.position = Vector3(5495.038, -1622.731, 15.55)
beginning.vehicles = {}
beginning.vehicleData = {}
beginning.vehicleData.position = Vector3(5484.858, -1627.659, 15.275)
beginning.vehicleData.model = 527



function startBeginnerTutorialForPlayer(player)
	if not player then
		return
	elseif not getElementType(player) == "player" then
		return
	end

	local id = player:getData("tws-id")
	if not id then
		outputDebugString("starting beginner tutorial for player " .. tostring(player.name) .. " with no tws-id", 1)
		return
	end

	if player.vehicle then
		outputDebugString("starting beginner tutorial for player " .. tostring(player.name) .. " while having a vehicle", 1)
		return
	end

	-- позиция
	player.position = beginning.position
	player.dimension = id
	player.frozen = true

	-- отправляем карту клиенту
	triggerClientEvent("instructions.serverBeginningMapRoot", resourceRoot, mapRoot, id)

	-- спавним машину для клиента
	local vehicle

	vehicle = createVehicle(beginning.vehicleData.model, beginning.vehicleData.position)
	vehicle.dimension = id
	vehicle.frozen = true
	vehicle:setData("instructions.beginnerPlayer", player)

	beginning.vehicles[player] = vehicle
end

function cleanStuff()
	local player = client or source
	if not player then
		return
	end

	if beginning.vehicles[player] then
		beginning.vehicles[player]:destroy()
		beginning.vehicles[player] = nil
	end
end

addEventHandler("onClientBeginnerTutorialComplete", resourceRoot, cleanStuff)
addEventHandler("onPlayerLogout", resourceRoot, cleanStuff)

addEventHandler("instructions.createRace", resourceRoot,
	function(checkpoints)
		local raceManager = exports["tws-race"]

		local players = {client}

		local settings = {
			maxPlayersCount = #players,
			players = players,
			checkpoints = checkpoints,
			countdownEnabled = true,
			leavingVehicleAllowed = false,
			changingVehicleAllowed = false,
			announcingWinnersEnabled = false
		}

		raceManager:startRace(raceManager:createRace(settings))
	end
)

addCommandHandler("beginning", startBeginnerTutorialForPlayer)