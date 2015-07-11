currentActiveEdit = nil

local function init(x, y, width, height, parent, text, masked)
	local control = getControlBase(x, y, width, height, parent)
	if not text then
		text = ""
	end
	control.text = text
	control.masked = false
	control.active = false

	control.defaultColor = colors.edit.border
	control.color = control.defaultColor
	return control
end

local function changeActiveEdit(newActiveEdit)
	if currentActiveEdit then
		currentActiveEdit.active = false
	end
	newActiveEdit.active = true
	currentActiveEdit = newActiveEdit
end

local function click(control)
	changeActiveEdit(control)
end

local function draw(control, x, y)
	local backgroundColor = colors.edit.background
	local textColor = colors.edit.text
	local borderColor = control.color

	if control.isEnabled then
		if control.isUnderMouse then
			backgroundColor = colors.edit.backgroundOver
		end
		if control.active and control.isEnabled then
			backgroundColor = colors.edit.backgroundActive
			textColor = tocolor(255, 255, 255, 255)

			-- TODO: Draw caret
			--local textWidth = dxGetTextWidth(control.text, 1, )
		end
	else
		borderColor = colors.edit.disabled_border
		textColor = colors.edit.disabled_text
		backgroundColor = colors.edit.disabled_background
	end
	dxDrawRectangle(x, y, control.width, control.height, borderColor)
	dxDrawRectangle(x + 1, y + 1, control.width - 2, control.height - 2, backgroundColor)
	local text = control.text
	if control.masked then
		text = string.gsub(text, ".", "*")
	end
	drawText(text, x + 5, y + 5, control.width - 10, control.height - 10, textColor, "text", "left", "center")

end

addControl("edit", {init = init, draw = draw, click = click}) 

local function gotoNextEdit()
	if not currentActiveEdit then
		return
	end

	if #currentActiveEdit.parent.children <= 1 then
		return
	end

	for k,v in ipairs(currentActiveEdit.parent.children) do
		if v.id ~= currentActiveEdit.id and v.type == "edit" then
			changeActiveEdit(v)
			return
		end
	end
end

-- Input
local repeatTimer = nil
local function keyHandler(key, state, isRepeating)
	if not state or not currentActiveEdit or not getKeyState(key) then
		return
	end

	if key == "backspace" then
		local before = currentActiveEdit.text
		local after = string.sub(currentActiveEdit.text, 1, -2)
		currentActiveEdit.text = after
		triggerEvent("onLuckyGUIChanged", resourceRoot, currentActiveEdit.id, before, after, true)
	elseif key == "tab" then
		gotoNextEdit()
	end

	if isTimer(repeatTimer) then
		killTimer(repeatTimer)
	end
	if not isRepeating then
		repeatTimer = setTimer(keyHandler, 400, 1, key, state, true)
	else
		repeatTimer = setTimer(keyHandler, 50, 1, key, state, true)
	end
end
addEventHandler("onClientKey", root, keyHandler)

local function characterHandler(character)
	if not currentActiveEdit then
		return
	end
	local unicode = string.byte(character)
	if unicode > 31 and unicode < 127 then
		local before = currentActiveEdit.text
		local after = currentActiveEdit.text .. character
		currentActiveEdit.text = after
		triggerEvent("onLuckyGUIChanged", resourceRoot, currentActiveEdit.id, before, after, false)
	end
end
addEventHandler("onClientCharacter", root, characterHandler)