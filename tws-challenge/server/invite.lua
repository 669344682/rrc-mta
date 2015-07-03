addEvent("tws-challengeInvitePlayer", true)
addEventHandler("tws-challengeInvitePlayer", resourceRoot,
	function(player, amount)
		if not amount then
			return
		end
		if exports["tws-main"]:getPlayerMoney(player) < amount then
			triggerClientEvent(client, "tws-challengePlayerAccept", resourceRoot, player, false, "nomoney")
			return
		end
		triggerClientEvent(player, "tws-challengeInvitePlayer", resourceRoot, client, amount)
	end
)

addEvent("tws-challengePlayerAccept", true)
addEventHandler("tws-challengePlayerAccept", resourceRoot,
	function(player, isAccepted, reason)
		triggerClientEvent(player, "tws-challengePlayerAccept", resourceRoot, client, isAccepted, reason)
		if isAccepted then
			createChallengeRace(player, client)
			local amount = tonumber(reason)
			exports["tws-main"]:takePlayerMoney(client, tonumber(amount))
			exports["tws-main"]:takePlayerMoney(player, tonumber(amount))
			outputChatBox("Вы внесли ставку на гонку: $" .. tostring(amount), player, 0, 255, 0)
			outputChatBox("Вы внесли ставку на гонку: $" .. tostring(amount), client, 0, 255, 0)
		end
	end
)

addEvent("tws-challengePlayerFinish", true)
addEventHandler("tws-challengePlayerFinish", resourceRoot,
	function(player, amount)
		triggerClientEvent(player, "tws-challengePlayerFinish", resourceRoot, client)

		outputChatBox("[Вызов] Противник победил и заработал $" .. tostring(amount), player, 255, 0, 0)
		outputChatBox("[Вызов] Вы победили и заработали $" .. tostring(amount), client, 0, 255, 0)
		exports["tws-main"]:givePlayerMoney(client, tonumber(amount * 2))
	end
)

addEvent("tws-challengePlayerLeft", true)
addEventHandler("tws-challengePlayerLeft", resourceRoot,
	function(player, amount)
		outputChatBox("[Вызов] Противник вышел из гонки. Вы заработали $"  .. tostring(amount) , client, 255, 0, 0)
		outputChatBox("[Вызов] Вы вышли из гонки и проиграли $"  .. tostring(amount) , client, 255, 0, 0)
		exports["tws-main"]:givePlayerMoney(client, tonumber(amount * 2))
	end
)