local function drawRaceTimer()
	-- TODO Оставшееся время
end

local function drawRaceProgress()
	-- TODO Количество чекпойнтов
end

local function drawRacePosition()
	-- TODO Позиция
end

local function drawWaitingMessage()
	-- TODO Сообщение о том, что гонка ещё не началась
end

local function draw()
	if raceGameplay.state == "running" then
		drawRaceProgress()
		drawRaceTimer()
	elseif raceGameplay.state == "waiting" then
		drawWaitingMessage()
	end
end

addEventHandler("onClientRender", root, draw)