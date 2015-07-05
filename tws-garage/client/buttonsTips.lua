buttonsTips = {}

buttonsTips.width = 120 * mainScale
buttonsTips.height = 20 * mainScale
buttonsTips.x = 0
buttonsTips.y = screenHeight - buttonsTips.height - 10 * mainScale
buttonsTips.space = 20

local buttonsList = {}
local textFont = dxCreateFont("fonts/calibri.ttf", 8 * mainScale)

function buttonsTips.start(buttons)
	buttonsList = buttons

	buttonsTips.x = (screenWidth - (buttonsTips.width + buttonsTips.space) * #buttonsList - buttonsTips.space) / 2
end

function buttonsTips.stop()
	buttonsList = nil
end

function buttonsTips.draw(fade)
	local x = buttonsTips.x
	local y = buttonsTips.y + fade * (buttonsTips.height * 5)
	for i, text in ipairs(buttonsList) do
		dxDrawRoundRectangle(x, y, buttonsTips.width, buttonsTips.height, getColor(colors.background2, 200), 5)
		dxDrawShadowText(text, x, y, x + buttonsTips.width, y + buttonsTips.height, getColor(colors.white, 200), 1, textFont, "center", "center")
		x = x + buttonsTips.width + buttonsTips.height
	end
end