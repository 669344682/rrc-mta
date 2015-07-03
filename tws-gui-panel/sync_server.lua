addEvent("tws-vehicleActionSync", true)
addEventHandler("tws-vehicleActionSync", resourceRoot,
	function(action)
		local vehicle = getPedOccupiedVehicle(client)
		if not isElement(vehicle) then
			outputChatBox("Вы должны находиться в автомобиле!", client, 255, 0, 0)
			return
		end
		if action == "engine" then
			setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
		elseif action == "lights" then
			if getVehicleOverrideLights(vehicle) ~= 2 then
				setVehicleOverrideLights(vehicle, 2)
			else
				setVehicleOverrideLights(vehicle, 1)
			end
		elseif action == "driftmode" then
			local isEnabled = getElementData(vehicle, "tws-driftMode")
			isEnabled = not isEnabled
			setElementData(vehicle, "tws-driftMode", isEnabled)
			if isEnabled then
				exports["tws-vehicles"]:setVehicleHandlingType(vehicle, "drift")
				outputChatBox("Дрифт-режим", client, 0, 255, 0)
			else
				exports["tws-vehicles"]:setVehicleHandlingType(vehicle, "normal")
				outputChatBox("Нормальный режим", client, 0, 255, 0)
			end
		elseif action == "lock" then
			local accountName = getElementData(client, "tws-accountName")
			local ownerName = getElementData(vehicle, "tws-owner")
			if accountName == ownerName then
				setVehicleLocked(vehicle, not isVehicleLocked(vehicle))
				if isVehicleLocked(vehicle) then
					outputChatBox("Вы закрыли двери автомобиля", client, 0, 255, 0, true)
				else
					outputChatBox("Вы открыли двери автомобиля", client, 0, 255, 0, true)
				end
			else
				outputChatBox("Вы не можете открыть/закрыть чужой автомобиль!", client, 0, 255, 0, true)
			end
		end
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player)
		if not isElement(player) then
			return
		end
		if not isVehicleLocked(source) then
			return
		end
		local accountName = getElementData(player, "tws-accountName")
		local ownerName = getElementData(source, "tws-owner")
		if accountName == ownerName then
			setVehicleLocked(source, false)
			outputChatBox("Вы открыли двери автомобиля", player, 0, 255, 0, true)
		end
	end
)

addEvent("tws-panelButtonAction", true)
addEventHandler("tws-panelButtonAction", resourceRoot,
	function(action)
		if action == "buylevel" then
			exports["tws-main"]:upgradePlayerLevel(client)
		end
	end
)