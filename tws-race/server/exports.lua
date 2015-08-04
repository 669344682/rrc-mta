-- createRace(table settings)
--
-- settings.maxPlayersCount 	- лимит игроков 
-- settings.players				- массив игроков 
-- settings.checkpoints			- массив чекпойнтов
-- settings.countdownEnabled	- true, чтобы был отсчет
-- settings.countdownFreeze 	- true, чтобы при отсчете игроков фризило на месте 
--
-- settings.leavingVehicleAllowed		- можно ли выходить из авто
-- settings.changingVehicleAllowed		- можно ли менять авто
-- settings.announcingWinnersEnabled	- объявлять ли победителей (объявляются после окончания гонки)
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