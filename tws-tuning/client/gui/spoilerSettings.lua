spoilerSettings = {}

spoilerSettings.x = 0
spoilerSettings.y = 0
spoilerSettings.width = 200 * mainScale
spoilerSettings.height = 80 * mainScale

local borderSize = 3 * mainScale
local sliderHeight = 15 * mainScale
local textOffset = 6 * mainScale
local textFont = dxCreateFont("fonts/calibri.ttf", 10 * mainScale, true)

function spoilerSettings.start(x, y, screen)
	spoilerSettings.x = x
	spoilerSettings.y = y

	parentScreen = screen
end

function spoilerSettings.stop()

end

function spoilerSettings.draw(fade)
	local mx, my = getMousePos()
	local ss = spoilerSettings
	dxDrawRoundRectangle(ss.x - borderSize, ss.y - borderSize, ss.width + borderSize * 2, ss.height + borderSize * 2, getColor(colors.background2, 200), 10)
	dxDrawRoundRectangle(ss.x, ss.y, ss.width, ss.height, getColor(colors.black, 220), 7)

	local y = ss.y
	dxDrawText("Тип спойлера", ss.x + textOffset, y, ss.x + ss.width, y + 25 * mainScale, getColor(colors.white, 200), 1, textFont, "left", "center")
	y = y + 25 * mainScale

	local buttonOffset = 6 * mainScale
	local buttonWidth = stickerSettings.width - buttonOffset * 2
	local buttonHeight = 20 * mainScale
	bx = ss.x + buttonOffset
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Обычный", getColor(colors.background2)) then
		exports["tws-spoilers"]:setVehicleSpoilerType(tuningVehicle.vehicle, "normal")
		spoilerScreen.selectedType = "normal"
		spoilerScreen.resetSpoilerColor()
	end
	y = y + buttonHeight + 1
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Карбоновый", getColor(colors.background2)) then
		exports["tws-spoilers"]:setVehicleSpoilerType(tuningVehicle.vehicle, "carbon")
		spoilerScreen.selectedType = "carbon"
	end	
end