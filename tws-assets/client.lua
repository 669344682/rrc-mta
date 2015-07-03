function createAssetTexture(name, ...)
	local path = "images/" .. tostring(name) .. ".png"

	if not fileExists(path) then
		outputDebugString("ERROR: Couldn't find asset: " .. path)
		return
	end
	return dxCreateTexture(path, ...)
end

function createAssetFont(name, ...)
	local path = "fonts/" .. tostring(name) .. ".ttf"

	if not fileExists(path) then
		outputDebugString("ERROR: Couldn't find asset: " .. path)
		return
	end
	return dxCreateFont(path, ...)
end