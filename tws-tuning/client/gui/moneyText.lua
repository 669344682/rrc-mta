moneyText = {}
local width = 400
local height = 100
local x = screenWidth - width
local y = 10
local textScale = 1.5 * mainScale

function moneyText.draw()
	local money = localPlayer:getData("tws-money")
	if not money then
		money = 0
	end
	dxDrawText("$" .. money, x - 1, y, x + width - 15 - 1, y + height, tocolor(0, 0, 0), textScale, "pricedown", "right", "top")
	dxDrawText("$" .. money, x + 1, y, x + width - 15 + 1, y + height, tocolor(0, 0, 0), textScale, "pricedown", "right", "top")
	dxDrawText("$" .. money, x, y - 1, x + width - 15, y + height - 1, tocolor(0, 0, 0), textScale, "pricedown", "right", "top")
	dxDrawText("$" .. money, x, y + 1, x + width - 15, y + height + 1, tocolor(0, 0, 0), textScale, "pricedown", "right", "top")
	dxDrawText("$#FFFFFF" .. money, x, y, x + width - 15, y + height, tocolor(50, 150, 0), textScale, "pricedown", "right", "top", false, false, false, true)
end

--addEventHandler("onClientRender", root, moneyText.draw)