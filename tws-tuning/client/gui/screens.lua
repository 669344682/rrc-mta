screens = {}
local defaultScreen = "sectionsScreen"
local currentScreen = ""
local screensTable = {}

local fade = 1
local fadeTarget = 0
local fadingScreen = ""
local fadingArgs = {}

function screens.start()
	exports["tws-utils"]:toggleHUD(false)
	screens.changeScreen(defaultScreen)
	addEventHandler("onClientRender", root, screens.draw)
	fadeTarget = 0
end

function screens.stop()
	removeEventHandler("onClientRender", root, screens.draw)
	screens.changeScreen() 
	exports["tws-utils"]:toggleHUD(true)
end

function screens.changeScreen(name, ...)
	if screensTable[currentScreen] then
		screensTable[currentScreen].stop()
	end
	if screensTable[name] then
		screensTable[name].start(...)
	elseif name then
		outputDebugString("No screen: " .. tostring(name))
	end
	currentScreen = name
end

function screens.fadeToScreen(name, ...)
	fadeTarget = 1
	fadingArgs = {...}
	fadingScreen = name
end

function screens.add(screen, name)
	screensTable[name] = screen
end

function screens.draw()
	fade = fade + math.floor(((fadeTarget - fade) * 0.15)*100)/100
	if fade > 0.9 and fadeTarget == 1 and fadingScreen ~= "" then
		screens.changeScreen(fadingScreen, unpack(fadingArgs))
		fadingScreen = ""
		fadeTarget = 0
	end
	if screensTable[currentScreen] then
		screensTable[currentScreen].draw(fade)
	end
	moneyText.draw()
	updateMouseClick()
end