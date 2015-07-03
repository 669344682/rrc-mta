stickerPreview = {}
stickerPreview.isVisible = false

stickerPreview.width = 200 * mainScale
stickerPreview.height = 200 * mainScale

local currentTexture = false

function stickerPreview.show(id)
	stickerPreview.isVisible = true
	currentTexture = exports["tws-stickers"]:getStickerByID(id)
end

function stickerPreview.hide()
	if not stickerPreview.isVisible then
		return
	end

	stickerPreview.isVisible = false
end

function stickerPreview.draw()
	if not stickerPreview.isVisible then
		return
	end

	if not isElement(currentTexture) then
		return
	end

	local x = screenWidth / 2 - stickerPreview.width / 2
	local y = screenHeight - stickerPreview.height - 40 * mainScale

	dxDrawRectangle(x, y, stickerPreview.width, stickerPreview.height, getColor(colors.background2, 150))
	dxDrawImage(x + 5, y + 5, stickerPreview.width - 10, stickerPreview.height - 10, currentTexture)
end