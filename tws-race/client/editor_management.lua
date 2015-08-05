addEvent("tws-race.onServerResponseForRaceStarting", true)
addEvent("tws-race.onCreatorReconnect", true)

local pencil = dxCreateTexture("files/pencil.png")
local lineDrawn = false
local whatLine = nil
local checkpoint
local width, height = 200, 20
local labelShadow = guiCreateLabel(screenX/2-width/2, screenY/2-height/2, width+1, height+1, "", false); labelShadow:setVisible(false)
labelShadow:setHorizontalAlign("center"); labelShadow:setVerticalAlign("center"); labelShadow:setFont(font)
labelShadow:setProperty("TextColours", "")
labelShadow:setProperty("Alpha", "0.75")
local label = guiCreateLabel(screenX/2-width/2, screenY/2-height/2, width, height, "", false) label:setVisible(false)
label:setHorizontalAlign("center"); label:setVerticalAlign("center"); label:setFont(font)

function getLineLength(tab)
	local i = 1
	local distance = 0
	while (i < #tab) do
		local xd = currentLine[i][1] - currentLine[i+1][1]
		local yd = currentLine[i][2] - currentLine[i+1][2]
		local zd = currentLine[i][3] - currentLine[i+1][3]
		distance = distance + math.sqrt(xd*xd + yd*yd + zd*zd)

		i = i + 1
	end
	return distance
end
	
function splitVector(x1, y1, x2, y2, splitLength)
        local x, y = x2 - x1, y2 - y1
        local len = math.sqrt(x*x+y*y)
        if len < splitLength then
                return {{x1, y1, x2, y2}}
        end
        local sx, sy = x / len * splitLength, y / len * splitLength
        local result = {}
        local cx, cy = x1, y1
        for i = 1, math.floor(len / splitLength) do
                local newVector = {cx, cy, cx + sx, cy + sy}
                cx = cx + sx
                cy = cy + sy
                table.insert(result, newVector)
        end
        if math.floor(cx, cy) ~= math.floor(x2, y2) then
                table.insert(result, {cx, cy, x2, y2})
        end
        return result
end

local function clientRender()
	local x, y, z = getElementPosition(localPlayer)
	local x1, y1, z1, x2, y2, z2 = getCameraMatrix()
	setCameraMatrix(x1, y1, z1, x2, y2, z2)

	if isCursorShowing() then
		if lineDrawn then
			return
		end

		if getLineLength(currentLine) > 50 then
			lineDrawn = true
			setCursorAlpha(255)
			stopLineDrawing()
			return
		end

		local cursorX, cursorY, worldx, worldy, worldz = getCursorPosition()
		dxDrawImage(cursorX * screenX - 32, cursorY * screenY - 32, 64, 64, pencil)

		local px, py, pz = getCameraMatrix()
		local hit, x, y, z, elementHit, nx, ny, nz = processLineOfSight(px, py, pz, worldx, worldy, worldz, true, false, false, false, false)

		if not hit then 
			return 
		end

		if getKeyState("mouse1") then
			if #currentLine == 0 then
				table.insert(currentLine, {x, y, z+0.1, x + nx, y + ny, z+0.1 + nz})
			else
				local xd = x - currentLine[#currentLine][1]
				local yd = y - currentLine[#currentLine][2]
				local zd = z - currentLine[#currentLine][3]
				local distance = math.sqrt(xd*xd + yd*yd + zd*zd)

				if distance >= 2 then		
					if distance < 3 then
						table.insert(currentLine, {x, y, z+0.1, x + nx, y + ny, z+0.1 + nz})
					else
						local vectors = splitVector(currentLine[#currentLine][1], currentLine[#currentLine][2], x, y, 2)
						for _, v in ipairs(vectors) do
							table.insert(currentLine, {v[1], v[2], z+0.1, v[1] + nx, v[2] + ny, z+0.1 + nz})
							table.insert(currentLine, {v[3], v[4], z+0.1, v[3] + nx, v[4] + ny, z+0.1 + nz})
						end
					end
				end
			end
		else
			if #currentLine ~= 0 then
				lineDrawn = true
				setCursorAlpha(255)
				stopLineDrawing()
			end
		end
	end
end
function startLineDrawing(line)
	lineDrawn = false
	if line == "start" then
		function confirmationReceived(bool)
			removeEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)

			if not bool then
				return
			end

			label:setText("Первый чекпоинт")
			labelShadow:setText("Первый чекпоинт")
			label:setVisible(true)
			labelShadow:setVisible(true)

			local x1, y1, z1 = checkpointsForLines[1].x, checkpointsForLines[1].y, checkpointsForLines[1].z
			local x2, y2, z2 = checkpointsForLines[2].x, checkpointsForLines[2].y, z1
			checkpoint = createMarker(x1, y1, z1, "cylinder", checkpointsForLines[1].size*1.5)
			setCameraMatrix(x1, y1, z1 + 75, x1, y1, z1)

			whatLine = line
			startLine = {}

			addEventHandler("onClientPreRender", root, clientRender)
			toggleAllControls(false, true, false)
			currentLine = {}

			setCursorAlpha(0)
			lineDrawing = true
		end


		if #startLine ~= 0 then
			showConfirmationWindow("Линия старта уже существует!\n\nНарисовать ее заново?")
			addEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)
		else
			local text = ""
			text = text .. "#EEEEEEЛинии старта и финиша - декорации! Они\nне являются частью гонки. "
			text = text .. "#EEEEEEСовет: #FF6666не рисуй-\nте #EEEEEEлинию старта слишком близко к первому\nчекпоинту. "
			text = text .. "#66CC66Рисуйте #EEEEEEлинию старта на неко-\nтором расстоянии #66CC66до #EEEEEEпервого чекпоинта."

			exports["tws-message-manager"]:showMessage("Менеджер создания гонок", text, "info", 60000, false)

			confirmationReceived(true)
		end
	elseif line == "finish" then
		function confirmationReceived(bool)
			removeEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)

			if not bool then
				return
			end

			label:setText("Последний чекпоинт")
			labelShadow:setText("Последний чекпоинт")
			label:setVisible(true)
			labelShadow:setVisible(true)

			local x, y, z = checkpointsForLines[4].x, checkpointsForLines[4].y, checkpointsForLines[4].z
			checkpoint = createMarker(x, y, z, "cylinder", checkpointsForLines[4].size*1.5)
			setCameraMatrix(x, y, z + 75, x, y, z)

			whatLine = line
			finishLine = {}

			addEventHandler("onClientPreRender", root, clientRender)
			toggleAllControls(false, true, false)
			currentLine = {}

			setCursorAlpha(0)
			lineDrawing = true
		end


		if #finishLine ~= 0 then
			showConfirmationWindow("Линия финиша уже существует!\n\nНарисовать ее заново?")
			addEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)
		else	
			local text = ""
			text = text .. "#EEEEEEЛинии старта и финиша - декорации!\nОни не являются частью гонки. Совет:"
			text = text .. "\n#66CC66Рисуйте #EEEEEEлинию финиша прямо через\nфинишный чекпоинт"

			exports["tws-message-manager"]:showMessage("Менеджер создания гонок", text, "info", 60000, false)

			confirmationReceived(true)
		end
	end
end

function stopLineDrawing()
	destroyElement(checkpoint)
	label:setVisible(false)
	labelShadow:setVisible(false)
	if whatLine == "start" then
		triggerServerEvent("tws-race.onCreatorDrawnLine", resourceRoot, whatLine, currentLine)
		startLine = currentLine
	elseif whatLine == "finish" then
		triggerServerEvent("tws-race.onCreatorDrawnLine", resourceRoot, whatLine, currentLine)
		finishLine = currentLine
	end
	whatLine = nil
	currentLine = {}

	removeEventHandler("onClientPreRender", root, clientRender)
	toggleAllControls(true, true, false)

	setCameraTarget(localPlayer)

	setCursorAlpha(255)
	lineDrawing = false
end

functions.blip = function()
	triggerServerEvent("tws-race.onCreatorToggleBlip", resourceRoot)
end

functions.addPlayer = function()
	hideRemovePlayerWindow()
	if addPlayerWindow:getVisible() then
		hideAddPlayerWindow()
	else
		showAddPlayerWindow()
	end
end

functions.removePlayer = function()
	hideAddPlayerWindow()
	if removePlayerWindow:getVisible() then
		hideRemovePlayerWindow()
	else
		showRemovePlayerWindow()
	end
end

functions.players = function()
	outputChatBox("players")
end

functions.lineStart = function()
	if lineDrawing then
		stopLineDrawing()
	else
		startLineDrawing("start")
	end
end

functions.lineFinish = function()
	if lineDrawing then
		stopLineDrawing()
	else
		startLineDrawing("finish")
	end
end

functions.startRace = function()
	triggerServerEvent("tws-race.onCreatorAsksForRaceStarting", resourceRoot)
	addEventHandler("tws-race.onServerResponseForRaceStarting", resourceRoot, startRace)
end

functions.abandon2 = function()
	function confirmationReceived(bool)
		removeEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)

		if not bool then
			return
		end

		triggerServerEvent("tws-race.onCreatorAbandonRace", resourceRoot)
		switchToStage(4)

		function mainButtonHid()
			raceCreating = false
			removeEventHandler("onMainButtonHid", resourceRoot, mainButtonHid)
		end
		addEventHandler("onMainButtonHid", resourceRoot, mainButtonHid)
	end

	showConfirmationWindow("Вы собираетесь полностью удалить гонку!\n\nНичего не будет сохранено! Вы уверены?")
	addEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)
end

function startRace(response)
	removeEventHandler("tws-race.onServerResponseForRaceStarting", resourceRoot, startRace)

	if not response then
		return
	end

	showCursor(false)
	switchToStage(3)

	--triggerServerEvent("onClientStartsRace", resourceRoot)
end

addEventHandler("tws-race.onCreatorReconnect", resourceRoot,
	function(race)
		local checkpoints = race.checkpoints

		showMainButton()
		switchToStage(2)

		checkpointsForLines[1] = checkpoints[1]
		checkpointsForLines[2] = checkpoints[2]
		checkpointsForLines[3] = checkpoints[#checkpoints-1]
		checkpointsForLines[4] = checkpoints[#checkpoints]
	end
)