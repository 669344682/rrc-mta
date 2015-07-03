-- Вывод информации о запуске ресурсов в debugscript
local OUTPUT_STARTUP_INFO = false

-- Resources autostart list
local resources = {
	-- Maps
	"tws-map-garageint",
	"tws-map-tuning-garage",
	"tws-map-world",
	--"tws-map-vazcarshop",
	--"tws-map-carshop2",

	-- Ресурсы
	--"tws-donat",
	"tws-shared",
	"tws-teleports",
	"tws-utils",
	"tws-assets",
	"tws-admin",
	"tws-blips",
	"tws-camera",
	"tws-carshop",
	--"tws-challenge",
	"tws-components",
	"tws-drift",
	"tws-hpregen",
	"tws-nametags",
	"tws-neon",
	"tws-potracheno",
	"tws-skinselecting",
	"tws-speedometer",
	"tws-spoilers",
	"tws-stickers",
	"tws-time",
	"tws-tuning",
	"tws-vehicles",
	"tws-vehicles-textures",
	"tws-voice",
	"tws-weather",
	"tws-wheels",

	-- GUI
	"tws-gui",
	"tws-gui-login",
	"tws-gui-map"
}


local function outputStartupInfo(...)
	if OUTPUT_STARTUP_INFO then
		outputDebugString(...)
	end
end

addEvent("twsRequireDimensions", true)
addEventHandler("twsRequireDimensions", root, 
	function()
		triggerClientEvent(source, "twsSetupDimensions", root, getPlayerID(source))
	end
)

addEventHandler("onResourceStart", resourceRoot, 
	function()
		if not getAccount("twsNumberSecretAccount") then
			addAccount("twsNumberSecretAccount", "Iqwfqf9a9sa8gsagshi1212ronis98oqgi98u")
		end
		setOcclusionsEnabled(false)
		local successCounter = 0
		local failCounter = 0
		for _,name in ipairs(resources) do
			local res = getResourceFromName(name)
			if res then
				if startResource(res) then 
					outputStartupInfo("Запуск ресурса: '" .. name .. "'")
					successCounter = successCounter + 1
				else
					if getResourceState(res) == "running" then
						outputStartupInfo("Ресурс уже запущен: '" .. name .. "'")
					else
						outputStartupInfo("Не удалось запустить ресурс: '" .. name .. "'", 2)
						failCounter = failCounter + 1
					end
				end
			else
				outputStartupInfo("Ресурс не найден: '" .. name .. "'", 2)
				failCounter = failCounter + 1
			end
		end
		outputDebugString("Ресурсов запущено: " .. successCounter .. ". Не удалось запустить: " .. failCounter, 0, 0, 191, 255)
		for _, player in ipairs(getElementsByType("player")) do
			local playerAccount = getPlayerAccount(player)
			if not isGuestAccount(playerAccount) then
				logOut(player)
			end
		end
	end
)

addEventHandler("onResourceStop", resourceRoot, 
	function()
		for i, player in ipairs(getElementsByType("player")) do
			savePlayerAccountData(player)
		end
		for _, player in ipairs(getElementsByType("player")) do
			local playerAccount = getPlayerAccount(player)
			if not isGuestAccount(playerAccount) then
				logOut(player)
			end
		end
		for _,name in ipairs(resources) do
			local res = getResourceFromName(name)
			if res then
				stopResource(res)
				outputStartupInfo("Остановка ресурса: '" .. name .. "'")
			end
		end
	end
)