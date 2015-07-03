local colors = require("colors")

buttonsTips = {}
buttonsTips.width = 130 * mainScale
buttonsTips.height = 20 * mainScale
buttonsTips.y = screenHeight - buttonsTips.height - 10 * mainScale
buttonsTips.space = 20

function buttonsTips:start(buttons)
	self.buttonsList = buttons
	if not self.buttonsList then
		self.buttonsList = {}
	end

	self.x = (screenWidth - (self.width + self.space) * #self.buttonsList - self.space) / 2

	assetsManager:loadTexture("corner")
	self.textFont = assetsManager:loadFont("calibri", 8 * mainScale, true)
end

function buttonsTips:stop()
	self.buttonsList = {}
end

function buttonsTips:draw()
	local x = self.x
	local y = self.y
	for i, text in ipairs(self.buttonsList) do
		dxDrawRoundRectangle(x, y, self.width, self.height, colors:getColor("background2", 200), 5, assetsManager.textures["corner"])
		dxDrawShadowText(text, x, y, x + self.width, y + self.height, colors:getColor("white", 200), 1, self.textFont, "center", "center")
		x = x + self.width + self.height
	end
end