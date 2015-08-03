addEvent("onClientFinished", true)

function stopRace(raceID)
	local race = getRaceByID(raceID)

	for creatorAccount, g_race in ipairs(races) do
		if race == g_race then
			races[creatorAccount] = nil
		end
	end

	if not race then
		outputChatBox("Ошибка #" .. debug.getinfo(1).currentline .. " " .. debug.getinfo(1).source, client, 255, 100, 100)
		return
	end 

	outputChatBoxToRacers("Гонка завершена! Победители:", race, 70, 255, 70)

	local place = #race.winners
	local step = 500
	local sleep = step
	while place >= 1 do
		local player = race.winners[place]
		if place == 3 then
			setTimer(outputChatBoxToRacers, sleep, 1, "" .. player .. " занял третье место!", race, 205, 127, 50)
		elseif place == 2 then
			setTimer(outputChatBoxToRacers, sleep, 1, "" .. player .. " занял второе место!", race, 200, 200, 200) 
		elseif place == 1 then
			setTimer(function()
				outputChatBoxToRacers("" .. player .. " занял первое место!", race, 255, 215, 0)

				for _, player in ipairs(race.players) do
					triggerClientEvent(player, "onRaceDone", resourceRoot)
				end

				triggerClientEvent(race.creatorAccount:getPlayer(), "onRaceDone", resourceRoot, true)

			end, sleep, 1)
		else
			setTimer(outputChatBoxToRacers, sleep, 1, "" .. player .. " занял " .. place .. " место!", race, 100, 100, 100)
		end

		sleep = sleep + step
		place = place - 1
	end

	
end


addEventHandler("onClientFinished", resourceRoot,
	function()
		local id = client:getData("raceID")
		local race = getRaceByID(id)

		if not race then
			outputChatBox("Ошибка #" .. debug.getinfo(1).currentline .. " " .. debug.getinfo(1).source, client, 255, 100, 100)
			return
		end 

		if #race.winners == 0 then
			outputChatBoxToRacers("Победитель определен! Гонка будет завершена через 10 секунд.", race, 70, 255, 70)
			setTimer(stopRace, 10000, 1, id)
		end
		table.insert(race.winners, client:getName())
	end
)
