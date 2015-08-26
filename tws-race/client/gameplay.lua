local activeRace

---------
-- эвенты
---------

addEvent("tws-race.onRaceStart", true)
addEvent("tws-race.onPreStartFreeze", true)
addEvent("tws-race.onCreatorDrawnLine", true)
addEvent("tws-race.onClientRaceJoin", true)
addEvent("tws-race.onClientRaceLeave", true)
addEvent("tws-race.onRaceInvite", true)

----------------------
-- приглашение в гонку
----------------------
addEventHandler("tws-race.onRaceInvite", resourceRoot,
	function(raceID, creatorName)
		local messageID = exports["tws-message-manager"]:showMessage("Гонка", "Организатор " .. tostring(creatorName) .. " приглашает вас в свою гонку!", "question", false, true, "Принять", "Отклонить")

		local function messageResponse(messageIDClicked, response)
			if messageID == messageIDClicked then
				if response == "yes" or response == "no" then
					removeEventHandler("tws-message.onClientMessageClick", root, messageResponse)

					triggerServerEvent("tws-race.onClientInviteResponse", resourceRoot, raceID, response)
				end
			end
		end
		addEventHandler("tws-message.onClientMessageClick", root, messageResponse)
	end
)



---------------------------------------------------------
-- следим за vehicleLeave/vehicleEnter и за самой машиной
---------------------------------------------------------
local d_ypos = screenY/4.5
local d_height = 150
local d_time = 11000
local d_staticText = "Если не вернетесь в машину, то будете дисквалифицированы через"
local d_startTime = nil
local raceVehicle -- автомобиль локалплеера


local function doDisqualifyClient()
	exports["tws-message-manager"]:showMessage("Гонка", "Вы были дисквалифицированы из гонки.", "race", 7000, true)
	triggerServerEvent("tws-race.onClientDisqualified", root, localPlayer:getData("raceID"))
end

-- отсчет до дисквалификации
local function disqualifyCountDown()
	local now = getTickCount()
	local time = now - d_startTime
	time = (d_time - time) / 1000
	time = math.floor(time)

	if time <= -1 then
		removeEventHandler("onClientRender", root, disqualifyCountDown)
		doDisqualifyClient()
		return
	end

	dxDrawRectangle(0, d_ypos, screenX, d_height, tocolor(0, 0, 0, 75))
	dxDrawText(d_staticText, 0, d_ypos+20, screenX, d_ypos + d_height, tocolor(255, 255, 255), 2, "default-bold", "center", "top")
	dxDrawText(tostring(time), 0, d_ypos, screenX, d_ypos + d_height-25, tocolor(255, 255, 255), 4, "default-bold", "center", "bottom")
end


local function vehicleEnter(player, seat)
	if (player ~= localPlayer) or (seat ~= 0) or (not activeRace) then
		return
	end

	if not raceVehicle then
		raceVehicle = source
	else
		if activeRace.changingVehicleAllowed then
			raceVehicle = source
		end
	end
	
	if raceVehicle then
		if source == raceVehicle then
			removeEventHandler("onClientRender", root, disqualifyCountDown)
		end
	end
end

local function vehicleExit(player, seat)
	if (player ~= localPlayer) or (seat ~= 0) or (not activeRace) then
		return
	end

	if not activeRace.leavingVehicleAllowed then
		if source == raceVehicle then
			d_startTime = getTickCount()
			addEventHandler("onClientRender", root, disqualifyCountDown)
		end
	end
end

addEventHandler("tws-race.onRaceStart", resourceRoot,
	function(race)
		if localPlayer.vehicle then
			if localPlayer.vehicle:getOccupant() == localPlayer then
				raceVehicle = localPlayer.vehicle
			end
		end

		addEventHandler("onClientVehicleEnter", root, vehicleEnter)
		addEventHandler("onClientVehicleExit", root, vehicleExit)
	end
)






--------------------------------
-- старт гонки, чекпоинты, финиш
--------------------------------
local activeCheckpoints -- массив с чекпоинтами
local checkpointIndexPos = 1 -- текущий чекпоинт
local visibleCheckpoint1, visibleCheckpoint2
local visibleBlip1, visibleBlip2 -- блипы над чекпоинтами
local timeSpend -- затраченное время на гонку (выводится после финиша)

addEventHandler("tws-race.onRaceStart", resourceRoot,
	function(race)
		activeRace = race
		checkpointIndexPos = 1
		visibleCheckpoint1, visibleCheckpoint2, visibleBlip1, visibleBlip2 = nil, nil, nil, nil
		activeCheckpoints = race.checkpoints
		addEventHandler("onClientMarkerHit", root, checkpointHit)
		showNextCheckpoint()
		timeSpend = getTickCount()
	end
)

function checkpointHit(hitElement)
	if hitElement == localPlayer then
		if localPlayer.vehicle then
			if localPlayer.vehicle:getOccupant() == localPlayer then
				if source == visibleCheckpoint1 then
					playSoundFrontEnd(43)
					showNextCheckpoint()
				end
			end
		end
	end
end

getTimeFromTickCount(125105)

function showNextCheckpoint()
	local index = checkpointIndexPos
	local x1, y1, z1, s1 = activeCheckpoints[index].x, activeCheckpoints[index].y, activeCheckpoints[index].z, activeCheckpoints[index].size
	local x2, y2, z2, s2

	if index < #activeCheckpoints then
		x2, y2, z2, s2 = activeCheckpoints[index+1].x, activeCheckpoints[index+1].y, activeCheckpoints[index+1].z, activeCheckpoints[index+1].size
	else
		if visibleCheckpoint2 then
			-- prelast checkpoint
			destroyElement(visibleCheckpoint1)
			destroyElement(visibleBlip1)

			destroyElement(visibleCheckpoint2); visibleCheckpoint2 = nil
			destroyElement(visibleBlip2); visibleBlip2 = nil

			visibleCheckpoint1 = createMarker(x1, y1, z1, "checkpoint", s1)
			visibleCheckpoint1.dimension = localPlayer.dimension
			setMarkerIcon(visibleCheckpoint1, "finish")
			visibleBlip1 = createBlipAttachedTo(visibleCheckpoint1, 0, 2, 0, 0, 255, 255)
			visibleBlip1.dimension = localPlayer.dimension
		else
			-- finish checkpoint
			playSoundFrontEnd(7)

			destroyElement(visibleCheckpoint1)
			destroyElement(visibleBlip1)


			triggerEvent("tws-race.onClientFinished", root)
			triggerServerEvent("tws-race.onClientFinished", root, localPlayer:getData("raceID"))

			if activeRace.announcingWinnersEnabled then
				if activeRace.announcingWinnersEnabled then
					local min, sec, ms = getTimeFromTickCount(getTickCount() - timeSpend)
					local time = min .. ":" .. sec .. ":" .. ms

					exports["tws-message-manager"]:showMessage("Гонка", "Вы финишировали в гонке и узнаете занятое место после ее завершения.\n\n\nВаше время: " .. tostring(time), "race", false, true)
				end
			end

			activeRace = nil
			activeCheckpoints = nil

			removeEventHandler("onClientMarkerHit", root, checkpointHit)
		end

		
		return
	end
	if visibleCheckpoint1 and visibleCheckpoint2 then
		destroyElement(visibleCheckpoint1)
		destroyElement(visibleBlip1)

		destroyElement(visibleCheckpoint2)
		destroyElement(visibleBlip2)
	end
		
	visibleCheckpoint1 = createMarker(x1, y1, z1, "checkpoint", s1)
	visibleCheckpoint2 = createMarker(x2, y2, z2, "checkpoint", s2)

	visibleBlip1 = createBlipAttachedTo(visibleCheckpoint1, 0, 2, 0, 0, 255, 255)
	visibleBlip2 = createBlipAttachedTo(visibleCheckpoint2, 0, 2, 0, 0, 255, 255)

	visibleCheckpoint1.dimension = localPlayer.dimension
	visibleCheckpoint2.dimension = localPlayer.dimension

	visibleBlip1.dimension = localPlayer.dimension
	visibleBlip2.dimension = localPlayer.dimension

	setMarkerTarget(visibleCheckpoint1, x2, y2, z2)
	checkpointIndexPos = checkpointIndexPos + 1
end

-------------------------------------------
-- отсчет при заморозке игроков (до старта)
-------------------------------------------
addEventHandler("tws-race.onPreStartFreeze", resourceRoot,
	function()
		doStartingCountdown()
	end
)

function doStartingCountdown()
	local text = "READY!"
	local shadowSize = 3
	local scale = 4
	local y = screenY/1.5

	local function drawing()
		dxDrawText(text, shadowSize, shadowSize, screenX + shadowSize, y + shadowSize, tocolor(0, 0, 0), scale, "default", "center", "center")
		dxDrawText(text, 0, 0, screenX, y, tocolor(255, 255, 255), scale, "default", "center", "center")
	end
	addEventHandler("onClientRender", root, drawing)

	local i = 1
	setTimer(
		function()
			if i == 1 then
				text = "3"
				playSoundFrontEnd(44)
			elseif i == 2 then
				text = "2"
				playSoundFrontEnd(44)
			elseif i == 3 then
				text = "1"
				playSoundFrontEnd(44)
			elseif i == 4 then
				text = "GO!"
				playSoundFrontEnd(45)
			elseif i == 5 then
				removeEventHandler("onClientRender", root, drawing)
			end
			i = i + 1
		end, 1000, 5
	)
end

--------------------------------
-- отрисовка линий старта/финиша
--------------------------------
startLine = {}
finishLine = {}

addEventHandler("tws-race.onCreatorDrawnLine", resourceRoot,
	function(whatLine, line)
		if whatLine == "start" then
			startLine = line
		elseif whatLine == "finish" then
			finishLine = line
		else
			outputDebugString("whatLine error", 2)
		end
	end
)

addEventHandler("tws-race.onClientRaceJoin", resourceRoot,
	function(_startLine, _finishLine)
		startLine = _startLine or {}
		finishLine = _finishLine or {}
			
		removeEventHandler("onClientRender", root, drawingLines)
		addEventHandler("onClientRender", root, drawingLines)
	end
)

addEventHandler("tws-race.onClientRaceLeave", resourceRoot,
	function()
		startLine = {}
		finishLine = {}

		if visibleCheckpoint1 and isElement(visibleCheckpoint1) then
			destroyElement(visibleCheckpoint1) visibleCheckpoint1 = nil
		end
		if visibleCheckpoint2 and isElement(visibleCheckpoint2) then
			destroyElement(visibleCheckpoint2) visibleCheckpoint2 = nil
		end
		if visibleBlip1 and isElement(visibleBlip1) then
			destroyElement(visibleBlip1) visibleBlip1 = nil
		end
		if visibleBlip2 and isElement(visibleBlip2) then
			destroyElement(visibleBlip2) visibleBlip2 = nil
		end

		activeRace = nil
		activeCheckpoints = nil

		removeEventHandler("onClientMarkerHit", root, checkpointHit)	
		removeEventHandler("onClientRender", root, drawingLines)
		removeEventHandler("onClientVehicleEnter", root, vehicleEnter)
		removeEventHandler("onClientVehicleExit", root, vehicleExit)
		removeEventHandler("onClientRender", root, disqualifyCountDown)
	end
)

local lineTexture = dxCreateTexture("files/line.png")
function drawingLines()
	local i = 1
	while (i < #currentLine) do
		dxDrawMaterialLine3D(
			currentLine[i][1], currentLine[i][2], currentLine[i][3], 
			currentLine[i+1][1], currentLine[i+1][2], currentLine[i+1][3], 
			lineTexture, 2, tocolor(255, 255, 255), currentLine[i][4], currentLine[i][5], currentLine[i][6]
		)
		i = i + 1
	end
	
	local i = 1
	while (i < #startLine) do
		dxDrawMaterialLine3D(
			startLine[i][1], startLine[i][2], startLine[i][3], 
			startLine[i+1][1], startLine[i+1][2], startLine[i+1][3], 
			lineTexture, 2, tocolor(255, 255, 255), startLine[i][4], startLine[i][5], startLine[i][6]
		)
		i = i + 1
	end

	local i = 1
	while (i < #finishLine) do
		dxDrawMaterialLine3D(
			finishLine[i][1], finishLine[i][2], finishLine[i][3], 
			finishLine[i+1][1], finishLine[i+1][2], finishLine[i+1][3], 
			lineTexture, 2, tocolor(255, 255, 255), finishLine[i][4], finishLine[i][5], finishLine[i][6]
		)
		i = i + 1
	end
end

-- если вдруг ресурс отключился при отсчете, нужно разморозить локалплеера
addEventHandler("onClientResourceStop", root,
	function(resourceStopped)
		if resourceStopped == getThisResource() then
			toggleControl("enter_exit", true)
			localPlayer.frozen = false
			if localPlayer.vehicle then
				localPlayer.vehicle.frozen = false
			end
		end
	end
)