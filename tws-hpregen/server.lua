local HEALING = 1.3
local HEALING_PERIOD = 1000

local timer

function regeneration()
	for _, player in ipairs(getElementsByType("player")) do
		if not player:getData("regenerationDisabled") then
			if player:getData("regeneration") then
				player.health = player.health + HEALING
			end
		end
	end
end

function toggleGlobalRegeneration(state)
	if state then
		timer = setTimer(regeneration, HEALING_PERIOD, 0)
	else
		if timer and isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
	end
end

toggleGlobalRegeneration(true)