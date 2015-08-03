utils = {}

-- Глобальные переменные для размера экрана
screenWidth, screenHeight = guiGetScreenSize()
screenX, screenY = guiGetScreenSize()

mainScale = 1 * screenHeight / 600

-- Проверка нахождения точки в прямоугольнике
function utils.isPointInRect(x, y, rx, ry, rw, rh)
	if x >= rx and y >= ry and x <= rx + rw and y <= ry + rh then
		return true
	else
		return false
	end
end

function utils.unpackVector3(vector)
	return vector.x, vector.y, vector.z
end

function utils.triggerServerEventOnTimer(eventName, source, delay, ...)
	setTimer(
		function(...)
			triggerServerEvent(eventName, source, ...)
		end
	, delay, 1, ...)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end