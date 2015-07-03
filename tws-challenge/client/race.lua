Race = {}
Race.opponent = nil
Race.isRunning = false
Race.blip = nil
Race.betAmount = 0

local carbonFont = dxCreateFont("fonts/calibri.ttf", 10 * mainScale, false) 

function Race.start(player, betAmount)
	if Race.isRunning then
		return
	end
	Race.isRunning = true
	Race.opponent = player

	if isElement(Race.blip) then
		destroyElement(Race.blip)
	end
	Race.blip = createBlipAttachedTo(player, 0, 2, 255, 0, 0)
	setElementData(Race.blip, "tws-isGlobalMapHiding", true)
	Race.betAmount = betAmount
end

function Race.cancel()
	if not Race.isRunning then
		return
	end
	triggerServerEvent("tws-challengePlayerLeft", resourceRoot, localPlayer, Race.betAmount)
	Race.stop()
end

function Race.finish()
	if not Race.isRunning then
		return
	end
	outputChatBox("Вы доехали до финиша!", 0, 255, 0)
	triggerServerEvent("tws-challengePlayerFinish", resourceRoot, Race.opponent, Race.betAmount)
	Race.stop()
end

function Race.loose()
	if not Race.isRunning then
		return
	end
	outputChatBox("Противник финишировал!", 0, 255, 0)
	Race.stop()
end

function Race.stop()
	if not Race.isRunning then
		return
	end
	removeCheckpoints()
	Race.isRunning = false
	outputChatBox("Гонка завершена", 0, 255, 0)
	if isElement(Race.blip) then
		destroyElement(Race.blip)
	end
end

function Race.draw()
	if not Race.isRunning then
		return
	end

	local text = "Сдаться"
	local w = dxGetTextWidth(text, 1, carbonFont) + 20 * mainScale
	local h = 20 * mainScale
	local x = screenWidth / 2 - w / 2
	local y = 0
	dxDrawRectangle(x - 1, y - 1, w + 2, h + 2, getColor(colors.background, 255))
	dxDrawRectangle(x, y, w, h, getColor(colors.background2))
	dxDrawText(text, x, y, x + w, y + h, getColor(colors.white, 255), 1, carbonFont, "center", "center")
	local mx, my = getMousePos()
	if mx >= x and mx <= x + w and my >= y and my <= y + h then
		dxDrawRectangle(x, y, w, h, getColor(colors.background, 50))
		if isMouseClick() then
			Race.cancel()
		end
	end
	updateMouseClick()
end

addEvent("tws-challengePlayerFinish", true)
addEventHandler("tws-challengePlayerFinish", resourceRoot,
	function(player)
		if player ~= Race.opponent then
			return
		end
		Race.loose()
		Race.opponent = nil
	end
)

addEventHandler("onClientPlayerQuit", root,
	function()
		if Race.isRunning and source == Race.opponent then
			triggerServerEvent("tws-challengePlayerLeft", resourceRoot, Race.opponent, Race.betAmount)
			Race.stop()
		end
	end
)