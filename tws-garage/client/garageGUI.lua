garageGUI = {}
garageGUI.isEnabled = false
garageGUI.drawSpawned = false

local screenWidth, screenHeight = guiGetScreenSize()

local topBlock = {
	x = 0, y = 0, 
	width = screenWidth,
	height = 100
}

local bottomBlock = {
	x = 0, y = screenHeight - 100,
	width = screenWidth,
	height = 100
}

local carInfoBlock = {
	x = 0, y = screenHeight - bottomBlock.height - 50 - 5, 
	width = screenWidth,
	height = 50
}

local shadowX = 1
local shadowY = 1
local shadowColor = tocolor(0, 0, 0, 150)

buttonsTips.start({"СТРЕЛКИ - ПРОСМОТР", "ENTER - ВЫБОР", "BACKSPACE - ВЫХОД"})
captionText.start(60 * mainScale, "ГAРAЖ", "ВЫБОР АВТОМОБИЛЯ")

local function dxDrawShadowText(...)
	local a = {...}
	dxDrawText(a[1], a[2] + shadowX, a[3] + shadowY, a[4] + shadowX, a[5] + shadowY, shadowColor, a[7], a[8], a[9], a[10], false, false, false, false)
	dxDrawText(...)
end

addEventHandler("onClientRender", root, 
	function()
		if not garageGUI.isEnabled then
			return
		end
		dxDrawScreenShadow()
		buttonsTips.draw(0)
		captionText.draw()
		local vehicleInfo = garageVehicles.getVehicleInfo()
		if not vehicleInfo then
			dxDrawText("У ВАС НЕТ АВТОМОБИЛЕЙ\n\nПосетите автомагазин, чтобы\nкупить авто", 3, 3, screenWidth + 3, screenHeight + 3 , tocolor(0, 0, 0, 150), 3, "default-bold", "center", "center", false, false, false, true)
			dxDrawText("У ВАС НЕТ АВТОМОБИЛЕЙ\n\nПосетите автомагазин, чтобы\nкупить авто", 0, 0, screenWidth, screenHeight , tocolor(255, 255, 255), 3, "default-bold", "center", "center", false, false, false, true)			return
		end
		carInfo.draw()
		if garageGUI.drawSpawned then
			dxDrawText("АВТОМОБИЛЯ НЕТ В ГАРАЖЕ", 3, 3, screenWidth + 3, screenHeight + 3 , tocolor(0, 0, 0, 150), 3, "default-bold", "center", "center", false, false, false, true)
			dxDrawText("АВТОМОБИЛЯ НЕТ В ГАРАЖЕ", 0, 0, screenWidth, screenHeight , tocolor(255, 0, 0), 3, "default-bold", "center", "center", false, false, false, true)
		end
		moneyText.draw()
	end
)