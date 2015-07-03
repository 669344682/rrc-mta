loadstring(exports["tws-shared"]:include("tuning"))()

tuningTexture = {} 

local textureWidth, textureHeight = 1024, 1024
local stickerSize = 300
local movementSpeedNormal = 2
local movementSpeedSlow = 1
local movementSpeed = movementSpeedNormal

-- textureOffsets[name] = {x, y, width, height, rotation}
local textureOffsets = {
	["left"] 	= {0, 	0, 288, 1024, 90},
	["right"] 	= {736, 0, 288, 1024, 270},
	["top"] 	= {384, 416, 256, 288, 180},
	["front"] 	= {288, 0, 448, 256 + 64, 180},
	["back"] 	= {352, 704, 320, 1024 - 704, 0}
}

local tuningStickers = {}
local selectedSticker = nil
local textureRenderTarget = nil

local highlightedStickerIndex = nil
local highlightedVisible = true
local highlightTimer = nil

-- onClientRestore event handler
local function onClientRestore(didClearRenderTargets)
	if didClearRenderTargets then
		tuningTexture.redraw()
	end
end

function tuningTexture.start()
	if isTimer(highlightTimer) then
		killTimer(highlightTimer)
	end
	highlightTimer = setTimer(
		function() 
			highlightedVisible = not highlightedVisible  
			tuningTexture.redraw()
		end, 500, 0)
	-- Color
	if not tuningVehicle.tuning.color then
		tuningVehicle.setTuning("color", {255, 255, 255})
	end 

	-- Stickers
	local vehicleStickers = tuningVehicle.tuning.stickers
	if not vehicleStickers then
		tuningVehicle.setTuning("stickers", {})
		vehicleStickers = {}
	end

	tuningStickers = vehicleStickers
	--[[for i, s in ipairs(vehicleStickers) do

		sticker = getStikerTableFromInfo(s)
		if sticker then
			table.insert(tuningStickers, sticker)
		end
	end]]

	-- RenderTarget
	--textureRenderTarget = exports["tws-vehicles-textures"]:getVehicleTextureRenderTarget(tuningVehicle.vehicle)
	addEventHandler("onClientRestore", root, onClientRestore)

	-- First redraw
	tuningTexture.redraw()
	tuningVehicle.tuning.stickers = tuningStickers
	selectedSticker = nil
end

function tuningTexture.stop()
	if isTimer(highlightTimer) then
		killTimer(highlightTimer)
	end

	tuningTexture.save()
	
	removeEventHandler("onClientRestore", root, onClientRestore)
	-- Destroy render target
 	if isElement(textureRenderTarget) then
		destroyElement(textureRenderTarget)
	end
	--exports["tws-vehicles-textures"]:resetVehicleTextureRenderTarget(tuningVehicle.vehicle)

	tuningStickers = {}
end

function tuningTexture.save()
	local vehicleStickers = {}
	--[[for i, s in ipairs(tuningStickers) do
		table.insert(vehicleStickers, {s.id, s.x, s.y, s.rotation, s.scale, s.sideRotation, s.color, s.mirrorX, s.mirrorY})
	end]]
	tuningVehicle.setTuning("stickers", tuningStickers)
end

function tuningTexture.redraw()
	--if not isElement(textureRenderTarget) then
	--	return
	--end
	exports["tws-vehicles-textures"]:drawToVehicleTexture(tuningVehicle.vehicle, tuningVehicle.tuning, highlightedStickerIndex, highlightedVisible)
end

local function getSide(x, y)
	local side = "_"
	if utils.isPointInRect(x, y, unpack(textureOffsets["left"])) then
		side = "left"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["right"])) then
		side = "right"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["top"])) then
		side = "top"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["front"])) then
		side = "front"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["back"])) then
		side = "back"
	end
	return side
end

local function getSideDirection(x, y, mx, my)
	local newX = mx
	local newY = my
	local side = "_"
	local rotOffset = 0
	if utils.isPointInRect(x, y, unpack(textureOffsets["left"])) then
		newX = my
		newY = mx
		side = "left"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["right"])) then
		newX = -my
		newY = -mx
		side = "right"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["top"])) then
		newX = -mx
		side = "top"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["front"])) then
		newX = -mx
		side = "front"
	elseif utils.isPointInRect(x, y, unpack(textureOffsets["back"])) then
		newY = -my
		side = "back"
	end
	if textureOffsets[side] then
		rotOffset = textureOffsets[side][5]
	end
	return newX, newY, side, rotOffset
end

function tuningTexture.getStickerSide(index)
	local sticker = tuningStickers[index]
	if not sticker then
		return false
	end	
	local side = getSide(sticker.x + stickerSize / 2, sticker.y + stickerSize / 2)
	return side
end

function tuningTexture.moveSelectedSticker(direction)
	local sticker = tuningStickers[selectedSticker]
	if not sticker then
		return
	end
	local moveX = 0
	local moveY = 0
	-- Направление движения
	if direction == "left" then
		moveX = -1
	elseif direction == "right" then
		moveX = 1
	elseif direction == "up" then
		moveY = 1
	elseif direction == "down" then
		moveY = -1
	end
	local rotationOffset = 0
	-- Направление движения в зависимости от стороны, на которой находится наклейка
	moveX, moveY, side, rotationOffset = getSideDirection(sticker.x + stickerSize / 2, sticker.y + stickerSize / 2, moveX, moveY)
	-- Новая сторона
	local newSide = getSide(sticker.x + stickerSize / 2 + movementSpeed * moveX, sticker.y + stickerSize / 2 + movementSpeed * moveY)
	-- Если наклейка не оказалась на другой стороне
	if side == newSide then
		sticker.x = sticker.x + movementSpeed * moveX
		sticker.y = sticker.y + movementSpeed * moveY
		sticker.sideRotation = rotationOffset
	end

	tuningTexture.redraw()
end

function tuningTexture.addSticker(id)
	local sticker = {
		id = id,
		x = 0,
		y = 0,
		rotation = 0,
		scale = 0.6,
		sideRotation = 0,
		color = tocolor(255, 255, 255),
		mirrorX = false,
		mirrorY = false
	}
	table.insert(tuningStickers, sticker)
	selectedSticker = #tuningStickers
	tuningTexture.moveStickerToSide("right")
	return selectedSticker
end

function tuningTexture.removeSelectedSticker()
	if not tuningStickers[selectedSticker] then
		return
	end
	table.remove(tuningStickers, selectedSticker)
	tuningTexture.redraw()
end

function tuningTexture.removeSelectedStickerByIndex(index)
	if not tuningStickers[index] then
		return
	end
	table.remove(tuningStickers, index)
	tuningTexture.redraw()
end

function tuningTexture.moveStickerToSide(side)
	local sticker = tuningStickers[selectedSticker]
	local offsets = textureOffsets[side]
	if not sticker or not offsets then
		return
	end
	sticker.x = offsets[1] + offsets[3] / 2 - stickerSize / 2
	if side == "right" then
		sticker.x = offsets[1] - stickerSize / 4
	elseif side == "left" then
		sticker.x = offsets[1] + stickerSize / 4
	end
	sticker.y = offsets[2] + offsets[4] / 2 - stickerSize / 2
	sticker.sideRotation = offsets[5]

	tuningTexture.redraw()
end

function tuningTexture.setStickerProperty(key, value)
	local sticker = tuningStickers[selectedSticker]
	if not sticker then
		return
	end
	if sticker[key] == nil then
		return
	end
	if value == nil then
		return
	end
	sticker[key] = value

	tuningTexture.redraw()
end

function tuningTexture.getStickerProperty(key)
	local sticker = tuningStickers[selectedSticker]
	if not sticker then
		return
	end
	return sticker[key]
end

function tuningTexture.getStickers()
	return tuningStickers
end

function tuningTexture.setHighlightedSticker(index)
	highlightedStickerIndex = index
end

function tuningTexture.getSticker(index)
	return tuningStickers[index]
end

function tuningTexture.setSkin(id)
	tuningVehicle.tuning.paintjob = id
	tuningTexture.redraw()
end

function tuningTexture.restoreSkin()
	tuningVehicle.restoreTuning("paintjob")
	tuningTexture.redraw()
end