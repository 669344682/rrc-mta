addCommandHandler("pay",
	function(player, cmd, idOrName, amount)
		if getPlayerLevel(player) <= 1 then
			outputChatBox("Деньги можно передавать только начиная со второго уровня!", player, 255, 0, 0)
			return
		end
		if not idOrName then
			outputChatBox("Неверно введена команда (/pay <id или ник> <количество>)", player, 255, 0, 0)
			return
		end
		local id = nil
		local name = nil
		if tonumber(idOrName) then
			id = tonumber(idOrName)
		else
			name = tostring(idOrName)
		end
		amount = tonumber(amount)
		if not amount then
			outputChatBox("Неверно введена команда (/pay <id или ник> <количество>)", player, 255, 0, 0)
			return
		end
		if amount <= 0 then
			outputChatBox("Неверное количество денег", player, 255, 0, 0)
			return
		end

		local player2 = nil
		if id then 
			player2 = getPlayerByID(id)
		elseif name then
			player2 = getPlayersByPartOfName(name, false)
		else
			return
		end
		if not isElement(player2) then
			outputChatBox("Игрок с таким ID не найден", player, 255, 0, 0)
			return
		end
		if getPlayerID(player) == getPlayerID(player2) then
			outputChatBox("Нельзя передать деньги самому себе", player, 255, 0, 0)
			return
		end

		if transferPlayerMoney(player, player2, amount) then
			outputChatBox("Вы передали $" .. tostring(amount) .. " игроку #FFFFFF" .. tostring(getPlayerName(player2)), player, 0, 255, 0, true)
			outputChatBox("Вы получили $" .. tostring(amount) .. " от игрока #FFFFFF" .. tostring(getPlayerName(player)), player2, 255, 0, 0, true)
		else
			outputChatBox("У вас недостаточно денег", player, 255, 0, 0)
		end
	end
)

addCommandHandler("buylevel",
	function(player, cmd)
		upgradePlayerLevel(player)
	end
)

addCommandHandler("accountreset", 
	function(player)
		outputChatBox("Account reset", player)
		local account = getPlayerAccount(player)
		if isGuestAccount(account) then
			return
		end

		for k, v in pairs(getAllAccountData(account)) do
			setAccountData(account, k, false)
		end
		logOut(player)
	end
)

function sendPM(player, idOrName, ...)
	if not idOrName then
		outputChatBox("Неверно введена команда (/pm <id или ник> <сообщение>)", player, 255, 0, 0)
		return
	end
	local id = nil
	local name = nil
	if tonumber(idOrName) then
		id = tonumber(idOrName)
	else
		name = tostring(idOrName)
	end
	local wordsTable = {...}
	local message = table.concat(wordsTable, " ")
	if not message or not wordsTable[1] then
		outputChatBox("Введите текст сообщения!", player, 255, 0, 0)
		return
	end

	local player2 = nil
	if id then 
		player2 = getPlayerByID(id)
	elseif name then
		player2 = getPlayersByPartOfName(name, false)[1]
	else
		return
	end
	if not isElement(player2) then
		outputChatBox("Игрок с таким ID или именем не найден", player, 255, 0, 0)
		return
	end
	if getPlayerID(player) == getPlayerID(player2) then
		outputChatBox("Нельзя отправить сообщение самому себе", player, 255, 0, 0)
		return
	end

	local senderID = tostring(getPlayerID(player))
	local receiverID = tostring(getPlayerID(player2))
	outputChatBox("#FFAA00PM от игрока #FFFFFF" .. tostring(getPlayerName(player)) .. "#FFFFFF(" .. senderID .. "): #FFDEAD" .. tostring(message), player2, 0, 255, 0, true)
	outputChatBox("#FFAA00PM игроку #FFFFFF" .. tostring(getPlayerName(player2)) .. "#FFFFFF(" .. receiverID .. "): #FFDEAD" .. tostring(message), player, 0, 255, 0, true)

	return player2
end

function processFastPM(player, cmd, ...)
	local player2 = getElementData(player, "tws-fastPMTo")
	if not isElement(player2) then
		unbindKey(player, "j")
		return
	end
	sendPM(player, getPlayerID(player2), ...)
end

local handledCommands = {}

addCommandHandler("pm",
	function(player, cmd, idOrName, ...)
		local player2 = sendPM(player, idOrName, ...)

		if player2 then
			-- fast pm
			local commandText = "PM игроку " .. getPlayerName(player2):gsub('#%x%x%x%x%x%x', '')
			if not handledCommands[commandText] then		
				addCommandHandler(commandText, processFastPM)
				handledCommands[commandText] = true
			end
			unbindKey(player, "j")
			bindKey(player, "j", "down", "chatbox", commandText)
			setElementData(player, "tws-fastPMTo", player2)
		end
	end
)