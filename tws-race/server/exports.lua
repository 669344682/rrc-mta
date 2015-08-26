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
-- Возвращает ID гонки или false вместе с названием ошибки
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

-- isPlayerInRace(player thePlayer)
-- Возвращает true/false - находится ли игрок в какой-либо гонке
function isPlayerInRace(...)
	return raceManager:isPlayerInRace(...)
end

-- getPlayerRace(player thePlayer)
-- Возвращает ID гонки, в которой находится игрок или false, если игрок не находится в гонке
function getPlayerRace(...)
	return raceManager:getPlayerRace(...)
end

-- SERVER EVENT
-- происходит, когда игрок финиширует
-- в параметрах raceID (игрок - client)
addEvent("tws-race.onClientFinished", true)

-- SERVER EVENT
-- происходит, если игрок дисквалифицирован из-за нахождения вне автомобиля 
-- в параметрах raceID (игрок - client)
addEvent("tws-race.onClientDisqualified", true)

-- CLIENT EVENT
-- только для участников гонки
-- происходит, когда гонка начинается (с учетом отсчета)
addEvent("tws-race.onRaceStart", true)