local twsComponentNames = {
	"tws-fbump",
	"tws-rbump",
	"tws-skirts",
	"tws-sunroof",
	"tws-spoiler"
}


local accordings = {
	["tws-fbump"] = 5,
	["tws-rbump"] = 6
}

function updatingComponents()
	local vehicles = getElementsByType("vehicle")
	for _, vehicle in ipairs(vehicles) do
		if isElementStreamedIn(vehicle) then
			-- заполняем список с модифицированными компонентами, если они есть
			if not vehicle:getData("customComponents") then
				local componentsList = {}
				local components = vehicle:getComponents()

				for _, name in ipairs(twsComponentNames) do
					if components[name] then
						table.insert(componentsList, name)
					end
				end

				if componentsList ~= 0 then
					vehicle:setData("customComponents", componentsList, false)
				else
					vehicle:setData("customComponents", 0, false)
				end
			end

			-- если список модифицированными компонентами не пустой, то
			if vehicle:getData("customComponents") ~= 0 then
				local componentsList = vehicle:getData("customComponents")
				for _, component in ipairs(componentsList) do
					local numberOfVehiclePart = accordings[component] -- соответствующее число в getVehiclePanelState
					local vehiclePartDamaggedInt = numberOfVehiclePart and getVehiclePanelState(vehicle, accordings[component]) or false

					-- если изменился уровень - ставим соответствующий компонент
					local level = vehicle:getData(component .. "-level")
					if level then
						local activeLevel = vehicle:getData(component .. "-activeLevel")
						if activeLevel ~= level then
							vehicle:setData(component .. "-activeLevel", level)

							-- скрываем все компоненты
							for i = 0, 5 do
								setVehicleComponentVisible(vehicle, component .. "-" ..  i, false)
								setVehicleComponentVisible(vehicle, component .. "-" ..  i .. "-dam", false)
							end

							-- делаем видимым нужный

							-- если есть повреждения, то выбираем, какой именно поставить
							if numberOfVehiclePart then
								if vehiclePartDamaggedInt == 0 then
									setVehicleComponentVisible(vehicle, component .. "-" ..  level, true)
								else
									setVehicleComponentVisible(vehicle, component .. "-" ..  level .. "-dam", true)
								end
							-- если повреждений не существует вообще в природе
							else
								setVehicleComponentVisible(vehicle, component .. "-" ..  level, true)
							end

							componentChanged(vehicle, component, level)
						end
					else
						vehicle:setData(component .. "-level", 0, false)
					end

					-- повреждения
					if numberOfVehiclePart then
						local isComponentDamagged = vehicle:getData(component .. "-isDamagged") or 0
						
						 -- если машина повреждена, а компонент нет
						if vehiclePartDamaggedInt > 0 and isComponentDamagged == 0 then
							vehicle:setData(component .. "-isDamagged", 1)

							setVehicleComponentVisible(vehicle, component .. "-" ..  level, false)
							setVehicleComponentVisible(vehicle, component .. "-" ..  level .. "-dam", true)

						-- если машина не повреждена, а компонент поврежден
						elseif vehiclePartDamaggedInt == 0 and isComponentDamagged == 1 then
							vehicle:setData(component .. "-isDamagged", 0)

							setVehicleComponentVisible(vehicle, component .. "-" ..  level .. "-dam", false)
							setVehicleComponentVisible(vehicle, component .. "-" ..  level, true)
						end
					end
				end
			end
		end
	end
end

addEventHandler("onClientRender", root, updatingComponents)

addEventHandler("onClientResourceStop", root,
	function(resourceStopped)
		if resourceStopped == getThisResource() then
			local vehicles = getElementsByType("vehicle")
			for _, vehicle in ipairs(vehicles) do
				vehicle:setData("customComponents", false, false)
			end
		end
	end
)