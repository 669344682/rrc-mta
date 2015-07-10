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