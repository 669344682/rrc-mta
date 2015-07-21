local WORLD_OFFSET = 0.6
local MAX_DISTANCE = 35
local SHADOW_SIZE = 20
local FONT_SIZE_MULTIPLIER = 1
local ID_COLOR = {155, 155, 155}

local nametagsVisible = true

local screenX, screenY = guiGetScreenSize()

local font1, font2, font3

font1 = dxCreateFont("font.ttf", 150, false)
font2 = dxCreateFont("font.ttf", 20, false)
font3 = dxCreateFont("font.ttf", 12, false)


dxDrawText("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()!\"№;%:?[];'><.,/\\+-=_~`♛", 0, 0, 0, 0, tocolor(255, 255, 255), 0, font1)
dxDrawText("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()!\"№;%:?[];'><.,/\\+-=_~`♛", 0, 0, 0, 0, tocolor(255, 255, 255), 0, font2)
dxDrawText("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()!\"№;%:?[];'><.,/\\+-=_~`♛", 0, 0, 0, 0, tocolor(255, 255, 255), 0, font3)

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

local CROWN = "♛"

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		for k, v in ipairs(getElementsByType("player")) do
			setPlayerNametagShowing(v, false)
		end
	end
)
addEventHandler("onClientPlayerJoin", root,
	function()
		setPlayerNametagShowing(source, false)
	end
)

function drawing()
	if not nametagsVisible then
		return
	end

	for index, player in ipairs(getElementsByType("player")) do
		while true do
			if player == localPlayer and not localPlayer:getData("showingSelfName") then
				break
			end

			--is he streamed in?
			if not isElementStreamedIn(player) then
				break
			end
			--is he on screen?
			if not isElementOnScreen(player) then 
				break
			end
			local headX, headY, headZ = getPedBonePosition(player, 8)
			headZ = headZ + WORLD_OFFSET
			--is the head position on screen?
			local absX, absY = getScreenFromWorldPosition(headX, headY, headZ)
			if not absX or not absY then
				break
			end
			local camX, camY, camZ = getCameraMatrix()
			--is there anything obstructing the icon?
			if not isLineOfSightClear(camX, camY, camZ, headX, headY, headZ, true, false, false, true, false, true, false, player) then
				break
			end
			--is he within the max distance?
			if (getDistanceBetweenPoints3D(camX, camY, camZ, headX, headY, headZ) > MAX_DISTANCE) then
				break
			end

			local crownShowing = player:getData("isCrownShowing")
			local crownColor = getPlayerColor(player) or RGBToHex(255, 255, 255)
			local nameColor = getPlayerColor(player) or RGBToHex(255, 255, 255)
			local name = player.name
			local id = " (" .. tostring(getElementData(player, "tws-id")) .. ")"

			dxDrawNametag(name, nameColor, id, crownShowing, crownColor, absX, absY, getDistanceBetweenPoints3D(camX, camY, camZ, headX, headY, headZ))

			break
		end
	end
end
addEventHandler("onClientRender", root, drawing)

function getPlayerColor(player)
	if not player:getData("isVIP") then
		return
	end

	local color

	local r = player:getData("nameColor_R")
	local g = player:getData("nameColor_G")
	local b = player:getData("nameColor_B")

	if not (r or g or b) then
		return
	end

	--outputChatBox("R: " .. tostring(r) .. ", " .. "G: " .. tostring(g) .. ", " .. "B: " .. tostring(b))
	color = RGBToHex(r, g, b)

	return color
end

function dxDrawNametag(name, nameColor, id, crownShowing, crownColor, posX, posY, distance)
	local r_distance = 1/distance
	local scale, font, shadowSize
	
	font = font1
	scale = MAX_DISTANCE / distance/(35 * (1 / FONT_SIZE_MULTIPLIER))
	shadowSize = SHADOW_SIZE * scale

	if distance > 10 then
		scale = MAX_DISTANCE / distance/(4.7 * (1 / FONT_SIZE_MULTIPLIER))
		font = font2
		shadowSize = (SHADOW_SIZE - 17) * scale
	end

	if distance > 13 then
		scale = MAX_DISTANCE / distance/(2.7 * (1 / FONT_SIZE_MULTIPLIER))
		font = font3
		shadowSize = (SHADOW_SIZE - 18) * scale
	end

	if crownShowing then
		local crownColored = crownColor .. CROWN .. RGBToHex(255, 255, 255)

		dxDrawText(CROWN .. " " .. tostring(name) .. " " .. CROWN .. id, posX+shadowSize, posY+shadowSize, posX+shadowSize, posY+shadowSize, tocolor(0, 0, 0, 100), scale, font, "center")
		dxDrawText(crownColored .. " " .. nameColor .. tostring(name) .. " " .. crownColored .. RGBToHex(unpack(ID_COLOR)) .. id, posX, posY, posX, posY, tocolor(255, 255, 255), scale, font, "center", "top", false, false, false, true)
	else
		dxDrawText(tostring(name) .. id, posX+shadowSize, posY+shadowSize, posX+shadowSize, posY+shadowSize, tocolor(0, 0, 0, 100), scale, font, "center")
		dxDrawText(nameColor .. tostring(name) .. RGBToHex(unpack(ID_COLOR)) .. id, posX, posY, posX, posY, tocolor(255, 255, 255), scale, font, "center", "top", false, false, false, true)
	end
end

function setNametagsVisible(state)
	nametagsVisible = state
end