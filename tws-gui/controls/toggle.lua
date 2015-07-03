local borderSize = 5
local boxWidth = 0.3

local function init(x, y, width, height, parent, state)
	local control = getControlBase(x, y, width, height, parent)
	control.state = state
	if control.state == nil then
		control.state = false
	end
	local parentx = parent.x
	if not parent.x then
		parentx = 0
	end
	control.boxPos = parentx + x + borderSize + 1
	return control
end

local function click(control)
	control.state = not control.state
end

local function draw(control, x, y)
	local mainColor = colors.toggle.mainOut
	local mainColor2 = colors.toggle.mainOut
	local borderColor = colors.toggle.border
	if control.isEnabled then
		if control.isUnderMouse then
			mainColor = colors.toggle.mainOver
		end
	else
		borderColor = colors.toggle.border_disabled
		mainColor = colors.toggle.main_disabled
		mainColor2 = colors.toggle.main_disabled
	end
	dxDrawRectangle(x, y, control.width, control.height, borderColor)
	dxDrawRectangle(x+1, y+1, control.width-2, control.height-2, mainColor2)
	dxDrawRectangle(x+borderSize, y+borderSize, control.width-borderSize*2, control.height-borderSize*2, colors.toggle.background)

	local left = x+borderSize + 1
	local right = x + control.width - borderSize - 1
	if control.state then
		control.boxPos = control.boxPos + (left - control.boxPos) * 0.5
	else
		control.boxPos = control.boxPos + ((right-control.width*boxWidth) - control.boxPos) * 0.5
	end
	dxDrawRectangle(control.boxPos, y+borderSize+1, control.width * boxWidth, control.height-borderSize*2 - 2, mainColor)
end

addControl("toggle", {init = init, draw = draw, click = click})