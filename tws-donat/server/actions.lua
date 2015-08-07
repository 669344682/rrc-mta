addEvent("donatAction", true)
addEventHandler("donatAction", resourceRoot,
	function(action, value)
		local player = client
		if action == "jetpack" then
			if player:doesHaveJetpack() then
				player:removeJetPack()
			else
				player:giveJetPack()
				setTimer(
					function()
						if player:doesHaveJetpack() then
							killTimer(sourceTimer)
						end
						player:giveJetPack()
					end, 200, 5
				)
			end
		end
	end
)

-- headless
addEventHandler("onPlayerSpawn", root,
	function()
		source.headless = source:getData("headless")
	end
)


-- skin changing
addEvent("onClientChangeSkinGlobal", true)
addEventHandler("onClientChangeSkinGlobal", resourceRoot,
	function(skin)
		client.model = skin
	end
)

-- vehicle number changing
addEvent("tws-donat.applyVehicleNumberPlate", true)
addEventHandler("tws-donat.applyVehicleNumberPlate", resourceRoot,
	function(vehicle, carNumberTextNew, region)
		if not vehicle then
			return
		end

		if vehicle ~= client.vehicle then
			return
		end

		exports["tws-vehicles"]:applyVehicleNumberPlate(vehicle, carNumberTextNew, region)
	end
)

-- spectating
local function spectate(client, player)
	local state = true
	if not player then
		state = false
		player = false
	end

	toggleAllControls(client, not state, true, false)
	client.alpha = state and 160 or 255
	client.frozen = state

	if client.vehicle then
		client.vehicle.frozen = state
	end

	if state then
		client:setData("tws-donat.spectating", player)
		player:setData("tws-donat.spectatingBy", client)
		triggerClientEvent(client, "tws-donat.onSpectateStart", resourceRoot)
	else
		local player = client:getData("tws-donat.spectating")
		if player then
			player:setData("tws-donat.spectatingBy", false)
		end
		client:setData("tws-donat.spectating", false)

		triggerClientEvent(client, "tws-donat.onSpectateStop", resourceRoot)
	end

	if player then
		setCameraTarget(client, player)
	else
		setCameraTarget(client)
	end
end

addEvent("tws-donat.startSpectating", true)
addEventHandler("tws-donat.startSpectating", resourceRoot,
	function(id)
		if not client or not id then
			return
		end

		local player = exports["tws-main"]:getPlayerByID(id)
		if not player then
			exports["tws-message-manager"]:showMessage(client, "VIP-панель", "Игрока с ID " .. tostring(id) .. " не существует!", "error", 3000)
			return
		end
			
		spectate(client, player)
	end
)

addEvent("tws-donat.stopSpectating", true)
addEventHandler("tws-donat.stopSpectating", resourceRoot,
	function()
		if not client then
			return
		end
			
		setCameraTarget(client, client)

		spectate(client, false)
	end
)

addEventHandler("onResourceStop", root,
	function(stoppedResource)
		if stoppedResource == getThisResource() then
			for _, player in ipairs(getElementsByType("player")) do
				if player:getData("tws-donat.spectating") then
					exports["tws-message-manager"]:showMessage(player, "VIP-панель", "Произошел рестарт VIP-панели. Слежка отключена.", "info", 5000)
					spectate(player, false)
				end

				local skin = player:getData("tws-skin")
				if skin then
					player.model = skin
				end
			end
		end
	end
)

addEventHandler("onPlayerLogout", root,
	function()
		local player = source
		local spectatingBy = player:getData("tws-donat.spectatingBy")
		if spectatingBy then
			spectate(spectatingBy, false)
			exports["tws-message-manager"]:showMessage(spectatingBy, "VIP-панель", "Игрок, за которым вы следили, вышел с сервера. Слежка отключена.", "info", 5000)
		end
	end
)