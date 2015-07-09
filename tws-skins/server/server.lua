addEvent("onClientChangeSkin", true)
addEventHandler("onClientChangeSkin", resourceRoot,
	function(skin)
		if client.model == skin then
			client.doubleSided = SKIN_DOUBLESIDED[skin] or false
			client.walkingStyle = SKIN_ANIMATIONS[skin] or SKIN_ANIMATION_DEFAULT
		end
	end
)