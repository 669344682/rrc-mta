buttonsList = {}

local buttonFont = dxCreateFont("fonts/calibri.ttf", 14 * mainScale, true)
local images = {
	background = "images/buttonsList/bg.png",
	shadow = "images/buttonsList/fg.png",
	arrow = "images/arrow.png"	
}

-- Position and size
buttonsList.x = 0
buttonsList.y = 0
buttonsList.defaultY = 0
buttonsList.width = 520 * mainScale
buttonsList.height = 35 * mainScale

-- Caption text
buttonsList.caption = "ТЕСТ"

local arrowOffset = 20 * mainScale

local buttonsTable = {}
local selectedButton = 1
local buttonsOffsetTargetX = 0
local buttonsOffsetX = 0

local buttonsRenderTargetWidth = buttonsList.width - arrowOffset * 2 - listArrow.size
local buttonsRenderTarget = dxCreateRenderTarget(buttonsRenderTargetWidth, buttonsList.height, true)

local buttonItem = {
	scale = 1,
	font = buttonFont,
	color = colors.textHeading,
	space = 30 * mainScale
}

local buttonsListType = ""

function buttonsList.start(y, caption, buttons, type)
	buttonsList.stop()
	
	buttonsList.x = (screenWidth - buttonsList.width) / 2
	buttonsList.y = y
	buttonsList.caption = caption
	buttonsTable = {}

	local x = 0
	for i, button in ipairs(buttons) do
		local newButton = {x = x, text = button.text, name = button.name, width = dxGetTextWidth(button.text, buttonItem.scale, buttonItem.font)}
		table.insert(buttonsTable, newButton)
		x = x + newButton.width + buttonItem.space
	end

	bindKey("arrow_l", "down", buttonsList.prev)
	bindKey("arrow_r", "down", buttonsList.next)
	bindKey("enter", "down", buttonsList.select)

	buttonsListType = type

	buttonsList.setSelectedButton(1)
end

function buttonsList.stop()
	unbindKey("arrow_l", "down", buttonsList.prev)
	unbindKey("arrow_r", "down", buttonsList.next)
	unbindKey("enter", "down", buttonsList.select)
end

function buttonsList.draw(fade)
	local bl = buttonsList
	local yOffset = fade * bl.height * 5
	if buttonsListType == "subsection" then
		yOffset = fade * bl.height * -5
	end
	-- Background
	dxDrawImage(bl.x, bl.y + yOffset, bl.width, bl.height, images.background, 0, 0, 0, getColor(colors.background))

	-- Buttons
	dxDrawImage(bl.x + (bl.width - buttonsRenderTargetWidth) / 2, bl.y + yOffset, buttonsRenderTargetWidth, bl.height, buttonsRenderTarget)
	
	-- Shadow
	dxDrawImage(bl.x, bl.y + yOffset, bl.width, bl.height, images.shadow, 0, 0, 0, getColor(colors.white))
	
	-- Caption
	dxDrawText("★ " .. bl.caption .. " ★", bl.x + 3, bl.y - 40 + 3 + yOffset, bl.x + bl.width / 2 + 3, bl.y + 3 + yOffset, getColor(colors.black, 200), 1, carbonFont)
	dxDrawText("★ " .. bl.caption .. " ★", bl.x, bl.y - 40 + yOffset, bl.x + bl.width / 2, bl.y + yOffset, getColor(colors.white, 200), 1, carbonFont)

	-- Arrows
	listArrow.draw(bl.x + arrowOffset, bl.y + yOffset, 180, "arrow_l")
	listArrow.draw(bl.x + bl.width - arrowOffset - listArrow.size, bl.y + yOffset, 0, "arrow_r")

	-- Buttons
	dxSetRenderTarget(buttonsRenderTarget, true)
	buttonsOffsetX = buttonsOffsetX + (buttonsOffsetTargetX - buttonsOffsetX) * 0.2
	for i, button in ipairs(buttonsTable) do
		dxDrawShadowText(button.text, buttonsOffsetX + button.x, 0, buttonsOffsetX + button.x + button.width, bl.height * 0.98, getColor(colors.textHeading), buttonItem.scale, buttonItem.font, "center", "center")
	end
	dxSetRenderTarget()
end

function buttonsList.setSelectedButton(index)
	if index < 1 then
		index = 1
	elseif index > #buttonsTable then
		index = #buttonsTable
	end
	selectedButton = index

	buttonsOffsetTargetX = buttonsRenderTargetWidth / 2 - buttonsTable[selectedButton].x - buttonsTable[selectedButton].width / 2

	if buttonsListType == "subsection" then
		subsectionScreen.updateItemsList(buttonsTable[selectedButton].name)
	end
end

function buttonsList.getSelectedButton()
	return selectedButton
end

function buttonsList.prev()
	if isMTAWindowActive() then
		return
	end
	playSoundFrontEnd(tuningConfig.sounds.select)
	buttonsList.setSelectedButton(selectedButton - 1)
end

function buttonsList.next()
	if isMTAWindowActive() then
		return
	end
	playSoundFrontEnd(tuningConfig.sounds.select)
	buttonsList.setSelectedButton(selectedButton + 1)
end

function buttonsList.select()
	if isMTAWindowActive() then
		return
	end
	if buttonsListType == "main" then
		screens.fadeToScreen("subsectionScreen", buttonsTable[selectedButton].name)
		playSoundFrontEnd(tuningConfig.sounds.buy)
	elseif buttonsListType == "subsection" then
		subsectionScreen.buttonSelect(buttonsTable[selectedButton].name)
	end
end