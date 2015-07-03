radioGUI = {}
radioGUI.searchInfo = {}

local twsGUI = exports["tws-gui"]
local screenWidth, screenHeight = guiGetScreenSize()

local playText = "Играть"
local pauseText = "Пауза"

local progressBarWidth = 400
local progressBarHeight = 12

function createProgressBar(x, y, parent)
	local window = twsGUI:createButton(x, y, progressBarWidth, progressBarHeight, parent)
	local bar = twsGUI:createButton(x + 2, y + 2, progressBarWidth - 4, progressBarHeight - 4, parent)
	twsGUI:setEnabled(bar, false)
	return bar
end

function setProgress(progressBar, progress)
	local w = progressBarWidth * progress
	local _, h = twsGUI:getSize(progressBar)
	twsGUI:setSize(progressBar, w, h)
end

local function createPlayerGUI()
	local windowWidth = 490
	local windowHeight = 95

	local w = {}
	w.window = twsGUI:createWindow(screenWidth / 2 - windowWidth / 2, windowHeight, windowWidth, windowHeight, radioGUI.canvas, "Радио")
	w.playButton = twsGUI:createButton(10, 10, 60, 35, w.window, pauseText)
	w.name = twsGUI:createLabel(85, 10, progressBarWidth, 20, w.window, "")
	w.progressBar = createProgressBar(80, 32, w.window)
	w.searchButton = twsGUI:createButton(10, 55, 140, 30, w.window, "Поиск музыки")
	w.stopButton = twsGUI:createButton(160, 55, 160, 30, w.window, "Выключить радио")
	w.closeButton = twsGUI:createButton(330, 55, 150, 30, w.window, "Закрыть")

	twsGUI:setVisible(w.window, false)
	radioGUI.player = w
end

local function createSearchGUI()
	local windowWidth = 400
	local windowHeight = 345

	local w = {}
	w.window = twsGUI:createWindow(screenWidth / 2 - windowWidth / 2, 220, windowWidth, windowHeight, radioGUI.canvas, "Поиск музыки")
	w.searchEdit = twsGUI:createEdit(10, 10, windowWidth - 10 - 100, 30, w.window, "")
	w.searchButton = twsGUI:createButton(windowWidth - 10 - 100, 10, 100, 30, w.window, "Поиск")

	w.searchResults = {}
	for i = 1, 12 do
		w.searchResults[i] = twsGUI:createButton(10, 25 + i * 24, windowWidth - 20, 25, w.window, "")
	end

	twsGUI:setVisible(w.window, false)
	radioGUI.search = w
end

function radioGUI:init()
	self.canvas = twsGUI:createCanvas(resourceRoot)
	createPlayerGUI()
	createSearchGUI()
end

function radioGUI:showPlayer(id)
	twsGUI:setVisible(radioGUI.player.window, true)
	if id then
		musicPlayer:requireInfo(id)
		setProgress(radioGUI.player.progressBar, 0)
	end
end

function radioGUI:showSearch()
	twsGUI:setVisible(radioGUI.search.window, not twsGUI:isVisible(radioGUI.search.window))
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		radioGUI:init()
	end
)

addEvent("onLuckyGUIClick", true)
addEventHandler("onLuckyGUIClick", root, 
	function(e)
		if e == radioGUI.search.searchButton then
			musicPlayer:search(twsGUI:getText(radioGUI.search.searchEdit))
		end
		-- Нажата одна из кнопок с результатами поиска
		for i, v in ipairs(radioGUI.search.searchResults) do
			if e == v then
				if radioGUI.searchInfo[i] then
					radioGUI:showPlayer(radioGUI.searchInfo[i])
					twsGUI:setText(radioGUI.player.name, twsGUI:getText(v))
					twsGUI:setVisible(radioGUI.search.window, false)
					return
				end
			end
		end

		if e == radioGUI.player.searchButton then
			radioGUI:showSearch()
		end

		if e == radioGUI.player.closeButton then
			twsGUI:setVisible(radioGUI.search.window, false)
			twsGUI:setVisible(radioGUI.player.window, false)
			showCursor(false)
		end

		if e == radioGUI.player.stopButton then
			twsGUI:setVisible(radioGUI.search.window, false)
			twsGUI:setVisible(radioGUI.player.window, false)
			twsGUI:setText(radioGUI.search.searchResults[i], "")
			setProgress(radioGUI.player.progressBar, 0)
			showCursor(false)
		end
	end
)

addEvent("tws-radioSearchResults", true)
addEventHandler("tws-radioSearchResults", resourceRoot, 
	function(tracks) 
		radioGUI.searchInfo = {}
		for i, track in ipairs(tracks) do
			if radioGUI.search.searchResults[i] then
				local str = track.artist .. " - " .. track.name
				if str:len() > 40 then
					str = str:sub(1, 40 - str:len())
				end
				twsGUI:setText(radioGUI.search.searchResults[i], str)
				radioGUI.searchInfo[i] = track.id
			else
				break
			end
		end
	end
)

addEvent("tws-radioMusicInfo", true)
addEventHandler("tws-radioMusicInfo", resourceRoot, 
	function(info)
		radio:playSound(info.url) 
	end
)

function showRadio()
	if not localPlayer.vehicle then
		return
	end
	if twsGUI:isVisible(radioGUI.player.window) then
		twsGUI:setVisible(radioGUI.search.window, false)
		twsGUI:setVisible(radioGUI.player.window, false)	
		showCursor(false)
		return
	end
	twsGUI:setVisible(radioGUI.search.window, false)
	twsGUI:setVisible(radioGUI.player.window, true)
	showCursor(true)
end

bindKey("r", "down",
	function()
		showRadio()
	end
)

setTimer(function()
	if not isElement(radio.localSound) then
		return
	end
	local position = getSoundPosition(radio.localSound)
	local length = getSoundLength(radio.localSound)
	setProgress(radioGUI.player.progressBar, position / length)
	localPlayer:setData("tws-radioSoundPosition", position, true)
end, 1000, 0)

addEventHandler("onClientVehicleExit", getRootElement(),
    function(player, seat)
		if player == localPlayer and twsGUI:isVisible(radioGUI.player.window) then
			twsGUI:setVisible(radioGUI.search.window, false)
			twsGUI:setVisible(radioGUI.player.window, false)	
			showCursor(false)
			return
		end
    end
)