colors = {}
colors.black = {0, 0, 0}
colors.white = {255, 255, 255}
colors.grey1 = {200, 200, 200}
colors.background = {0, 200, 255}
colors.background2 = {0, 40, 51}

colors.textHeading = {255, 255, 255}
colors.arrow = {255, 255, 0}

function getColor(color, alpha)
	if not alpha then
		alpha = 255
	end
	return tocolor(color[1], color[2], color[3], alpha)
end 

addCommandHandler("sc",
	function(cmd, n, r, g, b)
		colors[n] = {r, g, b}
	end
)