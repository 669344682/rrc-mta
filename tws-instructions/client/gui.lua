gui = {}
gui.alphaStep = 10
gui.borderSize = 1
gui.font = dxCreateFont("OpenSans-Regular.ttf", 12)
gui.panelheight = screenY / 18

gui.button = {}
gui.window = {}
gui.arrow = {}

button = gui.button
button.visible = false
button.alphaFull = 255
button.alpha = 0
button.color = button.colorNormal
button.w, button.h = 60, 30
button.x, button.y = 100, 200
button.text = "OK"

window = gui.window
window.visible = false
window.alphaFull = 255
window.alpha = 0
window.w, window.h = 200, 100
window.x, window.y = 200, 100
window.text = ""

arrow = gui.arrow
arrow.visible = false
arrow.x, arrow.y = 300, 300
arrow.texture = dxCreateTexture("arrow.png", "argb", true, "clamp")
arrow.w, arrow.h = arrow.texture:getSize()
arrow.w, arrow.h = (arrow.w / 2.13) * mainScale, (arrow.h / 2.13) * mainScale
arrow.alphaFull = 255
arrow.alpha = 0
arrow.rotation = 0

local function clientRender()
	-- window
	if window.visible then
		if window.alpha < window.alphaFull then
			window.isChanging = true
			window.alpha = window.alpha + gui.alphaStep

			if window.alpha >= window.alphaFull then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "window", true)
				window.alpha = window.alphaFull
			end
		end
	else
		if window.alpha > 0 then
			window.isChanging = true
			window.alpha = window.alpha - gui.alphaStep

			if window.alpha <= 0 then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "window", false)
				window.alpha = 0
			end
		end
	end

	window.color = tocolor(0, 40, 51, window.alpha)

	-- arrow
	if arrow.visible then
		if arrow.alpha < arrow.alphaFull then
			arrow.isChanging = true
			arrow.alpha = arrow.alpha + gui.alphaStep

			if arrow.alpha >= arrow.alphaFull then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "arrow", true)
				arrow.alpha = arrow.alphaFull
			end
		end
	else
		if arrow.alpha > 0 then
			arrow.isChanging = true
			arrow.alpha = arrow.alpha - gui.alphaStep

			if arrow.alpha <= 0 then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "arrow", false)
				arrow.alpha = 0
			end
		end
	end

	arrow.color = tocolor(255, 255, 255, arrow.alpha)

	-- button
	if button.visible then
		if button.alpha < button.alphaFull then
			button.isChanging = true
			button.alpha = button.alpha + gui.alphaStep

			if button.alpha >= button.alphaFull then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "button", true)
				button.alpha = button.alphaFull
			end
		end
	else
		if button.alpha > 0 then
			button.isChanging = true
			button.alpha = button.alpha - gui.alphaStep

			if button.alpha <= 0 then
				triggerEvent("onAlphaFullyChanged", resourceRoot, "button", false)
				button.alpha = 0
			end
		end
	end

	button.colorNormal = tocolor(0, 30, 40, button.alpha)
	button.colorHovered = tocolor(30, 70, 80, button.alpha)
	button.color = button.colorNormal


	-- cursor & hover & click
	if not button.isChanging then
		if isCursorShowing() then
			local cursorX, cursorY
			
			cursorX, cursorY = getCursorPosition()
			cursorX, cursorY = screenX * cursorX, screenY * cursorY

			if cursorX > button.x and cursorX < button.x + button.w then
				if cursorY > button.y and cursorY < button.y + button.h then
					button.color = button.colorHovered

					-- click
					gui.mouseState1 = gui.mouseState2
					gui.mouseState2 = getKeyState("mouse1")

					if (gui.mouseState1 == false) and (gui.mouseState2 == true) then
						triggerEvent("onButtonClick", resourceRoot)
					end
				end
			end
		end
	end

	-- visibility
	if gui.visible == false then
		button.visible = false
		window.visible = false
		arrow.visible = false

		gui.visible = nil
	end


	-- border
	local border = gui.borderSize

	-- window
	dxDrawRectangle(window.x - border, window.y - border, window.w + border*2, window.h + border*2, tocolor(0, 0, 0, window.alpha))
	dxDrawRectangle(window.x, window.y, window.w, window.h, window.color)
	dxDrawText(tostring(window.text), window.x, window.y, window.x + window.w, window.y + window.h, tocolor(255, 255, 255, window.alpha), 1, gui.font, "center", "center")

	-- button
	dxDrawRectangle(button.x - border, button.y - border, button.w + border*2, button.h + border*2, tocolor(0, 0, 0, button.alpha))
	dxDrawRectangle(button.x, button.y, button.w, button.h, button.color)
	dxDrawText(button.text, button.x, button.y, button.x + button.w, button.y + button.h, tocolor(255, 255, 255, button.alpha), 1, gui.font, "center", "center")

	-- arrow
	dxDrawImage(arrow.x, arrow.y, arrow.w, arrow.h, arrow.texture, arrow.rotation, 0, 0, arrow.color)
end

addEvent("onAlphaFullyChanged", false)
addEventHandler("onAlphaFullyChanged", resourceRoot,
	function(element, state)
		gui[element].isChanging = false
	end
)

function switch(element, x, y, w, h, text)
	local function continue(_, state)
		if not state then
			removeEventHandler("onAlphaFullyChanged", resourceRoot, continue)

			gui[element].x = x or gui[element].x
			gui[element].y = y or gui[element].y
			gui[element].w = w or gui[element].w 
			gui[element].h = h or gui[element].h
			gui[element].text = text or gui[element].text

			gui[element].visible = true
		end
	end

	if gui[element].visible then
		gui[element].visible = false

		addEventHandler("onAlphaFullyChanged", resourceRoot, continue)
	else
		continue()
	end
end

function init()
	isInitialized = true

	removeEventHandler("onClientRender", root, clientRender)
	addEventHandler("onClientRender", root, clientRender)
end

function deinit()
	isInitialized = false

	removeEventHandler("onClientRender", root, clientRender)
end