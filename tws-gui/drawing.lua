drawing = {}
drawing.canvasElements = {}
local screenWidth, screenHeight = guiGetScreenSize()
local mouseX, mouseY = 0, 0
local isMousePressed = false
local isMouseDown = false
local clickedElement = nil

local fonts = {}

local function createFont(path, ...)
	local font = dxCreateFont(path, ...)
	if not font then
		outputDebugString("lucky-gui: Couldn't load font: '" .. path .. "'")
		return "arial"
	end
	return font
end

fonts.title = createFont("fonts/OpenSans-Regular.ttf", 12, false)
fonts.text = createFont("fonts/OpenSans-Regular.ttf", 12, false)

function drawText(text, x, y, width, height, color, style, alignX, alignY)
	if not alignX then
		alignX = "center"
	end
	if alignY ~= "top" or alignY ~= "bottom" or alignY ~= "center" then
		alignY = "center"
	end
	if style == "title" then
		dxDrawText(text, x+1, y+1, x + width+1, y + height+1, tocolor(0, 0, 0, 100), 1, fonts.title, alignX, alignY)
		dxDrawText(text, x, y, x + width, y + height, color, 1, fonts.title, alignX, alignY)
	elseif style == "text" then
		dxDrawText(text, x, y, x + width, y + height, color, 1, fonts.text, alignX, alignY, false, false, false, true)
	end
end

function drawControlElement(controlElement)
	if not controlElement.visible then
		return
	end
	if controlElement.callbacks.draw then
		-- Calculate screen position
		local posX = controlElement.x + controlElement.parent.x
		local posY = controlElement.y + controlElement.parent.y

		-- Check is mouse over
		if	mouseX >= posX and mouseX <= posX + controlElement.width and
			mouseY >= posY and mouseY <= posY + controlElement.height 
		then
			if isMousePressed then
				clickedElement = controlElement
			end
			if not controlElement.isUnderMouse then
				controlElement.isUnderMouse = true
			end
		else
			if controlElement.isUnderMouse then
				controlElement.isUnderMouse = false
			end
		end

		-- Draw
		controlElement.callbacks.draw(controlElement, posX, posY)
	end

	-- Draw children
	-- RECURSION 
	if controlElement.children then
		for _,v in pairs(controlElement.children) do
			drawControlElement(v)
		end
	end
end

local function draw()
	-- Mouse possiton
	mouseX, mouseY = getCursorPosition()
	if mouseX and mouseY then
		mouseX = mouseX * screenWidth
		mouseY = mouseY * screenHeight
	else
		mouseX = 0
		mouseY = 0
	end

	-- Mouse state
	if not isMouseDown and getKeyState("mouse1") then
		isMousePressed = true
	else
		isMousePressed = false
	end
	isMouseDown = getKeyState("mouse1")

	-- Drawing
	for _,v in pairs(drawing.canvasElements) do
		drawControlElement(v)
	end

	if clickedElement then
		-- Make active edit inactive
		if currentActiveEdit then
			if clickedElement.id ~= currentActiveEdit.id then
				currentActiveEdit.active = false
				currentActiveEdit = nil
			end
		end

		if clickedElement.isEnabled then
			if clickedElement.callbacks.click then
				clickedElement.callbacks.click(clickedElement, mouseX, mouseY)
			end
			triggerEvent("onLuckyGUIClick", clickedElement.source, clickedElement.id)
		end
		clickedElement = nil

		if currentActiveEdit then
			guiSetInputEnabled(true)
		else
			guiSetInputEnabled(false)
		end
	end
end
addEventHandler("onClientRender", root, draw, false, "low+100")