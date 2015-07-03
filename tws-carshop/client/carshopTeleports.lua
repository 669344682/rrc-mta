addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i, carshopInfo in ipairs(carshopsList) do
			local x, y, z = unpack(carshopInfo.door_position)
			exports["tws-teleports"]:createArrow(x, y, z, 0, nil, carshopInfo.name)

			colSphere = createColSphere(x, y, z, 1)
			colSphere:setData("tws-carshop-id", i)
		end
	end
)

addEventHandler("onClientColShapeHit", root, 
	function(element)
		if element ~= localPlayer then
			return
		end
		local carshopID = source:getData("tws-carshop-id")

		if carshopID then
			carshopMain:startEnter(carshopID)
		end
	end
)