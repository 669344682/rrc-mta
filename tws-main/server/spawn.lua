hospitalSpawnPosition = {2283.2463378906, -1137.0402832031, 1050.8984375, 180}
carshopSpawnPosition = {1154.501, -1837.466, 14.5, 180}
spawnInterior = 11

-- TODO: REWRITE THIS
function twsSpawnPlayer(player, spawnType, spawnInfo)
	if not isElement(player) then
		return
	end
	triggerClientEvent(player, "hidePotracheno", resourceRoot)
	showChat(player, false)

	if spawnType == "novehicle" then
		pos = {unpack(carshopSpawnPosition)}
		pos[1] = pos[1] + math.random(-50, 50) / 10
		pos[2] = pos[2] + math.random(-25, 25) / 10
		int = 0
	elseif spawnType == "hospitalSpawnPosition" then
		pos = {unpack(hospitalSpawnPosition)}
		pos[1] = pos[1] + math.random(-50, 50) / 10
		pos[2] = pos[2] + math.random(-25, 25) / 10
		int = 0
	else
		if not spawnInfo or type(spawnInfo) ~= "table" then
			pos = {unpack(carshopSpawnPosition)}
			int = 0
		else
			pos = spawnInfo.position
			int = spawnInfo.interior
		end
	end
	spawnPlayer(player, pos[1], pos[2], pos[3], pos[4], getPlayerSkinID(player))
	setElementInterior(player, int)

	setCameraTarget(player, player)
	setTimer(
		function()
			clearChatBox(player)
			setElementModel(player, getPlayerSkinID(player))
			fadeCamera(player, true, 3)
			showChat(player, true)
			if isFirstSpawn then
				outputChatBox("Посетите автомагазин, чтобы купить свой первый автомобиль", player, 0, 255, 0)
				setElementRotation(player, 0, 0, pos[4])
				setTimer(
					function()
						--exports["tws-instructions"]:startInstruction(player, "carshop")
					end,
				1000, 1)
			end
		end, 1000, 1)

	--triggerClientEvent(player, "twsSpawn", root)
	triggerClientEvent(player, "tws-tuningSync", resourceRoot)
end

addEventHandler("onPlayerWasted", root,
	function()
		local player = source
		if isElement(player) then
			setTimer(twsSpawnPlayer, 5000, 1, player, "hospital")
		end
	end
)

addEvent("onPlayerChoseSkin", true)
addEventHandler("onPlayerChoseSkin", root, 
	function(skinID)
		local playerAccount = getPlayerAccount(client)
		if not isGuestAccount(playerAccount) then
			setAccountData(playerAccount, "skin", skinID)
			setElementData(client, "tws-skin", skinID)
			setElementModel(client, skinID)
			twsSpawnPlayer(client, not hasVehicles(playerAccount))
		end
	end
)