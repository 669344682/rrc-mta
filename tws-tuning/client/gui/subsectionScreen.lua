subsectionScreen = {}
subsectionScreen.lastSubsection = ""
subsectionScreen.lastButton = 1
local currentSectionName = ""

function subsectionScreen.start(name, selectedButton)
	if not name or not tuningConfig.subsections[name] then
		outputDebugString("NO SUBMENU")
		return
	end
	currentSectionName = name

	-- Camera
	tuningCamera.setLookMode("default", false)

	-- Start things
	itemsList.start(60 * mainScale + buttonsList.height + 10 * mainScale, buttonsList.width / 2.2, name)
	buttonsTips.start({"СТРЕЛКИ - ВЫБОР", "ENTER - КУПИТЬ", "BACKSPACE - НАЗАД"})
	buttonsList.start(60 * mainScale, tuningConfig.subsectionsCaptions[name], tuningConfig.subsections[name], "subsection")

	-- Bind keys
	unbindKey("backspace", "down", subsectionScreen.back)
	bindKey("backspace", "down", subsectionScreen.back)

	-- Select button
	if name == subsectionScreen.lastSubsection and subsectionScreen.lastButton and selectedButton then
		buttonsList.setSelectedButton(selectedButton)
	end
	subsectionScreen.lastSubsection = name
end

function subsectionScreen.stop()
	unbindKey("backspace", "down", subsectionScreen.back)
	
	subsectionScreen.lastButton = buttonsList.getSelectedButton()
	buttonsList.stop()
	buttonsTips.stop()
	itemsList.stop()
end

function subsectionScreen.draw(fade)
	dxDrawScreenShadow()
	buttonsList.draw(fade)
	buttonsTips.draw(fade)
	itemsList.draw(fade)
	stickerPreview.draw()
end

function subsectionScreen.updateItemsList(name)
	itemsList.setItems(tuningConfig.subsectionsItems[currentSectionName.."-"..name], name)
end

function subsectionScreen.buttonSelect(name)
	if isMTAWindowActive() then
		return
	end
	tuningUpgrades.show(currentSectionName.."-"..name)
end

function subsectionScreen.back()
	if isMTAWindowActive() then
		return
	end
	playSoundFrontEnd(tuningConfig.sounds.back)
	screens.fadeToScreen("sectionsScreen", true)
end

screens.add(subsectionScreen, "subsectionScreen")