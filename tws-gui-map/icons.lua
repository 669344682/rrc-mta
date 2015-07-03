Icons = {
	iconSize = 16,

	arrow = {
		size = 32,
		img = dxCreateTexture("images/icons/arrow.png")
	},

	marker = {
		img = dxCreateTexture("images/icons/marker.png")
	},

	waypoint = {
		size = 32,
		img = dxCreateTexture("images/icons/waypoint.png")
	},

	savehouse = {
		size = 32,
		img = dxCreateTexture("images/icons/savehouse.png")
	},

	spray = {
		size = 32,
		img = dxCreateTexture("images/icons/spray.png")
	},

	car = {
		size = 32,
		img = dxCreateTexture("images/icons/car.png")
	},

	cash = {
		size = 32,
		img = dxCreateTexture("images/icons/cash.png")
	}
}

Icons.standartIcons = {
	[41] = "waypoint",
	[35] = "savehouse",
	[63] = "spray",
	[55] = "car",
	[52] = "cash"
}

function Icons.drawIcon(name, x, y, rotation, color)
	-- Position and size
	local size = Icons[name].size
	if not size then
		size = Icons.iconSize
	end
	x = x - size / 2
	y = y - size / 2

	-- Rotation
	if not rotation then
		rotation = 0
	else
		rotation = -rotation
	end
	dxDrawImage(x, y, size, size, Icons[name].img, rotation, 0, 0, color)
end