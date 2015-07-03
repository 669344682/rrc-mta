Blips = {}

local localPlayerColor = tocolor(100, 255, 0)
local remotePlayerColor = tocolor(0, 208, 255)

local function drawBlip(blip)
	local x, y = getElementPosition(blip)
	local color = tocolor(getBlipColor(blip))
	local icon = getBlipIcon(blip)
	local iconName = "marker"
	if Icons.standartIcons[icon] then
		iconName = Icons.standartIcons[icon]
		color = tocolor(255, 255, 255)
	end
	Map.drawIcon(iconName, x, y, 0, color)
end

local function drawPlayer(player)
	if getElementDimension(player) ~= getElementDimension(localPlayer) or getElementData(player, "tws-isGlobalMapHiding")then
		return
	end

	local color = remotePlayerColor
	if player == localPlayer then
		color = localPlayerColor
	end
	local x, y = getElementPosition(player)
	local rx, ry, rz = getElementRotation(player)
	Map.drawIcon("arrow", x, y, rz, color)
end

function Blips.draw()
	-- Blips
	local blips = getElementsByType("blip")
	for i, blip in ipairs(blips) do
		local isHiding = getElementData(blip, "tws-isGlobalMapHiding")
		if not isHiding then
			drawBlip(blip)
		end
	end

	-- Remote players
	local players = getElementsByType("player")
	for i, player in ipairs(players) do
		if player ~= localPlayer then
			drawPlayer(player)
		end
	end

	-- Local player
	drawPlayer(localPlayer)
end