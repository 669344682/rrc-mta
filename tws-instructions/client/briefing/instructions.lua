addEvent("onAlphaFullyChanged", true)

--[[
template:


instructions.name = {
	show = function()

	end,
	buttonClick = function()

	end
}


]]--

local marker, blip

instructions.welcoming = {
	show = function()
		localPlayer.frozen = true
		toggleAllControls(false, true, false)

		window.text = "Добро пожаловать на сервер Russian Racing Club.\n"
		window.text = window.text .. "Вы только что зарегистрировали новый аккаунт.\n"
		window.text = window.text .. "Сейчас будет проведено краткое обучение управлению.\n\n"
		window.text = window.text .. "Чтобы включить курсор, нажмите " .. tostring(mouseButton) .. "\n\n\n"

		window.w, window.h = 500, 220
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, startInstruction, "panel")
	end
}

instructions.panel = {
	show = function()
		window.text = "Нажав на F1, вы попадаете в меню выбора\n"
		window.text = window.text .. "где вы можете зайти в гараж, открыть карту, и так далее.\n\n"

		window.w, window.h = 500, 160
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, startInstruction, "auto")
	end
}


local function markerHit(hitElement)
	if hitElement == localPlayer then
		if localPlayer.vehicle then
			removeEventHandler("onClientMarkerHit", marker, markerHit)

			marker:destroy(); marker = nil
			blip:destroy(); blip = nil

			startInstruction("challenge")
		else
			outputChatBox("Вы должны быть в автомобиле!", 255, 50, 50)
		end
	end
end

instructions.auto = {
	show = function()
		window.text = "Нажмите на F1 еще раз, чтобы скрыть меню и курсор.\n"
		window.text = window.text .. "Чтобы продолжить обучение, сядьте в автомобиль.\n\n"

		window.w, window.h = 500, 160
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		localPlayer.frozen = false
		toggleAllControls(true, true, false)

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
		continueAfterEvent("onClientVehicleEnter", root,
			function()
				marker = createMarker(5296.943, -2083.435, 13.5, "cylinder", 3, 255, 0, 0, 150)
				marker.dimension = localPlayer.dimension

				blip = createBlipAttachedTo(marker)
				blip.dimension = localPlayer.dimension

				addEventHandler("onClientMarkerHit", marker, markerHit)

				startInstruction("racemarker")
			end
		)
	end
}

instructions.racemarker = {
	show = function()
		window.text = "На миникарте появилась точка. Езжайте туда.\n\n\n"

		window.w, window.h = 400, 130
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
	end
}


instructions.challenge = {
	show = function()
		window.text = "Вы можете вызывать других игроков на дуэль.\n"
		window.text = window.text .. "Изменить ставку вы можете в настройках через F1.\n\n"	
		window.text = window.text .. "Чтобы вызвать кого-то на дуэль, включите\n"
		window.text = window.text .. "курсор и нажмите на автомобиль оппонента.\n\n\n"

		window.w, window.h = 500, 240
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
	end
}

instructions.map = {
	show = function()
		local offsetX = 300

		arrow.x = screenX - (offsetX * mainScale)
		arrow.y = screenY - arrow.h - gui.panelheight
		arrow.rotation = 0
		arrow.visible = true

		window.text = "Чтобы включить карту, используйте хоткей \"" .. tostring(mapHotkey) .."\".\n"
		window.text = window.text .. "Вы можете поставить точку на карте\nнажатием правой кнопкой мыши."
		window.w, window.h = 500, 100
		window.x, window.y = screenX - (offsetX * mainScale) + arrow.w/2 - window.w/2, arrow.y - window.h
		window.visible = true

		button.w = 100
		button.text = "OK"
		button.x = window.x + window.w - button.w
		button.y = window.y + window.h + 10
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
	end
}

instructions.VIP = {
	show = function()
		window.w, window.h = 500, 270
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.text = "Вы приобрели VIP аккаунт!\n\n"
		window.text = window.text .. "Теперь вы можете телепортироваться по карте.\n"
		window.text = window.text .. "Для этого откройте карту, поставьте метку\n"
		window.text = window.text .. "и нажмите на кнопку \"телепортироваться\".\n\n"
		window.text = window.text .. "Чтобы пользоваться всеми возможностями VIP,\n"
		window.text = window.text .. "используйте кнопку \"VIP-Панель\" через F1.\n\n\n\n"
		window.visible = true 

		button.w = 60
		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.text = "OK"
		button.visible = true

		-- arrow.x, arrow.y = screenX/2 - arrow.w/2, window.y + window.h
		-- arrow.rotation = 0
		-- arrow.visible = true
	end,
	buttonClick = function()
		triggerServerEvent("disableVIPInstruction", resourceRoot)

		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
	end
}

instructions.garage = {
	show = function()
		if localPlayer:getData("instructions.garageNoReminder") then
			return
		end

		window.w, window.h = 400, 150
		window.x, window.y = screenX/2 - window.w/2, screenY / 10
		window.text = "Чтобы получить доступ к своим автомобилям\n"
		window.text = window.text .. "нажмите на кнопку \"Гараж\" на панели\n\n\n"
		window.visible = true 

		button.w = 240
		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.text = "Больше не напоминать"
		button.visible = true

		setTimer(
			function()
				if window.visible then
					gui.visible = false
					continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
				end
			end, 4000, 1
		)
		
	end,
	buttonClick = function()
		triggerServerEvent("garageDisableReminder", resourceRoot)

		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", resourceRoot, deinit)
	end
}

triggerEvent("onInstructionsLoaded", resourceRoot)