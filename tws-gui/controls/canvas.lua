local function init(x, y, width, height, parent, resource)
	local control = getControlBase(x, y, width, height, parent)
	control.resource = resource
	return control
end

addControl("canvas", {init = init})