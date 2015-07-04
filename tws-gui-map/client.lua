isMapVisible = false
isMapEnabled = true

local isDragging = false
local dragX, dragY = 0, 0
local isDragMovedCursor = false

local movingSpeed = 20
local mouseMovingScreenOffset = 30 * mainScale

local function mapClick()
	Map.setWaypoint()
end

local function updateDragging()
	local mx, my = getMousePos()

	if isDragging then
		local x, y = mx - dragX, my - dragY
		if getDistanceBetweenPoints2D(x, y, Map.x, Map.y) > 2 then
			Map.moveTo(x, y)
			isDragMovedCursor = true
		end
	end

	if getKeyState("mouse1") and not isDragging then
		dragX, dragY = mx - Map.x, my - Map.y
		isDragging = true
		isDragMovedCursor = false
	elseif not getKeyState("mouse1") and isDragging then
		isDragging = false
		if not isDragMovedCursor then
			--mapClickLeft()
		end
	end
end

local function updateMoving()
	local speed = movingSpeed / Map.scale
	local moveX = 0
	local moveY = 0
	if getKeyState("arrow_l") then
		moveX = speed
	elseif getKeyState("arrow_r") then
		moveX = -speed 
	end
	if getKeyState("arrow_u") then
		moveY = speed
	elseif getKeyState("arrow_d") then
		moveY = -speed
	end

	local mx, my = getMousePos()
	if mx < mouseMovingScreenOffset then
		moveX = speed 
	end
	if mx > screenWidth - mouseMovingScreenOffset then
		moveX = -speed 
	end
	if my < mouseMovingScreenOffset then
		moveY = speed 
	end
	if my > screenHeight - mouseMovingScreenOffset then
		moveY = -speed 
	end

	if moveX ~= 0 or moveY ~= 0 then
		Map.moveTo(Map.x + moveX, Map.y + moveY)
	end
end

local function draw()
	dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0))
	Map.draw()
	--drawLines()
	Map.update()
	dxDrawScreenShadow()
	if Map.currentCity ~= "Unknown" then
		captionText.text = Map.currentCity .. " (" .. Map.currentZone .. ")"
	else
		captionText.text = ""
	end
	captionText.draw()
	buttonsTips.draw(0)
	updateDragging()
	updateMoving()
end

function showMap()
	if isMapVisible or not getElementData(localPlayer, "tws-accountName") or not exports["tws-utils"]:isHUDVisible() then
		return
	end
	
	--setCursorAlpha(0)
	Map.moveToPlayer()
	captionText.start(60 * mainScale, "Карта", "Los Santos")
	buttonsTips.start({"КУРСОР - ПЕРЕМЕЩЕНИЕ", "КОЛЕСО - ПРИБЛИЖЕНИЕ", "ПКМ - УСТАНОВИТЬ ЦЕЛЬ", "M - ЗАКРЫТЬ КАРТУ"})
	isMapVisible = true
	exports["tws-utils"]:toggleHUD(false, true)
	
	setTimer(
		function() 
			showCursor(true)
			addEventHandler("onClientRender", root, draw)
		end
	, 50, 1)
end

function hideMap()
	if not isMapVisible then
		return
	end
	removeEventHandler("onClientRender", root, draw)
	showCursor(false)
	setCursorAlpha(255)
	buttonsTips.stop()
	isMapVisible = false
	exports["tws-utils"]:toggleHUD(true, true)
end

function toggleMap()
	if isMapVisible then
		hideMap()
	elseif isMapEnabled then
		showMap()
	end
end

function isVisible()
	return isMapVisible
end

function setVisible(v)
	if isMapVisible then
		if not v then
			hideMap()
		end
	else
		if v then
			showMap()
		end
	end
end

function setEnabled(isEnabled)
	if not isEnabled and isMapVisible then
		setVisible(false)
	end
	isMapEnabled = isEnabled
end

addEventHandler("onClientKey", root,
	function(keyName, state)
		if isMTAWindowActive() then
			return
		end
		if keyName == "m" and state then
			toggleMap()
		end
		if not isMapVisible then
			return
		end
		if keyName == "mouse_wheel_down" then
			Map.zoomOut()
		elseif keyName == "mouse_wheel_up" then
			Map.zoomIn()
		elseif keyName == "mouse2" and state then
			mapClick()
		end
	end
)

toggleControl("radar", false)
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		toggleControl("radar", false)
	end
)

setTimer(
	function()
		toggleControl("radar", false)
	end
, 100, 500)