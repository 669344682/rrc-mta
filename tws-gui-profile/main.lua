local twsGUI = exports["tws-gui"]

local windowWidth = 420
local windowHeight = 420
local gui = {}

local isWaitingForKey = false
local currentSettings = {}

local function addSplit(text, y)
	twsGUI:createButton(10, y + 4, windowWidth - 20, 1, gui.window, text)	 
end

local function createWindow()
	canvas = twsGUI:createCanvas(resourceRoot)

	gui.window = twsGUI:createWindow(screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2, windowWidth, windowHeight, canvas, "Профиль")
	local x = 10
	local y = 10
	addSplit("Инфо", y)
	y = y + 20
	gui.accountName = twsGUI:createLabel(x, y, 100, 20, gui.window, "Аккаунт: #55AAFF%username%")
	y = y + 30
	gui.level = twsGUI:createLabel(x, y, 100, 20, gui.window, "Уровень: #55AAFF0")
	y = y + 30
	gui.repsects = twsGUI:createLabel(x, y, 100, 20, gui.window, "Респекты: #55AAFF0 из 0")
	y = y + 30
	gui.money = twsGUI:createLabel(x, y, 100, 20, gui.window, "Деньги: #55AAFF$999999999")
	y = y + 30
	gui.cars = twsGUI:createLabel(x, y, 100, 20, gui.window, "Количество машин в гараже: #55AAFF99")
	y = y + 30
	addSplit("Статистика", y)
	y = y + 20
	gui.timeOverall = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.timeCurrent = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.raceWinCount = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.raceLostCount = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.duelWinCount = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.duelLostCount = twsGUI:createLabel(x, y, 100, 20, gui.window)
	y = y + 30
	gui.closeButton = twsGUI:createButton(windowWidth / 2 - 50, y, 100, 30, gui.window, "Закрыть")	

	twsGUI:setVisible(gui.window, false)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		createWindow()
	end
)

local function calculateTimeStringFromSeconds(seconds, showDays)
	local minutes = math.floor(seconds / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	if not days then
		days = 0
	end
	minutes = minutes - hours * 60
	hours = hours - days * 24

	local str = hours .. " ч. " .. minutes .. " мин."
	if showDays then
		str = days .. " дн. " .. str
	end
	return str
end

function setProfileWindowVisible(isVisible)
	twsGUI:setVisible(gui.window, isVisible)
	if isVisible then
		twsGUI:setText(gui.accountName, "Аккаунт: #55AAFF" .. getElementData(localPlayer, "tws-accountName"))
		twsGUI:setText(gui.level, "Уровень: #55AAFF" .. getElementData(localPlayer, "tws-level"))
		twsGUI:setText(gui.repsects, "Респекты: #55AAFF" .. getElementData(localPlayer, "tws-respects"))
		twsGUI:setText(gui.money, "Деньги: #55AAFF$" .. getElementData(localPlayer, "tws-money"))
		twsGUI:setText(gui.cars, "Количество машин в гараже: #55AAFF-")

		local loginTime = tonumber(getElementData(localPlayer, "tws-loginTime"))
		if not loginTime then
			loginTime = getRealTime().timestamp 
		end
		local currentSeconds = getRealTime().timestamp - loginTime
		local playtime = tonumber(getElementData(localPlayer, "tws-playtime"))
		if not playtime then
			playtime = 0
		end
		local overallSeconds = currentSeconds + playtime

		twsGUI:setText(gui.timeOverall, "Общее время на сервере:  #55AAFF" .. calculateTimeStringFromSeconds(overallSeconds, true))
		twsGUI:setText(gui.timeCurrent, "Время со входа на сервер: #55AAFF" .. calculateTimeStringFromSeconds(currentSeconds, false))
		twsGUI:setText(gui.raceWinCount, "Количество побед в гонках: #55AAFF0")
		twsGUI:setText(gui.raceLostCount, "Количество поражений в гонках: #55AAFF0")
		twsGUI:setText(gui.duelWinCount, "Количество побед в вызовах: #55AAFF0")
		twsGUI:setText(gui.duelLostCount, "Количество поражений в вызовах: #55AAFF0")
	end
end

addEvent("onLuckyGUIClick")
addEventHandler("onLuckyGUIClick", root,
	function(element)
		if element == gui.closeButton then
			exports["tws-gui-panel"]:setCursorVisible(false)
			setProfileWindowVisible(false)
		end
	end
)