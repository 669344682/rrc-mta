local colors = {}

colors.names = {
	black = {0, 0, 0},
	white = {255, 255, 255},
	grey1 = {200, 200, 200},
	background = {0, 200, 255},
	background2 = {0, 40, 51},
	textHeading = {255, 255, 255},
	arrow = {255, 255, 0}
}


function colors:getColor(colorName, alpha)
	local color = self.names[colorName]
	if not color then 
		return tocolor(0, 0, 0)
	end
	if not alpha then
		alpha = 255
	end
	return tocolor(color[1], color[2], color[3], alpha)
end 

return colors