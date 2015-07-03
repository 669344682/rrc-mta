mouseButton = "F1"
mapHotkey = "m"


isInitialized = false
screenX, screenY = guiGetScreenSize()
mainScale = screenY / 600
arrowTexture = dxCreateTexture("arrow.png", "argb", true, "clamp")
arrowTextureX, arrowTextureY = arrowTexture:getSize()
arrowTextureX, arrowTextureY = (arrowTextureX / 2.13) * mainScale, (arrowTextureY / 2.13) * mainScale

function toggleControlAndHud(bool)
	setElementFrozen(localPlayer, not bool)
	toggleAllControls(bool, true, false)
	exports["tws-utils"]:toggleHUD(bool)
	if (bool == true) then
		setCameraTarget(localPlayer)
	end
end

function continueAfterEvent(event, func)
	local function continue()
		removeEventHandler(event, resourceRoot, continue)

		func()
	end

	addEventHandler(event, resourceRoot, continue)
end