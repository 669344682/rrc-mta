instructions = {}

screenX, screenY = guiGetScreenSize()
mainScale = screenY / 600
arrowTexture = dxCreateTexture("arrow.png", "argb", true, "clamp")
arrowTextureX, arrowTextureY = arrowTexture:getSize()
arrowTextureX, arrowTextureY = (arrowTextureX / 2.13) * mainScale, (arrowTextureY / 2.13) * mainScale

alphaVisible = true
defaultAlpha = 240
alpha = defaultAlpha
local step = 10

c_buttonColorNormal = {0, 30, 40}
buttonColorNormal = tocolor(0, 30, 40, alpha)
buttonColorHovered = tocolor(30, 70, 80, alpha)
buttonColor = buttonColorNormal
local buttonColorID = 0

button = guiCreateButton(0, 0, 60, 30, "OK", false)
button:setData("order", 0)
button.alpha = 0
button.visible = false

function mouseEnterOrLeave(fake)
	local eventName = eventName or fake
	if eventName == "onClientMouseEnter" then
		buttonColor = buttonColorHovered
		buttonColorID = 1
	else
		buttonColor = buttonColorNormal
		buttonColorID = 0
	end
end
addEventHandler("onClientMouseEnter", button, mouseEnterOrLeave)
addEventHandler("onClientMouseLeave", button, mouseEnterOrLeave)

addEventHandler("onClientGUIClick", button,
	function()
		local order = button:getData("order")
		button.visible = false
		setTimer(mouseEnterOrLeave, 400, 1, false)
		if order == 0 then
			button:setData("order", 1)
			changeAlpha(false)
			local function t()
				button.visible = true
				instructions.welcoming:stopDrawing()
				instructions.panel1:startDrawing()
				changeAlpha(true)

				c_buttonColorNormal = {0, 40, 50}
				buttonColorNormal = tocolor(0, 40, 50, alpha)
				buttonColor = buttonColorNormal

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		elseif order == 1 then
			button:setData("order", 2)
			changeAlpha(false)
			local function t()
				instructions.panel1:stopDrawing()
				instructions.panel2:startDrawing()
				changeAlpha(true)

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		elseif order == 2 then
			button:setData("order", 3)
			changeAlpha(false)
			local function t()
				instructions.panel2:stopDrawing()
				instructions.panel3:startDrawing()
				changeAlpha(true)

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		elseif order == 3 then
			button:setData("order", 4)
			changeAlpha(false)
			local function t()
				instructions.panel3:stopDrawing()
				instructions.panel4:startDrawing()
				changeAlpha(true)

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		elseif order == 4 then
			button:setData("order", 5)
			changeAlpha(false)
			local function t()
				instructions.panel4:stopDrawing()
				instructions.panel5:startDrawing()
				changeAlpha(true)

				c_buttonColorNormal = {0, 30, 40}
				buttonColorNormal = tocolor(0, 30, 40, alpha)
				buttonColor = buttonColorNormal

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		elseif order == 5 then
			button:setData("order", 6)
			changeAlpha(false)
			local function t()
				instructions.panel5:stopDrawing()

				removeEventHandler("onAlphaFullyChanged", resourceRoot, t)
			end
			addEventHandler("onAlphaFullyChanged", resourceRoot, t)
		end
	end
)

addEvent("onAlphaFullyChanged", false)
function changeAlpha(state)
	alphaVisible = state
	local function changingAlpha()
		if alphaVisible and alpha == defaultAlpha then
			return
		elseif not alphaVisible and alpha == 0 then
			return
		end

		buttonColorNormal = tocolor(c_buttonColorNormal[1], c_buttonColorNormal[2], c_buttonColorNormal[3], alpha)
		buttonColorHovered = tocolor(30, 70, 80, alpha)

		if buttonColorID == 0 then
			buttonColor = buttonColorNormal
		else
			buttonColor = buttonColorHovered
		end

		if not alphaVisible and alpha > 0 then
			alpha = alpha - step
		elseif alphaVisible and alpha < defaultAlpha then
			alpha = alpha + step
		end

		if alpha <= 0 then
			alpha = 0
			triggerEvent("onAlphaFullyChanged", resourceRoot, false)
			removeEventHandler("onClientRender", root, changingAlpha)
		elseif alpha >= defaultAlpha then
			alpha = defaultAlpha
			triggerEvent("onAlphaFullyChanged", resourceRoot, true)
			removeEventHandler("onClientRender", root, changingAlpha)
		end
	end
	addEventHandler("onClientRender", root, changingAlpha)
end

function instructions:show(noFade, keepClientFrozen)
	if self.before then
		self.before()
	end
	setTimer(
		function()
			showChat(true)
		end,
	self.duration, 1)
	local function t()
		fadeCamera(true)
		toggleControlAndHud(false)
		showChat(false)
		setCameraMatrix(self.cameraPos, self.cameraTarget)
		drawText(self.text, self.duration, self.cameraPos, self.cameraTarget, keepClientFrozen)

		if self.after then
			setTimer(
				function()
					self.after()
				end, self.duration, 1
			)
		end
	end
	if not noFade then
		fadeCamera(false)
		setTimer(t, 1000, 1)
	else
		t()
	end
end

function instructions:startDrawing()
	if self.before then
		self.before()
	end
	self.drawingEnabled = true
	local function t()
		if self.drawingEnabled == false then
			removeEventHandler("onClientRender", resourceRoot, t)
			return
		end

		self.drawing()
	end
	addEventHandler("onClientRender", root, t)
end

function instructions:stopDrawing()
	if self.after then
		self.after()
	end
	self.drawingEnabled = false
end

function drawText(text, duration, cameraPos, cameraTarget, keepClientFrozen)
	--playSFX("genrl", 52, 14, false)
	playSoundFrontEnd(33)
	toggleControlAndHud(false)

	setCameraMatrix(cameraPos, cameraTarget)

	local function drawStuff()
		dxDrawRectangle(0, 0, screenX, screenY/5, tocolor(0, 0, 0, 255 ), true)
		dxDrawRectangle(0, screenY-screenY/5, screenX, screenY, tocolor(0, 0, 0, 255 ), true)
		dxDrawText(text, 0, screenY-screenY/5, screenX, screenY, tocolor ( 255, 255, 255, 255 ), 2, "default-bold", "center", "center", false, true, true)
	end
	
	addEventHandler("onClientRender", root, drawStuff)
	setTimer(
		function()
			if not keepClientFrozen then
				fadeCamera(false)
			end
			setTimer(
				function()
					removeEventHandler("onClientRender", root, drawStuff)
					if not keepClientFrozen then 
						toggleControlAndHud(true)
						fadeCamera(true)
					end
				end, keepClientFrozen and 50 or 1000, 1
			)
		end, keepClientFrozen and duration or duration - 1000, 1
	)
end

function toggleControlAndHud(bool)
	setElementFrozen(localPlayer, not bool)
	toggleAllControls(bool, true, false)
	exports["tws-utils"]:toggleHUD(bool)
	if (bool == true) then
		setCameraTarget(localPlayer)
	end
end

function clientReset()
	toggleControlAndHud(true)
end

addEvent("onInstructionsLoaded", true)
addEventHandler("onInstructionsLoaded", resourceRoot,
	function()
		for funcName, func in pairs(instructions) do
			if type(func) == "function" then
				for tableName, table in pairs(instructions) do
					if type(table) == "table" then
						if not instructions[tableName][funcName] then
							instructions[tableName][funcName] = func
						end
					end
				end
			end
		end
	end
)

addCommandHandler("res", clientReset)