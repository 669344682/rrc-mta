local notAllowedSkinsDEFAULT = {3, 4, 5, 6, 8, 42, 65, 74, 86, 119, 149, 208, 265, 266, 267, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 294, 295}
local notAllowedSkins = notAllowedSkinsDEFAULT
local screenWidth, screenHeight = guiGetScreenSize()

addEvent("onSelectSkinForced", true)
addEventHandler("onSelectSkinForced", root,
	function()
		--outputChatBox("Пожалуйста, выберите скин", 0, 255, 0)
		setTimer(
			function()
				exports["tws-gui-hud"]:setVisible(false)
				setPlayerHudComponentVisible("radar", false)
			end, 50, 10
		)
		fadeCamera(false)
		setTimer(
			function()
				fadeCamera(true)
				setCameraMatrix(-2654.3403320313, 1423.0421142578, 913.37658691406, -2654.3403320313, 1522.2769775391, 890.32873535156, 0, 70)
				setCameraInterior(3)
				setElementInterior(localPlayer, 3)

				local ped = createPed(1, -2654.3403320313, 1427.3687744141, 912.41143798828, 180)
				setElementInterior(ped, 3)
				setElementDimension(ped, getElementDimension(localPlayer))

				function drawStuff()
					-- Верхний блок
					dxDrawRectangle(0, 0, screenWidth, 100, tocolor(0, 0, 0, 150), false)
					-- Нижний блок
					dxDrawRectangle(0, screenHeight - 100, screenWidth, 100, tocolor(0, 0, 0, 150), false)

					dxDrawText("Нажимайте #00FF00←#FFFFFF или #00FF00→#FFFFFF для просмотра", 0, 0, screenWidth, 100, tocolor(255, 255, 255), 2, "default-bold", "center", "center", false, false, false, true)
					dxDrawText("Выбрать персонажа - #00FF00ENTER", 0, screenHeight - 100, screenWidth, screenHeight, tocolor(255, 255, 255), 2, "default-bold", "center", "center", false, false, false, true)
				end

				local skinNumber = 1
				function clientKey(key, bool)
					if bool == true then
						if (key == "arrow_r") then
							playSFX("genrl", 52, 27, false)
							if(ped.model == 299) then
								ped.model = 1
							else
								skinNumber = skinNumber + 1
								local i = 1
								while (i <= #notAllowedSkins) do
									if skinNumber == notAllowedSkins[i] then
										skinNumber = skinNumber + 1
									end
									i = i + 1
								end
								if skinNumber > 299 then 
									skinNumber = 1 
								end

								ped.model = skinNumber
							end
							skinNumber = ped.model
						elseif (key == "arrow_l") then
							playSFX("genrl", 52, 27, false)
							if(ped.model == 1) then
								ped.model = 299
							else
								skinNumber = skinNumber - 1
								local i = #notAllowedSkins
								while (i >= 1) do
									if skinNumber == notAllowedSkins[i] then
										skinNumber = skinNumber - 1
									end
									i = i - 1
								end
								if skinNumber < 1 then 
									skinNumber = 299 
								end

								ped.model = skinNumber
							end
							skinNumber = ped.model
						elseif (key == "enter") then
							playSFX("genrl", 52, 27, false)
							fadeCamera(false)
							removeEventHandler("onClientKey", root, clientKey) 
							removeEventHandler("onClientRender", root, drawStuff)
							setTimer(
								function()
									setPlayerHudComponentVisible("radar", true)
									exports["tws-gui-hud"]:setVisible(true)
									triggerServerEvent("onPlayerChoseSkin", resourceRoot, ped.model)
									destroyElement(ped)
								end, 1000, 1
							)

						end
					end
				end

				addEventHandler("onClientKey", root, clientKey) 
				addEventHandler("onClientRender", root, drawStuff, true, "high")
			end, 1500, 1
		)
	end
)

function refreshSkins()
	local resource = getResourceFromName("tws-skins")
	if resource and resource.state == "running" then
		notAllowedSkins = notAllowedSkinsDEFAULT
		
		local VIPSkins = exports["tws-skins"]:getVIPSkins()
		for _, skin in ipairs(VIPSkins) do
			table.insert(notAllowedSkins, skin)
		end
	end
end

refreshSkins()

addEventHandler("onClientResourceStart", root,
	function(resourceStarted)
		if resourceStarted == getResourceFromName("tws-skins") then
			refreshSkins()
		end
	end
)