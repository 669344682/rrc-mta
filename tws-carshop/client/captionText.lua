local colors = require("colors")

captionText = {}
captionText.textures = {}

captionText.width = 520 * mainScale
captionText.height = 35 * mainScale

function captionText:start(caption, text)
	if not caption then
		caption = ""
	end
	if not text then
		text = ""
	end

	self.x = (screenWidth - captionText.width) / 2
	self.y = 60 * mainScale
	self.caption = caption
	self.text = text
	self.price = "$0"
	self.priceColor = tocolor(0, 255, 0)

	assetsManager:loadTexture("fg")
	assetsManager:loadTexture("bg")

	self.captionFont = assetsManager:loadFont("carbon", 19 * mainScale, true)
	self.textFont = assetsManager:loadFont("calibri", 14 * mainScale, true)
end

function captionText:stop()
	self.caption = ""
	self.text = ""
end

function captionText:draw()
	local ct = self
	-- Background
	dxDrawImage(ct.x, ct.y, ct.width, ct.height, assetsManager.textures["bg"], 0, 0, 0, colors:getColor("background"))

	-- Shadow
	dxDrawImage(ct.x, ct.y, ct.width, ct.height, assetsManager.textures["fg"], 0, 0, 0, colors:getColor("white"))
	
	-- Caption
	dxDrawText("★ " .. ct.caption .. " ★", ct.x + 3, ct.y + 3 - 40, ct.x + ct.width + 3, ct.y + ct.height + 3, colors:getColor("black", 200), 1, self.captionFont)
	dxDrawText("★ " .. ct.caption .. " ★", ct.x, ct.y - 40, ct.x + ct.width, ct.y + ct.height, colors:getColor("white", 200), 1, self.captionFont)
	-- 
	dxDrawShadowText(ct.text, ct.x, ct.y, ct.x + ct.width, ct.y + ct.height, colors:getColor("white", 200), 1, self.textFont, "center", "center")
	dxDrawShadowText(self.price, ct.x, ct.y + ct.height, ct.x + ct.width, ct.y + ct.height * 2, self.priceColor, 1, self.textFont, "center", "center")
end