local screenWidth, screenHeight = guiGetScreenSize()

local drawingName = false
local drawingOwner = false

local height = screenHeight / 3.7

local offsetY = height
local offsetTargetY = 0

addEventHandler("onClientRender", root, 
	function()
		if not drawingName then
			return
		end
		offsetY = offsetY + (offsetTargetY - offsetY) * 0.15
		local y = screenHeight - height + offsetY
		local h = screenHeight + offsetY
		dxDrawText(drawingName, 3, y + 3, screenWidth + 3, h + 3, tocolor(0, 0, 0, 170), 3, "default-bold", "center", "center")
		dxDrawText(drawingName, 0, y, screenWidth, h, tocolor(255, 255, 255), 3, "default-bold", "center", "center")

		if drawingOwner then
			local ownerOffset = dxGetFontHeight(3, "default-bold")
			y = y + ownerOffset
			h = h + ownerOffset
			dxDrawText(drawingOwner, 0, y, screenWidth, h, tocolor(48, 113, 138), 2, "default-bold", "center", "center", false, false, false, true)
		end
	end
)

local function hide()
	drawingName = false
end

local function startHiding()
	offsetTargetY = height
	setTimer(hide, 1000, 1)
end

addEventHandler("onClientVehicleEnter", root,
	function(player)
		if player ~= localPlayer then
			return
		end
		drawingName = getVehicleNameFromModel(getElementModel(source))
		local ownerName = getElementData(source, "tws-ownerName")
		if ownerName then
			drawingOwner = "Владелец: #FFFFFF" .. tostring(ownerName)
		else
			drawingOwner = false
		end
		offsetY = height
		offsetTargetY = 0

		setTimer(startHiding, 4000, 1)
	end
)