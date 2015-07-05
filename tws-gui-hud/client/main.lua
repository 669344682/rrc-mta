local MAX_PLAYER_HEALTH = 100
local MAX_VEHICLE_HEALTH = 1000

local isHUDVisible = true
local isButtonPanelVisible = false

local screenWidth, screenHeight = guiGetScreenSize()
local drawRect = dxDrawRectangle

local hpBarBlock = {}
hpBarBlock.offsetX = -10
hpBarBlock.offsetY = 10

hpBarBlock.width = 120
hpBarBlock.height = 16

hpBarBlock.x = hpBarBlock.offsetX + screenWidth - hpBarBlock.width
hpBarBlock.y = hpBarBlock.offsetY

hpBarBlock.borderWidth = 2
hpBarBlock.innerColor = tocolor(100, 0, 0)
hpBarBlock.hpColor = tocolor(200, 0, 0)

local hpCarBlock = {}
hpCarBlock.distance = hpBarBlock.height * 2
hpCarBlock.innerColor = tocolor(0, 40, 51)
hpCarBlock.hpColor = tocolor(0, 107, 153)

local cashBlock = {}
cashBlock.distance = hpBarBlock.height * 2
cashBlock.textColor = tocolor(0, 110, 0)

local garageButton = {}
garageButton.distance = hpBarBlock.height * 2
garageButton.height = 25
garageButton.borderWidth = 1
garageButton.colorNormal = tocolor(0, 40, 51)
garageButton.colorHover = tocolor(10, 60, 71)

local function isResourceRunning(resourceName)
	return getResourceFromName(resourceName) and getResourceFromName(resourceName).state == "running"
end

local function draw()
	if not isHUDVisible or not localPlayer:getData("tws-accountName") then
		return
	end
	local b

	b = hpBarBlock
	drawRect(b.x - b.borderWidth, b.y - b.borderWidth, b.width + b.borderWidth * 2, b.height + b.borderWidth * 2, tocolor(0, 0, 0))
	drawRect(b.x, b.y, b.width, b.height, b.innerColor)
	local width = localPlayer.health / MAX_PLAYER_HEALTH
	drawRect(b.x, b.y, b.width * width, b.height, b.hpColor)
	dxDrawImage(b.x - b.height - 6, b.y, b.height, b.height, "images/hp.png", 0, 0, 0, b.hpColor)

	local by = 0
	if isElement(localPlayer.vehicle) then
		by = b.y + hpCarBlock.distance
		drawRect(b.x - b.borderWidth, by - b.borderWidth, b.width + b.borderWidth * 2, b.height + b.borderWidth * 2, tocolor(0, 0, 0))
		drawRect(b.x, by, b.width, b.height, hpCarBlock.innerColor)
		local width = localPlayer.vehicle.health / MAX_VEHICLE_HEALTH
		drawRect(b.x, by, b.width * width, b.height, hpCarBlock.hpColor)
		dxDrawImage(b.x - b.height - 6, by, b.height, b.height, "images/car.png", 0, 0, 0, hpCarBlock.hpColor)
	end
	by = by + cashBlock.distance
	local money = localPlayer:getData("tws-money")
	if not money then
		return
	end
	local neededLen = 13
	local str = tostring(money)
	local len = string.len(str)
	if len < neededLen then
		str = "#00AA00" .. str
		for i = 1, neededLen - len do
			str = "0" .. str
		end
	end
	drawRect(b.x - b.borderWidth, by - b.borderWidth, b.width + b.borderWidth * 2, b.height + b.borderWidth * 2, tocolor(0, 0, 0, 80))
	dxDrawText(str, b.x, by, b.x + b.width, by + b.height, cashBlock.textColor, 1.2, "sans", "left", "center", false, false, false, true)
	dxDrawImage(b.x - b.height - 6, by, b.height, b.height, "images/cash.png")

	if not isButtonPanelVisible then
		return
	end
	drawRect(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 100))
	by = by + garageButton.distance
	local c = garageButton.colorNormal
	local a = 200
	local mx, my = getCursorPosition()
	if mx then
		mx, my = mx * screenWidth, my * screenHeight
	else
		mx, my = 0, 0
	end
	if mx > b.x and my > by and mx < b.x + b.width and my < by + garageButton.height then
		c = garageButton.colorHover
		a = 255

		if getKeyState("mouse1") then
			if isResourceRunning("tws-garage") then
				exports["tws-garage"]:clientEnterGarage()
			end
			isButtonPanelVisible = false
			showCursor(false)
		end
	end
	drawRect(b.x - garageButton.borderWidth, by - garageButton.borderWidth, b.width + garageButton.borderWidth * 2, garageButton.height + garageButton.borderWidth * 2, tocolor(0, 0, 0))
	drawRect(b.x, by, b.width, garageButton.height, c)
	dxDrawText("Мой гараж", b.x, by, b.x + b.width, by + garageButton.height, tocolor(255, 255, 255, a), 1, "default-bold", "center", "center", false, false, false, true)
end
addEventHandler("onClientRender", root, draw)

function setVisible(isVisible)
	isHUDVisible = isVisible == true
	if not isHUDVisible then
		isButtonPanelVisible = false
		showCursor(false)
	end
end

bindKey("F1", "down",
	function()
		if not isHUDVisible then
			isButtonPanelVisible = false
		else
			isButtonPanelVisible = not isButtonPanelVisible
		end
		showCursor(isButtonPanelVisible)
	end
)