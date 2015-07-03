local controls = {}
local controlElements = {}

function getControlBase(x, y, width, height, parent)
	local controlBase = {}
	controlBase.x = x
	controlBase.y = y
	controlBase.width = width
	controlBase.height = height
	controlBase.parent = parent
	controlBase.children = {}
	controlBase.visible = true
	controlBase.isEnabled = true
	controlBase.isUnderMouse = false
	controlBase.isMouseDown = false
	return controlBase
end

function addControl(controlTypeName, callbacks)
	controls[controlTypeName] = callbacks
end

function getControlElementByID(controlElementID)
	return controlElements[controlElementID]
end

function createControlElement(controlType, x, y, width, height, parentID, ...)
	local control = controls[controlType]
	if not control or not control.init then
		return false
	end
	local parent = getControlElementByID(parentID)
	local controlElement = control.init(x, y, width, height, parent, ...)
	setControlElementParent(controlElement, parent)
	controlElement.callbacks = control
	controlElement.type = controlType

	if controlType == "canvas" then
		table.insert(drawing.canvasElements, controlElement)
		controlElement.resource = ({...})[1]
	end

	table.insert2(controlElements, controlElement)
	controlElement.id = #controlElements

	controlElement.source = createElement("lucky-gui-" .. controlType)
	setElementData(controlElement.source, "lucky-gui-id", controlElement.id)
	return controlElement.id
end

function destroyControlElement(controlElement)
	if not controlElement then
		return false
	end
	removeControlElementChild(controlElement.parent, controlElement)
	if controlElement.callbacks.destroy then
		controlElement.callbacks.destroy()
	end
	if isElement(controlElement.source) then
		destroyElement(controlElement.source)
	end
	controlElements[controlElement.id] = nil
	return true
end

function setControlElementParent(controlElement, parentControlElement)
	if not parentControlElement then
		return false
	end
	if not parentControlElement.children then
		parentControlElement.children = {}
	end
	table.insert(parentControlElement.children, controlElement)
	controlElement.resource = parentControlElement.resource
	return true
end

function removeControlElementChild(parentControlElement, childControlElement)
	if not parentControlElement or not childControlElement then
		return false
	end
	if childControlElement.parent ~= parentControlElement then
		return false
	end
	if not parentControlElement.children then
		parentControlElement.children = {}
		return false
	end
	for i,v in ipairs(parentControlElement.children) do
		if v == childControlElement then
			table.remove(parentControlElement.children, i)
			break
		end
	end
	childControlElement = nil
	return true
end

local function destroyResourceCanvas()
	if not drawing.canvasElements then
		return
	end
	for i,v in ipairs(drawing.canvasElements) do
		if v.resource == source then
			local index = table.findByKey(controlElements, "resource", source)
			while index do
				table.remove(controlElements, index)
				index = table.findByKey(controlElements, "resource", source)
			end
			table.remove(drawing.canvasElements, i)
			break
		end
	end
end

addEventHandler("onClientResourceStop", root, destroyResourceCanvas)