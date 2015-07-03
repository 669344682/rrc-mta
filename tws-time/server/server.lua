local start_h, start_m = 0, 30
local synchronizePeriod = 60000 -- 1 min
local realTime = getRealTime()
local m = realTime.minute
local h = realTime.hour

function synchronizeTime()
	triggerClientEvent("onSynchronizeTime", resourceRoot, h, m)
end

setTimer(
	function()
		--[[m = m + 1
		if tonumber(m) >= 60 then h = h + 1 m = 0 end
		if tonumber(h) >= 24 then h = 0 end]]

		local realTime = getRealTime()
		m = realTime.minute
		h = realTime.hour
	end, minuteDuration, 0)

setTimer(
	function()
		triggerClientEvent("onSynchronizeTime", resourceRoot, h, m)
		setTimer(synchronizeTime, synchronizePeriod, 0)
	end, 1000, 1)

function setGlobalTime(_h, _m)
	h, m = _h, _m
	triggerClientEvent("onSynchronizeTime", resourceRoot, h, m)
end

addEvent("synchronizeRequest", true)
addEventHandler("synchronizeRequest", resourceRoot,
	function()
		--outputChatBox("sync")
		synchronizeTime()
	end
)

addCommandHandler("setGlobalTime", function(_, _, h, m) setGlobalTime(tonumber(h), tonumber(m)) end)