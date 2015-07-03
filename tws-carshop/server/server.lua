addEvent("tws-onClientCarshopEnter", true)
addEventHandler("tws-onClientCarshopEnter", resourceRoot,
	function(carshopID)
		if not carshopsList[carshopID] then
			triggerClientEvent(client, "tws-onServerCarshopExit", resourceRoot)
			return
		end
		client.frozen = true
		client.dimension = exports["tws-main"]:getPlayerID(client)
		
		triggerClientEvent(client, "tws-onServerCarshopEnter", resourceRoot, carshopsList[carshopID])
	end
)

addEvent("tws-onClientCarshopExit", true)
addEventHandler("tws-onClientCarshopExit", resourceRoot,
	function()
		client.frozen = false
		client.dimension = 0

		triggerClientEvent(client, "tws-onServerCarshopExit", resourceRoot)
	end
)

addEvent("tws-onClientCarshopBuy", true)
addEventHandler("tws-onClientCarshopBuy", resourceRoot, 
	function(carshopID, vehicleID)
		if not carshopsList[carshopID] then
			triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, false)
			return
		end
		if not carshopsList[carshopID].vehicles[vehicleID] then
			triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, false)
			return
		end
		local model = carshopsList[carshopID].vehicles[vehicleID].model
		local price = carshopsList[carshopID].vehicles[vehicleID].price

		if not model or not price then
			triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, false)
			return
		elseif client:getData("tws-money") >= price then
			local vehicleID = exports["tws-vehicles"]:addShopVehicleToGarage(client, model, 255, 255, 255)
			if vehicleID then
				exports["tws-main"]:givePlayerMoney(client, -price)
				triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, true)
			else
				triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, false)
			end
		else
			triggerClientEvent(client, "tws-onServerCarshopBuy", resourceRoot, false)
		end
	end
)