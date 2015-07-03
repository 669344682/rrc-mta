tuningUpgrades = {}
local callbacks = {}
local getCallbacks = {}

---------------------------------------------------------------------
-- НЕОН
---------------------------------------------------------------------

local neonColor = {255, 255, 255, false}

local function updateNeonColor(r, g, b)
	if not neonColor then
		return
	end
	neonColor[1] = r
	neonColor[2] = g
	neonColor[3] = b
	exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle, unpack(neonColor))
end

local function buyNeonColor(r, g, b)
	tuningVehicle.setTuning("neon", neonColor)

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)
end

local function resetNeon()
	if tuningVehicle.tuning.neon then
		exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle, unpack(tuningVehicle.tuning.neon))
	else
		exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle, nil)
	end
end

local function cancelNeonColor()
	outputDebugString("cancel")
	resetNeon()

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)
end

callbacks["visuals-neon"] = function(action, data)
	if action == "buy" then
		if not neonColor then
			tuningVehicle.setTuning("neon", nil)
			exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle, nil)
		else 
			tuningCamera.setLookMode("neonColor")
			screens.fadeToScreen("paletteScreen", updateNeonColor, buyNeonColor, cancelNeonColor, "Цвет неона")
		end
	elseif action == "show" then
		if data then
			if tuningVehicle.tuning.neon then
				neonColor = {unpack(tuningVehicle.tuning.neon)}
			end
			if not neonColor then
				neonColor = {255, 255, 255, true}
			end
			for i=1,3 do
				if not neonColor[i] then
					neonColor[i] = 255
				end
			end
		end
		if data == "enabled-sides" then
			neonColor[4] = true
		elseif data == "enabled-full" then
			neonColor[4] = false
		elseif data == "none" then
			neonColor = nil
			exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle)
		end
		if neonColor then
			exports["tws-neon"]:setVehicleNeon(tuningVehicle.vehicle, unpack(neonColor))
		end
	elseif action == "hide" then
		resetNeon()
	end
end

getCallbacks["visuals-neon"] = function()
	local neon = tuningVehicle.tuning.neon
	if not neon then
		return 1
	elseif neon[4] then
		return 2
	else 
		return 3
	end
end

---------------------------------------------------------------------
-- КАРБОН
---------------------------------------------------------------------

local function getCarbonTypeFromDoubleSized(id)
	local t = tuningConfig.isDoubleSized[getElementModel(tuningVehicle.vehicle)]
	if not t then
		return 1
	elseif t[id] then
		return 2
	else
		return 1
	end
end

callbacks["visuals-carbon"] = function(action, data, price)
	if action == "buy" then
		if data == "bonnet" then
			tuningVehicle.setTuning("bonnet", getCarbonTypeFromDoubleSized(1))
			tuningUpgrades.pay(price)
		elseif data == "boot" then
			tuningVehicle.setTuning("boot", getCarbonTypeFromDoubleSized(2))
		elseif data == "bonnet-default" then
			tuningVehicle.setTuning("bonnet", nil)
		elseif data == "boot-default" then
			tuningVehicle.setTuning("boot", nil)
		elseif data == "none" then
			tuningVehicle.setTuning("bonnet", nil)
			tuningVehicle.setTuning("boot", nil)
		end
	elseif action == "show" then
		tuningVehicle.restoreTuning("bonnet")
		tuningVehicle.restoreTuning("boot")
		tuningTexture.redraw()
		tuningCamera.setLookMode("topRight")
		if data == "bonnet" then
			tuningVehicle.tuning.bonnet = getCarbonTypeFromDoubleSized(1)
			tuningTexture.redraw()
		elseif data == "boot" then
			tuningVehicle.tuning.boot = getCarbonTypeFromDoubleSized(2)
			tuningTexture.redraw()
		elseif data == "bonnet-default" then
			tuningVehicle.tuning.bonnet = nil
			tuningTexture.redraw()
		elseif data == "boot-default" then
			tuningVehicle.tuning.boot = nil
			tuningTexture.redraw()
		elseif data == "none" then
			tuningVehicle.tuning.bonnet = nil
			tuningVehicle.tuning.boot = nil
			tuningTexture.redraw()
		end
	elseif action == "hide" then
		tuningVehicle.restoreTuning("bonnet")
		tuningVehicle.restoreTuning("boot")
		tuningTexture.redraw()
		tuningCamera.setLookMode("default", false)
	end
end

getCallbacks["visuals-carbon"] = function()
	if tuningVehicle.tuning.bonnet then
		return 3
	elseif tuningVehicle.tuning.boot then
		return 4
	end
	return 1
end
---------------------------------------------------------------------
-- ЦВЕТ
---------------------------------------------------------------------

local function updateBodyColor(r, g, b)
	tuningVehicle.tuning.color = {r, g, b}
	tuningTexture.redraw()
end

local function buyBodyColor(r, g, b)
	tuningVehicle.setTuning("color", {r, g, b})
	tuningTexture.redraw()

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)
end

local function cancelBodyColor()
	tuningVehicle.restoreTuning("color")
	tuningTexture.redraw()

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)
end

callbacks["visuals-bodyColor"] = function(action, data)
	if action == "show" then
		tuningCamera.setLookMode("bodyColor")
		screens.fadeToScreen("paletteScreen", updateBodyColor, buyBodyColor, cancelBodyColor, "Цвет кузова")
	end
end

---------------------------------------------------------------------
-- НАКЛЕЙКИ
---------------------------------------------------------------------

local currentStickerIndex = nil

local function stickersHandler(action, data)
	if not data and action == "show" then
		return
	end
	if action == "show" then
		if data ~= "none" then
			if not currentStickerIndex then
				currentStickerIndex = tuningTexture.addSticker(tonumber(data))
			else
				tuningTexture.setStickerProperty("id", tonumber(data))
			end
			--stickerPreview.show(tonumber(data))
		else
			if currentStickerIndex then
				tuningTexture.removeSelectedSticker()
			end
			currentStickerIndex = nil
		end
		tuningCamera.setLookMode("stickers")
	elseif action == "hide" then
		if currentStickerIndex then
			tuningTexture.removeSelectedSticker()
		end
		currentStickerIndex = nil
		tuningCamera.setLookMode("default", false)
		--stickerPreview.hide()
	elseif action == "buy" then
		if data ~= "none" then
			if currentStickerIndex then
				tuningTexture.removeSelectedSticker()
			end
			screens.changeScreen("stickerScreen", tonumber(data))
			--stickerPreview.hide()
		end
	end
end

callbacks["vinyls-shapes"] = function(action, data)
	stickersHandler(action, data)
end

callbacks["vinyls-flames"] = function(action, data)
	stickersHandler(action, data)
end

---------------------------------------------------------------------
-- СКИНЫ
---------------------------------------------------------------------


local skinColor = {255, 255, 255}

local function updateSkinColor(r, g, b)
	--[[if not skinColor then
		return
	end
	wheelsColor = {r, g, b}
	exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, r, g, b)]]
end

local function buySkinColor(r, g, b)
	--[[tuningVehicle.setTuning("wheels", {id = tuningVehicle.tuning.wheels.id, color = {r, g, b}})

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)]]
end

local function resetSkinColor()
	--[[if tuningVehicle.tuning.wheels then
		exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, unpack(tuningVehicle.tuning.wheels.color))
	else
		exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, 255, 255, 255)
	end]]
end

local function cancelSkinColor()
	resetWheelsColor()

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)

end

callbacks["vinyls-paintjobs"] = function(action, data)
	if not data and action == "show" then
		return
	end
	if action == "show" then
		if data ~= "none" then
			tuningTexture.setSkin(tonumber(data))
		else
			tuningTexture.setSkin(nil)
		end
	elseif action == "hide" then
		tuningTexture.restoreSkin()
	elseif action == "buy" then
		if data ~= "none" then
			tuningVehicle.setTuning("paintjob", tonumber(data))
		else
			tuningVehicle.setTuning("paintjob", nil)
		end
	end
end


---------------------------------------------------------------------
-- УДАЛЕНИЕ НАКЛЕЕК
---------------------------------------------------------------------

local currentStickerIndex = nil

callbacks["vinyls-removing"] = function(action, data)
	if action == "show" then
		screens.fadeToScreen("removingScreen")
	end
end

---------------------------------------------------------------------
-- СПОЙЛЕРЫ
---------------------------------------------------------------------
callbacks["visuals-spoilers"] = function(action, data)
	if not data then
		data = "spoiler0"
		if action == "show" then
			return
		end
	end
	local spoilerIndex = tonumber(string.sub(data, string.len("spoiler") + 1, -1))
	if action == "buy" then
		if spoilerIndex > 0 then
			screens.fadeToScreen("spoilerScreen", spoilerIndex)
		else
			tuningVehicle.setTuning("spoiler", nil)
		end
	elseif action == "show" then
		exports["tws-spoilers"]:removeVehicleSpoiler(tuningVehicle.vehicle)
		if spoilerIndex > 0 then
			exports["tws-spoilers"]:setVehicleSpoiler(tuningVehicle.vehicle, spoilerIndex)
			if tuningVehicle.tuning.spoiler then
				exports["tws-spoilers"]:setVehicleSpoilerType(tuningVehicle.vehicle,  tuningVehicle.tuning.spoiler.type)
			end
		end
		tuningCamera.setLookMode("spoilerView")
	elseif action == "hide" then
		exports["tws-spoilers"]:removeVehicleSpoiler(tuningVehicle.vehicle)
		tuningVehicle.restoreTuning("spoiler")
		if tuningVehicle.tuning.spoiler then
			exports["tws-spoilers"]:setVehicleSpoiler(tuningVehicle.vehicle, tuningVehicle.tuning.spoiler.id)
			exports["tws-spoilers"]:setVehicleSpoilerColor(tuningVehicle.vehicle, unpack(tuningVehicle.tuning.spoiler.color))
			exports["tws-spoilers"]:setVehicleSpoilerType(tuningVehicle.vehicle, tuningVehicle.tuning.spoiler.type)
		end
		tuningCamera.setLookMode("default")
	end
end

getCallbacks["visuals-spoilers"] = function()
	if not tuningVehicle.tuning.spoiler then
		return 1
	else
		return tuningVehicle.tuning.spoiler.id + 1
	end
end

---------------------------------------------------------------------
-- ТОНИРОВКА
---------------------------------------------------------------------

callbacks["visuals-windows"] = function(action, data)
	if not data and action == "show" then
		return
	end
	if action == "buy" then
		tuningVehicle.setTuning("windows", tonumber(data))
	elseif action == "show" then
		exports["tws-vehicles"]:setVehicleWindowsLevel(tuningVehicle.vehicle, tonumber(data))
	elseif action == "hide" then
		tuningVehicle.restoreTuning("windows")
		exports["tws-vehicles"]:setVehicleWindowsLevel(tuningVehicle.vehicle, tuningVehicle.tuning.windows)
	end
end

getCallbacks["visuals-windows"] = function()
	if not tuningVehicle.tuning.windows then
		return 1
	else
		return tuningVehicle.tuning.windows + 1
	end
end

---------------------------------------------------------------------
-- КОЛЕСА
---------------------------------------------------------------------
callbacks["visuals-wheels"] = function(action, data)
	if not data and action == "show" then
		return
	end
	if data then
		data = tonumber(data)
	end

	if action == "buy" then
		if data > 0 then
			tuningVehicle.setTuning("wheels", {id = data, color = {255, 255, 255}})
		else
			tuningVehicle.setTuning("wheels", nil)
		end
	elseif action == "show" then
		tuningCamera.setLookMode("wheelView")
		exports["tws-wheels"]:resetVehicleWheels(tuningVehicle.vehicle)
		if data > 0 then
			exports["tws-wheels"]:setVehicleWheels(tuningVehicle.vehicle, data)
		end
		exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, 255, 255, 255)
	elseif action == "hide" then
		exports["tws-wheels"]:resetVehicleWheels(tuningVehicle.vehicle)
		tuningVehicle.restoreTuning("wheels")
		if tuningVehicle.tuning.wheels then
			exports["tws-wheels"]:setVehicleWheels(tuningVehicle.vehicle, tuningVehicle.tuning.wheels.id)
			exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, unpack(tuningVehicle.tuning.wheels.color))
		end
		--tuningCamera.setLookMode("default")
	end
end

getCallbacks["visuals-wheels"] = function()
	if not tuningVehicle.tuning.wheels then
		return 1
	else
		return tuningVehicle.tuning.wheels.id + 1
	end
end


---------------------------------------------------------------------
-- ЦВЕТ КОЛЕС
---------------------------------------------------------------------

local wheelsColor = {255, 255, 255}

local function updateWheelsColor(r, g, b)
	if not wheelsColor then
		return
	end
	wheelsColor = {r, g, b}
	exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, r, g, b)
end

local function buyWheelsColor(r, g, b)
	tuningVehicle.setTuning("wheels", {id = tuningVehicle.tuning.wheels.id, color = {r, g, b}})

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)
end

local function resetWheelsColor()
	if tuningVehicle.tuning.wheels then
		exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, unpack(tuningVehicle.tuning.wheels.color))
	else
		exports["tws-wheels"]:setVehicleWheelsColor(tuningVehicle.vehicle, 255, 255, 255)
	end
end

local function cancelWheelsColor()
	resetWheelsColor()

	screens.fadeToScreen("subsectionScreen", subsectionScreen.lastSubsection, subsectionScreen.lastButton)
	tuningCamera.setLookMode("default", false)

end

callbacks["visuals-wheelsColor"] = function(action, data)
	if action == "show" then
		screens.fadeToScreen("paletteScreen", updateWheelsColor, buyWheelsColor, cancelWheelsColor, "Цвет дисков")
		tuningCamera.setLookMode("wheelView")
	end
end

---------------------------------------------------------------------
-- ПОДВЕСКА
---------------------------------------------------------------------

local suspensionLevels = {
	"original",
	0.8,
	0.6
}

local function applyForce(dir)
	setTimer(function()
		setElementVelocity(tuningVehicle.vehicle, 0, 0, 0.01 * dir)
	end, 50, 5)
end

local prev = 10

callbacks["upgrades-suspension"] = function(action, data)
	if not data and action == "show" then
		return
	end

	if action == "buy" then
		local handlingToSet = suspensionLevels[tonumber(data)]
		if handlingToSet == "original" then
			handlingToSet = nil
		end
		tuningVehicle.setHandling("suspensionForceLevel", handlingToSet)
	elseif action == "show" then
		tuningVehicle.previewHandling("suspensionForceLevel", suspensionLevels[tonumber(data)])
		if tonumber(data) > prev then
			applyForce(-1)
		elseif tonumber(data) < prev then
			applyForce(1)
		end
		prev = tonumber(data)
	elseif action == "hide" then
		tuningVehicle.restoreHandling("suspensionForceLevel")
	end
end

---------------------------------------------------------------------
---------------------------------------------------------------------

function tuningUpgrades.buy(name, data, price)
	if getElementData(localPlayer, "tws-money") < price then
		outputChatBox("У вас недостаточно денег!", 255, 0, 0)
		return
	end
	if callbacks[name] then
		callbacks[name]("buy", data, price)
		playSoundFrontEnd(tuningConfig.sounds.buy)
		return
	end
	--outputDebugString("Buy upgrade: " .. tostring(name) .. " [" .. tostring(data) .. "] ")
end

function tuningUpgrades.show(name, data)
	if callbacks[name] then
		callbacks[name]("show", data)
		return
	end
	--outputDebugString("Show upgrade: " .. tostring(name) .. " [" .. tostring(data) .. "] ")
end

function tuningUpgrades.hide(name)
	if callbacks[name] then
		callbacks[name]("hide")
		return
	end
	--outputDebugString("Hide upgrade: " .. tostring(name) .. " [" .. tostring(data) .. "] ")
end

function tuningUpgrades.getUpgrade(name)
	if getCallbacks[name] then
		return getCallbacks[name]()
	end
	return 1
end

function tuningUpgrades.pay(price)
	outputChatBox("tuningUpgrades.pay")
end