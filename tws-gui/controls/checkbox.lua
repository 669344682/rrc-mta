local function init(x, y, width, height, parent, text, state)
	-- Width and height are default
	local control = getControlBase(x, y, width, height, parent)
	if not text then
		text = ""
	end
	control.text = text 
	if state == nil then
		state = false
	end
	control.state = state
	return control
end

local function click(control)
	control.state = not control.state
end

local function draw(control, x, y)
	local currentMainColor = colors.checkbox.mainOut
	if control.isUnderMouse then
		currentMainColor = colors.checkbox.mainOver
	end
	dxDrawRectangle(x, y, control.height, control.height, colors.checkbox.border)
	dxDrawRectangle(x+1, y+1, control.height-2, control.height-2, colors.checkbox.background)

	if control.state then
		dxDrawRectangle(x+4, y+4, control.height-8, control.height-8, currentMainColor)
	end

	drawText(control.text, x + control.height + 10, y, control.width, control.height, colors.label.text, "text", "left", "center")
end

addControl("checkbox", {init = init, draw = draw, click = click})