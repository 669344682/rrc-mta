local screenWidth, screenHeight = guiGetScreenSize()
local screenSourceWidth = screenWidth / 3
local screenSourceHeight = screenHeight / 3
local screenSource

function sendPicture()
	-- Retreive pixels from the screenSource
	local texturePixels = dxGetTexturePixels(screenSource)
	destroyElement(screenSource)

	-- Convert and send pixels
	texturePixels = dxConvertPixels(texturePixels, "jpeg", 80)
	triggerLatentServerEvent("tws-updateVehiclePreview", 50000, resourceRoot, texturePixels)
end

function onFrameRendered()
	removeEventHandler("onClientRender", root, onFrameRendered)
	if not isElement(screenSource) then
		return
	end
	dxUpdateScreenSource(screenSource)	
	sendPicture()
end

function takePicture()
	if isElement(screenSource) then
		return
	end
	screenSource = dxCreateScreenSource(screenSourceWidth, screenSourceHeight)
	addEventHandler("onClientRender", root, onFrameRendered)
end