local components = {"ammo", "area_name", "armour", "breath", "clock", "health", "money", "vehicle_name", "weapon", "radio", "wanted"}


hudVisiblityState = true

function isHUDVisible()
	return hudVisiblityState 
end

local function isResourceRunning(resourceName)
	return getResourceFromName(resourceName) and getResourceFromName(resourceName).state == "running"
end

function toggleHUD(isVisible, ignoreMap)
	for _, component in ipairs(components) do
		setPlayerHudComponentVisible(component, false)
	end

	if isResourceRunning("tws-time") then
		exports["tws-time"]:setClockVisible(isVisible)
	end
	if isResourceRunning("tws-nametags") then
		--exports["tws-nametags"]:setPanelVisible(isVisible)
	end
	if isResourceRunning("tws-speedometer") then
		exports["tws-speedometer"]:setVisible(isVisible)
	end
	if isResourceRunning("tws-gui-hud") then
		exports["tws-gui-hud"]:setVisible(isVisible)
	end	
	if not ignoreMap then
		setPlayerHudComponentVisible("radar", isVisible)
		if isResourceRunning("tws-gui-map") then
			exports["tws-gui-map"]:setEnabled(isVisible)
		end
	end
	hudVisiblityState = isVisible
end