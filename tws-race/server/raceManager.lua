raceManager = {}
raceManager.activeRaces = {}

-- Создание гонки
function raceManager:createRace(maxPlayersCount, maxTime, playersTable, checkpointsTable)
	local race = {}

	race.time = 0
	race.state = RaceState.WAITING

	-- Максимальное количество игроков в гонке
	race.maxPlayersCount = 0
	if maxPlayersCount and type(maxPlayersCount) == "number" and maxPlayersCount > 0 then
		race.maxPlayersCount = maxPlayersCount
	end
	-- Время длительности гонки
	race.maxTime = 0
	if maxTime and type(maxTime) == "number" and maxTime > 0 then
		race.maxTime = maxTime
	end
	-- Массив чекпойнтов
	race.checkpoints = {}
	if checkpointsTable and type(checkpointsTable) == "table" then
		race.checkpoints = checkpointsTable
	end

	table.insert(self.activeRaces, race)
	race.id = #self.activeRaces

	-- Массив игроков
	race.players = {}
	if playersTable and type(playersTable) == "table" then
		for i, player in ipairs(playersTable) do
			self:addPlayerToRace(race.id, player)
		end
	end

	return race.id
end

-- Удаление гонки
function raceManager:removeRace(raceID)
	if not self:getRaceByID(raceID) then
		return false
	end
	table.remove(self.activeRaces, raceID)
	return true
end

function raceManager:getRaceByID(raceID)
	if not raceID then
		return false
	end
	local race = self.activeRaces[raceID]
	if race then
		return race
	else
		return false
	end
end

-- Добавление игрока в гонку
-- Возвращает true/false и название ошибки, если false
function raceManager:addPlayerToRace(raceID, player)
	-- Если гонки не существует или игрока не существует
	local race = self:getRaceByID(raceID)
	if race or not isElement(player) then
		return false, "bad_argument"
	end
	-- Если гонка уже начата
	if race.state == RaceState.RUNNING then
		return false, "race_running"
	end
	-- Если достигнут лимит игроков в гонке
	if #race.players >= race.maxPlayersCount then
		return false, "max_players_limit"
	end
	-- Находится ли игрок в другой гонке
	local playerRaceID = player:getData(RACE_ID_DATA)
	if self:getRaceByID(playerRaceID) then
		return false, "already_in_race"
	end
	-- Добавление игрока в гонку
	table.insert(race.players, player)
	player:setData(RACE_ID_DATA, raceID)
	triggerClientEvent(player, RaceEvent.JOINED, resourceRoot, race.checkpoints, race.settings)
	self:triggerEventForAllPlayers(playerRaceID, RaceEvent.PLAYER_ADDED, player, #race.players)
	return true
end

-- Удаление игрока из гонки
function raceManager:removePlayerFromRace(player)
	if not isElement(player) then
		return false
	end
	local playerRaceID = player:getData(RACE_ID_DATA)
	local race = self:getRaceByID(playerRaceID)
	-- Если игрок не учавствует в гонке
	if not race then
		return false
	end
	-- Поиск игрока в массиве игроков гонки
	local playerID = 0
	for i, p in ipairs(race.players) do
		if p == player then
			playerID = i
			break
		end
	end
	-- Если игрок не найден в гонке
	if playerID == 0 then
		return false
	end
	table.remove(race.players, playerID)
	self:triggerEventForAllPlayers(playerRaceID, RaceEvent.PLAYER_REMOVED, player, playerID)
	return true
end

function raceManager:triggerEventForAllPlayers(raceID, eventName, ...)
	local race = self:getRaceByID(raceID)
	if not race then
		return false
	end
	for i, p in ipairs(race.players) do
		triggerClientEvent(p, eventName, resourceRoot, ...)
	end	
end

-- Старт гонки
function raceManager:startRace(raceID)
	local race = self:getRaceByID(raceID)
	if not race then
		return false, "bad_race"
	end
	if #race.players == 0 then
		return false, "no_players"
	end
	if #race.checkpoints == 0 then
		return false, "no_checkpoints"
	end	
	self:triggerEventForAllPlayers(playerRaceID, RaceEvent.RACE_STARTED)
	race.finishTimer = setTimer(function(raceID) raceManager:finishRace(raceID) end, race.maxTime, 1, raceID)
	race.state = RaceState.RUNNING
	return true
end

-- Финиш гонки
function raceManager:finishRace(raceID)
	local race = self:getRaceByID(raceID)
	if race then
		return false, "bad_race"
	end

	self:triggerEventForAllPlayers(playerRaceID, RaceEvent.RACE_FINISHED)
	self:removeRace(raceID)
	return true
end