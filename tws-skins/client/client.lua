-- fixing flickering when changing skin
local skin1, skin2, rotationZ
local frameCounter = 0
function fixingSkinChangeFlickering()
	if localPlayer.vehicle then
		return
	end

	skin1 = skin2
	skin2 = localPlayer.model

	if skin1 ~= skin2 then
		triggerEvent("onClientChangeSkin", resourceRoot, skin2)
		triggerServerEvent("onClientChangeSkin", resourceRoot, skin2)
		frameCounter = 0
	end

	if frameCounter <= 10 then
		frameCounter = frameCounter + 1

		if not rotationZ then
			return
		end

		setElementRotation(localPlayer, 0, 0, rotationZ, "default", true)
		return
	end
	rotationZ = localPlayer.rotation.z
end

function toggleFixingSkinChangeFlickering(state)
	if state then
		removeEventHandler("onClientPreRender", root, fixingSkinChangeFlickering)
		addEventHandler("onClientPreRender", root, fixingSkinChangeFlickering)
	else
		removeEventHandler("onClientPreRender", root, fixingSkinChangeFlickering)
	end
end

toggleFixingSkinChangeFlickering(true)

addEvent("onClientChangeSkin", true)
addEventHandler("onClientChangeSkin", resourceRoot,
	function(skin)
		localPlayer.doubleSided = SKIN_DOUBLESIDED[skin] or false
		localPlayer.walkingStyle = SKIN_ANIMATIONS[skin] or SKIN_ANIMATION_DEFAULT
	end
)
