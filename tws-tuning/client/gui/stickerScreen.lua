stickerScreen = {}
local canMoveSticker = false
local lastColor = {255, 255, 255}

function stickerScreen.start(id)
	stickerScreen.stop()

	if id then
		tuningTexture.addSticker(id)
	else
		outputDebugString("WRONG STICKER ID")
	end

	colorPalette.start("Цвет наклейки", screenWidth - colorPalette.width - 10 * mainScale, 100 * mainScale, stickerScreen, true, true)
	buttonsTips.start({"СТРЕЛКИ - ДВИГАТЬ", "ENTER - СОХРАНИТЬ", "BACKSPACE - ОТМЕНА", "МЫШЬ - УПРАВЛЕНИЕ"})
	stickerSettings.start(colorPalette.x, colorPalette.y + colorPalette.height + 10 * mainScale)


	-- Bind keys
	unbindKey("backspace", "down", stickerScreen.back)
	unbindKey("enter", "down", stickerScreen.confirm)
	bindKey("backspace", "down", stickerScreen.back)
	bindKey("enter", "down", stickerScreen.confirm)

	canMoveSticker = true

	if lastColor then
		stickerScreen.updateColor(unpack(lastColor))
	end
end

function stickerScreen.stop()
	unbindKey("enter", "down", stickerScreen.confirm)
	unbindKey("backspace", "down", stickerScreen.back)

	colorPalette.stop()
	buttonsTips.stop()
	stickerSettings.stop()
	canMoveSticker = false
end

function stickerScreen.draw(fade)
	dxDrawScreenShadow()
	colorPalette.draw(fade)
	buttonsTips.draw(fade)
	stickerSettings.draw(fade)

	if canMoveSticker then
		if getKeyState("arrow_l") then
			tuningTexture.moveSelectedSticker("left")
		elseif getKeyState("arrow_r") then
			tuningTexture.moveSelectedSticker("right")
		end
		if getKeyState("arrow_u") then
			tuningTexture.moveSelectedSticker("up")
		elseif getKeyState("arrow_d") then
			tuningTexture.moveSelectedSticker("down")
		end
	end
end

function stickerScreen.back()
	tuningTexture.removeSelectedSticker()
	screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
end

function stickerScreen.confirm()
	canMoveSticker = false
	screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
end

function stickerScreen.updateColor(r, g, b)
	tuningTexture.setStickerProperty("color", tocolor(r, g, b))
	lastColor = {r, g, b}
end

function stickerScreen.selectColor(r, g, b)

end

screens.add(stickerScreen, "stickerScreen")