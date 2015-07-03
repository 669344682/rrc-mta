function setLoginWindowVisible(isVisible)
	if gui.isVisible == isVisible then
		return
	end
	gui.isVisible = isVisible
	if isVisible then
		addEventHandler("onClientRender", root, gui.draw)
		gui.reset()
		showChat(false)
	else
		removeEventHandler("onClientRender", root, gui.draw)
		--showChat(true)
	end
	customSetVisible(gui.login, isVisible)
	showCursor(isVisible)
	exports["tws-utils"]:toggleHUD(not isVisible)
end
addEvent("tws-gui-login-setLoginWindowVisible", true)
addEventHandler("tws-gui-login-setLoginWindowVisible", resourceRoot, setLoginWindowVisible)


-- Show on startup
setLoginWindowVisible(true)