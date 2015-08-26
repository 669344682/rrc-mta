checkpointHotkey = "1"

addEvent("onButtonsToggle", true)

lineDrawing = false

font = guiCreateFont("files/tahomabold.ttf", 10)
local descriptionArrow = guiCreateStaticImage(0, 0, 32, 24, "files/arrow.png", false); descriptionArrow:setVisible(false)
local descriptionLabel = guiCreateLabel(0, 0, 400, 20, "", false)
descriptionLabel:setVisible(false); descriptionLabel:setHorizontalAlign("center") guiSetFont(descriptionLabel, font)
local descriptionLabelShadow = guiCreateLabel(0, 0, 400, 20, "", false)
descriptionLabelShadow:setVisible(false); descriptionLabelShadow:setHorizontalAlign("center") guiSetFont(descriptionLabelShadow, font)
guiSetProperty(descriptionLabelShadow, "TextColours", "")
guiSetProperty(descriptionLabelShadow, "Alpha", "0.75")

local width, height = 350, 150
confirmationWindow = guiCreateWindow(screenX/2 - width/2, screenY/2 - height/2, width, height, "Подтвердите свой выбор", false); confirmationWindow:setVisible(false)
confirmationLabel = guiCreateLabel(20, 30, width-40, height/3, "", false, confirmationWindow); confirmationLabel:setHorizontalAlign("center")
confirmationYes = guiCreateButton(20, 30+height/3 + 10, width/3, 40, "Да", false, confirmationWindow)
confirmationNo = guiCreateButton(width-width/3 - 20, 30+height/3 + 10, width/3, 40, "Нет", false, confirmationWindow)

guiW, guiH = 120, 120
guiPosX, guiPosY = screenX-speedoW-guiW-70, screenY-guiH-40

width, height = 160, 70
addPlayerWindow = guiCreateWindow(0, 0, width, height, "Введите ID игрока", false); addPlayerWindow:setVisible(false)
addPlayerEdit = guiCreateEdit(10, 25, width/3, 30, "", false, addPlayerWindow); addPlayerEdit:setMaxLength(3)
addPlayerButton = guiCreateButton(width/3+20, 25, width/2, 30, "Допустить", false, addPlayerWindow)

removePlayerWindow = guiCreateWindow(0, 0, width, height, "Введите ID игрока", false); removePlayerWindow:setVisible(false)
removePlayerEdit = guiCreateEdit(10, 25, width/3, 30, "", false, removePlayerWindow); removePlayerEdit:setMaxLength(3)
removePlayerButton = guiCreateButton(width/3+20, 25, width/2, 30, "Исключить", false, removePlayerWindow)

buttons = {} -- all buttons
descriptions = {} -- buttons' descriptions
active = {} -- active buttons
buttonsShowing, buttonsMoving, buttonsEnabled = false, false, true
buttonsMovingStep = 10


mainButton = guiCreateStaticImage(guiPosX, guiPosY, guiW, guiH, "files/main.png", false); guiSetVisible(mainButton, false)

-- buttons 
buttons.createRace = guiCreateStaticImage(0, 0, 54, 62, "files/button-createrace.png", false)
buttons.abandon = guiCreateStaticImage(0, 0, 54, 62, "files/button-abandon.png", false)
buttons.checkpointHide = guiCreateStaticImage(0, 0, 54, 62, "files/button-checkpoint-hide.png", false)
buttons.checkpointDel = guiCreateStaticImage(0, 0, 54, 62, "files/button-checkpoint-del.png", false)
buttons.checkpointAdd = guiCreateStaticImage(0, 0, 54, 62, "files/button-checkpoint-add.png", false)
buttons.startRace = guiCreateStaticImage(0, 0, 54, 62, "files/button-startrace.png", false)
buttons.removePlayer = guiCreateStaticImage(0, 0, 54, 62, "files/button-removeplayer.png", false)
buttons.addPlayer = guiCreateStaticImage(0, 0, 54, 62, "files/button-addplayer.png", false)
buttons.players = guiCreateStaticImage(0, 0, 54, 62, "files/button-players.png", false)
buttons.blip = guiCreateStaticImage(0, 0, 54, 62, "files/button-blip.png", false)
buttons.abandon2 = guiCreateStaticImage(0, 0, 54, 62, "files/button-abandon2.png", false)
buttons.lineStart = guiCreateStaticImage(0, 0, 54, 62, "files/button-line-start.png", false)
buttons.lineFinish = guiCreateStaticImage(0, 0, 54, 62, "files/button-line-finish.png", false)

-- buttons' descriptions
descriptions.createRace = "Создать гонку"
descriptions.abandon = "Отменить создание гонки"
descriptions.checkpointHide = "Скрыть/показать все чекпоинты"
descriptions.checkpointDel = "Удалить последний чекпоинт"
descriptions.checkpointAdd = "Добавить чекпоинт (hotkey: " .. tostring(checkpointCursor) ..")"
descriptions.startRace = "Начать гонку"
descriptions.removePlayer = "Исключить игрока из гонки"
descriptions.addPlayer = "Допустить игрока до гонки"
descriptions.players = "Открыть список допущенных игроков"
descriptions.blip = "Показать/скрыть иконку на миникарте"
descriptions.abandon2 = "Отменить и удалить гонку"
descriptions.lineStart = "Нарисовать линию старта"
descriptions.lineFinish = "Нарисовать линию финиша"

-- common
buttons.empty = guiCreateStaticImage(0, 0, 31, 62, "files/button-empty.png", false)
buttons.edge = guiCreateStaticImage(0, 0, 31, 62, "files/button-edge.png", false)


for key, button in pairs(buttons) do
	button:setVisible(false)
	button:setData("key", key)
end

mainButton:bringToFront()
---------------
-- functions --
---------------

function toggleCursor()
	if isCursorShowing() then
		showCursor(false)
	else 
		showCursor(true)
	end
end

function showMainButton()
	buttonsEnabled = true
	mainButton:setVisible(true)
end


function hideMainButton()
	function buttonsToggle(state)
		if state == false then
			removeAllButtons()
			mainButton:setVisible(false)
			removeEventHandler("onButtonsToggle", resourceRoot, buttonsToggle)
			triggerEvent("onMainButtonHid", resourceRoot)
		end
	end
	if not buttonsMoving and not buttonsShowing then
		buttonsToggle(false)
	else
		toggleButtons(false)
		addEventHandler("onButtonsToggle", resourceRoot, buttonsToggle)
	end
end

function addButton(key, pos)
	if buttonsShowing or buttonsMoving then
		outputDebugString("All buttons have to be hidden and not moving for adding one!", 2)
		return
	end
	local pos = pos or #active + 1
	if #active ~= 0 then
		if active[1] == buttons.edge then 
		-- there is an edge button -> there is an empty button in the end, put new button between them
			if pos == 1 then
				pos = pos + 1
			elseif pos == #active then
				pos = pos - 1
			end
		end
	end
	table.insert(active, pos, buttons[key])
end

function removeButton(key)
	if buttonsShowing or buttonsMoving then
		outputDebugString("All buttons have to be hidden and not moving for deleting one!", 2)
		return
	end
	for index, button in ipairs(active) do
		if button:getData("key") == key then
			table.remove(active, index)
		end
	end
end

function removeAllButtons()
	if buttonsShowing or buttonsMoving then
		outputDebugString("All buttons have to be hidden and not moving for deleting them!", 2)
		return
	end
	active = {}
end

function toggleButtons(force) -- true for force showing it, false for force hiding it
	mainButton:bringToFront()
	local buttonsPosX = guiPosX + 35
	local buttonsPosY = guiPosY + 30
	if not (buttonsShowing or buttonsMoving) then
		-- adding edge and empty space
		if #active == 0 then
			outputDebugString("No buttons to toggle", 2)
			return
		else
			if active[1] ~= buttons.edge then
				table.insert(active, 1, buttons.edge)
				table.insert(active, buttons.empty)
			end
		end
		-- setting their position
		local width = 0
		for index, button in ipairs(active) do
			button:setPosition(buttonsPosX + width, buttonsPosY, false)
			width = width + button:getSize(false)
		end
	end

	if force == false then
		buttonsMovingStep = math.abs(buttonsMovingStep)
		buttonsEnabled = false
		clientMouseEnterOrLeave("onClientMouseLeave")
	elseif force == true then
		buttonsMovingStep = -math.abs(buttonsMovingStep)
		buttonsEnabled = false
	else
		buttonsMovingStep = -buttonsMovingStep
	end
	
	if moving then
		removeEventHandler("onClientRender", root, moving) 
	end

	function moving()
		for index, button in ipairs(active) do
			local w, h = button:getSize(false)
			local x, y = button:getPosition(false)
			
			button:setPosition(x + buttonsMovingStep, y, false)

			if (buttonsMovingStep < 0) and (x < buttonsPosX) then
				button:setVisible(true)

				if (x + w) < buttonsPosX then
					if index == #active then -- last button
						removeEventHandler("onClientRender", root, moving)
						buttonsMoving = false
						buttonsShowing = true
						triggerEvent("onButtonsToggle", resourceRoot, buttonsShowing)
					end
				end
			elseif (buttonsMovingStep > 0) and (x > buttonsPosX) then
				button:setVisible(false)

				if index == 1 then -- first button
					removeEventHandler("onClientRender", root, moving)
					buttonsMoving = false
					buttonsShowing = false
					triggerEvent("onButtonsToggle", resourceRoot, buttonsShowing)
				end
			end
		end
	end
	addEventHandler("onClientRender", root, moving)
	buttonsMoving = true
end

function clientMouseEnterOrLeave(fake_eventName)
	local eventName = eventName or fake_eventName
	if eventName == "onClientMouseEnter" then
		guiHoveredOn = source
	else
		guiHoveredOn = nil
	end

	-- mainButton highlight
	if buttonsEnabled then
		if source == mainButton then
			if eventName == "onClientMouseEnter" then
				mainButton:loadImage("files/main-hovered.png")
			else
				mainButton:loadImage("files/main.png")
			end
		end
	end

	-- buttons' description
	if (eventName == "onClientMouseEnter") and not buttonsMoving and buttonsEnabled then
		local x, y = source:getPosition(false)
		local w, h = source:getSize(false)
		local key = source:getData("key")

		if key then
			if descriptions[key] then
				descriptionArrow:setPosition(x + w/2 - 16, y-36, false)
				descriptionLabel:setPosition(x + w/2 - 200, y-60, false)
				descriptionLabel:setText(descriptions[key])

				descriptionLabelShadow:setPosition(x + w/2 - 200 + 1, y-60 + 1, false)
				descriptionLabelShadow:setText(descriptions[key])				

				descriptionArrow:setVisible(true)
				descriptionLabel:setVisible(true)
				descriptionLabelShadow:setVisible(true)

				descriptionLabel:bringToFront()
			end
		else
			descriptionArrow:setVisible(false)
			descriptionLabel:setVisible(false)
			descriptionLabelShadow:setVisible(false)
		end
	else
		descriptionArrow:setVisible(false)
		descriptionLabel:setVisible(false)
		descriptionLabelShadow:setVisible(false)
	end
end
addEventHandler("onClientMouseEnter", resourceRoot, clientMouseEnterOrLeave)
addEventHandler("onClientMouseLeave", resourceRoot, clientMouseEnterOrLeave)

addEventHandler("onClientClick", root, 
	function(button, state)
		if buttonsEnabled and button == "left" then
			if guiHoveredOn then
				if guiHoveredOn:getData("key") == "empty" then
					mainButton:bringToFront()
				end
				if guiHoveredOn == mainButton then
					if state == "down" then
						mainButton:loadImage("files/main-pressed.png")
					else
						mainButton:loadImage("files/main-hovered.png")
						toggleButtons()
					end
				end
			elseif state == "down" and not lineDrawing then
				showCursor(false)
				hideAddPlayerWindow()
				hideRemovePlayerWindow()
			end
		end
	end
)

addEventHandler("onButtonsToggle", resourceRoot,
	function(state)
		if state == true then
			buttonsEnabled = true
		end
	end
)

function showConfirmationWindow(text)
	clientMouseEnterOrLeave("onClientMouseLeave")
	buttonsEnabled = false
	confirmationLabel:setText(text)
	confirmationWindow:setVisible(true)
end

function hideConfirmationWindow()
	buttonsEnabled = true
	confirmationWindow:setVisible(false)
end


function showAddPlayerWindow()
	local offsetY = -135
	local x, y = screenX/2, screenY/2 + offsetY
	local w, h = 0, 0

	for index, button in ipairs(active) do
		if button:getData("key") == "addPlayer" then
			x, y = button:getPosition(false)
			w, h = button:getSize(false)
			break
		end
	end

	local w0, h0 = addPlayerWindow:getSize(false)

	addPlayerWindow:setPosition(x + w/2 - w0/2, y + offsetY, false)

	addPlayerWindow:setVisible(true)
end

function hideAddPlayerWindow()
	addPlayerWindow:setVisible(false)
end


function showRemovePlayerWindow()
	local offsetY = -135
	local x, y = screenX/2, screenY/2 + offsetY
	local w, h = 0, 0

	for index, button in ipairs(active) do
		if button:getData("key") == "removePlayer" then
			x, y = button:getPosition(false)
			w, h = button:getSize(false)
			break
		end
	end

	local w0, h0 = removePlayerWindow:getSize(false)

	removePlayerWindow:setPosition(x + w/2 - w0/2, y + offsetY, false)

	removePlayerWindow:setVisible(true)
end

function hideRemovePlayerWindow()
	removePlayerWindow:setVisible(false)
end

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if lineDrawing then
			setCursorAlpha(255)
			setCameraTarget(localPlayer)
			toggleAllControls(true, true, false)
		end
	end
)