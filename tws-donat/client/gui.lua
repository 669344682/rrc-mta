twsGUI = exports["tws-gui"]
gui = {}
canvas = twsGUI:createCanvas(resourceRoot)
windowsW, windowsH = 588, 580
windowsX, windowsY = screenX/2 - windowsW/2, screenY/2 - windowsH/2
isGUIVisible = false
carNumberText = ""
carNumberRegion = ""
carNumberTextNew = ""
carNumberRegionNew = ""

local errorInformed = false
local numbersFont = dxCreateFont("fonts/numbers.ttf", 9)
local progressBarW = windowsW - 41

function createTitle(y, w, h, parent, text)
	local startX = windowsW/2 - w/2
	local endX = (windowsW/2 - w/2) + w

	local edit = twsGUI:createLabel(startX, y, w, h, parent, text)

	local offset = w ~= 0 and 5 or 0
	local idk = w == 0 and 10 or 0
	local lineH = 1.5
	local line1 = twsGUI:createEdit(0, y + h/2, startX - offset, lineH, parent)
	local line2 = twsGUI:createEdit(endX + offset, y + h/2, - endX + offset - 70 + windowsX + idk, lineH, parent)
	return edit, line1, line2
end

function createProgressBar(y, parent)
	local window = twsGUI:createWindow(20, y + 20, progressBarW + 1, 0, parent)
	local bar = twsGUI:createButton(20, y, progressBarW, 19, parent)
	twsGUI:setEnabled(bar, false)

	return bar, bg
end

function setProgress(progressBar, progress)
	local w = progressBarW * progress
	local _, h = twsGUI:getSize(progressBar)
	twsGUI:setSize(progressBar, w, h)
end

function createToggle(x, y, w, h, parent, state)
	local label1 = twsGUI:createLabel(x, y, 0, h, parent, "Вкл.")
	local x = x + 45
	local toggle = twsGUI:createToggle(x, y, w, h, parent, state)
	local label2 = twsGUI:createLabel(x + w + 15, y, 0, h, parent, "Выкл.")
	return toggle
end

local offsetY = 10
local step = 33
local x = 20

local labelH = 25
local editH = 25
local editX, editW, buttonX, buttonW, spacing
local nextPageW = 190
local closeW = 148
local posX



gui.window1 = twsGUI:createWindow(windowsX, windowsY, windowsW, windowsH, canvas, "VIP Панель") twsGUI:setVisible(gui.window1, false)
gui.window2 = twsGUI:createWindow(windowsX, windowsY, windowsW, windowsH, canvas, "VIP Панель") twsGUI:setVisible(gui.window2, false)
gui.window = gui.window1

gui.progressBar1 = createProgressBar(20, gui.window1)
gui.daysLabel1 = twsGUI:createLabel(170, 30, 0, 0, gui.window, "")
setProgress(gui.progressBar1, 1)

gui.progressBar2 = createProgressBar(20, gui.window2)
gui.daysLabel2 = twsGUI:createLabel(170, 30, 0, 0, gui.window2, "")
setProgress(gui.progressBar2, 1)

gui.topLine1 = twsGUI:createButton(0, offsetY + step * 1 + 18, windowsW, 1, gui.window1)
gui.topLine2 = twsGUI:createButton(0, offsetY + step * 1 + 18, windowsW, 1, gui.window2)

spacing = 10
gui.close1 = twsGUI:createButton(x, windowsH - editH - spacing * 1.5, closeW, editH, gui.window1, "Закрыть")
gui.close2 = twsGUI:createButton(x, windowsH - editH - spacing * 1.5, closeW, editH, gui.window2, "Закрыть")

--gui.previousPage1 = twsGUI:createButton(windowsW - nextPageW - x - nextPageW - spacing, windowsH - editH - spacing * 1.5, nextPageW, editH, gui.window1, "Предыдущая страница")  twsGUI:setEnabled(gui.previousPage1, false)
gui.nextPage1 = twsGUI:createButton(windowsW - nextPageW - x, windowsH - editH - spacing * 1.5, nextPageW, editH, gui.window, "Следующая страница")

gui.previousPage2 = twsGUI:createButton(windowsW - nextPageW - x - nextPageW - spacing, windowsH - editH - spacing * 1.5, nextPageW, editH, gui.window2, "Предыдущая страница")
gui.nextPage2 = twsGUI:createButton(windowsW - nextPageW - x, windowsH - editH - spacing * 1.5, nextPageW, editH, gui.window2, "Следующая страница") twsGUI:setEnabled(gui.nextPage2, false)

gui.lineBottom1 = twsGUI:createButton(0, windowsH - editH - 33, windowsW, 1, gui.window1)
gui.lineBottom2 = twsGUI:createButton(0, windowsH - editH - 33, windowsW, 1, gui.window2)


editH = labelH - 5


------------------------------------------
----------- THE FIRST WINDOW -------------
------------------------------------------

-- Skin
gui.skinLabel = twsGUI:createLabel(x, offsetY + step * 2, 0, labelH, gui.window, "Ваш текущий скин:")
editX = 160; editW = 40
gui.skinEdit = twsGUI:createButton(x + editX, offsetY + step * 2 + 3, editW, editH, gui.window, "123")
twsGUI:setEnabled(gui.skinEdit, false)
buttonX = 150
gui.skinView = twsGUI:createButton(x + editX + editW + spacing, offsetY + step * 2 + 3, buttonX, editH, gui.window, "Выбрать скин")
gui.skinViewVIP = twsGUI:createButton(x + editX + editW + spacing + buttonX + spacing, offsetY + step * 2 + 2, 180, editH, gui.window, "Выбрать VIP скин")

gui.skinLabelNew = twsGUI:createLabel(x, offsetY + step * 3 + 2, 0, editH, gui.window, "Выбрать скин по ID:")
gui.skinEditNew = twsGUI:createEdit(x + editX, offsetY + step * 3 + 2, editW, editH, gui.window, "")
gui.skinButtonAccept = twsGUI:createButton(x + editX + editW + spacing, offsetY + step * 3 + 2, buttonX, editH, gui.window, "Применить")

-- Spectating
offsetY = 30
gui.line2 = twsGUI:createButton(0, offsetY + step * 4 - 17, windowsW, 1, gui.window)
gui.specLabel = twsGUI:createLabel(x, offsetY + step * 4, 0, labelH, gui.window, "Слежка за игроком:")
gui.specID = twsGUI:createEdit(x + editX, offsetY + step * 4 + 3, editW, editH, gui.window, "")
gui.specButton = twsGUI:createButton(x + editX + editW + spacing, offsetY + step * 4 + 3, buttonX, editH, gui.window, "Следить")
gui.specLabel = twsGUI:createLabel(x, offsetY + step * 5, 0, labelH, gui.window, "Вы также можете следить за игроками с помощью команды /spectate ID")
gui.jetpackLabel = twsGUI:createLabel(x, offsetY + step * 6, 0, labelH, gui.window, "Хоткей для включения джетпака: ")
gui.jetpackHotkey = twsGUI:createButton(x + 270, offsetY + step * 6 + 3, 90, editH, gui.window, "")

-- Other
offsetY = 50
gui.line3 = twsGUI:createButton(0, offsetY + step * 7 - 13, windowsW, 1, gui.window)

buttonW = 25
editW = 110

gui.colorLabel = twsGUI:createLabel(x, offsetY + step * 7, 0, labelH, gui.window, "Цвет вашего никнейма и точки на радаре: ")
gui.colorButton = twsGUI:createButton(x + 370 + buttonW + spacing, offsetY + step * 7 + 3, 145, editH, gui.window, "Изменить цвет")
colorSquareX, colorSquareY, colorSquareW, colorSquareH = windowsX + x + 371, windowsY + offsetY + step * 7 + 4, 23, editH - 2


gui.fightingStyleLabel = twsGUI:createLabel(x, offsetY + step * 8, 0, labelH, gui.window, "Стиль ведения боя вашего персонажа: ")
gui.fightingStylePrevious = twsGUI:createButton(x + 370, offsetY + step * 8 + 3, buttonW, editH, gui.window, "<")
gui.fightingStyle = twsGUI:createButton(x + 370 + buttonW + spacing, offsetY + step * 8 + 3, editW, editH, gui.window, "DEFAULT")
gui.fightingStyleNext = twsGUI:createButton(x + 370 + buttonW + spacing*2 + editW, offsetY + step * 8 + 3, buttonW, editH, gui.window, ">")
twsGUI:setEnabled(gui.fightingStyle, false)

gui.radarPosShowing = twsGUI:createLabel(x, offsetY + step * 9, 0, labelH, gui.window, "Скрывать ваше положение на радаре: ") -- "tws-isGlobalMapHiding"
gui.radarPosToggle = createToggle(x + 370, offsetY + step * 9, 70, labelH, gui.window, true)

gui.crownShowingLabel = twsGUI:createLabel(x, offsetY + step * 10, 0, labelH, gui.window, "Отображение значка короны в вашем нике: ")
gui.crownShowingToggle = createToggle(x + 370, offsetY + step * 10, 70, labelH, gui.window, true)

gui.headlessLabel = twsGUI:createLabel(x, offsetY + step * 11, 0, labelH, gui.window, "Снять голову с плеч вашего персонажа: ")
gui.headlessToggle = createToggle(x + 370, offsetY + step * 11, 70, labelH, gui.window, false)

gui.godmodeLabel = twsGUI:createLabel(x, offsetY + step * 12, 0, labelH, gui.window, "Бессмертие вашего персонажа и автомобиля: ")
gui.godmodeToggle = createToggle(x + 370, offsetY + step * 12, 70, labelH, gui.window, false)

gui.waterHoveringLabel = twsGUI:createLabel(x, offsetY + step * 13, 0, labelH, gui.window, "Возможность ездить по воде на автомобиле: ")
gui.waterHoveringToggle = createToggle(x + 370, offsetY + step * 13, 70, labelH, gui.window, true)


local w, h

w, h = 250, 70
spacing = 10

gui.stopSpectating = twsGUI:createButton(screenX/2 - w/2, screenY - screenY/10 - h, w, h, canvas, "Остановить слежку")
twsGUI:setVisible(gui.stopSpectating, false)

w, h = 200, 40

local y = screenY/7

local skinWindowW, skinWindowH = w*3 + spacing*4, h + spacing*10

local labelH = spacing * 4

gui.skinWindow = twsGUI:createWindow(screenX/2 - w/2 - w - spacing*2, y - spacing, skinWindowW, skinWindowH, canvas, "Просмотр скинов")
gui.skinGlobalVisibility = false
gui.skinGlobalVisibilityButton = twsGUI:createButton(spacing, spacing, skinWindowW - spacing*2, labelH - spacing, gui.skinWindow, "Другие игроки не видят, как вы меняете скин")
gui.previousSkin = twsGUI:createButton(spacing, spacing + labelH, w, h, gui.skinWindow, "Предыдущий скин")
gui.stopSkinViewing = twsGUI:createButton(w + spacing*2, spacing + labelH, w, h, gui.skinWindow, "Выбрать этот скин")
gui.nextSkin = twsGUI:createButton(w*2 + spacing*3, spacing + labelH, w, h, gui.skinWindow, "Следующий скин")

local w, h = skinWindowW - spacing*2, 30
gui.currentSkinString = "Текущий скин: ID "
gui.currentSkinLabel = twsGUI:createButton(spacing, skinWindowH - spacing - h, w, h, gui.skinWindow, gui.currentSkinString .. "-1")
twsGUI:setEnabled(gui.currentSkinLabel, false)

twsGUI:setVisible(gui.skinWindow, false)

------------------------------------------
----------- THE SECOND WINDOW ------------
------------------------------------------

local editW, editW2 = 70, 37

labelH = 25
offsetY = 10
buttonX = 150
posX = x + 280

gui.carplateLabel = twsGUI:createLabel(x, offsetY + step * 2, 0, labelH, gui.window2, "Текущие автомобильные номера: ")
gui.carNumberEdit = twsGUI:createButton(posX, offsetY + step * 2 + 3, editW, editH, gui.window2, "") twsGUI:setEnabled(gui.carNumberEdit, false)
gui.carRegionEdit = twsGUI:createButton(posX + editW + spacing, offsetY + step * 2 + 3, editW2, editH, gui.window2, "") twsGUI:setEnabled(gui.carRegionEdit, false)


gui.carplateNewLabel = twsGUI:createLabel(x, offsetY + step * 3 + 2, 0, editH, gui.window2, "Изменить автомобильные номера: ")
gui.carNumberNewEdit = twsGUI:createEdit(posX, offsetY + step * 3 + 3, editW, editH, gui.window2, "") 
gui.carRegionNewEdit = twsGUI:createEdit(posX + editW + spacing, offsetY + step * 3 + 2, editW2, editH, gui.window2, "")

gui.carplateButton = twsGUI:createButton(posX + editW + editW2 + spacing*2, offsetY + step * 3 + 3, 143, editH, gui.window2, "Применить")

-- drawing a square colored by name and some carNumbers text
addEventHandler("onClientRender", root,
	function()
		if twsGUI:isVisible(gui.window1) then
			local r = localPlayer:getData("nameColor_R")
			local g = localPlayer:getData("nameColor_G")
			local b = localPlayer:getData("nameColor_B")

			if not (r or g or b) then
				return
			end

			color = tocolor(r, g, b)

			local b = 0.5
			dxDrawRectangle(colorSquareX - b, colorSquareY - b, colorSquareW + b*2, colorSquareH + b*2, tocolor(20, 20, 20))
			dxDrawRectangle(colorSquareX, colorSquareY, colorSquareW, colorSquareH, color)
		elseif twsGUI:isVisible(gui.window2) then
			local x, y, w, h

			-- current number
			x, y = twsGUI:getPosition(gui.carNumberEdit)
			x, y = windowsX + x, windowsY + y + 1
			w, h = twsGUI:getSize(gui.carNumberEdit)
			dxDrawText(carNumberText, x, y, x + w, y + h, tocolor(255, 255, 255), 1, numbersFont, "center", "center") 
			-- current region
			x, y = twsGUI:getPosition(gui.carRegionEdit)
			x, y = windowsX + x, windowsY + y + 1
			w, h = twsGUI:getSize(gui.carRegionEdit)
			dxDrawText(carNumberRegion, x, y, x + w, y + h, tocolor(255, 255, 255), 1, numbersFont, "center", "center") 

			-- new number
			x, y = twsGUI:getPosition(gui.carNumberNewEdit)
			x, y = windowsX + x, windowsY + y + 1
			w, h = twsGUI:getSize(gui.carNumberNewEdit)
			dxDrawText(carNumberTextNew, x, y, x + w, y + h, tocolor(255, 255, 255), 1, numbersFont, "center", "center") 

			-- new region
			x, y = twsGUI:getPosition(gui.carRegionNewEdit)
			x, y = windowsX + x, windowsY + y + 1
			w, h = twsGUI:getSize(gui.carRegionNewEdit)
			dxDrawText(carNumberRegionNew, x, y, x + w, y + h, tocolor(255, 255, 255), 1, numbersFont, "center", "center") 
		end
	end, true, "low"
)
