-- test

local FONT_BIAS = 4 -- наложение (расстояние между цифрами)
local REFRESH_FRAME_RATE = 3 -- обновление скорости

local isSpeedoVisible = true
local screenX, screenY = guiGetScreenSize()
local speedometer = dxCreateTexture("speedo.png", "argb", true, "clamp")
local pointer = dxCreateTexture("pointer.png", "argb", true, "clamp")
local pointerOffsetY = 12
local pointerOffsetR = -128
local speedoW, speedoH = speedometer:getSize()
local speedoX, speedoY = screenX - speedoW - 100, screenY - speedoH - 50
local icon_hover = dxCreateTexture("icons/hover.png", "argb", true, "clamp")
local icon_move = dxCreateTexture("icons/move.png", "argb", true, "clamp")
local isHovering1, isHovering2 = false, false
local lastCursorPosX, lastCursorPosY
local isSpeedoPosChanged = false
local font = {}

-- читаем настройки (speedoX, speedoY)
local node = xmlLoadFile("settings.xml")
if node then
	node_x = node:findChild("speedoX", 0)
	node_y = node:findChild("speedoY", 0)

	speedoX = tonumber(node_x.value)
	speedoY = tonumber(node_y.value)
end

addEvent("onSpeedoPosChanged", false)

for i = 0, 9 do
	font[i] = {}
	font[i].texture = dxCreateTexture("FontPNG/" .. tostring(i) .. ".png", "argb", true, "clamp")
	font[i].width, font[i].height = font[i].texture:getSize()
end

addCommandHandler("cursor", function() showCursor(not isCursorShowing()) end)

function getElementSpeed(theElement, unit)
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3.create(getElementVelocity(theElement)) * mult).length
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


local vehicleSpeed, frameCounter = 0, 0
addEventHandler("onClientPreRender", root,
	function()
		if localPlayer.vehicle and isSpeedoVisible then
			local speed, tab = vehicleSpeed, {}

			local trueSpeed = math.round(getElementSpeed(localPlayer.vehicle, 1)^1.02)
				
			-- обновление скорости по REFRESH_FRAME_RATE 

			frameCounter = frameCounter + 1
			if frameCounter >= REFRESH_FRAME_RATE then
				vehicleSpeed = math.round(getElementSpeed(localPlayer.vehicle, 1)^1.02)
				frameCounter = 0
			end

			-- переводим скорость из string в вид таблицы	
			for i = 1, string.len(speed) do
				tab[i] = string.sub(speed, i, i)
			end

			-- сам спидометр
			dxDrawImage(speedoX, speedoY, speedoW, speedoH, speedometer)

			local angle = pointerOffsetR + trueSpeed * 0.82
			dxDrawImage(speedoX, speedoY + pointerOffsetY, speedoW, speedoH, pointer, angle < 126 and angle or 126)

			-- рисуем цифры с центрированием по горизонтали (с поддержкой разной ширины цифр)
			local width_all = 0
			for i, n in ipairs(tab) do
				width_all = width_all + font[tonumber(n)].width - FONT_BIAS
			end
			local width
			if #tab == 1 then
				width = speedoX + speedoW/2 + 1
			elseif #tab == 2 then
				width = speedoX + speedoW/2 
			else
				width = speedoX + speedoW/2 - 7
			end
			local height = speedoY + speedoH/2
			for i, n in ipairs(tab) do
				n = tonumber(n)

				dxDrawImage(math.floor(width - width_all/2), math.floor(height - font[n].height/2), font[n].width, font[n].height, font[n].texture)

				width = width + font[n].width - FONT_BIAS
			end

			
		end
	end
)

addEventHandler("onClientPreRender", root,
	function()
		if not isSpeedoVisible then 
			return
		end
		if not isCursorShowing() then
			if lastCursorPosX or lastCursorPosY then
				lastCursorPosX, lastCursorPosY = nil, nil
			end
			return
		end

		local isHovering = false
		local mouseX, mouseY = getCursorPosition()
		mouseX, mouseY = screenX * mouseX, screenY * mouseY

		-- если курсор на спидометре
		if (mouseX >= speedoX) and (mouseY >= speedoY) then
			if (mouseX <= speedoX + speedoW) and (mouseY <= speedoY + speedoH) then
				isHovering = true
			end
		end

		if isHovering then
			local w, h = 16, 16
			if getKeyState("mouse1") then -- если mouse1 зажата, рисуем icon_move
				dxDrawImage(mouseX - w/2, mouseY - h/2, w, h, icon_move)

				local mouseX, mouseY = getCursorPosition()
				mouseX, mouseY = screenX * mouseX, screenY * mouseY

				local differenceX = mouseX - lastCursorPosX
				local differenceY = mouseY - lastCursorPosY

				speedoX = speedoX + differenceX
				speedoY = speedoY + differenceY

				-- ограничение по X
				if speedoX + speedoW/2 > screenX then
					speedoX = screenX - speedoW/2
				elseif speedoX + speedoW/2 < 0 then
					speedoX = 0 - speedoW/2
				end

				-- ограничение по Y
				if speedoY + speedoH/2 > screenY then
					speedoY = screenY - speedoH/2
				elseif speedoY + speedoH/2 < 0 then
					speedoY = 0 - speedoH/2
				end

				isSpeedoPosChanged = true
			else -- рисуем icon_hover при наведении
				dxDrawImage(mouseX - w/2, mouseY - h/2, w, h, icon_hover)
			end
		end

		-- меняем прозрачность курсора при наведении и отдалении от спидометра (один раз)
		isHovering1 = isHovering2
		isHovering2 = isHovering
		if not isHovering1 and isHovering2 then
			setCursorAlpha(0)
		elseif isHovering1 and not isHovering2 then
			setCursorAlpha(255)

			if isSpeedoPosChanged then
				isSpeedoPosChanged = false
				triggerEvent("onSpeedoPosChanged", resourceRoot)
			end
		end

		lastCursorPosX, lastCursorPosY = mouseX, mouseY
	end
)

addEventHandler("onSpeedoPosChanged", resourceRoot,
	function()
		-- сохранение координат при изменении положения спидометра
		local node, node_x, node_y
		
		node = xmlLoadFile("settings.xml")

		if not node then
			node = xmlCreateFile("settings.xml", "settings")
			
			node:createChild("speedoX")
			node:createChild("speedoY")
		end

		node_x = node:findChild("speedoX", 0)
		node_y = node:findChild("speedoY", 0)

		node_x.value = speedoX
		node_y.value = speedoY
		
		node:saveFile()
		node:unload()
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		setCursorAlpha(255)
	end
)

function setVisible(isVisible)
	isSpeedoVisible = isVisible == true
end