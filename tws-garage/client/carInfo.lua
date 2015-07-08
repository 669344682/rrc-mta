carInfo = {}

local carbonFont = dxCreateFont("fonts/calibri.ttf", 16 * mainScale, true)

carInfo.width = 300 * mainScale
carInfo.height = 70 * mainScale
carInfo.x = (screenWidth - carInfo.width) / 2
carInfo.y = (screenHeight - 110 * mainScale)

local repairButton = {}
repairButton.offsetX = 90 * mainScale
repairButton.offsetY = 10 * mainScale
repairButton.height = 25 * mainScale

local gradient = dxCreateTexture("images/gradient.png", "argb", true, "clamp")
local gradientWidth = 100 * mainScale

function carInfo.draw()
	local ci = carInfo
	local x = carInfo.x 
	local y = carInfo.y
	dxDrawImage(x - gradientWidth, y, gradientWidth, ci.height, gradient, 0, 0, 0, getColor(colors.black, 150))
	dxDrawRectangle(x, y, ci.width, ci.height, getColor(colors.black, 150))
	dxDrawImage(x + ci.width + gradientWidth, y, -gradientWidth, ci.height, gradient, 0, 0, 0, getColor(colors.black, 150))

	listArrow.draw(x - 100 / 2, y + ci.height / 2 - listArrow.size / 2, 180, "arrow_l")
	listArrow.draw(x + ci.width + 100 / 2 - listArrow.size, y + ci.height / 2 - listArrow.size / 2, 0, "arrow_r")

	local str = tostring(garageVehicles.vehicleName)
	dxDrawText(str, x, y, x + ci.width, y + ci.height / 2, getColor(colors.white), 1, carbonFont, "center", "center", false, false, false, true)

	local btn = repairButton
	local bgColor = tocolor(0, 40, 51)
	local x,y,w,h = x + btn.offsetX, y + ci.height - btn.height - btn.offsetY, ci.width - btn.offsetX * 2, btn.height
	local mx, my = getCursorPosition()
	local a = 200
	local myMoney = localPlayer:getData("tws-money")
	if not myMoney then
		myMoney = -1
	end
	if garageVehicles.isBroken and myMoney >= garageVehicles.fixPrice then
		if mx then
			mx, my = mx * screenWidth, my * screenHeight
		else
			mx, my = 0, 0
		end
		if mx > x and my > y and mx < x + w and my < y + h then
			bgColor = tocolor(10, 60, 71)
			a = 255
			if getKeyState("mouse1") then
				garageVehicles.fixVehicle()
			end
		end
	else
		bgColor = tocolor(40, 40, 40)
		a = 100
	end
	dxDrawRectangle(x-1,y-1,w+2,h+2, tocolor(0, 0, 0))
	dxDrawRectangle(x,y,w,h, bgColor)
	local str = "Починить ($" .. tostring(garageVehicles.fixPrice) ..")"
	if garageVehicles.fixPrice <= 0 then
		str = "Починить"
	end
	dxDrawText(str, x,y,x+w,y+h, getColor(colors.white, a), 1 * mainScale, "arial", "center", "center", false, false, false, true)
end