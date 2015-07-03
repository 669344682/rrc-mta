local WAIT_TIME = 5000 
local timer

localPlayer:setData("regeneration", true)

addEventHandler("onClientPlayerDamage", localPlayer,
	function()
		localPlayer:setData("regenerationDisabled", true)
		if timer and isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
		timer = setTimer(
			function()
				localPlayer:setData("regenerationDisabled", false)
				timer = nil
			end, WAIT_TIME, 1
		)
	end
)


addEventHandler("onClientResourceStop", resourceRoot,
	function()
		localPlayer:setData("regenerationDisabled", false)
		localPlayer.health = 5
	end
)