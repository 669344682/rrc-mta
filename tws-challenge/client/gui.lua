local selectedPlayer = nil
local invitingPlayer = nil
local opponentPlayer = nil

Main = {}

Main.opponentBet = 0

local guiState = ""
local carbonFont = dxCreateFont("fonts/calibri.ttf", 10 * mainScale, true)

local infoBlockWidth = 300 * mainScale
local infoBlockHeight = 70 * mainScale
local infoBlockFading = 0

local function drawInfoBlock(text)
	local w = dxGetTextWidth(text, 1, carbonFont) + 20 * mainScale
	local h = infoBlockHeight 
	local x = screenWidth / 2 - w /2
	local y = 5 * mainScale
	dxDrawRectangle(x, y, w, h, getColor(colors.background2, 200 * infoBlockFading))
	dxDrawText(text, x + 10 * mainScale, y, x + 10 * mainScale+ w, y + h, getColor(colors.white, 255 * infoBlockFading), 1, carbonFont, "left", "center", false, false, false, true)

	infoBlockFading = math.min(1, infoBlockFading + (1 - infoBlockFading) * 0.2)
end

addEventHandler("onClientRender", root, 
	function()
		if guiState == "confirm_inviting" then
			local text = "Игрок " .. tostring(getPlayerName(selectedPlayer)) .. "#FFFFFF:\nНажмите '1', чтобы вызвать игрока на гонку\nили '2', чтобы отменить вызов."
			drawInfoBlock(text)
		elseif guiState == "invited" then
			local text = "Вызов от ".. tostring(getPlayerName(invitingPlayer)) .."#FFFFFF\nИгрок вызвал вас на гонку со ставкой $" .. tostring(Main.opponentBet) .. "\nНажмите '1', чтобы принять вызов или '2', чтобы отклонить."
			drawInfoBlock(text)
		end
		Race.draw()
	end
)



addEventHandler("onClientClick", root,
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if not exports["tws-gui-panel"]:isCursorVisible() then
			return
		end
		if button ~= "left" or state ~= "down" then
			return
		end
		if isMTAWindowActive() then
			return
		end

		if not clickedElement then
			return
		end
		if getElementType(clickedElement) ~= "vehicle" then
			return
		end
		local x1, y1, z1 = getElementPosition(localPlayer)
		local x2, y2, z2 = getElementPosition(clickedElement)
		if getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) > 10 then
			return
		end

		local player = getVehicleOccupant(clickedElement)
		if not isElement(player) then
			return
		end
		if player == localPlayer then
			return
		end

		guiState = "confirm_inviting"
		infoBlockFading = 0
		selectedPlayer = player
		exports["tws-gui-panel"]:setCursorVisible(false)
	end
)

addEventHandler("onClientKey", root,
	function(keyName, state)
		if isMTAWindowActive() then
			return
		end
		if not state then
			return
		end
		if guiState == "confirm_inviting" then
			if keyName == "2" then
				guiState = ""
				selectedPlayer = nil
			elseif keyName == "1" then
				guiState = ""
				if isElement(selectedPlayer) then
					Main.opponentBet = (tonumber(exports["tws-gui-settings"]:getSettingsTable().betAmount) or 500)
					triggerServerEvent("tws-challengeInvitePlayer", resourceRoot, selectedPlayer, Main.opponentBet)--)
				end
			end
		elseif guiState == "invited" then
			if keyName == "2" then
				guiState = ""
				triggerServerEvent("tws-challengePlayerAccept", resourceRoot, invitingPlayer, false, "decline")
				selectedPlayer = nil
				invitingPlayer = nil
			elseif keyName == "1" then
				guiState = ""
				triggerServerEvent("tws-challengePlayerAccept", resourceRoot, invitingPlayer, true, Main.opponentBet)
				outputChatBox("Вы приняли вызов игрока #FF0000" .. getPlayerName(invitingPlayer) .. "#00FF00!", 0, 255, 0, true)
				Race.start(invitingPlayer, Main.opponentBet)
				invitingPlayer = nil
			end			
		end
	end
)


addEvent("tws-challengeInvitePlayer", true)
addEventHandler("tws-challengeInvitePlayer", resourceRoot, 
	function(player, amount)
		if invitingPlayer then
			triggerServerEvent("tws-challengePlayerAccept", resourceRoot, player, false, "invitedAlready")
			return
		end
		guiState = "invited"
		infoBlockFading = 0
		Main.opponentBet = amount
		invitingPlayer = player
	end
)

addEvent("tws-challengePlayerAccept", true)
addEventHandler("tws-challengePlayerAccept", resourceRoot,
	function(player, isAccepted, reason)
		if player ~= selectedPlayer then
			return
		end
		if not isElement(selectedPlayer) then
			outputChatBox("Игрок не подключен, поэтому он не смог принять вызов", 255, 0, 0, true)
			return
		end
		if not isAccepted then
			if reason == "decline" then
				outputChatBox("Игрок " .. getPlayerName(player) .. "#FF0000 отказался принять ваш вызов.", 255, 0, 0, true)
			elseif reason == "invitedAlready" then
				outputChatBox("Игрок " .. getPlayerName(player) .. "#FF0000 уже учавствует в другой гонке.", 255, 0, 0, true)
			elseif reason == "nomoney" then
				outputChatBox("У игрока " .. getPlayerName(player) .. "#FF0000 недостаточно денег!", 255, 0, 0, true)
			end
			guiState = ""
			return
		end
		outputChatBox("Игрок #FF0000" .. getPlayerName(player) .. "#00FF00 принял ваш вызов!", 0, 255, 0, true)
		Race.start(player, Main.opponentBet)
	end
)