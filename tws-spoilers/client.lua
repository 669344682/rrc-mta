local spoilersIDs = {
	1000,
	1001,
	1002,
	1003,
	1014,
	1015,
	1016,
	1023,
	1049,
	1050,
	1058,
	1060,
	1138,
	1139,
	1146,
	1147,
	1158,
	1162,
	1163,
	1164
}

local spoilersShaders = {}
local spoilersTextures = {}
local spoilersTypes = {}

function setVehicleSpoiler(vehicle, id)
	removeVehicleSpoiler(vehicle)
	if not spoilersIDs[id] then
		return
	end

	if not spoilersShaders[vehicle] then
		spoilersShaders[vehicle] = dxCreateShader("texture_replace.fx")
	end
	if not spoilersTextures[vehicle] then
		spoilersTextures[vehicle] = dxCreateTexture(1, 1)
	end
	--engineApplyShaderToWorldTexture(spoilersShaders[vehicle], "tws-spoiler*", vehicle)
	dxSetShaderValue(spoilersShaders[vehicle], "gTexture", spoilersTextures[vehicle])

	addVehicleUpgrade(vehicle, spoilersIDs[id])
	setVehicleSpoilerType(vehicle, "normal")

	vehicle:setData("tws-boot-level", 0, false)
end

function setVehicleSpoilerType(vehicle, spoilerType)
	if not spoilerType then
		return
	end
	if spoilersTypes[vehicle] == spoilerType then
		return
	end
	if spoilerType == "carbon" then
		engineRemoveShaderFromWorldTexture(spoilersShaders[vehicle], "tws-spoiler*", vehicle)
	elseif spoilerType == "normal" then
		resetVehicleSpoilerColor(vehicle)
		engineApplyShaderToWorldTexture(spoilersShaders[vehicle], "tws-spoiler*", vehicle)
	end
	spoilersTypes[vehicle] = spoilerType
end

function resetVehicleSpoilerColor(vehicle)
	local tuningTable = getElementData(vehicle, "tws-tuning")
	if tuningTable and tuningTable.color then
		setVehicleSpoilerColor(vehicle, unpack(tuningTable.color))
	else
		setVehicleSpoilerColor(vehicle, 255, 255, 255)
	end
end

function setVehicleSpoilerColor(vehicle, r, g, b)
	local texture = spoilersTextures[vehicle]
	if not texture then
		return
	end
	local pixels = dxGetTexturePixels(texture)
	dxSetPixelColor(pixels, 0, 0, r, g, b)
	dxSetTexturePixels(texture, pixels)
end

function removeVehicleSpoiler(vehicle)
	for i, id in ipairs(spoilersIDs) do
		removeVehicleUpgrade(vehicle, id)
	end
	
	vehicle:setData("tws-boot-level", 1, false)
end