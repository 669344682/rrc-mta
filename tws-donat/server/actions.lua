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