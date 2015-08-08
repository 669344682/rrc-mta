challengeManager = {}
-- Настройки
challengeManager.settings = {
	checkpointsCount = 3
}

function challengeManager:createRace(player1)
	if exports["tws-race"]:isPlayerInRace(player1) then
		return false
	end

	local raceCheckpoints = generateCheckpointsForPlayer(player1, self.settings.checkpointsCount)
	if not raceCheckpoints then
		return false
	end

	-- Настройки по умолчанию
	local settings = {
		maxPlayersCount 			= 2,
		players 					= {player1},
		checkpoints 				= raceCheckpoints,
		countdownEnabled 			= false,
		leavingVehicleAllowed 		= false,
		changingVehicleAllowed 		= false,
		announcingWinnersEnabled 	= false,
		announcingTimeToWait 		= 0
	}
	local race = exports["tws-race"]:createRace(settings)
	exports["tws-race"]:startRace(race)

	return race
end

addCommandHandler("challenge",
	function(player, cmd)
		outputChatBox("Создание гонки...", player, 255, 150, 0)
		local result = challengeManager:createRace(player)
		if not result then
			outputChatBox("Не удалось создать гонку", player, 255, 0, 0)
		else
			outputChatBox("Гонка была успешно создана (ID" .. tostring(result) .. ")", player, 0, 255, 0)
		end
	end
)