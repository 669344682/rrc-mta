colorPalette = {}

--mainScale = 2

colorPalette.x = 0
colorPalette.y = 0
colorPalette.width = 200 * mainScale
colorPalette.height = 190 * mainScale + 5 * mainScale

colorPalette.caption = "Цвет кузова"

local borderSize = 3 * mainScale
local captionFont = dxCreateFont("fonts/calibri.ttf", 15 * mainScale, true)

-- COLOR
local colorBarHeight = 20 * mainScale
local colorBarBorder = borderSize

local colorGridWidth = colorPalette.width
local colorGridHeight = colorPalette.width * 2/3

local selectionRectSize = colorGridWidth / 15
local selectionX = 3
local selectionBorder = 3
local selectionY = 6
local rectsX = 15
local rectsY = 10

local currentHue = 0
local currentHueColor = tocolor(255, 0, 0)
local currentHSVColor = tocolor(255, 0, 0)
local valueChangingSpeed = 0.02

local currentState = "grid"

local autorepeatTimer = nil

local parentScreen = nil

local function removeAutorepeatTimer()
	if isTimer(autorepeatTimer) then
		killTimer(autorepeatTimer) 
	end
end

local function callAutorepeat(key, keyState, func, isAuto, isFirst)
	if keyState == "down" then
		colorPalette[func]()
		if not isAuto then
			removeAutorepeatTimer()
			autorepeatTimer = setTimer(callAutorepeat, 500, 1, key, "down", func, true, true)
		else
			if isFirst then
				removeAutorepeatTimer()
			end
			if not isTimer(autorepeatTimer) then 
				autorepeatTimer = setTimer(callAutorepeat, 50, 0, key, "down", func, true)
			end
		end
	else
		removeAutorepeatTimer() 
	end
end

function colorPalette.start(caption, x, y, screen, disableKeys, noColorReset)
	currentHue = 0

	colorPalette.caption = caption

	colorPalette.x = x
	colorPalette.y = y

	parentScreen = screen

	selectionX = 1
	selectionY = 1

	if not noColorReset then
		colorPalette.updateValue()
	end

	currentState = "value"

	unbindKey("arrow_l", "both", callAutorepeat, colorPalette.moveLeft)
	unbindKey("arrow_r", "both", callAutorepeat, colorPalette.moveRight)
	unbindKey("arrow_u", "both", callAutorepeat, colorPalette.moveUp)
	unbindKey("arrow_d", "both", callAutorepeat, colorPalette.moveDown)
	unbindKey("enter", "down", colorPalette.selectColor)

	if not disableKeys then
		bindKey("arrow_l", "both", callAutorepeat, "moveLeft")
		bindKey("arrow_r", "both", callAutorepeat, "moveRight")
		bindKey("arrow_u", "both", callAutorepeat, "moveUp")
		bindKey("arrow_d", "both", callAutorepeat, "moveDown")
	end
	bindKey("enter", "down", colorPalette.selectColor)
end

function colorPalette.stop()
	parentScreen = nil
	unbindKey("arrow_l", "both", callAutorepeat, colorPalette.moveLeft)
	unbindKey("arrow_r", "both", callAutorepeat, colorPalette.moveRight)
	unbindKey("arrow_u", "both", callAutorepeat, colorPalette.moveUp)
	unbindKey("arrow_d", "both", callAutorepeat, colorPalette.moveDown)
	unbindKey("enter", "down", colorPalette.selectColor)
end

function colorPalette.draw(fade)
	local mx, my = getMousePos()
	local cp = colorPalette
	dxDrawRoundRectangle(cp.x - borderSize, cp.y - borderSize, cp.width + borderSize * 2, cp.height + borderSize * 2, getColor(colors.background2, 200), 10)
	dxDrawRoundRectangle(cp.x, cp.y, cp.width, cp.height, getColor(colors.black, 220), 7)

	-- Caption
	local y = cp.y + 30 * mainScale
	dxDrawText(cp.caption, cp.x, cp.y, cp.x + cp.width, y, getColor(colors.white, 200), 1, captionFont, "center", "center")

	y = y + colorBarBorder
	dxDrawRectangle(cp.x, y - colorBarBorder, cp.width, colorBarHeight + colorBarBorder * 2, getColor(colors.background2))
	dxDrawImage(cp.x, y, cp.width, colorBarHeight, "images/h.png")
	if getKeyState("mouse1") and utils.isPointInRect(mx, my, cp.x, y, cp.width, colorBarHeight) then
		currentHue = (mx - cp.x) / cp.width
		currentState = "value"
		colorPalette.updateValue()
	end
	if currentState == "value" then
		local ox = currentHue * cp.width
		dxDrawRectangle(cp.x + ox - selectionBorder * 2, y, selectionBorder * 4, colorBarHeight, getColor(colors.arrow))
		dxDrawRectangle(cp.x + ox - selectionBorder, y + selectionBorder, selectionBorder * 2, colorBarHeight - selectionBorder * 2, currentHueColor)
	end
	y = y + colorBarHeight + colorBarBorder
	dxDrawRectangle(cp.x, y, colorGridWidth, colorGridHeight)
	dxDrawImage(cp.x, y, colorGridWidth, colorGridHeight, "images/preview.png", 0, 0, 0, currentHueColor)

	if getKeyState("mouse1") and utils.isPointInRect(mx, my, cp.x, y, colorGridWidth, colorGridHeight) then
		selectionX = math.floor((mx - cp.x + selectionRectSize) / colorGridWidth * 15)
		selectionY = math.floor((my - y + selectionRectSize) / colorGridHeight * 10)
		currentState = "grid"
		colorPalette.updateColor()
	end

	if currentState == "grid" then
		local sx = (selectionX - 1) * selectionRectSize + cp.x
		local sy = (selectionY - 1) * selectionRectSize + y
		dxDrawRectangle(sx - selectionBorder, sy - selectionBorder, selectionRectSize + selectionBorder * 2, selectionRectSize + selectionBorder * 2, getColor(colors.arrow))
		dxDrawRectangle(sx, sy, selectionRectSize, selectionRectSize, currentHSVColor)
	end
end

local function gridSetSelected(x, y)
	if x < 1 then
		x = rectsX 
	elseif x > rectsX then
		x = 1
	end
	if y < 1 then
		currentState = "value"
		y = 1
	elseif y > rectsY then
		currentState = "value"
		y = rectsY
	end
	selectionX = x
	selectionY = y

	colorPalette.updateColor()
end 

local function setValue(newValue)
	if newValue > 1 then
		newValue = 0
	elseif newValue < 0 then
		newValue = 1
	end
	currentHue = newValue
end

function colorPalette.moveLeft()
	if currentState == "grid" then
		gridSetSelected(selectionX - 1, selectionY)
	elseif currentState == "value" then
		setValue(currentHue - valueChangingSpeed)
		colorPalette.updateValue()
	end
end

function colorPalette.moveRight()
	if currentState == "grid" then
		gridSetSelected(selectionX + 1, selectionY)
	elseif currentState == "value" then
		setValue(currentHue + valueChangingSpeed)
		colorPalette.updateValue()
	end
end

function colorPalette.moveUp()
	if currentState == "grid" then
		gridSetSelected(selectionX, selectionY - 1)
	elseif currentState == "value" then
		currentState = "grid"
		gridSetSelected(selectionX, rectsY)
	end
end

function colorPalette.moveDown()
	if currentState == "grid" then
		gridSetSelected(selectionX, selectionY + 1)
	elseif currentState == "value" then
		currentState = "grid"
		gridSetSelected(selectionX, 1)
	end
end

function colorPalette.selectColor()
	local r, g, b = hsv2rgb(1 - currentHue, 1 - selectionX / 15, 1 - selectionY / 10)
	currentHSVColor = tocolor(r, g, b)

	if parentScreen then
		parentScreen.selectColor(r, g, b)
	end
end

function colorPalette.updateValue()
	currentHueColor = tocolor(hsv2rgb(1 - currentHue, 1, 1))
	colorPalette.updateColor()
end

function colorPalette.updateColor()
	local r, g, b = hsv2rgb(1 - currentHue, 1 - selectionX / 15, 1 - selectionY / 10)
	currentHSVColor = tocolor(r, g, b)
	if parentScreen then
		parentScreen.updateColor(r, g, b)
	end
end

function hsv2rgb(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	local switch = i % 6
	if switch == 0 then
		r = v g = t b = p
	elseif switch == 1 then
		r = q g = v b = p
	elseif switch == 2 then
		r = p g = v b = t
	elseif switch == 3 then
		r = p g = q b = v
	elseif switch == 4 then
		r = t g = p b = v
	elseif switch == 5 then
		r = v g = p b = q
	end
	return math.floor(r*255), math.floor(g*255), math.floor(b*255)
end