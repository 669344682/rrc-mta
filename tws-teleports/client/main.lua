loadstring(exports["tws-shared"]:include("utils"))()

local arrows = {}
local arrowsRotation = 0
local arrowsRotationSpeed = 3
local dimensionArrows = {}
local teleportsCount = 0

setDevelopmentMode(true)

function createArrow(x, y, z, int, dim, text)
	local arrow = createObject(1318, x, y, z)
	if int then
		setElementInterior(arrow, int)
	end
	if dim then
		local id = getElementData(localPlayer, "tws-id")
		if not id then
			table.insert(dimensionArrows, arrow)
		else
			setElementDimension(arrow, id)
		end
	end
	setElementData(arrow, "tp-text", text)
	return arrow
end

function setupDimensions(id)
	for i,arrow in ipairs(dimensionArrows) do
		setElementDimension(arrow, id)
	end
end

addEvent("twsSetupDimensions", true)
addEventHandler("twsSetupDimensions", root, setupDimensions)

function createTeleport(x1, y1, z1, r1, x2, y2, z2, r2, rad1, rad2, int1, int2, dimension1, dimension2, objectType, text1, text2)
	local col1 = createColSphere(x1, y1, z1, rad1)
	local col2 = createColSphere(x2, y2, z2, rad2)
	setElementData(col1, "tp-int", int1, true)
	setElementData(col2, "tp-int", int2, true)
	setElementData(col1, "tp-dimension", dimension1, true)
	setElementData(col2, "tp-dimension", dimension2, true)
	setElementData(col1, "tp-destination", col2, false)
	setElementData(col2, "tp-destination", col1, false)
	setElementData(col1, "tp-type", objectType, false)
	setElementData(col2, "tp-type", objectType, false)
	setElementData(col1, "tp-enabled", true, false)
	setElementData(col2, "tp-enabled", true, false)
	setElementData(col1, "tp-rot", r1, true)
	setElementData(col2, "tp-rot", r2, true)
	setElementData(col1, "tp-arrow", createArrow(x1, y1, z1, int1, dimension1, text1))
	setElementData(col2, "tp-arrow", createArrow(x2, y2, z2, int2, dimension2, text2))

	teleportsCount = teleportsCount + 1

	local tpID = teleportsCount
	setElementData(col1, "tp-id", tpID, true)
	setElementData(col2, "tp-id", tpID, true)
	return tpID
end

local function isElementMyCar(element)
	local myCar = getPedOccupiedVehicle(localPlayer)
	if not myCar then
		return false
	end
	if element ~= myCar then
		return false
	end
	return true
end

addEventHandler("onClientColShapeHit", root, 
	function(element)
		if getElementData(source, "tp-enabled") ~= true then
			return
		end

		if element ~= localPlayer and not isElementMyCar() then
			return 
		end
		local dest = getElementData(source, "tp-destination")
		if not isElement(dest) then
			return
		end
		local objectType = getElementData(dest, "tp-type")
		if (getElementType(element) ~= objectType) then
			return
		end

		local target = localPlayer 
		if objectType == "vehicle" then
			target = getPedOccupiedVehicle(localPlayer)
		end
		if objectType == "player" and getPedOccupiedVehicle(localPlayer) then
			return
		end


		setElementData(dest, "tp-enabled", false, false)
		toggleAllControls(false)
		fadeCamera(false, 1)
		setTimer(
			function()
				-- Change position
				local dx, dy, dz = getElementPosition(dest)
				setElementPosition(target, dx, dy, dz + 0.3, false)
				setElementRotation(target, 0, 0, getElementData(dest, "tp-rot"))
				-- Get int and dimension
				local destInt = getElementData(dest, "tp-int")
				local destDimension = getElementData(dest, "tp-dimension")
				-- Update arrow dimension
				local arrow = getElementData(dest, "tp-arrow")
				if arrow and destDimension then
					setElementDimension(arrow, getElementData(localPlayer, "tws-id"))
				end
				-- Server-side
				triggerServerEvent("twsTp", target, destDimension, tonumber(destInt))

				triggerEvent("tws-onClientTeleport", root, getElementData(dest, "tp-id"), getElementData(arrow, "tp-text"))

				-- Camera & controls
				fadeCamera(true, 1)
				toggleAllControls(true)
				
				-- Enable tp
				setTimer(function() setElementData(dest, "tp-enabled", true, false) end, 100, 1)
			end, 1000, 1)
	end
)

addEventHandler("onClientRender", root,
	function()
		arrowsRotation = arrowsRotation + arrowsRotationSpeed
		local px, py, pz = getElementPosition(localPlayer)
		for i,arrow in ipairs(arrows) do
			-- Rotate arrow
			setElementRotation(arrow, 0, 0, arrowsRotation)

			-- Draw text
			local arrowText = getElementData(arrow, "tp-text")
			if arrowText then
				local ax, ay, az = getElementPosition(arrow)
				local distance = getDistanceBetweenPoints2D(ax,ay,px,py)
				if distance <= 10 and math.abs(pz - az) < 1.5 then
					local scale = 5/distance
					local sx, sy = getScreenFromWorldPosition(ax, ay, az + 0.5)
					if sx and sy then
						dxDrawText(arrowText, sx, sy - 30, sx, sy - 30, tocolor(255,255,255, math.min(255, 255 * scale)), math.min(scale * 1, 1), "bankgothic", "center", "bottom", false, false, false )
					end
				end
			end
		end
	end
)

addEventHandler('onClientElementStreamIn', root,
	function()
		if getElementType(source) ~= "object" or getElementModel(source) ~= 1318 then
			return
		end
		table.insert(arrows, source)
	end
)
addEventHandler('onClientElementStreamOut', root,
	function()
		if getElementType(source) ~= "object" or getElementModel(source) ~= 1318  then
			return
		end
		for i,arrow in ipairs(arrows) do
			if arrow == source then
				table.remove(arrows, i)
			end
		end
	end
)