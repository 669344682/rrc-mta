function drawToVehicleTexture(vehicle, tuningTable)
	if textureManager.texturesShadersList[vehicle] then
		textureDrawing:drawTextureFromTuningTable(tuningTable, textureManager.texturesShadersList[vehicle].texture)
	end
end