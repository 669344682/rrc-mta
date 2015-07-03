local function init(x, y, width, height, parent, state)
	local control = getControlBase(x, y, width, height, parent)
	-- TODO
	return control
end

local function click(control)
	-- TODO: Select element
end

local function draw(control, x, y)
	-- TODO
end

addControl("list", {init = init, draw = draw, click = click})