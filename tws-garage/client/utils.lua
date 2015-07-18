-- include shared code
loadstring(exports["tws-shared"]:include("utils"))()
loadstring(exports["tws-shared"]:include("mouse_utils"))()
loadstring(exports["tws-shared"]:include("vehicle_utils"))()
loadstring(exports["tws-shared"]:include("dxGUI"))()

mainScale = 1 * screenHeight / 600
local cornerTexture = dxCreateTexture("images/corner.png", "argb", true, "clamp")

function dxDrawRoundRectangle(x, y, w, h, color, radius)
    dxDrawImage(x, y, radius, radius, cornerTexture, 0, 0, 0, color)
    dxDrawRectangle(x, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x, y + h - radius, radius, radius, cornerTexture, 270, 0, 0, color)
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color)
    dxDrawImage(x + w - radius, y, radius, radius, cornerTexture, 90, 0, 0, color)
    dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color)
    dxDrawImage(x + w - radius, y + h - radius, radius, radius, cornerTexture, 180, 0, 0, color)
end

function dxDrawScreenShadow()
    dxDrawImage(0, 0, screenWidth, screenHeight, "images/screen_shadow.png")
    dxDrawImage(0, 0, screenWidth, screenHeight, "images/screen_shadow.png", 180, 0, 0)
end

function getVehicleOccupantsCount()
	local veh = getPedOccupiedVehicle(localPlayer)
	
	if veh then 
		local count = 0
		for id,occupant in pairs(getVehicleOccupants(veh)) do
			if (occupant and getElementType(occupant) == "player") then
				count = count + 1
			end
		end
		return count
	end
	return 0
end