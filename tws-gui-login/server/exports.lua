function setLoginWindowVisible(player, isVisible)
	if not isElement(player) then
		return false
	end
	triggerClientEvent(player, "tws-gui-login-setLoginWindowVisible", resourceRoot, isVisible)
end