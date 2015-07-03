Map = {}
Map.currentZone = ""
Map.scale = 0
local maxScale = 1
local minScale = 0.3

Map.x = 0
Map.y = 0

-- Плавное перемещение
local movementSpeed = 0.4
local targetX, targetY = 0, 0

-- Плавное масштабирование
local scaleSpeed = 0.2
local zoomSpeed = 0.08
local targetScale = 0

local tileSize = 256
local tilesetWidth = 12
local tilesetHeight = 12
local tilesTable = {}

local pointSize = 10

Map.width = tileSize * tilesetWidth
Map.height = tileSize * tilesetHeight

local waypointBlip = nil

local function posMapToWorld(x, y)
	local offsetX = Map.x * Map.scale + screenWidth / 2
	local offsetY = Map.y * Map.scale + screenHeight / 2	
	local worldX = (x - offsetX) / (Map.width * Map.scale) * 6000 - 3000
	local worldY = 6000 - (y - offsetY) / (Map.height * Map.scale) * 6000 - 3000
	return worldX, worldY
end

local function posWorldToMap(x, y)
	local offsetX = Map.x * Map.scale + screenWidth / 2
	local offsetY = Map.y * Map.scale + screenHeight / 2
	local mapX = offsetX + (x + 3000) / 6000 * Map.width * Map.scale
	local mapY = offsetY + (-y + 3000) / 6000 * Map.height * Map.scale
	return mapX, mapY
end

local function posWorldToMapPos(x, y)
	local offsetX = screenWidth / 2
	local offsetY = screenHeight / 2
	local mapX = offsetX + (x + 3000) / 6000 * Map.width
	local mapY = offsetY + (-y + 3000) / 6000 * Map.height
	return mapX, mapY
end

function Map.zoomIn()
	targetScale = targetScale + zoomSpeed
	if targetScale > maxScale then
		targetScale = maxScale
	end
end

function Map.zoomOut()
	targetScale = targetScale - zoomSpeed
	if targetScale < minScale then
		targetScale = minScale
	end
end

function Map.moveTo(x, y)
	targetX = x
	targetY = y
end


function Map.moveToPlayer()
	x, y = posWorldToMapPos(getElementPosition(localPlayer))
	x = x - screenWidth / 2
	y = y - screenHeight / 2
	Map.x = -x
	Map.y = -y
	Map.moveTo(-x, -y)
end


function Map.init()
	for i, name in ipairs(textureNames) do
		local y = math.floor((i - 1) / tilesetWidth)
		local x = i - y * tilesetHeight
		if not tilesTable[x] then
			tilesTable[x] = {}
		end
		tilesTable[x][y] = dxCreateTexture(name, "argb", true, "clamp")
	end

	-- Положение
	Map.x = -screenWidth---tileSize
	Map.y = -screenHeight
	targetX, targetY = Map.x, Map.y

	-- Масштаб
	Map.scale = (maxScale - minScale) / 2 + minScale
	targetScale = Map.scale
end

function Map.drawPoint(x, y)
	x, y = posWorldToMap(x, y)
	local size = pointSize + 4
	dxDrawRectangle(x - size / 2, y - size / 2, size, size, getColor(colors.background2))
	size = pointSize
	dxDrawRectangle(x - size / 2, y - size / 2, size, size, tocolor(255, 150, 0))
end

function Map.drawIcon(name, x, y, rotation, color)
	x, y = posWorldToMap(x, y)
	Icons.drawIcon(name, x, y, rotation, color)
end

function Map.draw()
	local offsetX = (Map.x - tileSize) * Map.scale + screenWidth / 2
	local offsetY = Map.y * Map.scale + screenHeight / 2

	local tileOffsetX = math.max(0, math.floor(-offsetX / tileSize))
	local tileOffsetY = math.max(0, math.floor(-offsetY / tileSize))

	local tilesOnScreenX = math.floor((screenWidth / Map.scale) / tileSize) + 2
	local tilesOnScreenY = tilesOnScreenX
	for x = tileOffsetX, math.min(tilesetWidth, tileOffsetX + tilesOnScreenX) do
		for y = tileOffsetY, math.min(tilesetHeight, tileOffsetY + tilesOnScreenY) do
			if tilesTable[x] and isElement(tilesTable[x][y]) then
				dxDrawImage(x * tileSize * Map.scale + offsetX, y * tileSize * Map.scale + offsetY, tileSize * Map.scale, tileSize * Map.scale, tilesTable[x][y], 0, 0, 0)--tocolor(190, 255, 210))
			end
		end
	end

	-- Draw blips
	Blips.draw()

	-- Lines
	local mx, my = getMousePos()
	dxDrawLine(0, my, screenWidth, my, getColor(colors.background, 100))
	dxDrawLine(mx, 0, mx, screenHeight, getColor(colors.background, 100))
end

function Map.update()
	-- Update movement
	Map.x = Map.x + (targetX - Map.x) * movementSpeed
	Map.y = Map.y + (targetY - Map.y) * movementSpeed

	-- Ограничение перемещения карты
	if Map.x > 0  then
		Map.x = 0 
	elseif Map.x < -Map.width then
		Map.x = -Map.width
	end
	if Map.y > 0 then
		Map.y = 0
	elseif Map.y < -Map.height then
		Map.y = -Map.height
	end

	Map.scale = Map.scale + (targetScale - Map.scale) * scaleSpeed

	local mx, my = getMousePos()
	local wx, wy = posMapToWorld(mx, my)
	Map.currentCity = getZoneName(wx, wy, 0, true)
	Map.currentZone = getZoneName(wx, wy, 0, false)
end

function Map.setWaypoint()
	local mx, my = getMousePos()
	if isElement(waypointBlip) then
		Map.removeWaypoint()
		return
	end
	local x, y = posMapToWorld(mx, my)
	if not isElement(waypointBlip) then
		waypointBlip = createBlip(x, y, 0, 41, 2, 255, 255, 255)
	end
	setElementPosition(waypointBlip, x, y, 0)
end

function Map.removeWaypoint()
	if isElement(waypointBlip) then
		destroyElement(waypointBlip)
	end
end

Map.mapPosToWorldPos = posMapToWorld
Map.worldPosToMapPos = posWorldToMap
Map.init()
