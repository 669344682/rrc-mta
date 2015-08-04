manager = {}

function manager:showMessage(...)
	local arg = {...}
	local showTo = arg[1]
	if isElement(showTo) and getElementType(showTo) == "player" then
		table.remove(arg, 1)
		triggerClientEvent(showTo, "tws-message.showMessageFromServer", resourceRoot, unpack(arg))
	elseif type(showTo) == "table" then
		table.remove(arg, 1)
		for _, player in ipairs(showTo) do
			if isElement(player) and getElementType(player) == "player" then
				triggerClientEvent(player, "tws-message.showMessageFromServer", resourceRoot, unpack(arg))
			end
		end
	elseif showTo == "all" then
		table.remove(arg, 1)
		triggerClientEvent("tws-message.showMessageFromServer", resourceRoot, unpack(arg))
	end
end