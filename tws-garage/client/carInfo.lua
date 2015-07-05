carInfo = {}

local carbonFont = dxCreateFont("fonts/calibri.ttf", 16 * mainScale, true)

carInfo.width = 300 * mainScale
carInfo.height = 60 * mainScale
carInfo.x = (screenWidth - carInfo.width) / 2
carInfo.y = (screenHeight - 110 * mainScale)

local gradient = dxCreateTexture("images/gradient.png", "argb", true, "clamp")
local gradientWidth = 100 * mainScale

function carInfo.draw()
	local ci = carInfo
	local x = carInfo.x 
	local y = carInfo.y
	dxDrawImage(x - gradientWidth, y, gradientWidth, ci.height, gradient, 0, 0, 0, getColor(colors.black, 150))
	dxDrawRectangle(x, y, ci.width, ci.height, getColor(colors.black, 150))
	dxDrawImage(x + ci.width + gradientWidth, y, -gradientWidth, ci.height, gradient, 0, 0, 0, getColor(colors.black, 150))

	listArrow.draw(x - 100 / 2, y + ci.height / 2 - listArrow.size / 2, 180, "arrow_l")
	listArrow.draw(x + ci.width + 100 / 2 - listArrow.size, y + ci.height / 2 - listArrow.size / 2, 0, "arrow_r")

	dxDrawText(tostring(garageVehicles.vehicleName), x, y, x + ci.width, y + ci.height, getColor(colors.white), 1, carbonFont, "center", "center", false, false, false, true)
end