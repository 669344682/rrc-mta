local stickersTextures = {}
for i = 1, 33 do
	stickersTextures[i] = dxCreateTexture("images/stickers/" .. i .. ".png")
end

local skinTextures = {}
for i = 1, 26 do
	skinTextures[i] = dxCreateTexture("images/skins/" .. i .. ".png")
end


function getStickerByID(id)
	if id < 1 and id > #stickersTextures then
		return false
	end
	return stickersTextures[id]
end

function getSkinByID(id)
	if id < 1 and id > #skinTextures then
		return false
	end
	return skinTextures[id]
end