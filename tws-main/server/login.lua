function getPlayerSkinID(player)
	local skinID = getElementData(player, "tws-skin")
	if not skinID then
		return 0
	else
		return skinID
	end
end

function hasVehicles(account)
	local vehicles = getAccountData(account, "vehicles")
	if not vehicles then
		return false
	end
	if #fromJSON(vehicles) == 0 then
		return false
	else
		return true
	end
end

-- Setup account
addEventHandler("onPlayerLogin", root,
	function(previousAccount, account)
		setElementData(source, "tws-accountName", getAccountName(account))
		clearChatBox(source)
		outputChatBox("Вы успешно вошли", source, 0, 255, 0)
		-- Check account data
		for dataKey, dataValue in pairs(defaultAccountData) do
			local accountData = getAccountData(account, dataKey)
			if not accountData or accountData == "nil" then
				setAccountData(account, dataKey, dataValue)
			end
		end

		-- Load account data to player data
		for _, dataKey in ipairs(accountDataToPlayerData) do
			local accountData = getAccountData(account, dataKey)
			if accountData ~= nil and accountData ~= "nil" then
				setElementData(source, "tws-" .. dataKey, accountData)
			end
		end

		-- Skin sheck
		local playerSkinID = getAccountData(account, "skin")
		if not playerSkinID then
			setTimer(function(player)
				clearChatBox(player)
				outputChatBox("Добро пожаловать на сервер! Пожалуйста, выберите ваш скин", player, 0, 255, 0)
				end, 500, 1, source
			)
			exports["tws-skinselecting"]:forcePlayerSelectSkin(source)
		else
			local spawnType = "normal"
			if not hasVehicles(account) then
				spawnType = "novehicle"
			end
			local positionJSON = getAccountData(account, "disconnectPosition")
			local positionInfo
			if positionJSON then
				positionInfo = fromJSON(positionJSON)
			end
			twsSpawnPlayer(source, spawnType, positionInfo)
		end
		
		exports["tws-gui-login"]:setLoginWindowVisible(source, false)

		setElementData(source, "tws-loginTime", getRealTime().timestamp)
 	end
)

function savePlayerAccountData(player)
	local account = getPlayerAccount(player)
	if account and not isGuestAccount(account) then
		for _, dataKey in ipairs(accountDataToSaveOnLogout) do
			local accountDataKey = string.sub(dataKey, 5, -1) -- Убирание "tws-"
			local dataValue = getElementData(player, dataKey)
			if accountDataKey and dataValue ~= nil then
				setAccountData(account, accountDataKey, dataValue)
			end
		end
	end
end

function clearPlayerData(player)
	for _, dataKey in ipairs(accountDataToSaveOnLogout) do
		setElementData(player, dataKey, nil)
	end
	setElementData(player, "tws-accountName", nil)
end

-- TODO: REWRITE THIS
addEventHandler("onPlayerLogout", root,
	function(account)
		savePlayerAccountData(source)

		-- Обновить время
		local currentPlaytime = tonumber(getAccountData(account, "playtime"))
		if not currentPlaytime then
			currentPlaytime = 0
		end
		currentPlaytime = currentPlaytime + getPlayerSessionTime(source)
		setAccountData(account, "playtime", currentPlaytime)
		setElementData(source, "tws-loginTime", nil)

		fadeCamera(source, false, 0)
		exports["tws-gui-login"]:setLoginWindowVisible(source, true)
		clearPlayerData(source)

		local player = source
		if isElement(player) then
			local posX, posY, posZ = getElementPosition(player)
			local rotX, rotY, rotZ = getElementRotation(player)
			local dim = getElementDimension(player)
			local int = getElementInterior(player)

			local data = {
				position = {posX, posY, posZ}, 
				rotation = {rotX, rotY, rotZ},
				dimension = dim,
				interior = int
			}
			setAccountData(account, "disconnectPosition", toJSON(data))

			removePedFromVehicle(player)
			local playerID = getPlayerID(player)
			if playerID then
				setElementDimension(player, playerID)
			else
				setElementDimension(player, 10000 + math.random(1, 500)) -- random
			end

			setElementPosition(player, 0, 0, 3)
			setElementInterior(player, 0)
			--setCameraMatrix(player, startSpawnPosition[1], startSpawnPosition[2], startSpawnPosition[3] + 2, startSpawnPosition[1], startSpawnPosition[2], startSpawnPosition[3])
		
			clearChatBox(player)
			outputChatBox("Выход из аккаунта...", player, 255, 150, 0)
			setTimer(
				function()
					if isElement(player) then
						clearChatBox(player)
						outputChatBox("Вы успешно вышли из аккаунта.", player, 0, 255, 0)	
					end
				end
			,1000, 1)
		end
	end
)

addEvent("onPlayerLoginButtonClick", true)
addEventHandler("onPlayerLoginButtonClick", root,
	function(username, password)
		if not username then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Введите имя пользователя")--, client, 255, 0, 0)
			return
		end
		if not password then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Введите пароль")
			return
		end
		
		local account = getAccount(username)
		if not account then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Аккаунт '" .. username .. "' не найден.")
			return
		end
		local player = getAccountPlayer(account)
		if isElement(player) then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Аккаунт '" .. username .. "' уже используется другим игроком.")
			return
		end
		local result = logIn(client, account, password)
		if not result then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Неверный пароль!")
			return
		end
		outputChatBox("Вход...", client, 255, 150, 0)
	end
)


addEvent("onPlayerRegisterButtonClick", true)
addEventHandler("onPlayerRegisterButtonClick", root,
	function(username, password)
		if not username then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Введите имя пользователя")
			return
		end
		if not password then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Введите пароль")
			return
		end
		local playerAccount = getPlayerAccount(client)
		if not isGuestAccount(playerAccount) then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Вы уже залогинены!")
			return
		end

		local currentAccount = getAccount(username)
		if currentAccount then
			--clearChatBox(client)
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Аккаунт с именем '" .. username .. "'' уже зарегистрирован!")
			return
		end

		local newAccount = addAccount(username, password)
		if not newAccount then
			--clearChatBox(client)
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Не удалось зарегистрировать аккаунт.")
			return
		end
		outputChatBox("Аккаунт зарегистрирован!", client, 0, 255	, 0)

		local result = logIn(client, newAccount, password)
		if not result then
			triggerClientEvent(client, "tws-loginRegisterError", resourceRoot, "Ошибка входа в аккаунт.")
			return
		end
		outputChatBox("Вход...", client, 255, 150, 0)
	end
)

addEventHandler("onPlayerCommand", root,
	function(command)
		if command == "logout" then
			cancelEvent()
		end
	end
)

addCommandHandler("areset",
	function(player, cmd, pass)
		local account = getPlayerAccount(player)
		if isGuestAccount(account) then
			return
		end
		if not pass then
			outputChatBox("Введите пароль от своего аккаунта")
			return
		end
		local accountName = getAccountName(account)
		local account = getAccount(accountName, pass)
		if not account then
			outputChatBox("Неверный пароль")
			return
		end
		logOut(player)
		removeAccount(account)
		addAccount(accountName, pass)
		outputChatBox("Сброс аккаунта")
	end
)