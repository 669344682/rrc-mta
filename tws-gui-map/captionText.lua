captionText = {}

local carbonFont = dxCreateFont("fonts/carbon.ttf", 19 * mainScale, true)
local textFont = dxCreateFont("fonts/calibri.ttf", 14 * mainScale, true)

local images = {
	background = "images/bg.png",
	shadow = "images/fg.png",
}

-- Position and size
captionText.x = 0
captionText.y = 0
captionText.defaultY = 0
captionText.width = 520 * mainScale
captionText.height = 35 * mainScale

-- Caption text
captionText.caption = ""
captionText.text = ""

function captionText.start(y, caption, text)
	captionText.x = (screenWidth - captionText.width) / 2
	captionText.y = y
	captionText.caption = caption
	captionText.text = text
end

function captionText.draw()
	local ct = captionText
	-- Background
	dxDrawImage(ct.x, ct.y, ct.width, ct.height, images.background, 0, 0, 0, getColor(colors.background))

	-- Shadow
	dxDrawImage(ct.x, ct.y, ct.width, ct.height, images.shadow, 0, 0, 0, getColor(colors.white))
	
	-- Caption
	dxDrawText("★ " .. ct.caption .. " ★", ct.x + 3, ct.y + 3 - 40, ct.x + ct.width + 3, ct.y + ct.height + 3, getColor(colors.black, 200), 1, carbonFont)
	dxDrawText("★ " .. ct.caption .. " ★", ct.x, ct.y - 40, ct.x + ct.width, ct.y + ct.height, getColor(colors.white, 200), 1, carbonFont)

	-- 
	dxDrawShadowText(ct.text, ct.x, ct.y, ct.x + ct.width, ct.y + ct.height, getColor(colors.white, 200), 1, textFont, "center", "center")
end