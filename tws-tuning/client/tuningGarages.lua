local tuningGarages = {
	{id = 10, gates = {1041.5,-1026,30}, teleport = {1041.5,-1010,30}}
}

addEventHandler("onClientColShapeHit", root, 
	function(element)
		if element ~= getPedOccupiedVehicle(localPlayer) and element ~= localPlayer then
			return
		end

		if not getElementData(source, "tws-tuningColShape") then
			return
		end

		local garageID = getElementData(source, "tws-garageID")
		if garageID then
			setGarageOpen(garageID, true)
		end

		if  element == getPedOccupiedVehicle(localPlayer) and getElementData(source, "tws-tuningEnter") and getElementData(source, "tws-colshapeEnabled") then
			tuningEnter(source)
			setElementData(source, "tws-colshapeEnabled", false)
		end
	end
)

addEventHandler("onClientColShapeLeave", root,
	function(element)
		if element ~= localPlayer and element ~= getPedOccupiedVehicle(localPlayer) then
			return
		end
		if not getElementData(source, "tws-tuningColShape") then
			return
		end

		local garageID = getElementData(source, "tws-garageID")
		if garageID and not getElementData(source, "tws-tuningEnter") then
			setGarageOpen(garageID, false)
		end

		if getElementData(source, "tws-tuningEnter") then
			setElementData(source, "tws-colshapeEnabled", true)
		end
	end
)

local function addGarage(id, x, y, z, tx, ty, tz)
	local gateCol = createColSphere(x, y, z, 8)
	local tpCol = createColSphere(tx, ty, tz, 6)
	setElementData(gateCol, "tws-tuningColShape", true, false)
	setElementData(tpCol, "tws-tuningColShape", true, false)
	setElementData(tpCol, "tws-colshapeEnabled", true)

	setElementData(gateCol, "tws-garageID", id, false)
	setElementData(tpCol, "tws-garageID", id, false)
	setElementData(tpCol, "tws-tuningEnter", true, false)
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i, g in ipairs(tuningGarages) do
			addGarage(g.id, g.gates[1], g.gates[2], g.gates[3], g.teleport[1], g.teleport[2], g.teleport[3])
		end
	end
)