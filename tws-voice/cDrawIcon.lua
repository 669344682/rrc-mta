local g_screenX,g_screenY = guiGetScreenSize()
local BONE_ID = 8
local SCREEN_OFFSET = 0
local WORLD_OFFSET = 0.8
local WORLD_OFFSET_LOCALPLAYER = 0.4
local ICON_PATH = "images/voice.png"
local ICON_WIDTH = 400
local MAX_DISTANCE = 35
-- local ICON_HEIGHT = 0.213333333333*g_screenY
--
local voiceIcon = dxCreateTexture("images/voice.png", "argb", true, "clamp")
local iconHalfWidth = ICON_WIDTH/2
-- local iconHalfHeight = ICON_HEIGHT/2

local ICON_DIMENSIONS = 16
local ICON_LINE = 20
local ICON_TEXT_SHADOW = tocolor ( 0, 0, 0, 255 )

--Draw the voice image
addEventHandler ( "onClientRender", root,
	function()
		local index = 0
		--if not bShowChatIcons then return end
		for player in pairs(voicePlayers) do
			--local color = tocolor(getPlayerNametagColor ( player ))
			--dxDrawVoiceLabel ( player, index, color )
			index = index + 1
			while true do
				--is he streamed in?
				if not isElementStreamedIn(player) then
					break
				end
				--is he on screen?
				if not isElementOnScreen(player) then 
					break
				end
				local headX,headY,headZ = getPedBonePosition(player,BONE_ID)
				if player == localPlayer then
					headZ = headZ + WORLD_OFFSET_LOCALPLAYER
				else
					headZ = headZ + WORLD_OFFSET
				end
				--is the head position on screen?
				local absX,absY = getScreenFromWorldPosition ( headX,headY,headZ )
				if not absX or not absY then
					break
				end
				local camX,camY,camZ = getCameraMatrix()
				--is there anything obstructing the icon?
				if not isLineOfSightClear ( camX, camY, camZ, headX, headY, headZ, true, false, false, true, false, true, false, player ) then
					break
				end
				--is he within the max distance?
				if (getDistanceBetweenPoints3D(camX, camY, camZ, headX, headY, headZ) > MAX_DISTANCE) then
					break
				end
				dxDrawVoice ( absX, absY, color, getDistanceBetweenPoints3D(camX, camY, camZ, headX, headY, headZ) )
				break
			end
		end
	end
)

function dxDrawVoice ( posX, posY, color, distance )
	distance = 1/distance
	dxDrawImage ( posX - iconHalfWidth*distance, posY - iconHalfWidth*distance - SCREEN_OFFSET, ICON_WIDTH*distance, ICON_WIDTH*distance, voiceIcon, 0, 0, 0, tocolor(255, 255, 255), false )
end

function dxDrawVoiceLabel ( player, index, color )
	local sx, sy = guiGetScreenSize ()
	local scale = sy / 800
	local spacing = ( ICON_LINE * scale )
	local px, py = sx - 200, sy * 0.7 + spacing * index
	local icon = ICON_DIMENSIONS * scale

	dxDrawImage ( px, py, icon, icon, ICON_PATH, 0, 0, 0, color, false )

	px = px + spacing

	-- shadows
	dxDrawText ( getPlayerName ( player ), px + 1, py + 1, px, py, ICON_TEXT_SHADOW, scale )
	-- text
	dxDrawText ( getPlayerName ( player ), px, py, px, py, color, scale )
end

