-- functionName ( required_argument1, required_argument2, [ optional_argument1, argumentType argument])
-- argument = default_value

function destroy(element)
	local element = getControlElementByID(element)
	if element then
		return destroyControlElement(element)
	end
	return false
end

--[[function setProperty(element, property, value)
	if not value then 
		return false
	end
	local element = getControlElementByID(element)
	if element then
		element[property] = value
	end
end

function getProperty(element, property, value)
	local element = getControlElementByID(element)
	if element then
		return element[property]
	end
	return false
end]]

function getSource(element)
	local element = getControlElementByID(element)
	if element then
		return element.source
	end
	return false
end

function getElement(source)
	if isElement(source) then
		return getElementData(source, "lucky-gui-id")
	end
	return false
end

function setText(element, text)
	local element = getControlElementByID(element)
	if element and element.text then
		if not text then
			text = ""
		end
		element.text = text
		return true
	end
	return false
end

function getText(element)
	local element = getControlElementByID(element)
	if element and element.text then
		return element.text
	end
	return false
end

function setPosition(element, x, y)
	if not x or not y then
		return false
	end
	local element = getControlElementByID(element)
	if element and element.x and element.y then
		element.x = x
		element.y = y
		return true
	end
	return false
end

function getPosition(element)
	local element = getControlElementByID(element)
	if element then
		return element.x, element.y
	end
	return false
end

function setSize(element, width, height)
	if not width or not height then
		return false
	end
	local element = getControlElementByID(element)
	if element and element.width and element.height then
		if width >= 0 then
			element.width = width
		end
		if height >= 0 then
			element.height = height
		end
		return true
	end
	return false
end

function getSize(element)
	local element = getControlElementByID(element)
	if element then
		return element.width, element.height
	end
	return false
end


function setEnabled(element, isEnabled)
	local element = getControlElementByID(element)
	if element then
		if isEnabled == nil then
			isEnabled = false
		end
		element.isEnabled = isEnabled
	end
end

function isEnabled(element)
	local element = getControlElementByID(element)
	if element then
		return element.isEnabled
	end
	return false
end

function setVisible(element, isVisible)
	local element = getControlElementByID(element)
	if element then
		if isVisible == nil then
			isVisible = false
		end
		element.visible = isVisible
	end
end

function isVisible(element)
	local element = getControlElementByID(element)
	if element then
		if element.visible == nil then
			element.visible = false
		end
		return element.visible
	end
	return false
end

-- createCanvas ( resourceRootElement )
function createCanvas(resource)
	return createControlElement("canvas", 0, 0, 0, 0, nil, resource)
end

-- createWindow ( x, y, width, height, parent, [ string title, bool showHeader ] )
-- title = ""
-- showHeader = true
function createWindow(...)
	return createControlElement("window", ...)
end

-- createButton ( x, y, width, height, parent, [ string text ] )
-- text = ""
function createButton(...)
	return createControlElement("button", ...)
end

-- createLabel ( x, y, width, height, parent, [ string text ] )
-- text = ""
function createLabel(...)
	return createControlElement("label", ...)
end

-- createToggle ( x, y, width, height, parent, [ boolean state ] )
-- state = false
function createToggle(...)
	return createControlElement("toggle", ...)
end

function getToggleState(toggle)
	local toggle = getControlElementByID(toggle)
	if toggle then
		return toggle.state
	end
	return false
end

function setToggleState(toggle, state)
	local toggle = getControlElementByID(toggle)
	if toggle then
		toggle.state = state
		return true
	end
	return false
end

function createCheckbox(...)
	return createControlElement("checkbox", ...)
end

function getCheckboxState(checkbox)
	local checkbox = getControlElementByID(toggle)
	if checkbox then
		return checkbox.state
	end
	return false
end

function createEdit(...)
	return createControlElement("edit", ...)
end

function setEditMasked(edit, masked)
	local element = getControlElementByID(edit)
	if element then
		if masked == nil then
			masked = false
		end
		element.masked = masked
	end
end

-- setColor ( element, [ color ] )
-- if "color" argument is nil then color will be reset to default
function setColor(element, color)
	local element = getControlElementByID(element)
	if element then
		if color then
			element.color = color
		else
			element.color = element.defaultColor
		end
	end
	return false
end
