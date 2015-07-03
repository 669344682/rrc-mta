local lastPaymentHour = -1

function givePlayerMoney(player, amount)
	amount = tonumber(amount)
	if not amount then
		return
	end
	local currentAmount = getElementData(player, "tws-money")
	currentAmount = tonumber(currentAmount)
	if not currentAmount then
		currentAmount = 0
	end
	setElementData(player, "tws-money", currentAmount + amount)
end

function getPlayerMoney(player)
	return getElementData(player, "tws-money")
end

function setPlayerMoney(player, amount)
	if not amount then
		return
	end
	return setElementData(player, "tws-money", amount)
end

function takePlayerMoney(player, amount)
	if not amount then
		return
	end
	local currentMoney = getPlayerMoney(player)
	if currentMoney < amount then
		return false
	end
	setElementData(player, "tws-money", math.max(currentMoney - amount, 0))
	return true
end

function transferPlayerMoney(player1, player2, amount)
	if not isElement(player1) or not isElement(player2) or not amount then
		return false
	end
	if player1 == player2 then
		return false
	end
	if amount <= 0 then
		return false
	end
	local money1 = getPlayerMoney(player1)
	if money1 < amount then
		return false
	end
	takePlayerMoney(player1, amount)
	givePlayerMoney(player2, amount)
	return true
end

-- В секундах
function getPlayerSessionTime(player)
	if not isElement(player) then
		return 0
	end
	local loginTime = getElementData(player, "tws-loginTime")
	local currentTime = getRealTime().timestamp
	if not loginTime then 
		loginTime = currentTime
	end
	return (currentTime - loginTime)
end

local function payPlayerMoney(player)
	outputChatBox("Пособие: вы получили $1000", player, 0, 255, 0)
	givePlayerMoney(player, 1000)
end

local function givePlayerRespects(player)
	local currentRespects = getElementData(player, "tws-respects")
	if not currentRespects then
		currentRespects = 0
	end
	setElementData(player, "tws-respects", currentRespects + 1)
end

local function onHour()
	for i, player in ipairs(getElementsByType("player")) do
		if getPlayerSessionTime(player) > 15 * 60 then
			payPlayerMoney(player)
			givePlayerRespects(player)
		else
			outputChatBox("Вы играли слишком мало, поэтому не получили зарплату за прошедший час", player, 255, 0, 0)
		end
		savePlayerAccountData(player)
	end
end

local function checkPayTime()
	local curTime = getRealTime()
	if curTime["minute"] == 0 and curTime["hour"] ~= lastPaymentHour then
		lastPaymentHour = curTime["hour"] 
		onHour()
	end
end

setTimer(checkPayTime, 60000, 0)
addCommandHandler("hr",
	function()
		onHour()
	end
)

function getPlayerRespects(player)
	return getElementData(player, "tws-respects")
end

function getPlayerLevel(player)
	return getElementData(player, "tws-level")
end

function upgradePlayerLevel(player)
	local money = getPlayerMoney(player)
	local level = getPlayerLevel(player)
	local respects = getPlayerRespects(player)

	local respectsNeeded = 4 + level * 4
	local moneyNeeded = 10000 + 5000 * (level - 1)

	if respects < respectsNeeded then
	 	outputChatBox("Недостаточно респектов для перехода на следующий уровень", player, 255, 0, 0)
	 	return
	end
	if money < moneyNeeded then
		outputChatBox("Недостаточно денег для перехода на следующий уровень", player, 255, 0, 0)
		return
	end

	takePlayerMoney(player, moneyNeeded)
	setElementData(player, "tws-respects", respects - respectsNeeded)
	setElementData(player, "tws-level", level + 1)
	savePlayerAccountData(player)

	outputChatBox("Вы перешли на следующий уровень! Теперь ваш уровень: " .. tostring(level + 1), player, 0, 255, 0)
end