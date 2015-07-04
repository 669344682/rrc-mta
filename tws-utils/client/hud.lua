local enabledHudComponents = {
	"radar"
}

hudVisiblityState = true

function isHUDVisible()
	return hudVisiblityState 
end

local function isResourceRunning(resourceName)
	return getResourceFromName(resourceName) and getResourceFromName(resourceName).state == "running"
end

function toggleHUD(isVisible, ignoreMap)
	setPlayerHudComponentVisible("all", false)
	if isVisible then
		for i, name in ipairs(enabledHudComponents) do
			setPlayerHudComponentVisible(name, true)
		end
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
	if not ignoreMap then
		if isResourceRunning("tws-gui-map") then
			exports["tws-gui-map"]:setEnabled(isVisible)
		end
	end
	hudVisiblityState = isVisible
end