hospitalSpawnPositions = {
	{1184.2950439453, -1323.5886230469, 13.574824333191, 270.53387451172},
	{2030.6058349609, -1418.4337158203, 16.9921875, 133.98641967773}

}
carshopSpawnPosition = {1154.501, -1837.466, 14.5, 180}

randomSpawnPositions = {
	{1226.4674072266, -1824.6783447266, 13.589803695679, 180.05046081543},
	{901.37432861328, -1527.5733642578, 13.544944763184, 272.99014282227},
	{552.56634521484, -1266.5938720703, 17.2421875, 341.33062744141},
	{331.31423950195, -1517.9100341797, 35.8671875, 232.99998474121},
	{320.41259765625, -1814.6871337891, 4.346173286438, 358.42684936523},
	{1093.9653320313, -1795.4689941406, 13.603803634644, 89.468322753906},
	{1278.3942871094, -1337.3175048828, 13.363974571228, 89.142150878906},
	{1686.1442871094, -1129.1539306641, 24.091220855713, 90.417449951172},
	{2228.3901367188, -1159.6060791016, 25.789922714233, 85.984039306641},
	{2499.4560546875, -1680.1619873047, 13.361832618713, 30.691802978516},
	{2857.1843261719, -1862.4997558594, 11.094980239868, 86.443664550781},
	{1940.0806884766, -2104.0261230469, 13.559032440186, 263.73764038086}
}

local function findNearestHospitalForPlayer(player)
	local minDistance = 50000
	local minID = 1

	local x, y, z = getElementPosition(player)
	for i, pos in ipairs(hospitalSpawnPositions) do
		local distance = getDistanceBetweenPoints2D(x, y, pos[1], pos[2])
		if distance < minDistance then
			minDistance = distance
			minID = i
		end
	end

	return {unpack(hospitalSpawnPositions[minID])}
end

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
	elseif spawnType == "hospital" then
		pos = findNearestHospitalForPlayer(player)
		pos[1] = pos[1] + math.random(-50, 50) / 10
		pos[2] = pos[2] + math.random(-25, 25) / 10
		int = 0
	else
		pos = {unpack(randomSpawnPositions[math.random(1, #randomSpawnPositions)])}
		pos[1] = pos[1] + math.random(-2, 2) / 10
		pos[2] = pos[2] + math.random(-2, 2) / 10
		int = 0
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
			end
		end, 1000, 1)

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