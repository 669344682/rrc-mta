local sectionsScreen = {}

local exitPressed = false
local lastSelected = 1

function sectionsScreen.start(isReturn)
	exitPressed = false
	tuningCamera.setLookMode("default", false)
	buttonsTips.start({"ENTER - ВЫБОР", "BACKSPACE - ВЫХОД"})
	buttonsList.start(buttonsTips.y - buttonsList.height - 10 * mainScale, "Тюнинг", tuningConfig.mainSections, "main")

	if isReturn then
		buttonsList.setSelectedButton(lastSelected)
	end
end

function sectionsScreen.stop()
	lastSelected = buttonsList.getSelectedButton()
	buttonsList.stop()
end

function sectionsScreen.draw(fade)
	dxDrawScreenShadow()
	buttonsList.draw(fade)
	buttonsTips.draw(fade)

	if getKeyState("backspace") and not exitPressed and not isMTAWindowActive() then
		tuningExit()
		playSoundFrontEnd(tuningConfig.sounds.back)
		exitPressed = true
	end
end

screens.add(sectionsScreen, "sectionsScreen")