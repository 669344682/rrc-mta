local lineMaterial = dxCreateTexture("material.png", "argb", true, "clamp")
local lineEndMaterial = dxCreateTexture("material2.png", "argb", true, "clamp")

local neonSize = 0.15
local glowSize = 0.5
local glowAlpha = 100
local endLength = 0.2

for i, car in pairs(neonLines) do
	for j, line in ipairs(car) do
		local x1, y1, z1, x2, y2, z2 = line[1], line[2], line[3], line[4], line[5], line[6]
		local length = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
		local gx, gy, gz = (x2 - x1) / length * endLength, (y2 - y1) / length * endLength, (z2 - z1) / length * endLength
		line[7] = gx
		line[8] = gy
		line[9] = gz
	end
end

local visibleVehicles = {}

local function addVisibleVehicle(vehicle)
	if getElementType(vehicle) == "vehicle" and neonLines[getElementModel(vehicle)] then
		local neonColor = getElementData(vehicle, "tws-neon")
		if neonColor then
			if not neonColor[4] then
				neonColor[4] = #neonLines[getElementModel(vehicle)]
			else
				neonColor[4] = 1
			end
			visibleVehicles[vehicle] = neonColor
		else
			visibleVehicles[vehicle] = nil
		end
	end
end

for i,vehicle in ipairs(getElementsByType("vehicle")) do
	if isElementStreamedIn(vehicle) then
		addVisibleVehicle(vehicle)
	end
end

addEventHandler("onClientElementStreamIn", root, 
	function()
		addVisibleVehicle(source)
	end
)

addEventHandler("onClientElementSteamOut", root,
	function()
		if getElementType(source) == "vehicle" then
			visibleVehicles[source] = nil
		end
	end
)

local function drawNeonLine(vehicle, x1, y1, z1, x2, y2, z2, gx, gy, gz, r, g, b)
	local vx, vy, vz = getElementPosition(vehicle)
	local cx, cy, cz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(vx, vy, vz, cx, cy, cz)

	local wx1, wy1, wz1 = getPositionFromElementOffset(vehicle, x1, y1, z1)
	local wx2, wy2, wz2 = getPositionFromElementOffset(vehicle, x2, y2, z2)

	if distance <= 200 then
		if distance <= 50 then
			local color1 = tocolor(r, g, b)

			local gx1, gy1, gz1 = getPositionFromElementOffset(vehicle, x1 - gx, y1 - gy, z1 - gz)
			local gx2, gy2, gz2 = getPositionFromElementOffset(vehicle, x2 + gx, y2 + gy, z2 + gz)

			-- Line
			dxDrawMaterialLine3D(wx1, wy1, wz1, wx2, wy2, wz2, lineMaterial, neonSize, color1)

			if distance <= 40 then
				-- End1
				dxDrawMaterialLine3D(gx1, gy1, gz1, wx1, wy1, wz1, lineEndMaterial, neonSize, color1)

				-- End2
				dxDrawMaterialLine3D(gx2, gy2, gz2, wx2, wy2, wz2, lineEndMaterial, neonSize, color1)

				if distance <= 25 then
					local alpha = glowAlpha * math.min(1, 1 - (distance - 20) / 5)
					local color2 = tocolor(r, g, b, alpha)
					dxDrawMaterialLine3D(wx1, wy1, wz1, wx2, wy2, wz2, lineMaterial, glowSize, color2)
					dxDrawMaterialLine3D(gx1, gy1, gz1, wx1, wy1, wz1, lineEndMaterial, glowSize, color2)
					dxDrawMaterialLine3D(gx2, gy2, gz2, wx2, wy2, wz2, lineEndMaterial, glowSize, color2)
				end
			end
		else
			local alpha = 150 * math.min(1, 1 - (distance - 100) / 50)
			local color1 = tocolor(r, g, b, alpha)
			dxDrawLine3D(wx1, wy1, wz1, wx2, wy2, wz2, color1, 6, false)
		end
	end
end

local function drawNeon()
	for vehicle, settings in pairs(visibleVehicles) do
		if isElement(vehicle) and vehicle.dimension == localPlayer.dimension then
			local lines = neonLines[getElementModel(vehicle)]
			for i = 1, settings[4] do
				local line = lines[i]
				drawNeonLine(vehicle, line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9], settings[1], settings[2], settings[3])
				drawNeonLine(vehicle, -line[1], line[2], line[3], -line[4], line[5], line[6], -line[7], line[8], line[9], settings[1], settings[2], settings[3])
			end
		else
			visibleVehicles[vehicle] = nil
		end
	end
end

addEventHandler("onClientPreRender", root, drawNeon)

function setVehicleNeon(vehicle, r, g, b, onlySides)
	local newSettings = nil
	if r and g and b then
		newSettings = {r, g, b, onlySides}
	end
	setElementData(vehicle, "tws-neon", newSettings, false)
	addVisibleVehicle(vehicle)
end