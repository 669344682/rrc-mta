local function init(x, y, width, height, parent, text)
	local control = getControlBase(x, y, width, height, parent)
	if not text then
		text = ""
	end
	control.text = text

	return control
end

local function draw(control, x, y)
	if control.isEnabled then
		local currentBackgroundColor = colors.button.backgroundOut
		if control.isUnderMouse then
			if control.height > 2 then
				currentBackgroundColor = colors.button.backgroundOver
			end
		end
		dxDrawRectangle(x, y, control.width, control.height, colors.button.border)
		dxDrawRectangle(x+1, y+1, control.width-2, control.height-2, currentBackgroundColor)
		drawText(control.text, x, y, control.width, control.height, colors.button.text, "title")
	else
		dxDrawRectangle(x, y, control.width, control.height, colors.button.disabled_border)
		dxDrawRectangle(x+1, y+1, control.width-2, control.height-2, colors.button.disabled_background)
		drawText(control.text, x, y, control.width, control.height, colors.button.disabled_text, "title")
	end
end

addControl("button", {init = init, draw = draw})