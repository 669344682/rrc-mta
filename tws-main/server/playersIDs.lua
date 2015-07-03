-- playersIDs
-- Выдает каждому игроку уникальный ID при входе

local dataFieldName = "tws-id" -- название в element data
local players = {}

function givePlayerID(player)
	if not isElement(player) then
		return false
	end
	local id = -1
	for i = 1, #players + 1 do
		if not isElement(players[i]) then
			id = i
			break
		end
	end
	players[id] = player
	setElementData(player, dataFieldName, id)
	return id
end

function removePlayerID(player)
	if not isElement(player) then
		return false
	end
	local id = getPlayerID(player)
	if not id then
		return false
	end
	players[id] = nil
	setElementData(player, dataFieldName, false)
end

-- Event handlers

addEventHandler("onPlayerJoin", root, 
	function()
		givePlayerID(source)
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		logOut(source)
		removePlayerID(source)
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function()
		local players = {}
		for _, player in ipairs(getElementsByType("player")) do
			givePlayerID(player)
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for _, player in ipairs(getElementsByType("player")) do
			removePlayerID(player)
		end
	end
)

-- Exported

function getPlayerByID(id)
	if not id or type(id) ~= "number" then 
		return false
	end
	return players[id]
end

function getPlayerID(player)
	return getElementData(player, dataFieldName)
end

-- Возвращает массив игроков, у которых в имени присутствует подстрока
function getPlayersByPartOfName(namePart, caseSensitive)
	if not namePart then
		return
	end
	local players = getElementsByType("player")
	if not caseSensitive then
		namePart = string.lower(namePart)
	end
	local matchingPlayers = {}
	for i, player in ipairs(players) do
		local playerName = getPlayerName(player)
		if not caseSensitive then
			playerName = string.lower(playerName)
		end
		if string.find(playerName, namePart) then
			table.insert(matchingPlayers, player)
		end
	end
	return matchingPlayers
end