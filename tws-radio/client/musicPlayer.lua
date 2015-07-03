musicPlayer = {}

function musicPlayer:search(searchString)
	triggerServerEvent("tws-onClientMusicSearch", resourceRoot, searchString)
end

function musicPlayer:onSearchResults(tracks)

end

function musicPlayer:requireInfo(id)
	triggerServerEvent("tws-onClientRequireMusicInfo", resourceRoot, id)
end

-- function musicPlayer:onMusicInfo(info)
-- 	--triggerServerEvent("tws-clientPlayMusic", resourceRoot, info.url)
-- end


-- addCommandHandler("msearch",
-- 	function(cmd, ...)
-- 		local searchString = table.concat({...}, " ")
-- 		outputChatBox("Поиск музыки: \"" .. tostring(searchString) .. "\"")
-- 		musicPlayer:search(searchString)
-- 		triggerServerEvent("tws-onClientMusicSearch", resourceRoot, searchString)
-- 	end
-- )

-- addCommandHandler("mplay",
-- 	function(cmd, id)
-- 		local track = musicPlayer.tracks[tonumber(id)]
-- 		if not track then
-- 			outputChatBox("Нет песни под таким номером")
-- 			return
-- 		end
-- 		outputChatBox("Воспроизведение: \"" .. track.artist .. " - " .. track.name .. "\"")
-- 		musicPlayer:requireInfo(track.id)
-- 	end
-- )

-- local sounds = {}

-- addEvent("tws-serverPlayMusic", true)
-- addEventHandler("tws-serverPlayMusic", resourceRoot,
-- 	function(player, url)
-- 		if isElement(sounds[player]) then
-- 			destroyElement(sounds[player])
-- 		end
-- 		sounds[player] = playSound3D(url, 0, 0, 0)
-- 		attachElements(sounds[player], player)
-- 		setSoundMaxDistance(sounds[player], 20)
-- 	end
-- )
