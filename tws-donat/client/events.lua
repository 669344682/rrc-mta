local oldSettings = {}
local isSkinViewingVIP = nil

addEvent("onLuckyGUIClick", true)
addEventHandler("onLuckyGUIClick", root, 
	function(g)
		if g == gui.close1 or g == gui.close2 then
			-- закрываем гуи и сохраняем некоторые изменения (те, что не сохраняются в реальном времени)
			toggleGUI(false)

			triggerServerEvent("onVIPSettingsChange", resourceRoot, "fightingStyleID", localPlayer:getData("fightingStyleID"))
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "fightingStyleName", localPlayer:getData("fightingStyleName"))
		elseif g == gui.nextPage1 then
			twsGUI:setVisible(gui.window1, false)
			twsGUI:setVisible(gui.window2, true)

			gui.window = gui.window2
		elseif g == gui.previousPage2 then
			twsGUI:setVisible(gui.window2, false)
			twsGUI:setVisible(gui.window1, true)

			gui.window = gui.window1
		elseif g == gui.skinEditNew then
			-- делаем поле ввода для ID скина пустым
			twsGUI:setText(gui.skinEditNew, "")
		elseif g == gui.skinButtonAccept then
			-- применяем скин
			local id = tonumber(twsGUI:getText(gui.skinEditNew))

			if not id then return end

			local goodID = false
			if id >= 0 and id <= 312 then
				goodID = true

				for _, badID in ipairs(notAllowedSkins) do
					if id == badID then
						goodID = false
						break
					end
				end
			end

			if goodID then
				twsGUI:setText(gui.skinEdit, id)
				triggerServerEvent("onVIPSettingsChange", resourceRoot, "skin", id)
			else
				twsGUI:setText(gui.skinEditNew, "")
			end
		elseif g == gui.specID then
			-- делаем поле ввода для ID игрока пустым
			twsGUI:setText(gui.specID, "")
		elseif g == gui.specButton then
			-- начинаем спекать за ID
			local id = twsGUI:getText(gui.specID)

			startSpectating(id)
		elseif g == gui.jetpackHotkey then
			-- делаем поле ввода для хоткея пустым и ждем хоткей
			twsGUI:setText(gui.jetpackHotkey, "...")
			
			removeEventHandler("onClientKey", root, waitingHotkeyForJetpack)
			addEventHandler("onClientKey", root, waitingHotkeyForJetpack)
		elseif g == gui.colorButton then
			-- выбор цвета

			toggleGUI(false)
			localPlayer:setData("showingSelfName", true)
			Colorpicker:start("Цвет вашего никнейма и точки на радаре", screenX/2 - Colorpicker.width/2, screenY - Colorpicker.height - screenY/10)
		elseif g == gui.fightingStylePrevious then
			twsGUI:setText(gui.fightingStyle, changeFightingStyle(twsGUI:getText(gui.fightingStyle), "previous"))
		elseif g == gui.fightingStyleNext then
			twsGUI:setText(gui.fightingStyle, changeFightingStyle(twsGUI:getText(gui.fightingStyle), "next"))
		elseif g == gui.radarPosToggle then
			-- переключение блипа игрока на радаре
			local state = twsGUI:getToggleState(gui.radarPosToggle)
			
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "tws-isGlobalMapHiding", state)
		elseif g == gui.crownShowingToggle then
			-- переключение короны возле ника
			local state = twsGUI:getToggleState(gui.crownShowingToggle)
			
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "isCrownShowing", state)
		elseif g == gui.headlessToggle then
			-- убираем голову
			local state = twsGUI:getToggleState(gui.headlessToggle)
			
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "headless", state)
		elseif g == gui.godmodeToggle then
			-- переключаем годмод
			local state = twsGUI:getToggleState(gui.godmodeToggle)
			
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "godmode", state)
		elseif g == gui.waterHoveringToggle then
			-- переключаем возможность ездить по воде
			local state = twsGUI:getToggleState(gui.waterHoveringToggle)
			
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "waterHovering", state)
		elseif g == gui.stopSpectating then
			stopSpectating()
		elseif g == gui.skinView then
			-- включаем окно выбора скинов
			twsGUI:setText(gui.currentSkinLabel, gui.currentSkinString .. localPlayer.model)
			twsGUI:setVisible(gui.skinWindow, true)
			toggleGUI(false)

			isSkinViewingVIP = false
		elseif g == gui.skinViewVIP then
			-- включаем окно выбора скинов (VIP скины)
			twsGUI:setText(gui.currentSkinLabel, gui.currentSkinString .. localPlayer.model)
			twsGUI:setVisible(gui.skinWindow, true)
			toggleGUI(false)

			isSkinViewingVIP = true
		elseif g == gui.skinGlobalVisibilityButton then
			-- переключаем видимость смены скинов для всех
			gui.skinGlobalVisibility = not gui.skinGlobalVisibility
			local text = gui.skinGlobalVisibility and "Другие игроки видят, как вы меняете скин" or "Другие игроки не видят, как вы меняете скин" 
			twsGUI:setText(gui.skinGlobalVisibilityButton, text)
		elseif g == gui.stopSkinViewing then
			-- отключаем окно выбора скинов, включаем окно доната
			twsGUI:setVisible(gui.skinWindow, false)
			toggleGUI(true)

			isSkinViewingVIP = nil

			triggerServerEvent("onVIPSettingsChange", resourceRoot, "skin", localPlayer.model)
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "tws-skin", localPlayer.model)
		elseif g == gui.previousSkin or g == gui.nextSkin then
			-- следующий или предыдущий скин
			local skin

			if g == gui.nextSkin then -- NEXT SKIN
				if isSkinViewingVIP then -- только VIP скины
					if localPlayer.model == VIPSkins[#VIPSkins] then  -- если это край, то идем в другой конец
						skin = VIPSkins[1]
					else
						local index = 1
						for i, VIPSkin in ipairs(VIPSkins) do
							if localPlayer.model == VIPSkin then
								index = i
								break
							end
						end

						skin = VIPSkins[index + 1]
					end
				else -- только normal скины
					if localPlayer.model == normalSkins[#normalSkins] then  -- если это край, то идем в другой конец
						skin = normalSkins[1]
					else
						local index = 1
						for i, normalSkin in ipairs(normalSkins) do
							if localPlayer.model == normalSkin then
								index = i
								break
							end
						end

						skin = normalSkins[index + 1]
					end
				end
			elseif g == gui.previousSkin then -- PREVIOUS SKIN
				if isSkinViewingVIP then -- только VIP скины
					if localPlayer.model == VIPSkins[1] then  -- если это край, то идем в другой конец
						skin = VIPSkins[#VIPSkins]
					else
						local index = #VIPSkins
						for i, VIPSkin in ipairs(VIPSkins) do
							if localPlayer.model == VIPSkin then
								index = i
								break
							end
						end

						skin = VIPSkins[index - 1]
					end
				else -- только normal скины
					if localPlayer.model == normalSkins[1] then -- если это край, то идем в другой конец
						skin = normalSkins[#normalSkins]
					else
						local index = #normalSkins
						for i, normalSkin in ipairs(normalSkins) do
							if localPlayer.model == normalSkin then
								index = i
								break
							end
						end

						skin = normalSkins[index - 1]
					end
				end
			end

			if gui.skinGlobalVisibility then -- меняем скин сервером
				triggerServerEvent("onClientChangeSkinGlobal", resourceRoot, skin)
			else -- меняем скин клиентом
				localPlayer.model = skin
			end

			twsGUI:setText(gui.currentSkinLabel, gui.currentSkinString .. skin)
			------------------------------------------
			----------- THE SECOND WINDOW ------------
			------------------------------------------
			elseif g == gui.carNumberNewEdit then
				carNumberTextNew = ""
			elseif g == gui.carRegionNewEdit then
				carNumberRegionNew = ""
			elseif g == gui.carplateButton then
				local vehicle = localPlayer.vehicle
				if not vehicle then
					outputChatBox("* Чтобы изменить номера, нужно быть в своей машине!", 255, 100, 100)
					return
				end
				
				if not vehicle:getData("tws-owner") or not localPlayer:getData("tws-accountName") then
					outputChatBox("* Неизвестная ошибка! (#NO DATA)", 255, 100, 100)
					return
				end

				if vehicle:getData("tws-owner") ~= localPlayer:getData("tws-accountName") then
					outputChatBox("* Менять номера можно только у своей машины!", 255, 100, 100)
					return
				end

				if string.len(carNumberTextNew) ~= 6 then
					outputChatBox("* Выбранный вами номер слишком короткий!", 255, 100, 100)
					return
				end

				if string.len(carNumberRegionNew) < 1 then
					outputChatBox("* Введите регион!", 255, 100, 100)
					return
				end

				local region = carNumberRegionNew

				if tonumber(region) < 10 then
					region = "0" .. tostring(region)
				end

				exports["tws-vehicles"]:applyVehicleNumberPlate(vehicle, carNumberTextNew, region)
			end
	end
)

addEvent("tws-onColorpickerSelect", true)
addEventHandler("tws-onColorpickerSelect", resourceRoot,
	function(r, g, b)
		localPlayer:setData("nameColor_R", r)
		localPlayer:setData("nameColor_G", g)
		localPlayer:setData("nameColor_B", b)

		localPlayer:setData("showingSelfName", false)
		toggleGUI(true)

		triggerServerEvent("onVIPSettingsChange", resourceRoot, "nameColor_R", r)
		triggerServerEvent("onVIPSettingsChange", resourceRoot, "nameColor_G", g)
		triggerServerEvent("onVIPSettingsChange", resourceRoot, "nameColor_B", b)
	end
)

addEvent("tws-onColorpickerUpdateColor", true)
addEventHandler("tws-onColorpickerUpdateColor", resourceRoot,
	function(r, g, b)
		localPlayer:setData("nameColor_R", r)
		localPlayer:setData("nameColor_G", g)
		localPlayer:setData("nameColor_B", b)
	end
)

local numberLetters = {"A", "B", "C", "E", "H", "K", "M", "O", "P", "T", "X", "Y"}

addEvent("onLuckyGUIChanged", true)
addEventHandler("onLuckyGUIChanged", root,
	function(id, before, after, isBackspace)
		if id == gui.skinEditNew or id == gui.specID then
			if string.len(after) > 3 then
				twsGUI:setText(id, before)
			end
		elseif id == gui.carRegionNewEdit then
			twsGUI:setText(id, "")

			if after == "" and not isBackspace then
				return
			end

			if isBackspace then
				carNumberRegionNew = string.sub(carNumberRegionNew, 1, -2)
				return
			end

			local lastSymbol = after
			local before = carNumberRegionNew
			local after = before .. lastSymbol
			local region = after

			if not tonumber(after) then
				region = before
			elseif tonumber(after) >= 199 then
				region = 199
			elseif tonumber(after) <= 0 then
				region = 1
			end

			if not tonumber(region) then
				return
			end

			if tonumber(region) > 10 then
				region = tostring(tonumber(region))
			end

			carNumberRegionNew = region
		elseif id == gui.carNumberNewEdit then
			twsGUI:setText(id, "")

			if after == "" and not isBackspace then
				return
			end

			if isBackspace then
				carNumberTextNew = string.sub(carNumberTextNew, 1, -2)
				return
			end

			local lastSymbol = after
			local before = carNumberTextNew
			local after = before .. lastSymbol
			local carNumber = after

			if string.len(after) > 6 then
				carNumber = before
			elseif string.len(before) >= 1 and string.len(before) < 4 then
				if lastSymbol ~= "0" and not tonumber(lastSymbol) then
					carNumber = before
				end
			elseif string.len(before) == 0 or string.len(before) >= 4 then
				carNumber = before
				for _, letter in ipairs(numberLetters) do
					if lastSymbol == string.lower(letter) then
						carNumber = after
						break
					end
				end
			end

			carNumberTextNew = carNumber
		end
	end
)

addEvent("onServerSendVIPTimeLeft", true)
addEventHandler("onServerSendVIPTimeLeft", resourceRoot,
	function(daysLeft, progressBarTimeLeft)
		local daysLeft = math.ceil(daysLeft)
		local lastNumber = tonumber(daysLeft) % 10
		local twoLastNumbers = tonumber(daysLeft) % 100
		local string = "до окончания VIP аккаунта" 

		if lastNumber == 1 and twoLastNumbers ~= 11 then
			string = " день " .. string
		elseif lastNumber == 2 or lastNumber == 3 or lastNumber == 4 then
			if twoLastNumbers ~= 12 and twoLastNumbers ~= 13 and twoLastNumbers ~= 14 then
				string = " дня " .. string
			else
				string = " дней " .. string
			end
		else
			string = " дней " .. string
		end

		string = daysLeft .. string

		if progressBarTimeLeft > 1 then
			progressBarTimeLeft = 1
		end


		twsGUI:setText(gui.daysLabel1, string)
		setProgress(gui.progressBar1, progressBarTimeLeft)

		twsGUI:setText(gui.daysLabel2, string)
		setProgress(gui.progressBar2, progressBarTimeLeft)
	end
)

local fightingStyles = {
	{name = "DEFAULT", id = 15},
	{name = "BOXING", id = 5},
	{name = "KUNG_FU", id = 6},
	{name = "KNEE_HEAD", id = 7},
}

function changeFightingStyle(current, direction)
	local index
	for i, v in ipairs(fightingStyles) do
		if current == v.name then
			if direction == "next" then
				if (i + 1) <= #fightingStyles then
					index = i + 1
				else
					index = 1
				end
			else
				if (i - 1) >= 1 then
					index = i - 1
				else
					index = #fightingStyles
				end
			end
		end
	end
	if fightingStyles[index] then
		localPlayer:setData("fightingStyleID", fightingStyles[index].id, false)
		localPlayer:setData("fightingStyleName", fightingStyles[index].name, false)
		return fightingStyles[index].name
	else
		localPlayer:setData("fightingStyleID", fightingStyles[1].id, false)
		localPlayer:setData("fightingStyleName", fightingStyles[1].name, false)
		return fightingStyles[1].name
	end
end

local badHotkeys = {"w", "a", "s", "d", "t", "space", "escape", "lctrl", "lalt", "lshift", "enter", "tab", "rctrl", "ralt", "rshift", "capslock", "`"}
function waitingHotkeyForJetpack(key, state)
	if state == true then
		for _, badHotkey in ipairs(badHotkeys) do
			if key == badHotkey then
				return
			end
		end

		if key == "mouse1" or key == "mouse2" then
			twsGUI:setText(gui.jetpackHotkey, string.upper(oldSettings.jetpackHotkey))
		else
			twsGUI:setText(gui.jetpackHotkey, string.upper(key))
			triggerServerEvent("onVIPSettingsChange", resourceRoot, "jetpackHotkey", key)
		end
		removeEventHandler("onClientKey", root, waitingHotkeyForJetpack)
	end
end

function toggleGUI(state)
	if state == true then
		if not localPlayer:getData("isVIP") then
			outputChatBox("[ERROR] Вы не VIP!", 220, 0, 0)
			return
		end

		twsGUI:setText(gui.skinEdit, localPlayer.model)
		twsGUI:setText(gui.jetpackHotkey, string.upper(localPlayer:getData("jetpackHotkey")))
		twsGUI:setText(gui.fightingStyle, localPlayer:getData("fightingStyleName"))

		twsGUI:setToggleState(gui.radarPosToggle, localPlayer:getData("tws-isGlobalMapHiding"))
		twsGUI:setToggleState(gui.crownShowingToggle, localPlayer:getData("isCrownShowing"))
		twsGUI:setToggleState(gui.headlessToggle, localPlayer:getData("headless"))
		twsGUI:setToggleState(gui.godmodeToggle, localPlayer:getData("godmode"))
		twsGUI:setToggleState(gui.waterHoveringToggle, localPlayer:getData("waterHovering"))


		local t = {}
		t.skin = twsGUI:getText(gui.skinEditNew)
		t.jetpackHotkey = twsGUI:getText(gui.jetpackHotkey)
		t.fightingStyle = twsGUI:getText(gui.fightingStyle)
		t.radarPosBlip = twsGUI:getToggleState(gui.radarPosToggle)
		t.crownShowing = twsGUI:getToggleState(gui.crownShowingToggle)
		t.headless = twsGUI:getToggleState(gui.headlessToggle)
		t.godmode = twsGUI:getToggleState(gui.godmodeToggle)
		t.waterHovering = twsGUI:getToggleState(gui.waterHoveringToggle)

		oldSettings = t

		twsGUI:setVisible(gui.window, true)
	else
		oldSettings = {}

		twsGUI:setVisible(gui.window, false)
	end
	isGUIVisible = state
end

function startSpectating(id)
	if not localPlayer:getData("isVIP") then
		outputChatBox("[ERROR] Вы не VIP!", 220, 0, 0)
		return
	end

	local id = tonumber(id)

	local resource = getResourceFromName("tws-main")
	if not (resource and resource.state == "running") then
		return
	end

	local player = exports["tws-main"]:getPlayerByID(id)
	if player then
		setCameraTarget(player)

		toggleGUI(false)
		twsGUI:setVisible(gui.stopSpectating, true)
	else
		outputChatBox("[ERROR] Неверный ID!", 220, 0, 0)
	end
end

function stopSpectating()
	setCameraTarget(localPlayer)

	toggleGUI(true)
	twsGUI:setVisible(gui.stopSpectating, false)
end

addCommandHandler("spectate", function(cmd, shit) startSpectating(id) end)

addCommandHandler("donatgui", function() toggleGUI(not isGUIVisible) end)

