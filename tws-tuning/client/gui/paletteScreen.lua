paletteScreen = {}
local updateCallback = nil
local selectCallback = nil
local cancelCallback = nil

function paletteScreen.start(callback1, callback2, callback3, caption)
	paletteScreen.stop()

	updateCallback = callback1
	selectCallback = callback2
	cancelCallback = callback3
	if not caption then
		caption = "Цвет"
	end
	colorPalette.start(caption, screenWidth - colorPalette.width - 10 * mainScale, 100 * mainScale, paletteScreen)
	buttonsTips.start({"СТРЕЛКИ - ВЫБОР", "ENTER - КУПИТЬ", "BACKSPACE - ОТМЕНА"})

	bindKey("backspace", "down", paletteScreen.back)
end

function paletteScreen.stop()
	unbindKey("backspace", "down", paletteScreen.back)
	colorPalette.stop()
	buttonsTips.stop()

	updateCallback = nil
	selectCallback = nil
	cancelCallback = nil
end

function paletteScreen.draw(fade)
	dxDrawScreenShadow()
	colorPalette.draw(fade)
	buttonsTips.draw(fade)
end

function paletteScreen.updateColor(r, g, b)
	if updateCallback then
		updateCallback(r, g, b)
	end
end

function paletteScreen.selectColor(r, g, b)
	if isMTAWindowActive() then
		return
	end
	if selectCallback then
		selectCallback(r, g, b)
	end
end

function paletteScreen.back()
	if cancelCallback then
		cancelCallback()
	end
end

screens.add(paletteScreen, "paletteScreen")