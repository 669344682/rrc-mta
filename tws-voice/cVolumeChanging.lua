local MAX_DISTANCE = 40

local colshape = createColSphere(localPlayer.position, MAX_DISTANCE)

addEventHandler("onClientPreRender", root,
	function()
		colshape.position = localPlayer.position

		local players = colshape:getElementsWithin("player")
		for _, player in ipairs(players) do
			if player ~= localPlayer then
				local distance = getDistanceBetweenPoints3D(player.position, localPlayer.position)
				local volume = 1 - (distance / MAX_DISTANCE)

				setSoundVolume(player, volume)
			end
		end

	end
)

addEventHandler("onClientPlayerJoin", root,
	function()
		source.volume = 0
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local players = getElementsByType("player")
		for _, player in ipairs(players) do
			if player ~= localPlayer then
				setSoundVolume(player, 0)
			end
		end
	end
)