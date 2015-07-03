screenWidth, screenHeight = guiGetScreenSize()
-- Была ли нажата мышь в текущем кадре
wasMousePressedInCurrentFrame = false
-- Координаты точки последнего клика
mouseClickX = 0
mouseClickY = 0

-- Абсолютные координаты мыши 
function getMousePos()
	local mx, my = getCursorPosition()
	if not mx or not my then
		mx, my = 0, 0
	end
	return mx * screenWidth, my * screenHeight
end

function isMouseClick()
	return wasMousePressedInCurrentFrame
end

function updateMouseClick()
	wasMousePressedInCurrentFrame = false
end

addEventHandler("onClientClick", root, 
	function(button, state)
		if button ~= "left" or state ~= "down" then
			return
		end
		if isMTAWindowActive() then
			return
		end
		wasMousePressedInCurrentFrame = true
		mouseClickX, mouseClickY = getMousePos()
	end
)