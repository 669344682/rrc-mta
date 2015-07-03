-- include shared code
loadstring(exports["tws-shared"]:include("utils"))()
loadstring(exports["tws-shared"]:include("mouse_utils"))()

local colors = {}
colors.black = {0, 0, 0}
colors.white = {255, 255, 255}
colors.grey1 = {200, 200, 200}
colors.background = {0, 40, 51}
colors.background2 = {0, 40 * 0.8, 51 * 0.8}
colors.background3 = {10, 40 * 1.5, 51 * 1.5}
colors.buttonOver = {15, 40 * 2, 51 * 2}

colors.textHeading = {255, 255, 255}
colors.arrow = {255, 255, 0}

local function getColor(color, alpha)
	if not alpha then
		alpha = 255
	end
	return tocolor(color[1], color[2], color[3], alpha)
end 


local function dxDrawRoundRectangle(x, y, w, h, color, radius)
    dxDrawImage(x, y, radius, radius, cornerTexture, 0, 0, 0, color)
    dxDrawRectangle(x, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x, y + h - radius, radius, radius, cornerTexture, 270, 0, 0, color)
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color)
    dxDrawImage(x + w - radius, y, radius, radius, cornerTexture, 90, 0, 0, color)
    dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x + w - radius, y + h - radius, radius, radius, cornerTexture, 180, 0, 0, color)
end

Colorpicker = {}

Colorpicker.isActive = false

local mainScale = 1

Colorpicker.x = 0
Colorpicker.y = 0
Colorpicker.width = 400
Colorpicker.height = 360

Colorpicker.caption = "Цвет"

local borderSize = 3 * mainScale
local captionFont = dxCreateFont("fonts/OpenSans-Regular.ttf", 13, false)
local buttonFont = dxCreateFont("fonts/OpenSans-Regular.ttf", 12, false)

-- COLOR
local colorBarHeight = 20 * mainScale
local colorBarBorder = borderSize

local colorGridWidth = Colorpicker.width
local colorGridHeight = Colorpicker.width * 2/3

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

local okButtonWidth = 100
local okButtonHeight = 25

function Colorpicker:start(caption, x, y)
	if self.isActive then
		return
	end
	self.isActive = true
	currentHue = 0

	self.caption = caption

	self.x = x
	self.y = y

	selectionX = 1
	selectionY = 1

	currentState = "value"

	addEventHandler("onClientRender", root, self.draw, false, "low+95")
end

function Colorpicker:stop()
	if not self.isActive then
		return
	end
	removeEventHandler("onClientRender", root, self.draw)
	self.isActive = false
end

function Colorpicker:draw(fade)
	local mx, my = getMousePos()
	local cp = Colorpicker
	dxDrawRectangle(cp.x - borderSize - 1, cp.y - borderSize - 1, cp.width + borderSize * 2 + 2, cp.height + borderSize * 2 + 2, getColor(colors.background))
	dxDrawRectangle(cp.x - borderSize, cp.y - borderSize, cp.width + borderSize * 2, cp.height + borderSize * 2, getColor(colors.background3))

	-- Caption
	local y = cp.y + 25 * mainScale
	dxDrawText(cp.caption, cp.x, cp.y, cp.x + cp.width, y, getColor(colors.white), 1, captionFont, "center", "center")

	y = y + colorBarBorder + 2
	dxDrawRectangle(cp.x, y - colorBarBorder, cp.width, colorBarHeight + colorBarBorder * 2, getColor(colors.background2))
	dxDrawImage(cp.x, y, cp.width, colorBarHeight, "images/h.png")
	if getKeyState("mouse1") and isPointInRect(mx, my, cp.x, y, cp.width, colorBarHeight) then
		currentHue = (mx - cp.x) / cp.width
		currentState = "value"
		Colorpicker:updateValue()
	end
	if currentState == "value" then
		local ox = currentHue * cp.width
		dxDrawRectangle(cp.x + ox - selectionBorder * 2, y, selectionBorder * 4, colorBarHeight, getColor(colors.arrow))
		dxDrawRectangle(cp.x + ox - selectionBorder, y + selectionBorder, selectionBorder * 2, colorBarHeight - selectionBorder * 2, currentHueColor)
	end
	y = y + colorBarHeight + colorBarBorder
	dxDrawRectangle(cp.x, y, colorGridWidth, colorGridHeight)
	dxDrawImage(cp.x, y, colorGridWidth, colorGridHeight, "images/preview.png", 0, 0, 0, currentHueColor)

	if getKeyState("mouse1") and isPointInRect(mx, my, cp.x, y, colorGridWidth, colorGridHeight) then
		selectionX = math.floor((mx - cp.x + selectionRectSize) / colorGridWidth * 15)
		selectionY = math.floor((my - y + selectionRectSize) / colorGridHeight * 10)
		currentState = "grid"
		Colorpicker:updateColor()
	end

	if currentState == "grid" then
		local sx = (selectionX - 1) * selectionRectSize + cp.x
		local sy = (selectionY - 1) * selectionRectSize + y
		dxDrawRectangle(sx - selectionBorder, sy - selectionBorder, selectionRectSize + selectionBorder * 2, selectionRectSize + selectionBorder * 2, getColor(colors.arrow))
		dxDrawRectangle(sx, sy, selectionRectSize, selectionRectSize, currentHSVColor)
	end

	y = y + colorGridHeight + 8

	local buttonColor = getColor(colors.background)
	local bx = cp.x + cp.width / 2 - okButtonWidth / 2
	local by = y
	local bw = okButtonWidth
	local bh = okButtonHeight
	if isPointInRect(mx, my, bx, by, bw, bh) then
		buttonColor = getColor(colors.buttonOver)
		if isMouseClick() then
			Colorpicker:selectColor()
		end
	end
	dxDrawRectangle(bx - 1, by - 1, bw + 2, bh + 2, getColor(colors.background2))
	dxDrawRectangle(bx, by, bw, bh, buttonColor)
	dxDrawText("Сохранить", bx, by, bx + bw, by + bh, getColor(colors.white), 1, buttonFont, "center", "center")
	updateMouseClick()
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

	Colorpicker:updateColor()
end 

local function setValue(newValue)
	if newValue > 1 then
		newValue = 0
	elseif newValue < 0 then
		newValue = 1
	end
	currentHue = newValue
end

function Colorpicker:selectColor()
	local r, g, b = hsv2rgb(1 - currentHue, 1 - selectionX / 15, 1 - selectionY / 10)
	currentHSVColor = tocolor(r, g, b)

	--outputChatBox("Color select: " .. table.concat({r, g, b}, " "))
	Colorpicker:stop()
	triggerEvent("tws-onColorpickerSelect", resourceRoot, r, g, b)
end

function Colorpicker:updateValue()
	currentHueColor = tocolor(hsv2rgb(1 - currentHue, 1, 1))
	self:updateColor()
end

function Colorpicker:updateColor()
	local r, g, b = hsv2rgb(1 - currentHue, 1 - selectionX / 15, 1 - selectionY / 10)
	currentHSVColor = tocolor(r, g, b)
	--outputChatBox("Color update: " .. table.concat({r, g, b}, " "))
	triggerEvent("tws-onColorpickerUpdateColor", resourceRoot, r, g, b)
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