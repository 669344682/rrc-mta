listArrow = {}

listArrow.size = 35 * mainScale

function listArrow.draw(x, y, rotation, key)
	local alpha = 170
	local sizeOffset = 0
	if getKeyState(key) then
		alpha = 255
		sizeOffset = 5
	end
	dxDrawImage(x - sizeOffset, y - sizeOffset, listArrow.size + sizeOffset * 2, listArrow.size + sizeOffset * 2, "images/arrow.png", rotation, 0, 0, getColor(colors.arrow, alpha))	
end