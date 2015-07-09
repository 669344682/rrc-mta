addEvent("garageDisableReminder", true)
addEvent("disableVIPInstruction", true)

addEventHandler("onPlayerLogin", root,
	function()
		local data
		local player = source
		local account = player.account

		-- garage
		data = account:getData("instructions.garageNoReminder")
		player:setData("instructions.garageNoReminder", data)

		-- VIP
		if account:getData("isVIP") then
			if not account:getData("instructions.isVIPInstructionShown") then
				setTimer(startInstruction, 3000, 1, player, "VIP")
			end
		end
	end
)

addEventHandler("garageDisableReminder", resourceRoot,
	function()
		local player = client

		player:setData("instructions.garageNoReminder", true)
		player.account:setData("instructions.garageNoReminder", true)
	end
)

addEventHandler("disableVIPInstruction", resourceRoot,
	function()
		if not client or not client.account then
			return
		end

		client.account:setData("instructions.isVIPInstructionShown", true)
	end
)