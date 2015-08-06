manager = {}

-----------
-- settings
-----------
manager.step = 32 -- альфа за кадр (появление/скрытие)
manager.w, manager.h = 320, 128 -- размер сообщений
manager.spacing = 10 -- расстояние между сообщениями
manager.offsetY = -20
manager.offsetX = 2
manager.x = screenX - manager.w - manager.spacing + manager.offsetX
manager.duration = 1000 -- время, за которое сообщение передвинется на исчезнувшее
manager.easingFunction = "InQuad" -- функция, по которой сдвигаем сообщения



speedoH = speedoH - manager.spacing + manager.offsetY -- при включенном спидометре уезжаем вниз немножко
------------

manager.imgAmount = 2 -- количество папок с img

manager.availableID = 1


-- части сообщения
manager.img = {
	["topleft"] = 	{w = 16, h = 16},
	["topright"] = 	{w = 16, h = 16},
	["botleft"] = 	{w = 16, h = 16},
	["botright"] = 	{w = 16, h = 16},

	["top"] = 		{w = 2, h = 16},
	["bottom"] = 	{w = 2, h = 16},
	["left"] = 		{w = 16, h = 128},
	["right"] = 	{w = 16, h = 128},

	["middle"] = 	{w = 2, h = 128},

	["close"] = 	{w = 8, h = 8}
}

-- делаем текстуры
for name, v in pairs(manager.img) do
	v.texture = dxCreateTexture("img/" .. name .. ".png", "argb", true, "clamp")
end


-- иконки
manager.icons = {
	["ok"] = {},
	["error"] = {},
	["list"] = {},
	["info"] = {},
	["plus"] = {},
	["minus"] = {},
	["question"] = {},
	["race"] = {},
	["warning"] = {},
	["cash"] = {},
	["cashbag"] = {}
}

-- делаем иконки
for name, v in pairs(manager.icons) do
	v.texture = dxCreateTexture("icons/" .. name .. ".png", "argb", true, "clamp")
	v.w = 32
	v.h = 32
end


-- позиции сообщений
manager.positions = {}
local yPos = screenY - manager.h - manager.spacing + manager.offsetY
for i = 1, 50 do
	table.insert(manager.positions, {y = yPos})
	yPos = yPos - manager.h - manager.spacing
end




manager.messages = {}



function manager:showMessage(title, text, icon, time, wordWrappingEnabled, buttonYes, buttonNo)
	local message = {}
	local direction = direction or "up"
	local wordWrappingEnabled = (wordWrappingEnabled == (nil or true)) and true or false

	message.direction = direction
	message.w = manager.w
	message.h = manager.h
	message.alpha = 0
	message.step = manager.step
	message.time = time
	message.now = getTickCount()
	message.id = self.availableID
	message.shown = false
	message.x = manager.x
	message.title = (title ~= "") and title or false
	message.text = text
	message.iconOffset = 0
	message.wordWrappingEnabled = wordWrappingEnabled
	message.buttonYes = buttonYes or false
	message.buttonNo = buttonNo or false
	message.buttonW = 100
	message.buttonH = 20

	if icon then
		for key, value in pairs(manager.icons) do
			if key == icon then
				message.icon = value
				message.iconOffset = value.w + 10
				break
			end
		end
	end

	local didWeFoundAPlaceForNewMessage = false
	for _, pos in ipairs(manager.positions) do
		if not pos.messageID then
			message.y = pos.y
			message.aboveSpeedo = pos.aboveSpeedo
			pos.messageID = message.id
			didWeFoundAPlaceForNewMessage = true
			break
		end
	end

	if didWeFoundAPlaceForNewMessage then
		table.insert(manager.messages, message)
		self.availableID = self.availableID + 1
		return message.id
	else
		return false
	end
end

function manager:hideMessage(id)
	local message = self:getMessageByID(id)
	if not message then
		return false
	end

	message.hide = true
	return true
end

function manager:hideAllMessages()
	for _, message in ipairs(self.messages) do
		self.hideMessage(message.id)
	end
end

function manager:getMessageByID(id)
	for _, message in ipairs(self.messages) do
		if message.id == id then
			return message
		end
	end
	return false
end

function manager:getPosByID(id)
	for index, pos in ipairs(self.positions) do
		if pos.messageID == id then
			return pos, index
		end
	end
	return false
end

--local test = dxCreateTexture("img/test.png", "argb", true, "clamp")

-- рисуем окна
addEventHandler("onClientRender", root,
	function()
		--dxDrawImage(400, 400, 256, 160, test)
		local img = manager.img
		local index = 1
		while index <= #manager.messages do
			local message = manager.messages[index]
			if not message.hidden then
				local X, Y = message.x, message.y
				local x, y, w, h = X, Y, message.w, message.h
				local rightX = (x + img.topleft.w + w - img.topleft.w*3) 
				local middleHeight = h - img.topleft.h * 2

				-- переезжаем при шатании спидометра
				local thisPos = manager:getPosByID(message.id)
				if thisPos then
					if (thisPos.aboveSpeedo and not message.aboveSpeedo) or (not thisPos.aboveSpeedo and message.aboveSpeedo) then
						message.aboveSpeedo = not message.aboveSpeedo
						message.move = {
							startTime = getTickCount(),
							endTime = getTickCount() + manager.duration,
							y = thisPos.y
						}
					end
				end

				-- смотрим, есть ли свободные места
				local thisPos, index = manager:getPosByID(message.id)
				if thisPos and index then
					if index > 1 then
						local nextPos = manager.positions[index - 1]
						if nextPos.messageID == nil then
							thisPos.messageID = nil
							nextPos.messageID = message.id

							if not message.move then
								message.move = {
									startTime = getTickCount(),
									endTime = getTickCount() + manager.duration,
									y = nextPos.y
								}
							else
								local now = getTickCount()
								local elapsedTime = now - message.move.startTime
								message.move = {
									startTime = message.move.startTime + elapsedTime,
									endTime = message.move.endTime + elapsedTime,
									y = nextPos.y
								}
							end
						end
					end
				end

				-- двигаем сообщение, если нужно
				if message.move then
					local now = getTickCount()
					local elapsedTime = now - message.move.startTime
					local progress = elapsedTime / manager.duration

					if progress >= 1 then
						progress = 1
					end
					
					local fAnimationTime = getEasingValue(progress, manager.easingFunction)

					message.y = message.y + (message.move.y - message.y) * fAnimationTime

					if progress >= 1 then
						message.move = nil
					end
				end
			

				-- проверяем время
				if not message.hide and message.time then
					if getTickCount() > (message.now + message.time) then
						manager:hideMessage(message.id)
					end
				end


				-- show
				if not message.shown then
					message.alpha = message.alpha + message.step

					if message.alpha >= 255 then
						message.alpha = 255
						message.shown = true
					end
				end

				-- hide
				if message.hide then
					message.alpha = message.alpha - message.step

					if message.alpha <= 0 then
						message.alpha = 0
						message.hidden = true
					end

					if message.hidden then
						local pos = manager:getPosByID(message.id)
						if pos then
							pos.messageID = nil
						end
					end
				end

				-- рисование самого сообщения

				-- alpha
				bgColor = tocolor(255, 255, 255, message.alpha)


				-- top left
				dxDrawImage(x, y, img.topleft.w, img.topleft.h, img.topleft.texture, 0, 0, 0, bgColor)

				-- left
				y = y + img.topleft.h
				dxDrawImage(x, y, img.left.w, middleHeight, img.left.texture, 0, 0, 0, bgColor)

				-- bottom left
				y = y + middleHeight
				dxDrawImage(x, y, img.botleft.w, img.botleft.h, img.botleft.texture, 0, 0, 0, bgColor)

				-- top
				x = X + img.topleft.w
				y = Y
				dxDrawImage(x, y, rightX - X, img.top.h, img.top.texture, 0, 0, 0, bgColor)
				x = x + 2

				-- middle
				x = X + img.topleft.w
				y = Y + img.topleft.h
				dxDrawImage(x, y, rightX - X, middleHeight, img.middle.texture, 0, 0, 0, bgColor)
				x = x + 2

				-- bottom
				x = X + img.topleft.w
				y = y + middleHeight
				dxDrawImage(x, y, rightX - X, img.bottom.h, img.bottom.texture, 0, 0, 0, bgColor)

				-- topright
				x = rightX + img.topleft.w
				y = Y
				dxDrawImage(x, y, img.topright.w, img.topright.h, img.topright.texture, 0, 0, 0, bgColor)

				-- right
				y = y + img.topleft.h
				dxDrawImage(x, y, img.right.w, middleHeight, img.right.texture, 0, 0, 0, bgColor)

				-- bottom right
				y = y + middleHeight
				dxDrawImage(x, y, img.botright.w, img.botright.h, img.botright.texture, 0, 0, 0, bgColor)

				-- close icon
				x = X + message.w - img.close.w*2
				y = Y + img.close.h
				dxDrawImage(x, y, img.close.w, img.close.h, img.close.texture, 0, 0, 0, bgColor)

				-- icon
				if message.icon then
					dxDrawImage(X + img.topleft.w, Y + img.topleft.h, message.icon.w, message.icon.h, message.icon.texture, 0, 0, 0, bgColor)
				end

				-- buttons
				local cursorX, cursorY
				if message.buttonYes or message.buttonNo then
					cursorX, cursorY = getCursorPosition()
					if cursorX and cursorY then
						cursorX, cursorY = cursorX * screenX, cursorY * screenY
					end

					message.buttonY = Y + message.h - img.botleft.h - message.buttonH
					message.buttonYesX = (message.icon and message.icon.w or 0) + X + img.botleft.w
					message.buttonNoX = X + message.w - img.botright.w - message.buttonW

					y = message.buttonY
					w = message.buttonW
					h = message.buttonH
				end

				-- yes button
				if message.buttonYes then
					local color = tocolor(0, 40, 51, message.alpha)
					if cursorX and cursorY then
						if utils.isPointInRect(cursorX, cursorY, message.buttonYesX, message.buttonY, message.buttonW, message.buttonH) then
							color = tocolor(0, 40 * 1.2, 51 * 1.2, message.alpha)
						end
					end
					x = message.buttonYesX
					dxDrawRectangle(x-1, y-1, w+2, h+2, tocolor(0, 0, 0, message.alpha))
					dxDrawRectangle(x, y, w, h, color)
					dxDrawText(message.buttonYes, x, y, x+w, y+h, bgColor, 1, "default", "center", "center")
				end

				-- no button
				if message.buttonNo then
					local color = tocolor(0, 40, 51, message.alpha)
					if cursorX and cursorY then
						if utils.isPointInRect(cursorX, cursorY, message.buttonNoX, message.buttonY, message.buttonW, message.buttonH) then
							color = tocolor(0, 40 * 1.2, 51 * 1.2, message.alpha)
						end
					end
					x = message.buttonNoX
					dxDrawRectangle(x-1, y-1, w+2, h+2, tocolor(0, 0, 0, message.alpha))
					dxDrawRectangle(x, y, w, h, color)
					dxDrawText(message.buttonNo, x, y, x+w, y+h, bgColor, 1, "default", "center", "center")
				end


				-- text, title
				if message.title then
					dxDrawText(message.title, X + img.topleft.w + message.iconOffset, Y + img.topleft.h, img.topleft.w + rightX, Y + img.topleft.h + middleHeight, bgColor, 1, "default-bold", "left", "top", false, false, false, true)
					dxDrawText(message.text, X + img.topleft.w + message.iconOffset, Y + img.topleft.h + 20, img.topleft.w + rightX, Y + img.topleft.h + middleHeight, bgColor, 1, "default", "left", "top", false, message.wordWrappingEnabled, false, not message.wordWrappingEnabled)
				else
					dxDrawText(message.text, X + img.topleft.w + message.iconOffset, Y + img.topleft.h, img.topleft.w + rightX, Y + img.topleft.h + middleHeight, bgColor, 1, "default", "left", "top", false, message.wordWrappingEnabled, false, not message.wordWrappingEnabled)
				end
			else
				table.remove(manager.messages, index)
				index = index - 1
			end

			index = index + 1
		end
	end
)

-- следим за спидометром
addEventHandler("onClientRender", root,
	function()
		for _, pos in ipairs(manager.positions) do
			if localPlayer:getData("isSpeedoVisible") and not pos.aboveSpeedo then
				pos.y = pos.y - speedoH
				pos.aboveSpeedo = true
			elseif not localPlayer:getData("isSpeedoVisible") and pos.aboveSpeedo then
				pos.y = pos.y + speedoH
				pos.aboveSpeedo = false
			end
		end
	end
)

-- следим за курсором
addEventHandler("onClientRender", root,
	function()
		if isCursorShowing() then
			local cursorX, cursorY
			
			cursorX, cursorY = getCursorPosition()
			cursorX, cursorY = cursorX * screenX, cursorY * screenY

			manager.mouseClick1 = manager.mouseClick2
			manager.mouseClick2 = getKeyState("mouse1")


			for _, message in ipairs(manager.messages) do

				if utils.isPointInRect(cursorX, cursorY, message.x, message.y, message.w, message.h) then
					if not manager.mouseClick1 and manager.mouseClick2 then
						if not message.clicked then
							local button = false

							if message.buttonYes then
								if utils.isPointInRect(cursorX, cursorY, message.buttonYesX, message.buttonY, message.buttonW, message.buttonH) then
									button = "yes"
								end
							end

							if message.buttonNo then
								if utils.isPointInRect(cursorX, cursorY, message.buttonNoX, message.buttonY, message.buttonW, message.buttonH) then
									button = "no"
								end
							end

							triggerEvent("tws-message.onClientMessageClick", root, message.id, button)
						end
					end

					break
				end
			end

		end
	end
)


addEvent("tws-message.onClientMessageClick", true)
addEventHandler("tws-message.onClientMessageClick", resourceRoot,
	function(id, button)
		local message = manager:getMessageByID(id)
		if not (message.buttonYes or message.buttonNo) then
			manager:hideMessage(id)
			message.clicked = true
			triggerServerEvent("tws-message.onClientMessageClick", root, id, button)
		else
			if button then
				manager:hideMessage(id)
				message.clicked = true
				triggerServerEvent("tws-message.onClientMessageClick", root, id, button)
			end
		end
	end
)

addEvent("tws-message.showMessageFromServer", true)
addEventHandler("tws-message.showMessageFromServer", resourceRoot,
	function(...)
		manager:showMessage(...)
	end
)