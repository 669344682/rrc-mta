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

function toggleHUD(isVisible)
	if not isVisible then
		setPlayerHudComponentVisible("all", false)
		if isResourceRunning("tws-time") then
			exports["tws-time"]:setClockVisible(false)
		end
		if isResourceRunning("tws-gui-panel") then
			exports["tws-gui-panel"]:setPanelVisible(false)
		end
		if isResourceRunning("tws-nametags") then
			--exports["tws-nametags"]:setPanelVisible(false)
		end
	else
		setPlayerHudComponentVisible("all", false)
		for i, name in ipairs(enabledHudComponents) do
			setPlayerHudComponentVisible(name, true)
		end
		if isResourceRunning("tws-time") then
			exports["tws-time"]:setClockVisible(true)
		end
		if isResourceRunning("tws-gui-panel") then
			exports["tws-gui-panel"]:setPanelVisible(true)
		end
		if isResourceRunning("tws-nametags") then
			--exports["tws-nametags"]:setPanelVisible(true)
		end
	end
	hudVisiblityState = isVisible
end