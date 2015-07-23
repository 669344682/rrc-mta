-- createRace(int maxPlayersCount, int maxTime, table checkpointsTable)
-- maxPlayersCount 	- лимит игроков
-- maxTime 			- лимит времени в секундах
-- playersTable		- массив игроков (игроков можно добавить после создания гонки)
-- checkpointsTable - массив чекпойнтов
--
-- Возвращает ID гонки
function createRace(...)
	return raceManager:createRace(...)
end

-- startRace(int raceID)
-- Возвращает true/false и название ошибки при false
function startRace(...)
	return raceManager:startRace(...)
end

-- finishRace(int raceID)
-- Возвращает true/false и название ошибки при false
function finishRace(...)
	return raceManager:finishRace(...)
end