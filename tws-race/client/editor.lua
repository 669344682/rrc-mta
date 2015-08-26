addEvent("onMainButtonHid", true)
addEvent("onButtonsToggle", true)
addEvent("onConfirmationReceived", true)

local lineTexture = dxCreateTexture("files/line.png")

functions = {}
currentLine = {}
startLine = {}
finishLine = {}
raceCreating = false
checkpointsForLines = {}
local currentStage = 0

local hotkeyCursor = "r"
local checkpointCursor = checkpointHotkey -- editor_gui.lua
local checkpoints = {}
local lines = {}
local checkpointsVisibility = true

function startRaceCreating()
	if raceCreating then
		return
	end

	raceCreating = true

	local text = "Включен режим создания гонки.\n\nВ правом нижнем углу появилась\nкнопка интерфейса создания гонки"
	exports["tws-message-manager"]:showMessage("Менеджер создания гонок", text, "info", 6000, false)
	--outputChatBox("Для включения/выключения курсора жмите \"" .. hotkeyCursor .. "\"")

	switchToStage(1)

	showMainButton()
end

function deleteAllCheckpoints()
	for index, checkpoint in ipairs(checkpoints) do
		destroyElement(checkpoint.element)
		destroyElement(checkpoint.blip)
	end
	checkpoints = {}
	lines = {}
	checkpointsVisibility = true
end

functions.checkpointAdd = function()
	if currentStage ~= 1 then
		return
	end
	if localPlayer.vehicle then
		local x, y, z = getElementPosition(localPlayer)
		local size = 5
		
		if #checkpoints == 0 then
			size = size * 1.5
		elseif #checkpoints == 1 then
			size = size * 1.375
		elseif #checkpoints == 2 then
			size = size * 1.25
		elseif #checkpoints == 3 then
			size = size * 1.125
		end

		local checkpoint = createMarker(x, y, z, "checkpoint", size)
		local blip = createBlipAttachedTo(checkpoint, 0, 2, 0, 0, 255, 255)

		checkpoint.dimension = localPlayer.dimension
		blip.dimension = localPlayer.dimension

		if (#checkpoints + 1) > 1 then
			local x1, y1, z1 = checkpoints[#checkpoints].x, checkpoints[#checkpoints].y, checkpoints[#checkpoints].z
			local x2, y2, z2 = getElementPosition(checkpoint)
			table.insert(lines, {x1, y1, z1+3, x2, y2, z2+3})

			if #checkpoints == 1 then
				setMarkerTarget(checkpoints[#checkpoints].element, getElementPosition(checkpoint))
			end
		end
		table.insert(checkpoints, {element = checkpoint, size = size, blip = blip, x = x, y = y, z = z})
	else
		exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "Вы должны находиться в машине\nдля создания чекпоинта!", "error", 3000, false)
		--outputChatBox("Вы должны находиться в машине для создания чекпоинта!", 255, 100, 100)
	end
end

functions.checkpointDel = function()
	if #checkpoints == 0 then
		return
	end

	destroyElement(checkpoints[#checkpoints].blip)
	destroyElement(checkpoints[#checkpoints].element)
	table.remove(checkpoints)
	table.remove(lines)
end

functions.checkpointHide = function()
	if checkpointsVisibility then
		removeEventHandler("onClientRender", root, drawLines)
		for _, checkpoint in ipairs(checkpoints) do
			setMarkerSize(checkpoint.element, -9999)
			local r, g, b = getBlipColor(checkpoint.blip)
			setBlipColor(checkpoint.blip, r, g, b, 0)
		end
		checkpointsVisibility = false
	else
		addEventHandler("onClientRender", root, drawLines)
		for _, checkpoint in ipairs(checkpoints) do
			setMarkerSize(checkpoint.element, checkpoint.size)
			local r, g, b = getBlipColor(checkpoint.blip)
			setBlipColor(checkpoint.blip, r, g, b, 255)
		end
		checkpointsVisibility = true
	end
end

functions.createRace = function()
	if #checkpoints < 3 then
		--outputChatBox("Вы должны добавить хотя бы 10 чекпоинтов!", 255, 100, 100)
		exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "Вы должны добавить хотя бы 3\nчекпоинта для создания гонки!", "error", 5000, false)
		return
	end

	if localPlayer:getData("raceID") then
		exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "Вы не можете создать гонку, пока сами участвуете в гонке!", "error", 5000, true)
		return
	end

	if localPlayer:getData("creator_raceID") then
		exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "Вы не можете создать гонку, пока не закончится предыдущая созданная вами гонка!", "error", 5000, true)
		return
	end

	function confirmationReceived(bool)
		removeEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)

		if not bool then
			return
		end

		triggerServerEvent("tws-race.onCreatorCreateRace", resourceRoot, checkpoints)
		checkpointsForLines[1] = checkpoints[1]
		checkpointsForLines[2] = checkpoints[2]
		checkpointsForLines[3] = checkpoints[#checkpoints-1]
		checkpointsForLines[4] = checkpoints[#checkpoints]
		deleteAllCheckpoints()
		switchToStage(2)
	end
	showConfirmationWindow("Вы уверены?\n\nВы больше не сможете редактировать чекпоинты!")
	addEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)
end

functions.abandon = function()
	function confirmationReceived(bool)
		removeEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)

		if not bool then
			return
		end

		showCursor(false)
		hideMainButton()
		
		function mainButtonHid()
			deleteAllCheckpoints()
			raceCreating = false
			removeEventHandler("onMainButtonHid", resourceRoot, mainButtonHid)
		end
		addEventHandler("onMainButtonHid", resourceRoot, mainButtonHid)
	end
	if #checkpoints ~= 0 then
		showConfirmationWindow("Вы уверены?\n\nВсе чекпоинты будут удалены!")
		addEventHandler("onConfirmationReceived", resourceRoot, confirmationReceived)
	else
		confirmationReceived(true)
	end
end

function switchToStage(int)
	function buttonsToggle(state)
		if state == false then
			removeAllButtons()
			confirmationWindow:setVisible(false)
			addPlayerWindow:setVisible(false)
			removePlayerWindow:setVisible(false)


			removeEventHandler("onButtonsToggle", resourceRoot, buttonsToggle)

			currentStage = int

			if int == 1 then -- first stage: creating checkpoints
				addButton("checkpointAdd")
				addButton("checkpointDel")
				addButton("checkpointHide")
				addButton("createRace")
				addButton("abandon")
			elseif int == 2 then -- second stage: adding people, drawing lines
				addButton("blip")
				addButton("addPlayer")
				addButton("removePlayer")
				--addButton("players")
				addButton("lineStart")
				addButton("lineFinish")
				addButton("startRace")
				addButton("abandon2")
				setTimer(toggleButtons, 100, 1)
				removeEventHandler("onClientRender", root, drawingLines)
				addEventHandler("onClientRender", root, drawingLines)
			elseif int == 3 then -- third stage: racing stage
				hideMainButton()
				raceCreating = false
			elseif int == 4 then -- fourth stage: race is over
				hideMainButton()
				removeEventHandler("onClientRender", root, drawingLines)
				startLine = {}
				finishLine = {}
				raceCreating = false
			end
		end
	end
	if not buttonsShowing and not buttonsMoving then
		buttonsToggle(false)
	else
		toggleButtons(false)
		addEventHandler("onButtonsToggle", resourceRoot, buttonsToggle)
	end
end
addEventHandler("onClientGUIClick", resourceRoot, 
	function()
		if not buttonsMoving then
			local key = source:getData("key")
			if key and buttonsEnabled then
				if functions[key] then
					functions[key]()
				end
			else
				if source == confirmationYes then
					hideConfirmationWindow()
					triggerEvent("onConfirmationReceived", resourceRoot, true)
				elseif source == confirmationNo then
					hideConfirmationWindow()
					triggerEvent("onConfirmationReceived", resourceRoot, false)
				elseif source == addPlayerButton then
					local id = tonumber(addPlayerEdit:getText())
					addPlayerEdit:setText("")
					if not id then
						exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "ID не введен или введен неверно!", "error", 4000, false)
						return
					end
					triggerServerEvent("tws-race.onCreatorAddPlayer", resourceRoot, id)
				elseif source == removePlayerButton then
					local id = tonumber(removePlayerEdit:getText())
					removePlayerEdit:setText("")
					if not id then
						exports["tws-message-manager"]:showMessage("Менеджер создания гонок", "ID не введен или введен неверно!", "error", 4000, false)
						return
					end
					triggerServerEvent("tws-race.onCreatorRemovePlayer", resourceRoot, id)
				elseif (source == addPlayerEdit) or (source == addPlayerButton) then
					addPlayerEdit:setText("")
				elseif (source == removePlayerEdit) or (source == removePlayerButton) then
					removePlayerEdit:setText("")
				end
			end
		end
	end
)

-- рисуем линии между чекпоинтами
function drawLines()
	local color
	for i, line in ipairs(lines) do
		if (i % 2) == 0 then
			color = tocolor(255, 0, 0)
		else
			color = tocolor(0, 255, 0)
		end
		dxDrawLine3D (line[1], line[2], line[3], line[4], line[5], line[6], color, 10)
	end
end
addEventHandler("onClientRender", root, drawLines)

--startRaceCreating()
addCommandHandler("race", startRaceCreating)
--bindKey(hotkeyCursor, "down", toggleCursor)

bindKey(checkpointHotkey, "down", 
	function()
		if raceCreating then
			functions.checkpointAdd()
		end
	end
)


addCommandHandler("savecheckpoints",
	function()
		if not checkpoints then
			return
		end

		local string = "checkpoints = {\n"

		for _, checkpoint in ipairs(checkpoints) do
			local x, y, z, size = checkpoint.x, checkpoint.y, checkpoint.z, checkpoint.size

			string = string .. "\t{x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", size = " .. size .. "},\n"
		end

		string = string .. "}"

		local file = fileCreate("save/checkpoints.lua")
		if file then
			outputDebugString("CHECKPOINTS WERE SUCCESFULLY SAVED")
			file:write(string)
			file:close()
		else
			outputDebugString("CHECKPOINTS FILE WAS NOT CREATED")
		end
	end
)
