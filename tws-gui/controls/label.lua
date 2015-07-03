local function init(x, y, width, height, parent, text, alignX, alignY)
	local control = getControlBase(x, y, width, height, parent)
	if not text then
		text = ""
	end
	if not alignX then
		alignX = "left"
	end
	if not alignY then
		alignY = "top"
	end
	control.alignX = alignX
	control.alignY = alignY
	control.text = text
	
	control.defaultColor = colors.label.text
	control.color = control.defaultColor
	return control
end

local function draw(control, x, y)
	drawText(control.text, x, y, control.width, control.height, control.color, "text", control.alignX, control.alignY)
end

addControl("label", {init = init, draw = draw})