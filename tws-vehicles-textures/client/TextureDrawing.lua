textureDrawing = {}

function textureDrawing:init()
	self.renderTargetSize = {width = 1024, height = 1024}
	self.textureSize = {width = 1024, height = 1024}
	self.stickerSize = 300
end

function textureDrawing:drawTextureOffset(tuningTable, offsetX, offsetY)
	-- Основной цвет
	if not tuningTable.color then
		tuningTable.color = {255, 255, 255}
	end
	dxDrawRectangle(offsetX, offsetY, self.textureSize.width, self.textureSize.height, tocolor(unpack(tuningTable.color)))

	-- Раскраска 
	if tuningTable.paintjob then
		local skinTexture = exports["tws-stickers"]:getSkinByID(tuningTable.paintjob)
		if isElement(skinTexture) then
			dxDrawImage(offsetX, offsetY, self.textureSize.width, self.textureSize.height, skinTexture)
		end
	end

	-- Карбоновый капот
	if tuningTable.bonnet then
		dxDrawImage(offsetX, offsetY, self.textureSize.width, self.textureSize.height, "images/carbon/bonnet" .. tostring(tuningTable.bonnet) .. ".png")
	end

	-- Наклейки
	if tuningTable.stickers then
		for i, sticker in ipairs(tuningTable.stickers) do
			local isVisible = true--(i ~= highlightedStickerIndex) or highlightedVisible
			if isVisible then
				if not sticker.x or not sticker.y then
					return
				end
				-- Масштаб
				local scaleOffset = (self.stickerSize - self.stickerSize * sticker.scale) / 2
				local size = self.stickerSize * sticker.scale
				-- Центрирование
				local x = sticker.x + scaleOffset
				local y = sticker.y + scaleOffset
				-- Отзеркаливание
				local mX = 1
				local mY = 1
				if sticker.mirrorX then 
					mX = -1 
					x = x + size
				end
				if sticker.mirrorY then 
					mY = -1
					y = y + size
				end

				local stickerTexture = exports["tws-stickers"]:getStickerByID(sticker.id)
				if isElement(stickerTexture) then
					dxDrawImage(x + offsetX, y + offsetY, size * mX, size * mY, stickerTexture, sticker.rotation + sticker.sideRotation, 0, 0, sticker.color)
				end
			end
		end
	end
end

function textureDrawing:drawScratchTexture(vehicle)
	for i = 0, 5 do
		local doorState = getVehicleDoorState(vehicle, i)
		if doorState >= 2 then
			dxDrawImage(0, 0, 1024, 1024, "images/scratch_" .. tostring(i) ..".png")
		end
	end
end

function textureDrawing:drawTextureFromTuningTable(vehicle, tuningTable, renderTarget)
	if not tuningTable then
		outputDebugString("WARNING: textureDrawing:drawTextureFromTuningTable: tuningTable is nil")
		return
	end
	if not isElement(renderTarget) then
		outputDebugString("WARNING: textureDrawing:drawTextureFromTuningTable: renderTarget is not an element")
		return
	end
	-- Отрисовка текстуры
	dxSetRenderTarget(renderTarget, true)
	textureDrawing:drawTextureOffset(tuningTable, 0, 0)
	textureDrawing:drawTextureOffset(tuningTable, self.textureSize.width, self.textureSize.height)
	textureDrawing:drawScratchTexture(vehicle)

	dxSetRenderTarget()
end