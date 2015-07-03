local screenX, screenY = guiGetScreenSize()
local textBoldSize = 1 + screenY/480 + (3 - (screenY/480))*(screenY-480)/(1080-480)
local font = "pricedown"
local scaleX = screenX/640 + (2 - (screenY/640))*(screenY-640)/(1920-640)
local scaleY = screenY/480 + (3 - (screenY/480))*(screenY-480)/(1080-480)
local worldTimeFrozen = false
local start_h, start_m = 24, 0
local setWorldTime = setTime
local isClockVisible = true

setMinuteDuration(minuteDuration)

setPlayerHudComponentVisible("clock", false)

addEvent("onSynchronizeTime", true)
addEventHandler("onSynchronizeTime", resourceRoot,
	function(h, m)
		setTime(h, m)
		if not worldTimeFrozen then
			setWorldTime(h, m)
		end
	end
)


function setTime(h, m)
	if tonumber(m) >= 60 then h = h + 1 m = 0 end
	if tonumber(h) >= 24 then h = 0 end

	if string.len(h) == 1 then
		h = "0" .. h
	end

	if string.len(m) == 1 then
		m = "0" .. m
	end

	time_h = h
	time_m = m
end
setTime(start_h, start_m)


setTimer(function()
	--setTime(tonumber(time_h), tonumber(time_m) + 1)
end, minuteDuration, 0)

--[[addEventHandler("onClientRender", root,
	function()
		if not isClockVisible then
			return
		end
		local x1 = screenX * 0.86125
		local y1 = screenY * 0.05
		local x2 = screenX * 0.94
		local y2 = screenY * 0.15

		dxDrawText (time_h .. ":" .. time_m, x1 + textBoldSize, y1, x2, y2, tocolor(0, 0, 0), scaleX, scaleY or scaleX, font, "center", "center")
		dxDrawText (time_h .. ":" .. time_m, x1 - textBoldSize, y1, x2, y2, tocolor(0, 0, 0), scaleX, scaleY or scaleX, font, "center", "center")
		dxDrawText (time_h .. ":" .. time_m, x1, y1 + textBoldSize, x2, y2, tocolor(0, 0, 0), scaleX, scaleY or scaleX, font, "center", "center")
		dxDrawText (time_h .. ":" .. time_m, x1, y1 - textBoldSize, x2, y2, tocolor(0, 0, 0), scaleX, scaleY or scaleX, font, "center", "center")

		dxDrawText (time_h .. ":" .. time_m, x1, y1, x2, y2, tocolor(215, 215, 215), scaleX, scaleY or scaleX, font, "center", "center")
	end
)]]


function freezeWorldTimeAt(h, m)
	worldTimeFrozen = true
	setWorldTime(h, m)
	setMinuteDuration(99999999)
end

function unfreezeWorldTime()
	worldTimeFrozen = false
	setMinuteDuration(minuteDuration)
	triggerServerEvent("synchronizeRequest", resourceRoot)
end

triggerServerEvent("synchronizeRequest", resourceRoot)

function setClockVisible(isVisible)
	isClockVisible = isVisible
end

function getTime()
	return tonumber(time_h), tonumber(time_m)
end

function getTimeString()
	return time_h .. ":" .. time_m
end