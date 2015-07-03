local twsGUI = exports["tws-gui"]

local windowWidth = 400
local windowHeight = 350
local gui = {}

local isWaitingForKey = false
local currentSettings = {}

local function createWindow()
	canvas = twsGUI:createCanvas(resourceRoot)

	gui.window = twsGUI:createWindow(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2, windowWidth, windowHeight, canvas, "Настройки")
	local x = 10
	local y = 10
	twsGUI:createLabel(x, y, 100, 20, gui.window, "Показывать панель только по наведению")
	y = y + 20 + 10
	twsGUI:createLabel(x, y + 5, 50, 20, gui.window, "Выкл")
	twsGUI:createLabel(x + 45 + 55, y + 5, 50, 20, gui.window, "Вкл")
	gui.panelVisiblityToggle = twsGUI:createToggle(55, 40, 50, 30, gui.window)
	twsGUI:setEnabled(gui.panelVisiblityToggle, false)
	y = y + 30 + 20
	twsGUI:createLabel(x, y, 100, 20, gui.window, "Кнопка для включения/выключения курсора")
	y = y + 20 + 10
	gui.button1 = twsGUI:createButton(x + 15, y, 90, 30, gui.window, "F1")
	twsGUI:setEnabled(gui.button1, false)

	y = y + 30 + 10
	twsGUI:createLabel(x, y, 100, 20, gui.window, "Кнопка для открытия карты")
	y = y + 20 + 10
	gui.button2 = twsGUI:createButton(x + 15, y, 90, 30, gui.window, "M")
	twsGUI:setEnabled(gui.button2, false)

	y = y + 30 + 10
	twsGUI:createLabel(x, y, 100, 20, gui.window, "Сумма ставки для вызова")
	y = y + 20 + 10
	gui.betAmountEdit = twsGUI:createEdit(x + 15, y, 90, 30, gui.window, "500")
	twsGUI:setEnabled(gui.betAmountEdit, true)

	y = y + 30 + 10
	gui.acceptButton = twsGUI:createButton(windowWidth / 2 - 210 / 2, y, 100, 40, gui.window, "Сохранить")
	gui.cancelButton = twsGUI:createButton(windowWidth / 2 - 210 / 2 + 110, y, 100, 40, gui.window, "Отменить")

	twsGUI:setVisible(gui.window, false)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		createWindow()
	end
)

function saveSettings()
	local f = nil
	if not fileExists("@settings") then
		f = fileCreate("@settings")
	else
		f = fileOpen("@settings")
	end

	local settingsTable = {}
	settingsTable.panelVisiblity = twsGUI:getToggleState(gui.panelVisiblityToggle)
	settingsTable.hotkeys = {
		cursor = twsGUI:getText(gui.button1),
		map = twsGUI:getText(gui.button2)
	}
	settingsTable.betAmount = tonumber(twsGUI:getText(gui.betAmountEdit))
	if not settingsTable.betAmount then
		settingsTable.betAmount = 0
	end
	if settingsTable.betAmount < 0 then
		settingsTable.betAmount = -settingsTable.betAmount
	end
	if settingsTable.betAmount > 999999 then
		settingsTable.betAmount = 999999 
	end
	currentSettings = settingsTable
	local settingsString = toJSON(settingsTable)
	fileWrite(f, settingsString)
	fileClose(f)

	triggerEvent("tws-clientSettingsChanged", root, currentSettings)
end

function loadSettings()
	if not fileExists("@settings") then
		saveSettings()
		return
	end
	local f = fileOpen("@settings")
	local settingsString = fileRead(f, fileGetSize(f))
	fileClose(f)
	local settingsTable = fromJSON(settingsString)
	if not settingsTable then
		saveSettings()
		return
	end
	twsGUI:setToggleState(gui.panelVisiblityToggle, settingsTable.panelVisiblity)
	if settingsTable.hotkeys.cursor then
		twsGUI:setText(gui.button1, settingsTable.hotkeys.cursor)
	end
	if settingsTable.hotkeys.map then
		twsGUI:setText(gui.button2, settingsTable.hotkeys.map)
	end
	twsGUI:setText(gui.betAmountEdit, settingsTable.betAmount)

	currentSettings = settingsTable
end

function setSettingsWindowVisible(isVisible)
	loadSettings() 
	twsGUI:setVisible(gui.window, isVisible)
	if isVisible then
		loadSettings()
	end
end

addEvent("onLuckyGUIClick")
addEventHandler("onLuckyGUIClick", root,
	function(element)
		if element == gui.acceptButton then
			saveSettings()
			exports["tws-gui-panel"]:setCursorVisible(false)
			setSettingsWindowVisible(false)
		elseif element == gui.cancelButton then
			exports["tws-gui-panel"]:setCursorVisible(false)
			setSettingsWindowVisible(false)
		elseif element == gui.button1 then
			isWaitingForKey = gui.button1
		elseif element == gui.button2 then
			isWaitingForKey = gui.button2
		end
	end
)

addEventHandler("onClientKey", root,
	function(keyName, state)
		if isMTAWindowActive() then
			return
		end
		if isWaitingForKey and state then
			twsGUI:setText(isWaitingForKey, string.upper(keyName))
			isWaitingForKey = nil
		end
	end
)


function getSettingsTable()
	return currentSettings
end

loadSettings()