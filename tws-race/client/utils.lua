screenX, screenY = guiGetScreenSize()
speedoX, speedoY, speedoX2, speedoY2 = exports["tws-speedometer"]:getPosition()
speedoW = speedoX2 - speedoX
speedoH = speedoY2 - speedoY

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getTimeFromTickCount(tickCount)
	local sec, ms = math.modf(tickCount/1000)
	local min = math.modf(sec / 60)

	sec = sec % 60
	if string.len(sec) == 1 then
		sec = "0" .. tostring(sec)
	end

	ms = string.sub(ms, 3)
	if string.len(ms) == 0 then
		ms = "000"
	elseif string.len(ms) == 1 then
		ms = tostring(ms) .. "00"
	elseif string.len(ms) == 2 then
		ms = tostring(ms) .. "0"
	elseif string.len(ms) > 3 then
		ms = string.sub(ms, 1, 3)
	end

	return min, sec, ms
end