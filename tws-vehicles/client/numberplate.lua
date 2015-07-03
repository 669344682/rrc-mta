local plateShaders = {}

local numberBackground = dxCreateTexture("images/number.png")
local numberFont = dxCreateFont("fonts/numbers.ttf", 25)

local textOffset = 24
local textWidth = 164
local numberHeight = 64

local regionOffset = 191
local regionWidth = 47
local regionHeight = 47

function getTextureFromRenderTarget(renderTarget)
	return dxCreateTexture(dxGetTexturePixels(renderTarget))
end

local function generatePlateTexture(text, region)
	local renderTarget = dxCreateRenderTarget(256, 64)
	dxSetRenderTarget(renderTarget)
	dxDrawImage(0, 0, 256, 64, numberBackground)
	dxDrawText(tostring(text), textOffset, 0, textOffset + textWidth, numberHeight, tocolor(0, 0, 0), 1, numberFont, "center", "center")
	dxDrawText(tostring(region), regionOffset, 0, regionOffset + regionWidth, regionHeight, tocolor(0, 0, 0), 0.75, numberFont, "center", "center")
	dxSetRenderTarget()

	local texture = getTextureFromRenderTarget(renderTarget)
	destroyElement(renderTarget)
	return texture
end

function setVehicleNumberPlate(vehicle, text, region)
	if plateShaders[vehicle] then
		resetVehicleNumberPlate(vehicle)
	end

	local texture = generatePlateTexture(text, region)
	shader = dxCreateShader("shaders/texreplace.fx")
	plateShaders[vehicle] = shader
	engineApplyShaderToWorldTexture(shader, "tws-number", vehicle)
	dxSetShaderValue(shader, "gTexture", texture)	
end

function resetVehicleNumberPlate(vehicle)
	local shader = plateShaders[vehicle]
	if isElement(shader) then
		destroyElement(shader)
		shader = nil
	end
	plateShaders[vehicle] = nil
end

addEvent("tws-setVehicleNumberPlate", true)
addEventHandler("tws-setVehicleNumberPlate", root,
	function(text, region)
		if not isElementStreamedIn(source) then
			return
		end
		if not text then
			resetVehicleNumberPlate(source)
		else
			setVehicleNumberPlate(source, text, region)
		end
	end
)

addEventHandler("onClientElementStreamIn", root,
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		if plateShaders[source] then
			return
		end
		local plateData = getElementData(source, "tws-numberPlate")
		if not plateData then
			return
		end
		setVehicleNumberPlate(source, plateData[1], plateData[2])
	end
)