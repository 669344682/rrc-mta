addEvent("onVIPSettingsChange", true)
addEventHandler("onVIPSettingsChange", resourceRoot,
	function(setting, value)
		if setting == "skin" then 
			setElementModel(client, value)
		elseif setting == "fightingStyleID" then
			setPedFightingStyle(client, value)
		elseif setting == "headless" then
			setPedHeadless(client, value)
		elseif setting == "tws-isGlobalMapHiding" then
			triggerEvent("onPlayerTogglesSelfBlip", client, value)
		elseif setting == "skin" then
			client.model = value
		end

		local account = client.account
		account:setData(setting, value)
		client:setData(setting, value)
	end
)

local defaultNoVIPData = {
	["jetpackHotkey"] = false,
	["skin"] = 0,
	["nameColor_R"] = 255,
	["nameColor_G"] = 255,
	["nameColor_B"] = 255,
	["fightingStyleID"] = 15,
	["fightingStyleName"] = "DEFAULT",
	["tws-isGlobalMapHiding"] = false,
	["isCrownShowing"] = false,
	["headless"] = false,
	["godmode"] = false,
	["waterHovering"] = false,
}

local defaultVIPData = {
	["jetpackHotkey"] = "J", 
	["skin"] = 0,
	["nameColor_R"] = 255,
	["nameColor_G"] = 200,
	["nameColor_B"] = 0,
	["fightingStyleID"] = 15,
	["fightingStyleName"] = "DEFAULT",
	["tws-isGlobalMapHiding"] = false,
	["isCrownShowing"] = true,
	["headless"] = false,
	["godmode"] = false,
	["waterHovering"] = false
}

function changeStuff(player, isVIP)
	local stuffToChange = {"fightingStyleID", "headless"}
	local data = isVIP and defaultVIPData or defaultNoVIPData

	for _, key in ipairs(stuffToChange) do
		if string == "fightingStyleID" then
			setPedFightingStyle(player, data[string])
		elseif string == "headless" then
			setPedHeadless(player, data[string])
		end
	end
end

function refreshData(_, account)
	local player = account.player

	if not player then
		return
	end

	local VIPBoughtAtTimestamp = player.account:getData("VIPBoughtAtTimestamp") 
	local VIPExpiresAtTimestamp = player.account:getData("VIPExpiresAtTimestamp")
	--outputChatBox(0)

	-- рассчитываем время до окончания вип-акка, если он вообще есть
	local daysLeft = -1
	local progressBarTimeLeft = nil
	if VIPBoughtAtTimestamp and VIPExpiresAtTimestamp then
	--	outputChatBox(1)
		local totalTimestamp = VIPExpiresAtTimestamp - VIPBoughtAtTimestamp
		local nowTimestamp = getRealTime().timestamp
		local leftTimestamp = VIPExpiresAtTimestamp - nowTimestamp
		
		daysLeft = secondsToDays(leftTimestamp)
		progressBarTimeLeft = 1 - ((secondsToDays(totalTimestamp) - daysLeft) / secondsToDays(totalTimestamp))
	end

	-- проверяем, есть ли вип аккаунт и не закончился ли он
	if daysLeft > 0 then
	--	outputChatBox(2)
		player:setData("isVIP", true)
		account:setData("isVIP", true)
		setTimer(
			function()
				triggerClientEvent(player, "onServerSendVIPTimeLeft", resourceRoot, daysLeft, progressBarTimeLeft)
			end, 100, 1
		)
	else
	--outputChatBox(3)
		player:setData("isVIP", false)
		account:setData("isVIP", false)
	end

	-- если он таки есть, включаем ему плюшки
	if account:getData("isVIP") then
	--	outputChatBox(4)
		for dataName, defaultValue in pairs(defaultVIPData) do
		--	outputChatBox("set " .. dataName .. " to " .. tostring(account:getData(dataName) or defaultValue))
			player:setData(dataName, account:getData(dataName) or defaultValue)
		end

		setPedFightingStyle(player, player:getData("fightingStyleID"))
		setPedHeadless(player, player:getData("headless"))
	else
	--	outputChatBox(5)
	-- если нет, сбрасываем плюшки на дефолт
		for dataName, defaultValue in pairs(defaultNoVIPData) do
			player:setData(dataName, defaultValue)
		end

		changeStuff(player, false)
	end
end
addEventHandler("onPlayerLogin", root, refreshData)


addEventHandler("onResourceStart", resourceRoot,
	function()
		local players = getElementsByType("player")
		for _, player in ipairs(players) do
			if not player.account:isGuest() then
				setTimer(function() refreshData(_, player.account) end, 500, 1)
			end
		end
	end
)

addCommandHandler("vip",
	function(player)
		player.account:setData("VIPBoughtAtTimestamp", getRealTime().timestamp)
		player.account:setData("VIPExpiresAtTimestamp", getRealTime().timestamp + 86400 * 10)
		outputChatBox("Вы получили VIP аккаунт на 10 дней.", player, 255, 255, 255)
		refreshData(_, player.account)
	end
)

function secondsToDays(seconds)
	return seconds / 24 / 3600
end
