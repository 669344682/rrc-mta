stickerSettings = {}

stickerSettings.x = 0
stickerSettings.y = 0
stickerSettings.width = 200 * mainScale
stickerSettings.height = 190 * mainScale

local borderSize = 3 * mainScale
local sliderHeight = 15 * mainScale
local textOffset = 6 * mainScale
local textFont = dxCreateFont("fonts/calibri.ttf", 10 * mainScale, true)

local stickerScaleSliderDefault = 0.2
local stickerRotationSliderDefault = 0.5

local stickerScaleSlider = stickerScaleSliderDefault
local stickerRotationSlider = stickerRotationSliderDefault

local lastSide = "right"

local function updateScale()
	local newScale = (stickerScaleSlider + 0.1) * 2
	lastScale = stickerScaleSlider

	tuningTexture.setStickerProperty("scale", newScale)
end

local function updateRotation()
	local newRotation = math.floor(stickerRotationSlider * 360 - 180)
	tuningTexture.setStickerProperty("rotation", newRotation)
end

function stickerSettings.start(x, y, screen)
	stickerSettings.x = x
	stickerSettings.y = y

	parentScreen = screen

	updateScale()
	updateRotation()

	tuningCamera.setLookMode(lastSide)
	tuningTexture.moveStickerToSide(lastSide)
end

function stickerSettings.stop()

end

function stickerSettings.draw(fade)
	local mx, my = getMousePos()
	local ss = stickerSettings
	dxDrawRoundRectangle(ss.x - borderSize, ss.y - borderSize, ss.width + borderSize * 2, ss.height + borderSize * 2, getColor(colors.background2, 200), 10)
	dxDrawRoundRectangle(ss.x, ss.y, ss.width, ss.height, getColor(colors.black, 220), 7)

	local y = ss.y
	dxDrawText("Сторона наклейки", ss.x + textOffset, y, ss.x + ss.width, y + 25 * mainScale, getColor(colors.white, 200), 1, textFont, "left", "center")
	y = y + 25 * mainScale
	local buttonOffset = 6 * mainScale
	local buttonWidth = (stickerSettings.width - buttonOffset * 2 + 3) / 3 - 2
	local buttonHeight = 15 * mainScale
	local bx = ss.x + buttonOffset
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Перед", getColor(colors.background2)) then
		if tuningCamera.setLookMode("front") then
			tuningTexture.moveStickerToSide("front")
			lastSide = "front"
		end
	end
	bx = bx + buttonWidth + 1
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Верх", getColor(colors.background2)) then
		if tuningCamera.setLookMode("top") then
			tuningTexture.moveStickerToSide("top")
			lastSide = "top"
		end
	end
	bx = bx + buttonWidth + 1
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Зад", getColor(colors.background2)) then
		if tuningCamera.setLookMode("back") then
			tuningTexture.moveStickerToSide("back")
			lastSide = "back"
		end
	end

	y = y + buttonHeight + 1
	buttonWidth = (stickerSettings.width - buttonOffset * 2) / 2 - 1
	bx = ss.x + buttonOffset
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Лево", getColor(colors.background2)) then
		if tuningCamera.setLookMode("left") then
			tuningTexture.moveStickerToSide("left")
			lastSide = "left"
		end
	end
	bx = bx + buttonWidth + 1
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "Право", getColor(colors.background2)) then
		if tuningCamera.setLookMode("right") then
			tuningTexture.moveStickerToSide("right")
			lastSide = "right"
		end
	end	

	y = y + buttonHeight + 1
	local changed = false
	dxDrawText("Размер", ss.x + textOffset, y, ss.x + ss.width, y + 25 * mainScale, getColor(colors.white, 200), 1, textFont, "left", "center")
	y = y + 25 * mainScale
	stickerScaleSlider, changed = dxDrawSlider(ss.x + textOffset, y, ss.width - textOffset * 2, sliderHeight, stickerScaleSlider, getColor(colors.background2), getColor(colors.background))
	if changed then
		updateScale()
	end
	y = y + sliderHeight

	dxDrawText("Поворот", ss.x + textOffset, y, ss.x + ss.width, y + 25 * mainScale, getColor(colors.white, 200), 1, textFont, "left", "center")
	y = y + 25 * mainScale
	stickerRotationSlider, changed = dxDrawSlider(ss.x + textOffset, y, ss.width - textOffset * 2, sliderHeight, stickerRotationSlider, getColor(colors.background2), getColor(colors.background))
	if changed then
		updateRotation()
	end

	y = y + sliderHeight

	dxDrawText("Отражение", ss.x + textOffset, y, ss.x + ss.width, y + 25 * mainScale, getColor(colors.white, 200), 1, textFont, "left", "center")
	y = y + 25 * mainScale

	bx = ss.x + buttonOffset
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "По горизонтали", getColor(colors.background2)) then
		tuningTexture.setStickerProperty("mirrorX", not tuningTexture.getStickerProperty("mirrorX"))
	end
	bx = bx + buttonWidth + 1
	if dxDrawButton(bx, y, buttonWidth, buttonHeight, "По вертикали", getColor(colors.background2)) then
		tuningTexture.setStickerProperty("mirrorY", not tuningTexture.getStickerProperty("mirrorY"))
	end	
end