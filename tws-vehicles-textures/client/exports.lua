function drawToVehicleTexture(vehicle, tuningTable)
	if textureManager.texturesShadersList[vehicle] then
		textureDrawing:drawTextureFromTuningTable(vehicle, tuningTable, textureManager.texturesShadersList[vehicle].texture)
	end
end

function updateVehicleTexture(vehicle, tuningTable)
	textureManager:updateVehicleTexture(vehicle)
end