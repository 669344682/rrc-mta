function getStikerTableFromInfo(s)
	local sticker = {
		id = s[1],
		x = s[2],
		y = s[3],
		rotation = s[4],
		scale = s[5],
		sideRotation = s[6],
		color = s[7],
		mirrorX = s[8],
		mirrorY = s[9]
	}

	-- CHECK
	if not sticker.id then
		return false
	end
	-- TODO: Проверка на существование наклейки с таким ID
	if sticker.id < 1 then
		return false
	end
	if not sticker.x then
		sticker.x = 0
	end
	if not sticker.y then
		sticker.y = 0
	end
	if not sticker.rotation then
		sticker.rotation = 0
	end
	if not sticker.scale then
		sticker.scale = 1
	end
	if not sticker.sideRotation then
		sticker.sideRotation = 0
	end
	if not sticker.color then
		sticker.color = tocolor(255, 255, 255)
	end
	return sticker
end