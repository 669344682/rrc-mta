local isPanelVisible = false

local panelHeight = 20 * mainScale
local panelY = screenHeight - panelHeight
local mainFont = dxCreateFont("fonts/calibri.ttf", 9 * mainScale)
local blockSpace = 15 * mainScale
local backgroundColor = getColor(colors.background2, 200)

local shadowTexture = dxCreateTexture("images/shadow.png", "argb", true, "clamp")
local shadowSize = 5
local shadowAlpha = 0.7
local borderAlpha = 0.3

local iconSize = math.floor(panelHeight * 0.8)
local iconY = panelY + (panelHeight - iconSize) / 2 

local accountNameBlock = {
	color = getColor(colors.white),
	font = mainFont,
	icon = "images/user.png"
}

local moneyBlock = {
	color = getColor(colors.white),
	font = mainFont,
	icon = "images/money.png"
}

local driftModeBlock = {
	text = "Машина",
	color = getColor(colors.white, 255),
	font = mainFont
}

local settingsBlock = {
	color = getColor(colors.white),
	font = mainFont,
	text = "Настройки"
}

local timeBlock = {
	color = getColor(colors.white),
	font = mainFont
}

local mapBlock = {
	color = getColor(colors.white),
	font = mainFont,
	text = "Карта"
}


local levelBlock = {
	color = getColor(colors.white),
	font = mainFont,
	icon = "images/level.png"
}

local currentSubMenu = nil

local tooltipTexture = dxCreateTexture("images/triangle.png", "argb", true, "clamp")


local function drawTooltip(text, x, y)
	y = y - 2
	local textWidth = dxGetTextWidth(text, 1, mainFont)
	local tooltipWidth = textWidth + 20
	local rx = math.max(x - tooltipWidth / 2, 5)
	local ry = y - panelHeight - 9
	dxDrawImage(x - 5 + 2, y - 10 + 2, 10, 10, tooltipTexture, 0, 0, 0, getColor(colors.black, 150))
	dxDrawRectangle(rx + 2, ry + 2, tooltipWidth, panelHeight, getColor(colors.black, 150))
	dxDrawRectangle(rx, ry, tooltipWidth, panelHeight, getColor(colors.background2, 255))
	dxDrawImage(x - 5, y - 10, 10, 10, tooltipTexture, 0, 0, 0, getColor(colors.background2, 255))
	dxDrawText(text, rx, ry, rx + tooltipWidth, ry + panelHeight, tocolor(255, 255, 255), 1, mainFont, "center", "center")
end

local vehicleSubMenuWidth = 100 * mainScale
local vehicleSubMenuItemSize = 20 * mainScale
local vehicleSubMenuItemSpace = 2 * mainScale
local vehicleSubMenuItems = {
	"Двери",
	"Зажигание",
	"Дрифт-режим",
	"Фары",
	"Крыша"
}

local function processVehicleAction(id)
	if vehicleSubMenuItems[id] == "Зажигание" then
		triggerServerEvent("tws-vehicleActionSync", resourceRoot, "engine")
	elseif vehicleSubMenuItems[id] == "Дрифт-режим" then
		--exports["tws-drift"]:toggleDriftMode()
		triggerServerEvent("tws-vehicleActionSync", resourceRoot, "driftmode")
	elseif vehicleSubMenuItems[id] == "Фары" then
		triggerServerEvent("tws-vehicleActionSync", resourceRoot, "lights")
	elseif vehicleSubMenuItems[id] == "Крыша" then
		outputChatBox("На этой машине нельзя поднять/опустить крышу", 255, 0, 0, true)
	elseif vehicleSubMenuItems[id] == "Двери" then
		triggerServerEvent("tws-vehicleActionSync", resourceRoot, "lock")
	end
end

local function drawVehicleSubMenu(x, y)
	local mx, my = getMousePos()
	local w = vehicleSubMenuWidth
	local h = #vehicleSubMenuItems * (vehicleSubMenuItemSize + vehicleSubMenuItemSpace)
	local x = math.max(5, x - vehicleSubMenuWidth / 2)
	local y = panelY - h
	dxDrawRectangle(x, y, w, h, getColor(colors.background2, 220))
	x = x + 10
	for i,text in ipairs(vehicleSubMenuItems) do
		local y2 = y + vehicleSubMenuItemSize + vehicleSubMenuItemSpace
		if mx >= x - 10 and mx <= x + w - 10 and my >= y and my <= y2 then
			dxDrawImage(x - 10, y, w, vehicleSubMenuItemSize, "images/light.png", 0, 0, 0, tocolor(0, 200, 255, 50))
			if isMouseClick() then
				setCursorVisible(false)
				processVehicleAction(i)
			end
		end
		dxDrawText(text, x, y, x + w - 10, y + vehicleSubMenuItemSize, tocolor(255, 255, 255), 1, mainFont, "left", "center")
		dxDrawLine(x - 10, y, x + w - 10, y, getColor(colors.background, 255 * borderAlpha))
		y = y2
	end
end

local function drawPanelButton(mx, my, x, width, tipText)
	if 	mx >= x and mx <= x + width and 
		my >= panelY and my <= panelY + panelHeight 
	then
		dxDrawImage(x, panelY, width, panelHeight, "images/light.png", 0, 0, 0, tocolor(0, 200, 255, 50))
		if tipText then
			drawTooltip(tipText, x + width / 2, panelY)
		end

		if isMouseClick() then
			return true
		end
	end
	return false
end

function drawPanel()
	if not isPanelVisible or not getElementData(localPlayer, "tws-accountName") then
		return
	end 
	local mx, my = getMousePos()
	local x = 0
	local y = panelY
	dxDrawImage(0, y - shadowSize, screenWidth, shadowSize, shadowTexture, 0, 0, 0, tocolor(0, 0, 0, 255 * shadowAlpha))
	dxDrawImage(0, y, screenWidth, panelHeight, "images/background.png", 0, 0, 0, backgroundColor)
	dxDrawLine(0, y, screenWidth, y, getColor(colors.background, 255 * borderAlpha))

	x = 5
	-- Account name
	local accountName = string.upper(getElementData(localPlayer, "tws-accountName"))
	local textWidth = dxGetTextWidth(accountName, 1, accountNameBlock.font)
	dxDrawImage(x, iconY, iconSize, iconSize, accountNameBlock.icon)
	dxDrawText(accountName, x + iconSize, y, x + iconSize + textWidth + blockSpace / 2, y + panelHeight, accountNameBlock.color, 1, accountNameBlock.font, "center", "center")
	local blockWidth = textWidth + iconSize
	if drawPanelButton(mx, my, x, blockWidth + blockSpace, "Просмотр профиля") then
		exports["tws-gui-profile"]:setProfileWindowVisible(true)
	end

	x = x + blockWidth + blockSpace
	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))
	-- Money
	local moneyText = "$" .. tostring(getElementData(localPlayer, "tws-money"))
	dxDrawImage(x + blockSpace / 2, iconY, iconSize, iconSize, moneyBlock.icon)
	textWidth = dxGetTextWidth(moneyText, 1, moneyBlock.font)
	dxDrawText(moneyText, x + blockSpace * 1.3, y, x + blockSpace * 1.3 + textWidth + blockSpace, y + panelHeight, moneyBlock.color, 1, moneyBlock.font, "center", "center")
	local blockWidth = textWidth + iconSize
	if drawPanelButton(mx, my, x, blockWidth + blockSpace * 1.5, "Передача денег") then
		outputChatBox("Для передачи денег используйте команду /pay <id/имя> <количество>")
	end

	x = x + blockWidth + blockSpace * 1.5
	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))
	-- Машина
	if localPlayer.vehicle and getVehicleOccupant(localPlayer.vehicle) == localPlayer then
		local text = driftModeBlock.text
		--[[if getElementData(localPlayer, "tws-accountName") == getElementData(localPlayer.vehicle, "tws-owner") then
			text = ""
		else
			local ownerName = getElementData(localPlayer.vehicle, "tws-ownerName")
			if ownerName then
				text = text .. " игрока " .. tostring(ownerName):gsub('#%x%x%x%x%x%x', '')
			end
		end]]
		textWidth = dxGetTextWidth(text, 1, driftModeBlock.font)
		dxDrawText(text, x, y, x + textWidth + blockSpace, y + panelHeight, driftModeBlock.color, 1, driftModeBlock.font, "center", "center", false, false, false, false)
		if currentSubMenu == "vehicle" then
			drawVehicleSubMenu(x + (textWidth + blockSpace) / 2, panelY)
		end
		if drawPanelButton(mx, my, x, textWidth + blockSpace) then
			if currentSubMenu == "vehicle" then
				currentSubMenu = ""
			else
				currentSubMenu = "vehicle"
			end
		else
			if isMouseClick() then
				currentSubMenu = ""
			end
		end

		x = x + textWidth + blockSpace
		dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))
	else
		currentSubMenu = nil
	end

	-- Warp
	local warpText = "Гараж"
	textWidth = dxGetTextWidth(warpText, 1, mainFont)
	dxDrawText(warpText, x, y, x + textWidth + blockSpace, y + panelHeight, tocolor(255, 255, 255), 1, mainFont, "center", "center")
	local blockWidth = textWidth + iconSize
	if drawPanelButton(mx, my, x, textWidth + blockSpace, "Нажмите, чтобы открыть список своих автомобилей") then
		exports["tws-gui-carmenu"]:showCarmenu()
	end

	x = x + textWidth + blockSpace
	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))

	x = screenWidth - 90
	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))

	-- Часы
	local res, timeString = pcall(exports["tws-time"].getTimeString)
	if not timeString then
		outputDebugString("Ресурс tws-time не запущен", 0, 255, 150, 00)
		timeString = "00:00"
	end
	local timeText = "Время: " .. timeString
	textWidth = dxGetTextWidth(timeText, 1, timeBlock.font)
	x = x - textWidth - blockSpace
	dxDrawText(timeText, x, y, x + textWidth + blockSpace, y + panelHeight, timeBlock.color, 1, timeBlock.font, "center", "center")	
	drawPanelButton(mx, my, x, textWidth + blockSpace, "Текущее время")

	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))
	-- Настройки
	textWidth = dxGetTextWidth(settingsBlock.text, 1, settingsBlock.font)
	x = x - textWidth - blockSpace
	dxDrawText(settingsBlock.text, x, y, x + textWidth + blockSpace, y + panelHeight, timeBlock.color, 1, timeBlock.font, "center", "center")	
	if drawPanelButton(mx, my, x, textWidth + blockSpace, "Открыть окно настроек") then
		exports["tws-gui-settings"]:setSettingsWindowVisible(true)
	end

	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))

	-- Карта
	textWidth = dxGetTextWidth(mapBlock.text, 1, mapBlock.font)
	x = x - textWidth - blockSpace
	dxDrawText(mapBlock.text, x, y, x + textWidth + blockSpace, y + panelHeight, mapBlock.color, 1, mapBlock.font, "center", "center")	
	if drawPanelButton(mx, my, x, textWidth + blockSpace, "Открыть карту (M)") then
		setCursorVisible(false)
		exports["tws-gui-map"]:toggleMap()
	end

	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))

	-- Уровень
	local playerLevelNumber = getElementData(localPlayer, "tws-level")
	if not playerLevelNumber then
		playerLevelNumber = 0
	end
	local playerLevel = tostring(playerLevelNumber)
	local playerRespects = tostring(getElementData(localPlayer, "tws-respects"))
	local requiredRespects = tostring(4 + playerLevelNumber * 4)
	local color = "#656565"
	if getElementData(localPlayer, "tws-respects") >= (4 + playerLevelNumber * 4) then
		color = "#008800"
	end
	local levelText = "Уровень: " .. playerLevel .. color .. " (" .. playerRespects .. "/" .. requiredRespects .. ")"
	local levelTextNocode = "Уровень: " .. playerLevel .. " (" .. playerRespects .. "/" .. requiredRespects .. ")"
	textWidth = dxGetTextWidth(levelTextNocode, 1, levelBlock.font)
	x = x - textWidth - blockSpace
	dxDrawText(levelText, x, y, x + textWidth + blockSpace, y + panelHeight, levelBlock.color, 1, levelBlock.font, "center", "center", false, false, false, true)	
	x = x - blockSpace * 1.5
	dxDrawImage(x + blockSpace / 2, iconY, iconSize, iconSize, levelBlock.icon)
	x = x - blockSpace / 4
	dxDrawLine(x, y, x, y + panelHeight, getColor(colors.background, 255 * borderAlpha))
	if drawPanelButton(mx, my, x, textWidth + iconSize + blockSpace * 2 - 5, "Переход на следующий уровень") then
		triggerServerEvent("tws-panelButtonAction", resourceRoot, "buylevel")
	end

	updateMouseClick()
end

addEventHandler("onClientRender", root, drawPanel)

isMouseCursorVisible = false
function setPanelVisible(isVisible)
	isPanelVisible = isVisible
end

function setCursorVisible(isVisible)
	showCursor(isVisible, false)
	setCursorPosition(screenWidth / 2, screenHeight / 2)
	isMouseCursorVisible = isVisible
end

function isCursorVisible(isVisible)
	return isMouseCursorVisible
end

bindKey("f1", "down",
	function()
		setCursorVisible(not isMouseCursorVisible)
		toggleControl("fire", not isCursorShowing())
		currentSubMenu = ""
	end
)