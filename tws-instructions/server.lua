function toggleControlAndHud(bool)
	setElementFrozen(localPlayer, not bool)
	toggleAllControls(bool, true, false)
	setPlayerHudComponentVisible("radar", bool)
	if bool == true then
		setCameraTarget(localPlayer)
	end
end

function startInstruction(player, instruction)
	triggerClientEvent(player, "tws-startInstruction", resourceRoot, instruction)
end

local colshape = createColSphere(348.37384033203, -1531.9445800781, 33.303489685059, 49.656677246094, 100)
addEventHandler("onColShapeHit", colshape,
	function(hitElement)
		if getElementType(hitElement) ~= "vehicle" then
			return
		end
		local player = getVehicleOccupant(hitElement)
		if not isElement(player) then
			return
		end

		local account = getPlayerAccount(player)
		if isGuestAccount(account) then
			return
		end

		local tutorialCheck = getAccountData(account, "tws-tutorial-hotel")
		if not tutorialCheck then
			setAccountData(account, "tws-tutorial-hotel", true)
			startInstruction(player, "hotel")
		end
	end
)