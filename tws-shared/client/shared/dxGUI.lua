-- dxGUI
-- Функции рисования интерфейса
-- 
-- dxDrawSlider
-- dxDrawButton
-- dxDrawShadowText

function dxDrawSlider(x, y, w, h, value, color1, color2)
	local changed = false
	local mx, my = getMousePos()

	if not color1 then
		color1 = tocolor(0, 0, 0, 150)
	end
	dxDrawRectangle(x, y, w, h, color1, false)
	local sw = w / 16
	local sh = h - 4
	local sx = x + (w-sw) * value
	local sy = y + 2
	if not color2 then
		color2 = tocolor(255, 255, 255, 150)
	end
	local color = color2
	if utils.isPointInRect(mouseClickX, mouseClickY, x, y, w, h) then
		sy = y + 1
		sh = h - 2
		sx = sx - 1
		sw = sw + 2
		if getKeyState("mouse1") then
			value = math.min(math.max(0, math.floor((mx - x - sw / 2) / (w - sw) * 100) / 100), 1)
			changed = true
			color = tocolor(255, 255, 255)
		end
	end
	dxDrawRectangle(math.min(math.max(x + 2, sx), x + w - sw - 2), sy, sw, sh, color, false)
	return value, changed
end

function dxDrawButton(x, y, w, h, text, color, round)
	local pressed = false
	local mx, my = getMousePos()

	local bgcolor = tocolor(0, 0, 0, 150)
	if color then
		bgcolor = color
	end
	local tcolor = tocolor(255, 255, 255, 200)
	if utils.isPointInRect(mx, my, x, y, w, h) then
		bgcolor = tocolor(255, 255, 255)
		tcolor = tocolor(0, 0, 0)
		if isMouseClick() then
			pressed = true
		end
	end
	dxDrawRectangle(x, y, w, h, bgcolor, false)
	dxDrawText(text, x, y, x + w, y + h, tcolor, 1, "default-bold", "center", "center", true, false, false, true)
	return pressed
end

-- Текст с тенью
-- (!) не поддерживает цветовые коды
local shadowX = 1
local shadowY = 1
local shadowColor = tocolor(0, 0, 0, 150)

function dxDrawShadowText(...)
	local a = {...}
	dxDrawText(a[1], a[2] + shadowX, a[3] + shadowY, a[4] + shadowX, a[5] + shadowY, shadowColor, a[7], a[8], a[9], a[10], false, false, false, false)
	dxDrawText(...)
end

function dxDrawRoundRectangle(x, y, w, h, color, radius, cornerTexture)
    dxDrawImage(x, y, radius, radius, cornerTexture, 0, 0, 0, color)
    dxDrawRectangle(x, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x, y + h - radius, radius, radius, cornerTexture, 270, 0, 0, color)
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color)
    dxDrawImage(x + w - radius, y, radius, radius, cornerTexture, 90, 0, 0, color)
    dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x + w - radius, y + h - radius, radius, radius, cornerTexture, 180, 0, 0, color)
end