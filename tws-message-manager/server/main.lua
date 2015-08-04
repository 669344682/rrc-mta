manager = {}

function manager:showMessage(...)
	local arg = {...}
	local showTo = arg[1]
	if isElement(showTo) and getElementType(showTo) == "player" then
		triggerClientEvent(showTo, "tws-message.showMessageFromServer", resourceRoot, ...)
	elseif type(showTo) == "table" then
		for _, player in ipairs(showTo) do
			if isElement(player) and getElementType(player) == "player" then
				triggerClientEvent(player, "tws-message.showMessageFromServer", resourceRoot, ...)
			end
		end
	else
		table.remove(arg, 1)
		triggerClientEvent("tws-message.showMessageFromServer", resourceRoot, unpack(arg))
	end
end