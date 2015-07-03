local screenWidth, screenHeight = guiGetScreenSize()

local isMenuActive = false

-- Colors
local colors = {
	backgroundBlack = tocolor(0, 0, 0, 230), 
	backgroundMain = tocolor(0, 40, 51),
	buttonBorder = tocolor(0, 10, 20, 180),

	captionTextBackground = tocolor(0, 0, 0, 200),
	captionTextColor = tocolor(255, 255, 255)
}

-- Fonts 
local fonts = {
	carbon = dxCreateFont("fonts/carbon.ttf", 19 * mainScale, true),
	text = dxCreateFont("fonts/calibri.ttf", 14 * mainScale, true)	
}

local mainBlock = {
	height = 180 * mainScale,
	titleOffset = 60
}

local imageBlock = {
	width = 512 * 0.7,
	height = 288 * 0.7,

	infoHeight = 40,
	infoColor = tocolor(0, 0, 0, 240),

	space = 20,
	shadowColor = tocolor(0, 0, 0, 150)
}

local spawnButton = {
	text = "ВЫБРАТЬ АВТОМОБИЛЬ",
	width = imageBlock.width * 0.9,
	height = 50,
	space = 20,
	borderSize = 2
}

local cancelButton = {
	text = "Отмена",
	width = 80,
	height = 30,
	space = 20,
	borderSize = 2
}


local carsList = {}

local selectedCar = 1
local selectedCarTarget = 1

local function drawPreviewImage(offsetX, offsetY, name, image, isSelected)
	local imageAlpha = 100
	if isSelected then
		imageAlpha = 255
	end
	dxDrawImage(offsetX - 8, offsetY - 8, imageBlock.width + 16, imageBlock.height + 16, "images/shadow.png", 0, 0, 0, imageBlock.shadowColor)
	if not image then
		dxDrawImage(offsetX, offsetY, imageBlock.width, imageBlock.height, "images/nopic.png", 0, 0, 0, tocolor(255, 255, 255, imageAlpha))
	else
		dxDrawImage(offsetX, offsetY, imageBlock.width, imageBlock.height, image, 0, 0, 0, tocolor(255, 255, 255, imageAlpha))
	end
	dxDrawRectangle(offsetX, offsetY + imageBlock.height - imageBlock.infoHeight, imageBlock.width, imageBlock.infoHeight, imageBlock.infoColor)
	dxDrawTextRect(name, offsetX, offsetY + imageBlock.height - imageBlock.infoHeight, imageBlock.width, imageBlock.infoHeight, colors.captionTextColor, 1, fonts.text, "center", "center")
end

function draw()
	-- Затемнение экрана
	dxDrawRectangle(0, 0, screenWidth, screenHeight, colors.backgroundBlack)

	local offsetX = 0
	local offsetY = screenHeight / 2 - mainBlock.height / 2
	dxDrawImage(0, offsetY - 8, screenWidth, mainBlock.height + 16, "images/shadow.png", 0, 0, 0, tocolor(0, 0, 0, 150))
	dxDrawRectangle(0, offsetY, screenWidth, mainBlock.height, colors.backgroundMain)

	-- Заголовок
	--dxDrawText("★ ГАРАЖ ★", ct.x + 3, ct.y + 3 - 40, ct.x + ct.width + 3, ct.y + ct.height + 3, getColor(colors.black, 200), 1, carbonFont)
	dxDrawTextRect("★ ВЫБЕРИТЕ AВТОМОБИЛЬ ★", 0,  offsetY - mainBlock.titleOffset, screenWidth, mainBlock.titleOffset, colors.captionTextColor, 1, fonts.carbon, "center", "center")

	-- Изображение
	local imagesTotalWidth = (imageBlock.width + imageBlock.space) * (selectedCar - 1) * 2
	offsetX = screenWidth / 2 - imagesTotalWidth / 2 - imageBlock.width / 2
	offsetY = offsetY + mainBlock.height / 2 - imageBlock.height / 2

	for i, carInfo in ipairs(carsList) do
		local isSelected = i == selectedCarTarget
		drawPreviewImage(offsetX, offsetY, carInfo.name, carInfo.texture, isSelected)
		local mx, my = getMousePos()
		if utils.isPointInRect(mx, my, offsetX, offsetY, imageBlock.width, imageBlock.height) then
			dxDrawRectangle(offsetX, offsetY, imageBlock.width, imageBlock.height, tocolor(255, 255, 255, 20))
			if isMouseClick() then
				selectedCarTarget = i
			end
		end
		offsetX = offsetX + imageBlock.width + imageBlock.space
	end

	selectedCar = selectedCar + (selectedCarTarget - selectedCar) * 0.2

	--dxDrawRectangle(screenWidth / 2 - spawnButton.width / 2 - spawnButton.borderSize, screenHeight / 2 + mainBlock.height / 2 + spawnButton.space - spawnButton.borderSize, spawnButton.width + spawnButton.borderSize * 2, spawnButton.height + spawnButton.borderSize * 2, colors.buttonBorder)

	updateMouseClick()
end

spawnButton.button = gui:createButton(screenWidth / 2 - spawnButton.width / 2, screenHeight / 2 + mainBlock.height / 2 + spawnButton.space, spawnButton.width, spawnButton.height, canvas, spawnButton.text)
cancelButton.button = gui:createButton(screenWidth / 2 - cancelButton.width / 2, screenHeight / 2 + mainBlock.height / 2 + spawnButton.height + spawnButton.space + cancelButton.space, cancelButton.width, cancelButton.height, canvas, cancelButton.text)
gui:setVisible(canvas, false)

function setupCarsList(list)
	if carsList and #carsList > 0 then
		for i, carInfo in ipairs(carsList) do
			if isElement(carInfo.texture) then
				destroyElement(carInfo.texture)
			end
		end
	end
	carsList = {}
	for i, carInfo in ipairs(list) do
		local texture
		if carInfo.texture then
			texture = dxCreateTexture(carInfo.texture)
		end
		table.insert(carsList, {name = carInfo.name, texture = texture})
	end
	selectedCarTarget = math.max(1, math.min(selectedCarTarget, #carsList))
	selectedCar = selectedCarTarget
end

function start()
	if not isMenuActive then
		toggleAllControls(false)
		if not selectedCarTarget then
			selectedCarTarget = 1
		end
		selectedCarTarget = math.max(1, math.min(selectedCarTarget, #carsList))
		selectedCar = selectedCarTarget
		gui:setVisible(canvas, true)
		addEventHandler("onClientRender", root, draw)
		isMenuActive = true
		previewImages:require(setupCarsList)
	else
		toggleAllControls(true)
		gui:setVisible(canvas, false)
		removeEventHandler("onClientRender", root, draw)
		isMenuActive = false
	end
end

addEvent("onLuckyGUIClick", false)
addEventHandler("onLuckyGUIClick", root, 
	function(element)
		if element == spawnButton.button then
			triggerServerEvent("tws-onCarmenuSelect", resourceRoot, selectedCarTarget)
		end
	end
)

function showCarmenu()
	if not isMenuActive then
		start()
	end
end

function hideCarmenu()
	if isMenuActive then
		start()
	end
end

addEvent("tws-onCarmenuServerSpawn", true)
addEventHandler("tws-onCarmenuServerSpawn", resourceRoot,
	function(response)
		if response.success then
			outputChatBox("Выбран автомобиль " .. tostring(carsList[selectedCarTarget].name), 0, 255, 0)
			hideCarmenu()
		else
			if response.info == "spawned" then
				outputChatBox("Этот автомобиль уже заспавнен", 255, 0, 0)
			elseif response.info == "nocar" then
				outputChatBox("Автомобиль, который вы пытаетесь заспавнить, не существует", 255, 0, 0)
			else
				outputChatBox("Не удалось заспавнить автомобиль", 255, 0, 0)
			end
		end
	end
)