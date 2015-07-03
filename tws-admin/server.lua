function isPlayerAdmin(player)
	if not isElement(player) then
		return nil
	end
	local adminAclGroup = aclGetGroup("Admin")
	if not adminAclGroup then
		return false
	end
	local accountName = getElementData(player, "tws-accountName")
	if not accountName then
		return false
	end
	if isObjectInACLGroup("user." .. tostring(accountName), adminAclGroup) then
		return true
	end
	return false
end

function getPlayerFromIdOrName(idOrName)
	if not idOrName then
		return false
	end
	local id = nil
	local name = nil
	if tonumber(idOrName) then
		id = tonumber(idOrName)
	else
		name = tostring(idOrName)
	end
	local player = nil
	if id then 
		player = exports["tws-main"]:getPlayerByID(id)
	elseif name then
		player = exports["tws-main"]:getPlayersByPartOfName(name, false)[1]
	else
		return false
	end

	return player
end

addCommandHandler("isadmin",
	function(player)
		if isPlayerAdmin(player) then
			outputChatBox("Вы являетесь администратором.", player, 0, 255, 0)
		else
			outputChatBox("Вы не являетесь администратором", player, 255, 0, 0)
		end
	end
)

function addAdminCommandHandler(command, func)
	if not func then
		return
	end
	addCommandHandler(command, 
		function(player, cmd, ...)
			if not isPlayerAdmin(player) then
				outputChatBox("Вы не являетесь администратором", player, 255, 0, 0)
				return
			end
			func(player, cmd, ...)
		end
	)
end

addAdminCommandHandler("givemoney",
	function(player, cmd, idOrName, amount)
		if not idOrName then
			outputChatBox("[ADMIN] Неверно введена команда. /givemoney <ID/имя> <сумма>", player, 255, 0, 0)
			return
		end
		if not amount then
			outputChatBox("[ADMIN] Неверно введена команда. /givemoney <ID/имя> <сумма>", player, 255, 0, 0)
			return
		end
		amount = tonumber(amount)
		if not amount then
			outputChatBox("[ADMIN] Неверно введена команда. /givemoney <ID/имя> <сумма>", player, 255, 0, 0)
			return
		end
		local targetPlayer = getPlayerFromIdOrName(idOrName)
		if not targetPlayer then
			outputChatBox("[ADMIN] Игрок с таким именем или ID не найден.", player, 255, 0, 0)
			return
		end
		exports["tws-main"]:givePlayerMoney(targetPlayer, amount)
		outputChatBox("[ADMIN] Вы дали $" .. amount .. " игроку #FFFFFF" .. getPlayerName(targetPlayer), player, 0, 255, 0, true)
	end
)

addAdminCommandHandler("fixcar",
	function(player, cmd, idOrName)
		if not idOrName then
			local vehicle = getPedOccupiedVehicle(player)
			if not vehicle then
				return
			end
			exports["tws-vehicles"]:fixVehicle(vehicle)
			outputChatBox("[ADMIN] Вы починили свой автомобиль", player, 0, 255, 0)
		else
			local targetPlayer = getPlayerFromIdOrName(idOrName)
			if not targetPlayer then
				outputChatBox("[ADMIN] Игрок с таким именем или ID не найден.", player, 255, 0, 0)
				return
			end
			local vehicle = getPedOccupiedVehicle(targetPlayer)
			if not isElement(vehicle) then
				outputChatBox("[ADMIN] Игрок #FFFFFF" .. getPlayerName(targetPlayer) .. "#FF0000 не находится в автомобиле", player, 255, 0, 0, true)
				return
			end
			exports["tws-vehicles"]:fixVehicle(vehicle)
			outputChatBox("[ADMIN] Вы починили автомобиль игрока #FFFFFF" .. getPlayerName(targetPlayer), player, 0, 255, 0, true)
		end
	end
)

addAdminCommandHandler("getallcars",
	function(player, cmd)
		local account = getPlayerAccount(player)
		if isGuestAccount(account) then
			return
		end

		local carTable = {}
		local models = exports["tws-vehicles"]:getAllVehiclesModels()
		for i,model in ipairs(models) do
			table.insert(carTable, {model = model, tuning = {color = {235, 20, 20}}})
		end
		setAccountData(account, "vehicles", toJSON(carTable))

		outputChatBox("[ADMIN] Вы получили все машины", player, 0, 255, 0)
	end
)