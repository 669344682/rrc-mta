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

instructions.welcoming = {
	show = function()
		setPlayerHudComponentVisible("radar", false)
		setElementFrozen(localPlayer, true)
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

		continueAfterEvent("onAlphaFullyChanged", startInstruction, "panel1")
	end
}

instructions.panel1 = {
	show = function()
		local offsetX = 100

		arrow.x, arrow.y = offsetX, screenY - arrow.h - gui.panelheight
		arrow.rotation = 45
		arrow.visible = true

		window.text = "Чтобы посмотреть свой профиль, нажмите на имя профиля.\n\n"
		window.text = window.text .. "Чтобы передать кому-то деньги, нажмите на ваши деньги."
		window.w, window.h = 500, 100
		window.x, window.y = 40 + offsetX, arrow.y - window.h
		window.visible = true

		button.w = 100
		button.text = "Дальше"
		button.x = window.x + window.w - button.w
		button.y = window.y + window.h + 10
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", startInstruction, "panel2")
	end
}

instructions.panel2 = {
	show = function()
		local offsetX = 390

		arrow.x = screenX - (offsetX * mainScale)
		arrow.y = screenY - arrow.h - gui.panelheight
		arrow.rotation = 0
		arrow.visible = true

		window.text = "По достижении нужного количества респектов\n"
		window.text = window.text .. "Вы сможете купить новый уровень, нажав\n"
		window.text = window.text .. "на кнопку уровня на панели."
		window.w, window.h = 500, 100
		window.x, window.y = screenX - (offsetX * mainScale) + arrow.w/2 - window.w/2, arrow.y - window.h
		window.visible = true

		button.w = 100
		button.text = "Дальше"
		button.x = window.x + window.w - button.w
		button.y = window.y + window.h + 10
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", startInstruction, "panel3")
	end
}

instructions.panel3 = {
	show = function()
		local offsetX = 300

		arrow.x = screenX - (offsetX * mainScale)
		arrow.y = screenY - arrow.h - gui.panelheight
		arrow.rotation = 0
		arrow.visible = true

		window.text = "Чтобы включить карту, нажмите на кнопку\n"
		window.text = window.text .. "или используйте хоткей \"" .. tostring(mapHotkey) .."\".\n"
		window.text = window.text .. "Вы можете поставить точку на карте\nнажатием правой кнопкой мыши."
		window.w, window.h = 500, 100
		window.x, window.y = screenX - (offsetX * mainScale) + arrow.w/2 - window.w/2, arrow.y - window.h
		window.visible = true

		button.w = 100
		button.text = "Дальше"
		button.x = window.x + window.w - button.w
		button.y = window.y + window.h + 10
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", startInstruction, "panel4")
	end
}

instructions.panel4 = {
	show = function()
		window.text = "Вы можете наводить на элементы панели,\n"
		window.text = window.text .. "и над ними будут отображаться пояснения.\n\nНе забудьте: курсор включается кнопкой " .. tostring(mouseButton) .. "\n\n\n"
		window.w, window.h = 500, 200
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.visible = true

		button.w = 60
		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.text = "OK"
		button.visible = true
	end,
	buttonClick = function()
		gui.visible = false

		setTimer(
			function()
				setPlayerHudComponentVisible("radar", true)
				setElementFrozen(localPlayer, false)
				toggleAllControls(true, true, false)
			end, 200, 1
		)

		continueAfterEvent("onAlphaFullyChanged", deinit)
	end
}

instructions.panel = panel1


instructions.VIP = {
	show = function()
		window.w, window.h = 500, 270
		window.x, window.y = screenX/2 - window.w/2, screenY/2 - window.h/2
		window.text = "Вы приобрели VIP аккаунт!\n\n"
		window.text = window.text .. "Теперь вы можете телепортироваться по карте.\n"
		window.text = window.text .. "Для этого откройте карту, поставьте метку\n"
		window.text = window.text .. "и нажмите на кнопку \"телепортироваться\".\n\n"
		window.text = window.text .. "Чтобы пользоваться другими возможностями VIP,\nнажмите на кнопку \"VIP-Панель\" на нижней панели.\n\n\n\n"
		window.visible = true 

		button.w = 60
		button.x = window.x + window.w/2 - button.w/2
		button.y = window.y + window.h - button.h - 20
		button.text = "OK"
		button.visible = true

		arrow.x, arrow.y = screenX/2 - arrow.w/2, window.y + window.h
		arrow.rotation = 0
		arrow.visible = true
	end,
	buttonClick = function()
		triggerServerEvent("disableVIPInstruction", resourceRoot)

		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", deinit)
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
					continueAfterEvent("onAlphaFullyChanged", deinit)
				end
			end, 4000, 1
		)
		
	end,
	buttonClick = function()
		triggerServerEvent("garageDisableReminder", resourceRoot)

		gui.visible = false

		continueAfterEvent("onAlphaFullyChanged", deinit)
	end
}

instructions.beginning = {
	show = function()
		triggerServerEvent("instructions.onClientBeginnerTutorialStart", resourceRoot)
	end
}


triggerEvent("onInstructionsLoaded", resourceRoot)