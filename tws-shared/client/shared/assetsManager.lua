local assetsManager = {}
local twsAssets = exports["tws-assets"]

function assetsManager:start()
	self.textures = {}
	self.fonts = {}
end

function assetsManager:loadTexture(name, ...)
	if not name then
		return false
	end
	if not self.textures[name] then
		self.textures[name] = twsAssets:createAssetTexture(name, ...)
	end
	return self.textures[name]
end

function assetsManager:loadFont(name, ...)
	if not name then
		return false
	end
	local dxFont = twsAssets:createAssetFont(name, ...)
	table.insert(self.fonts, dxFont)
	return dxFont
end

function assetsManager:stop()
	for k, v in pairs(self.textures) do
		if isElement(v) then
			destroyElement(v)
		end
	end
	self.textures = {}

	for k, v in pairs(self.fonts) do
		if isElement(v) then
			destroyElement(v)
		end
	end
	self.fonts = {}
end

return assetsManager