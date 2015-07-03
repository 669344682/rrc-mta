local mouseButton = "F1"
local mapHotkey = "m"

instructions.carshop1 = {
	cameraPos = Vector3(1168.8999023438, -1837.4420166016, 29.207851409912),
	cameraTarget = Vector3(1140.3837890625, -1869.1912841797, 13.845083236694),
	text = "Это автосалон. Тут вы в любой момент можете приобрести новый автомобиль.",
	duration = 8000
}
instructions.carshop2 = {
	cameraPos = Vector3(1113.7983398438, -1861.5899658203, 14.806400299072),
	cameraTarget = Vector3(1114.5179443359, -1862.2595214844, 14.622410774231),
	text = "Чтобы купить в машину, нужно сесть в нее и нажать пробел.",
	duration = 7000
}
instructions.carshop = {
	show = function()
		instructions.carshop1:show(false, true)
		setTimer(
			function()
				instructions.carshop2:show(true, false)
			end, instructions.carshop1.duration, 1
		)
	end
}

instructions.welcoming = {
	before = function()
		setPlayerHudComponentVisible("radar", false)
		setElementFrozen(localPlayer, true)
		toggleAllControls(false, true, false)
		local w, h = 800, 300
		local x, y = screenX/2-30, screenY/2+h/2-50
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local w, h = 800, 300
		local x, y = screenX/2 - w/2, screenY/2 - h/2
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Добро пожаловать на сервер Russian Racing Club.\nВы только что зарегистрировали новый аккаунт.\nСейчас будет проведено краткое обучение управлению.\n\n\nЧтобы включить курсор, нажмите " .. tostring(mouseButton) .."\n\n\n", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 2, "default-bold", "center", "center")
	
		local x, y = screenX/2-30, screenY/2+h/2-50
		w, h = 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end	
}

instructions.panel1 = {
	before = function()
		local x, y, w, h = 50, screenY - arrowTextureY - screenY/18
		w, h = 400, 100
		x, y = 100, y - 100
		x, y, w, h = x+w-60, y+h+10, 60, 30
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local x, y, w, h = 50, screenY - arrowTextureY - screenY/18
		dxDrawImage(x, y, arrowTextureX, arrowTextureY, arrowTexture, 45, 0, 0, tocolor(255, 255, 255, alpha))
		w, h = 400, 100
		x, y = 100, y - 100
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Чтобы посмотреть свой профиль, нажмите на имя профиля.\n\nЧтобы передать кому-то деньги, нажмите на ваши деньги.", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
		x, y, w, h = x+w-60, y+h+10, 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end
}

instructions.panel2 = {
	before = function()
		local x, y, w, h = screenX - (390 * mainScale), screenY - arrowTextureY - screenY/18
		w, h = 400, 100
		x, y = screenX - (390 * mainScale) + arrowTextureX/2 - w/2, y - 100
		x, y, w, h = x+w-60, y+h+10, 60, 30
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local x, y, w, h = screenX - (390 * mainScale), screenY - arrowTextureY - screenY/18
		dxDrawImage(x, y, arrowTextureX, arrowTextureY, arrowTexture, 0, 0, 0, tocolor(255, 255, 255, alpha))
		w, h = 400, 100
		x, y = screenX - (390 * mainScale) + arrowTextureX/2 - w/2, y - 100
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("По достижении нужного количества респектов,\nВы сможете купить новый уровень, нажав\nна кнопку уровня на панели.", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
		x, y, w, h = x+w-60, y+h+10, 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end
}

instructions.panel3 = {
	before = function()
		local x, y, w, h = screenX - (300 * mainScale), screenY - arrowTextureY - screenY/18
		w, h = 400, 100
		x, y = screenX - (300 * mainScale) + arrowTextureX/2 - w/2, y - 100
		x, y, w, h = x+w-60, y+h+10, 60, 30
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local x, y, w, h = screenX - (300 * mainScale), screenY - arrowTextureY - screenY/18
		dxDrawImage(x, y, arrowTextureX, arrowTextureY, arrowTexture, 0, 0, 0, tocolor(255, 255, 255, alpha))
		w, h = 400, 100
		x, y = screenX - (300 * mainScale) + arrowTextureX/2 - w/2, y - 100
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Чтобы включить карту, нажмите на кнопку\nили используйте хоткей \"" .. tostring(mapHotkey) .."\".\nВы можете поставить точку на карте\nнажатием правой кнопкой мыши.", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
		x, y, w, h = x+w-60, y+h+10, 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end
}

instructions.panel4 = {
	before = function()
		local x, y, w, h = screenX - (240 * mainScale), screenY - arrowTextureY - screenY/18
		w, h = 400, 100
		x, y = screenX - (240 * mainScale) + arrowTextureX/2 - w/2, y - 100
		x, y, w, h = x+w-60, y+h+10, 60, 30
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local x, y, w, h = screenX - (240 * mainScale), screenY - arrowTextureY - screenY/18
		dxDrawImage(x, y, arrowTextureX, arrowTextureY, arrowTexture, 0, 0, 0, tocolor(255, 255, 255, alpha))
		w, h = 400, 100
		x, y = screenX - (240 * mainScale) + arrowTextureX/2 - w/2, y - 100
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Также вы можете зайти в настройки,\nнажав на соответствующую кнопку.", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
		x, y, w, h = x+w-60, y+h+10, 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end,
	after = function()

	end
}

instructions.panel5 = {
	before = function()
		local w, h = 800, 300
		local x, y = screenX/2-30, screenY/2+h/2-50
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local w, h = 800, 300
		local x, y = screenX/2 - w/2, screenY/2 - h/2
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Вы можете наводить на элементы панели,\n и над ними будут отображаться пояснения.\n\nТеперь купите любой авто и следуйте\nдальнейшим инструкциям.\n\n", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 2, "default-bold", "center", "center")
	
		local x, y = screenX/2-30, screenY/2+h/2-50
		w, h = 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end,
	after = function()
		button.visible = false
		setPlayerHudComponentVisible("radar", true)
		setElementFrozen(localPlayer, false)
		toggleAllControls(true, true, false)
	end
}

instructions.vehiclepanel = {
	before = function()
		local w, h = 800, 300
		local x, y = screenX/2-30, screenY/2+h/2-50
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local w, h = 800, 300
		local x, y = screenX/2 - w/2, screenY/2 - h/2
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("При нахождении в автомобиле будет появляться\nкнопка \"Машина\" на панели. Нажав на нее, вы сможете\nвыполнять различные действия над своим автомобилем:\nпереключение дрифт-режима, фар, двигателя, и прочее.\n\n", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 2, "default-bold", "center", "center")
	
		local x, y = screenX/2-30, screenY/2+h/2-50
		w, h = 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end,
	after = function()
		button.visible = false
	end
}

instructions.map = {
	before = function()
		local w, h = 800, 300
		local x, y = screenX/2-30, screenY/2+h/2-50
		button:setPosition(x, y, false)
		button.visible = true
	end,
	drawing = function()
		local w, h = 800, 300
		local x, y = screenX/2 - w/2, screenY/2 - h/2
		dxDrawRectangle(x, y, w, h, tocolor(0, 40, 51, alpha))
		dxDrawText("Вы можете включать карту и ориентироваться по значкам.\nЧаще всего у каждого места, имеющего значение\n(отель, тюнинг, салоны и т.д) есть свои значки на карте,\nпо которым вы всегда сможете их найти.\n\n", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 2, "default-bold", "center", "center")
	
		local x, y = screenX/2-30, screenY/2+h/2-50
		w, h = 60, 30
		dxDrawRectangle(x, y, w, h, buttonColor)
		dxDrawText("OK", x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 1, "default-bold", "center", "center")
	end,
	after = function()
		button.visible = false
	end
}


addEvent("onCameraFinishedMoving", false)

instructions.hotel1 = {
	cameraPos = Vector3(385.8117980957, -1506.2413330078, 60.117900848389),
	cameraTarget = Vector3(331.59225463867, -1514.4986572266, 35.8671875),
	text = "Это отель. Здесь вы будете появляться при входе в игру или в случае смерти.",
	duration = 7000
}

function instructions.hotel1:after()
	local self = instructions.hotel1
	local obj
	local movingTime = 2000
	obj = createObject(1337, self.cameraTarget)
	obj.alpha = 0
	obj.collisions = false

	--outputChatBox(tostring(instructions.hotel2.cameraTarget))
	moveObject(obj, movingTime, instructions.hotel2.cameraTarget, 0, 0, 0, "InOutQuad")
	
	local function clientRender()
		dxDrawRectangle (0, 0, screenX, screenY/5, tocolor(0, 0, 0, 255), true)
		dxDrawRectangle (0, screenY-screenY/5, screenX, screenY, tocolor(0, 0, 0, 255 ), true)
		setCameraMatrix(self.cameraPos, obj.position)

		if obj.position.x == instructions.hotel2.cameraTarget.x and 
			obj.position.y == instructions.hotel2.cameraTarget.y and
			obj.position.z == instructions.hotel2.cameraTarget.z then

			setTimer(
				function()
					removeEventHandler("onClientRender", root, clientRender)
					triggerEvent("onCameraFinishedMoving", resourceRoot)
				end, 50, 1
			)

		end
	end
	addEventHandler("onClientRender", root, clientRender)

end

instructions.hotel2 = {
	cameraPos = instructions.hotel1.cameraPos,
	cameraTarget = Vector3(367.77679443359, -1474.5841064453, 32.521179199219),
	text = "Вы сможете заехать в гараж, если вы будете за рулем своей машины, \nчтобы поставить ее или взять новую.Также вы можете \nзайти в гараж непосредственно из самого отеля.",
	duration = 10000
}


instructions.hotel = {
	show = function()
		instructions.hotel1:show(false, true)
		local function t()
			removeEventHandler("onCameraFinishedMoving", resourceRoot, t)
			instructions.hotel2:show(true, false)
		end
		addEventHandler("onCameraFinishedMoving", resourceRoot, t)
	end
}

function startInstruction(instruction)
	instructions[instruction]:show()
end


triggerEvent("onInstructionsLoaded", resourceRoot)

instructions.vehiclepanel.show = instructions.vehiclepanel.startDrawing
instructions.welcoming.show = instructions.welcoming.startDrawing
instructions.map.show = instructions.welcoming.startDrawing

-- carshop, welcoming, vehiclepanel, map, hotel

addEvent("tws-startInstruction", true)
addEventHandler("tws-startInstruction", resourceRoot,
	function(instruction)
		startInstruction(instruction)
	end
)