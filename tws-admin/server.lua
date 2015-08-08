function outputPlayerAdminString(text, player, messageType)
	local r, g, b = 0, 255, 0
	if messageType == 2 then
		r, g, b = 255, 0, 0
	end
	outputChatBox("[ADMIN] " .. text, player, r, g, b, true)
end

function outputError(text, player)
	outputPlayerAdminString(text, player, 2)
end

function outputText(text, player)
	outputPlayerAdminString(text, player, 1)
end

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
			outputError("Неверно введена команда. /givemoney <ID/имя> <сумма>", player)
			return
		end
		if not amount then
			outputError("Неверно введена команда. /givemoney <ID/имя> <сумма>", player)
			return
		end
		amount = tonumber(amount)
		if not amount then
			outputError("Неверно введена команда. /givemoney <ID/имя> <сумма>", player)
			return
		end
		local targetPlayer = getPlayerFromIdOrName(idOrName)
		if not targetPlayer then
			outputError("Игрок с таким именем или ID не найден.", player)
			return
		end
		exports["tws-main"]:givePlayerMoney(targetPlayer, amount)
		outputText("Вы дали $" .. amount .. " игроку #FFFFFF" .. getPlayerName(targetPlayer), player)
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
			outputText("Вы починили свой автомобиль", player)
		else
			local targetPlayer = getPlayerFromIdOrName(idOrName)
			if not targetPlayer then
				outputError("Игрок с таким именем или ID не найден.", player)
				return
			end
			local vehicle = getPedOccupiedVehicle(targetPlayer)
			if not isElement(vehicle) then
				outputError("Игрок #FFFFFF" .. getPlayerName(targetPlayer) .. "#FF0000 не находится в автомобиле", player)
				return
			end
			exports["tws-vehicles"]:fixVehicle(vehicle)
			outputText("Вы починили автомобиль игрока #FFFFFF" .. getPlayerName(targetPlayer), player)
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

		outputText("Вы получили все машины", player)
	end
)

addAdminCommandHandler("getcar",
	function(player, cmd, id)
		if not id then id = 1 end
		local x, y, z = getElementPosition(player)
		local rx, ry, rz = 0, 0, player.rotation.z
		if player.vehicle then
			x, y, z = getElementPosition(player.vehicle)
			rx, ry, rz = getElementRotation(player.vehicle)
		end
		local vehicle, errorDesc = exports["tws-vehicles"]:spawnPlayerVehicle(player, id, x, y, z, rx, ry, rz)

		if vehicle then
			removePedFromVehicle(player)
			setTimer(
				function()
					vehicle:setPosition(x, y, z)
					warpPedIntoVehicle(player, vehicle)
				end,
			500, 1)
			
			outputText("Вы заспавнили автомобиль из своего гаража", player)
		else
			local errorText = "Неизвестная ошибка (" .. errorDesc .. ")"
			if errorDesc == "no_such_car" then
				errorText = "Автомобиля с таким ID нет в гараже"
			elseif errorDesc == "car_already_spawned" then
				errorText = "Автомобиль уже заспавнен"
			elseif errorDesc == "bad_account" then
				errorText = "Вы не залогинены"
			end
			outputError("Не удалось заспавнить автомобиль. " .. tostring(errorText), player)
		end
	end
)

addAdminCommandHandler("getcars",
	function(player, cmd)
		local x, y, z = getElementPosition(player)
		for id = 1, 24 do
			local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(player, id, x, y + id * 3, z, 0, 0, 90)
		end
		outputText("Вы заспавнили все автомобили из своего гаража", player)
	end
)

addAdminCommandHandler("getplayercar",
	function(player, cmd, idOrName, vehicleID)
		if not id then id = 1 end
		local targetPlayer = getPlayerFromIdOrName(idOrName)
		if not isElement(targetPlayer) then
			outputError("Игрок с таким именем или ID не найден.", player)
			return
		end
		local positionAndRotation = {player:getPosition(), 0, 0, player.rotation.z}
		local vehicle = exports["tws-vehicles"]:spawnPlayerVehicle(targetPlayer, id, unpack(positionAndRotation))
		if vehicle then
			warpPedIntoVehicle(player, vehicle)
			outputText("Вы заспавнили автомобиль из гаража игрока #FFFFFF" .. tostring(targetPlayer.name), player)
		else
			outputError("Не удалось заспавнить автомобиль", player)
		end
	end
)