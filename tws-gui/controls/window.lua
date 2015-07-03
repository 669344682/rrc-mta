local frameSize = 3
local headerSize = 20

local function init(x, y, width, height, parent, text, showHeader)
	local control = getControlBase(x, y, width, height, parent)
	if not text then
		text = ""
	end
	control.text = text

	if showHeader == nil then
		showHeader = true
	end
	if not showHeader then
		headerSize = 0
		control.text = ""
	end
	return control
end

local function draw(control, x, y)
	dxDrawRectangle(x - frameSize - 1, y - headerSize - frameSize - 1, control.width + frameSize*2 + 1, control.height + headerSize + frameSize*2 + 1, colors.window.border)
	dxDrawRectangle(x - frameSize, y - headerSize - frameSize, control.width + frameSize*2, control.height + headerSize + frameSize*2, colors.window.frame)
	dxDrawRectangle(x, y, control.width, control.height, colors.window.background)
	drawText(control.text, x, y - headerSize - frameSize, control.width, headerSize + frameSize, colors.window.header_text, "title")
end

addControl("window", {init = init, draw = draw})