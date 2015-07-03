function clearChatBox(player)
	if not isElement(player) then
		return
	end
	for i = 1, 25 do
		outputChatBox(" ", player)
	end
end