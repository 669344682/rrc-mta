require("utils")

carshopMain = {}
carshopMain.isActive = false

function carshopMain:start(carshopInfo)
	self.position = Vector3(unpack(carshopInfo.interior_position))
	assetsManager:start()
	carshopInterior:start()
	carshopGUI:start()
	carshopVehicle:start(Vector3(unpack(carshopInfo.vehicle_rotation)), carshopInfo.vehicles)
	carshopCamera:start()
end

function carshopMain:stop()
	carshopInterior:stop()
	carshopGUI:stop()
	carshopCamera:stop()
	carshopVehicle:stop()
	assetsManager:stop()
end

function carshopMain:startEnter(carshopID)
	if self.isActive then
		outputChatBox("Вы уже находитесь в автомагазине", 255, 0, 0)
		return
	end
	self.carshopID = carshopID
	fadeCamera(false)
	utils.triggerServerEventOnTimer("tws-onClientCarshopEnter", resourceRoot, 1000, carshopID)
end

function carshopMain:onEnter(carshopInfo)
	self.isActive = true
	carshopMain:start(carshopInfo)
	fadeCamera(true)
end

function carshopMain:startExit()
	if not self.isActive then
		outputChatBox("Вы не находитесь в автомагазине", 255, 0, 0)
		return
	end
	fadeCamera(false)
	utils.triggerServerEventOnTimer("tws-onClientCarshopExit", resourceRoot, 1000)
end

function carshopMain:onExit()
	self.isActive = false
	carshopMain:stop()
	self.carshopID = nil
	fadeCamera(true)
end

function carshopMain:buyVehicle()
	if localPlayer:getData("tws-money") < carshopVehicle.price then
		outputChatBox("У вас недостаточно денег для покупки этого автомобиля.", 255, 0, 0)
		return
	else
		triggerServerEvent("tws-onClientCarshopBuy", resourceRoot, self.carshopID, carshopVehicle.currentVehicle)
	end
end

function carshopMain:onBuy(isSuccess)
	if isSuccess then
		self:startExit()
		outputChatBox("Поздравляем с покупкой нового автомобиля!", 0, 255, 0)
		outputChatBox("Теперь он доступен в вашем гараже.", 0, 255, 0)
	else
		outputChatBox("Вы не можете приобрести этот автомобиль.", 255, 0, 0)
	end
end

-- Handling server-side events

addEvent("tws-onServerCarshopEnter", true)
addEventHandler("tws-onServerCarshopEnter", resourceRoot, function(...) carshopMain:onEnter(...) end)

addEvent("tws-onServerCarshopExit", true)
addEventHandler("tws-onServerCarshopExit", resourceRoot, function(...) carshopMain:onExit(...) end)

addEvent("tws-onServerCarshopBuy", true)
addEventHandler("tws-onServerCarshopBuy", resourceRoot, function(...) carshopMain:onBuy(...) end)

-- Debug command

addCommandHandler("carshop",
	function()
		if not carshopMain.isActive then
			carshopMain:startEnter(1)
		else
			carshopMain:startExit()
		end
	end
)