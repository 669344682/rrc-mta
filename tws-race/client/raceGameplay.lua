raceGameplay = {}

raceGameplay.id = 0
raceGameplay.state = ""

raceGameplay.players = {}
raceGameplay.checkpoints = {}

function raceGameplay.createRace()
	-- TODO
end

function raceGameplay.startRace()
	raceGameplay.players = {}
	raceGameplay.state = RaceState.RUNNING
end

function raceGameplay.finishRace()
	raceGameplay.stopRace()
	raceGameplay.state = RaceState.FINISHED
end

function raceGameplay.nextCheckpoint()

end

function raceGameplay.stopRace()

end

-- Обработка эвентов с сервера
addEvent(RaceEvent.PLAYER_ADDED, true)
addEventHandler(RaceEvent.PLAYER_ADDED, resourceRoot, 
	function(player, playerID)
		table.insert(raceGameplay.players, player)
	end
)

addEvent(RaceEvent.PLAYER_REMOVED, true)
addEventHandler(RaceEvent.PLAYER_REMOVED, resourceRoot, 
	function(player, playerID)
		table.remove(raceGameplay.players, playerID)
	end
)

addEvent(RaceEvent.RACE_STARTED, true)
addEventHandler(RaceEvent.RACE_STARTED, resourceRoot, 
	function()
		raceGameplay.startRace()
	end
)

addEvent(RaceEvent.RACE_FINISHED, true)
addEventHandler(RaceEvent.RACE_FINISHED, resourceRoot, 
	function()
		raceGameplay.finishRace()
	end
)