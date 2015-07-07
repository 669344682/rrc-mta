spoilerScreen = {}
spoilerScreen.selectedID = 0
spoilerScreen.selectedColor = {255, 255, 255}
spoilerScreen.selectedType = "normal"
spoilerScreen.price = 0

spoilerScreen.isLocked = false

function spoilerScreen.start(id, price)
	spoilerScreen.stop()
	spoilerScreen.isLocked = false

	spoilerScreen.price = price

	colorPalette.start("Цвет спойлера", screenWidth - colorPalette.width - 10 * mainScale, 100 * mainScale, spoilerScreen, true, true)
	buttonsTips.start({"ENTER - СОХРАНИТЬ", "BACKSPACE - ОТМЕНА"})
	spoilerSettings.start(colorPalette.x, colorPalette.y + colorPalette.height + 10 * mainScale)


	-- Bind keys
	unbindKey("backspace", "down", spoilerScreen.back)
	unbindKey("enter", "down", spoilerScreen.confirm)
	bindKey("backspace", "down", spoilerScreen.back)
	bindKey("enter", "down", spoilerScreen.confirm)

	tuningCamera.setLookMode("spoilerView")
	exports["tws-spoilers"]:setVehicleSpoiler(tuningVehicle.vehicle, id)

	spoilerScreen.selectedID = id
	spoilerScreen.resetSpoilerColor()
end

function spoilerScreen.stop()
	spoilerScreen.isLocked = false
	unbindKey("enter", "down", spoilerScreen.confirm)
	unbindKey("backspace", "down", spoilerScreen.back)

	colorPalette.stop()
	buttonsTips.stop()
	spoilerSettings.stop()
end

function spoilerScreen.draw(fade)
	dxDrawScreenShadow()
	colorPalette.draw(fade)
	buttonsTips.draw(fade)
	spoilerSettings.draw(fade)
end

function spoilerScreen.back()
	tuningVehicle.restoreTuning("spoiler")
	screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
end

function spoilerScreen.confirm()
	if spoilerScreen.isLocked then
		return
	end
	spoilerScreen.isLocked = true
	tuningUpgrades.pay(spoilerScreen.price,
		function()
			tuningVehicle.setTuning("spoiler", {id = spoilerScreen.selectedID, color = spoilerScreen.selectedColor, type = spoilerScreen.selectedType})
			screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
		end,
		function()
			screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
		end
	)
	spoilerScreen.price = 0
end

function spoilerScreen.updateColor(r, g, b)
	exports["tws-spoilers"]:setVehicleSpoilerColor(tuningVehicle.vehicle, r, g, b)
	spoilerScreen.selectedColor = {r, g, b}
end

function spoilerScreen.selectColor(r, g, b)

end

function spoilerScreen.resetSpoilerColor()
	local color = tuningVehicle.tuning.color
	if not color then
		color = {255, 255, 255}
	end
	exports["tws-spoilers"]:setVehicleSpoilerColor(tuningVehicle.vehicle, unpack(color))
	spoilerScreen.selectedColor = color
end

screens.add(spoilerScreen, "spoilerScreen")