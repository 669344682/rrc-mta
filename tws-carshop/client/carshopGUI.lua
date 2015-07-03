require("mouse_utils")
require("utils")
require("dxGUI")

local screenWidth, screenHeight = guiGetScreenSize()

carshopGUI = {}

carshopGUI.caption = "автомагазин"
carshopGUI.textures = {}
carshopGUI.fonts = {}

local tipsTexts = {
	"СТРЕЛКИ - ПРОСМОТР", 
	"ENTER - КУПИТЬ", 
	"BACKSPACE - ВЫХОД"
}

local function onKey(...) carshopGUI:onKey(...) end
local function draw() carshopGUI:draw() end

function carshopGUI:start()
	addEventHandler("onClientRender", root, draw)
	addEventHandler("onClientKey", root, onKey)

	assetsManager:loadTexture("screen_shadow")
	exports["tws-utils"]:toggleHUD(false)

	captionText:start(self.caption)
	buttonsTips:start(tipsTexts)
end

function carshopGUI:stop()
	removeEventHandler("onClientRender", root, draw)
	removeEventHandler("onClientKey", root, onKey)

	exports["tws-utils"]:toggleHUD(true)

	captionText:stop()
	buttonsTips:stop()
end

function carshopGUI:setInfoText(carName, price)
	captionText.text = tostring(carName)
	captionText.price = "Цена: $" .. tostring(price)
	if price > localPlayer:getData("tws-money") then
		captionText.priceColor = tocolor(255, 0, 0)
	else
		captionText.priceColor = tocolor(0, 255, 0)
	end
end

function carshopGUI:draw()
	--dxDrawRectangle(0, 0, screenWidth, screenHeight)
	dxDrawImage(0, 0, screenWidth, screenHeight, assetsManager.textures["screen_shadow"])
	dxDrawImage(0, 0, screenWidth, screenHeight, assetsManager.textures["screen_shadow"], 180)

	captionText:draw()
	buttonsTips:draw()
end

function carshopGUI:onKey(button, press)
	if not press or not carshopMain.isActive or isChatBoxInputActive() then
		return
	end

	if button == "enter" then
		carshopMain:buyVehicle()
	elseif button == "backspace" then
		carshopMain:startExit()
	end
end