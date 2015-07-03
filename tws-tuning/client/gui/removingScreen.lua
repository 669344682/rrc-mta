removingScreen = {}

local currentIndex = nil
local selectedSticker = 0

local function setSelectedSticker(index)
	if selectedSticker == index then
		return
	end
	local count = #tuningTexture.getStickers()
	if count == 0 then
		selectedSticker = 0
		return
	end
	if index > count then
		index = 1
	elseif index < 1 then
		index = count 
	end
	selectedSticker = index

	tuningTexture.setHighlightedSticker(index)

	local stickerSide = tuningTexture.getStickerSide(index)
	outputDebugString(stickerSide)
	tuningCamera.setLookMode(stickerSide)

	currentIndex = tuningTexture.getSticker(index)
end

function removingScreen.start(id)
	removingScreen.stop()

	buttonsTips.start({"СТРЕЛКИ - ВЫБОР", "ENTER - УДАЛИТЬ", "BACKSPACE - ВЫХОД"})

	-- Bind keys
	unbindKey("arrow_l", "down", removingScreen.prev)
	unbindKey("arrow_r", "down", removingScreen.next)
	unbindKey("backspace", "down", removingScreen.back)
	unbindKey("enter", "down", removingScreen.confirm)
	bindKey("backspace", "down", removingScreen.back)
	bindKey("enter", "down", removingScreen.confirm)
	bindKey("arrow_l", "down", removingScreen.prev)
	bindKey("arrow_r", "down", removingScreen.next)

	setSelectedSticker(1)
end

function removingScreen.stop()
	unbindKey("arrow_l", "down", removingScreen.prev)
	unbindKey("arrow_r", "down", removingScreen.next)
	unbindKey("enter", "down", removingScreen.confirm)
	unbindKey("backspace", "down", removingScreen.back)

	buttonsTips.stop()
	tuningTexture.setHighlightedSticker()
end

function removingScreen.draw(fade)
	dxDrawScreenShadow()
	buttonsTips.draw(fade)
end

function removingScreen.back()
	--tuningTexture.removeSelectedSticker()
	screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
end

function removingScreen.confirm()
	tuningTexture.removeSelectedStickerByIndex(selectedSticker)
	setSelectedSticker(selectedSticker + 1)
	--screens.changeScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
end

function removingScreen.next()
	setSelectedSticker(selectedSticker + 1)
end	

function removingScreen.prev()
	setSelectedSticker(selectedSticker - 1)
end

screens.add(removingScreen, "removingScreen")