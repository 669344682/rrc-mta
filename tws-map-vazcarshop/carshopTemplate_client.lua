local closeGatesWhenFar = true

local gates = {
	id = "vazcarshop-gates",
	opened = {1144.936, -1860.884, 20.500},
	closed = {1144.936, -1860.884, 15.200},
	time = 3000
}

function setDoorState(openedClosed)
	local gatesObject = getElementByID(gates.id)
	if not isElement(gatesObject) then
		outputDebugString("Gates object (id='" .. tostring(gates.id) .. "') not found")
		return
	end
	if openedClosed == "opened" then
		moveObject(gatesObject, gates.time, gates.opened[1], gates.opened[2], gates.opened[3])
	elseif openedClosed == "closed" then
		moveObject(gatesObject, gates.time, gates.closed[1], gates.closed[2], gates.closed[3])
	else
		outputDebugString("[" .. tostring(gates.id) .. "] Unknown gates state: '" .. tostring(openedClosed) .. "'")
	end
end

-- Закрытие двери при отдалении игрока
if closeGatesWhenFar then
	addEventHandler("onClientResourceStart", resourceRoot,
		function()
			local gatesObject = getElementByID(gates.id)
			if isElement(gatesObject) then
				addEventHandler("onClientElementStreamOut", gatesObject,
					function()
						setDoorState("closed")
					end)
			end
		end
	)
end