addEvent("hidePotracheno", true)
--addEvent("onServerPlayerWasted", true)
addEventHandler("onClientPlayerWasted", localPlayer, 
	function()
		setTimer(
			function()
				--toggleHUD(false)

				local screenX, screenY = guiGetScreenSize()
				local step = 5
				local alpha = 0

				-- text
				local x1, y1 = 0, 0
				local x2, y2 = screenX, screenY
				local font = "sans"
				local scaleX = screenX/150
				local scaleY = screenY/180
				-- border
				local s = 10
				local text = "П О Т Р А Ч Е Н О"

				function draw()
					dxDrawText (text, x1+s, y1, x2, y2, tocolor (0, 0, 0, alpha), scaleX, scaleY, font, "center", "center", false, false, false)
					dxDrawText (text, x1, y1+s, x2, y2, tocolor (0, 0, 0, alpha), scaleX, scaleY, font, "center", "center", false, false, false)
					dxDrawText (text, x1-s, y1, x2, y2, tocolor (0, 0, 0, alpha), scaleX, scaleY, font, "center", "center", false, false, false)
					dxDrawText (text, x1, y1-s, x2, y2, tocolor (0, 0, 0, alpha), scaleX, scaleY, font, "center", "center", false, false, false)

					dxDrawText (text, x1, y1, x2, y2, tocolor (255, 255, 255, alpha), scaleX, scaleY, font, "center", "center", false, false, false)

					if alpha < 255 then
						alpha = alpha + step
						if alpha > 255 then
							alpha = 255
						end
					end
				end
				addEventHandler("onClientRender", root, draw)

				addEventHandler("hidePotracheno", root, -- при спавне игрока сразу убираем надпись 
					function()
						--toggleHUD(true)
						removeEventHandler("onClientRender", root, draw)
					end
				)
			end, 500, 1
		)
	end
)