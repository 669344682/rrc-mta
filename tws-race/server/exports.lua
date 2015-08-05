-- createRace(table settings)
--
-- settings.maxPlayersCount 	- лимит игроков 
-- settings.players				- массив игроков 
-- settings.checkpoints			- массив чекпойнтов
-- settings.countdownEnabled	- true, чтобы был отсчет
--
-- settings.leavingVehicleAllowed		- можно ли выходить из авто
-- settings.changingVehicleAllowed		- можно ли менять авто
-- settings.announcingWinnersEnabled	- объявлять ли победителей (объявляются после окончания гонки)
-- settings.announcingTimeToWait		- время, через которое объявят победителей и закончится гонка 
--										  (после финиширования первого игрока) (default: 10000)
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

-- addPlayerToRace(player thePlayer, int raceID)
-- Возвращает true/false и название ошибки при false
function addPlayerToRace(...)
	return raceManager:addPlayerToRace(...)
end

-- removePlayerFromRace(player thePlayer, int raceID)
-- Возвращает true/false и название ошибки при false
function removePlayerFromRace(...)
	return raceManager:removePlayerFromRace(...)
end

-- abandonRace(int raceID, bool sendMessageToPlayers = true)
-- sendMessageToPlayers - будет ли отослано сообщение "Гонка была отменена"
-- Возвращает true/false
function abandonRace(...)
	return raceManager:abandonRace(...)
end


-- происходит, когда игрок финиширует
-- в параметрах raceID (игрок - client)
addEvent("tws-race.onClientFinished", true)

-- происходит, если игрок дисквалифицирован из-за нахождения вне автомобиля 
-- в параметрах raceID (игрок - client)
addEvent("tws-race.onClientDisqualified", true)