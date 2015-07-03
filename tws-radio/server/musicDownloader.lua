musicDownloader = {}
local SEARCH_URL = "http://zaycev.net/search.html?query_search="
local PAGES_URL  = "http://zaycev.net/pages"

function urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end

-- Поиск музыки
function musicDownloader:search(player, searchString)
	if not isElement(player) then
		return false
	end
	if not searchString then
		return false
	end
	searchString = urlencode(searchString)
	
	local url = SEARCH_URL .. searchString

	fetchRemote(url, 5, 
		function(responseData, errorNumber)
			if errorNumber ~= 0 then
				outputDebugString("fetchRemote error: " .. tostring(errorNumber))
				return false
			end

			local searchResults = htmlParser:parseSearchResults(responseData)
			if searchResults then
				triggerClientEvent(player, "tws-radioSearchResults", resourceRoot, searchResults)
			end
		end
	)

	return true
end

-- Получение подробной информации о треке
function musicDownloader:getInfo(id, callback)
	if not id then
		return false
	end
	if not callback then
		return false
	end

	local url = PAGES_URL .. id .. ".shtml"

	fetchRemote(url, 5,
		function(responseData, errorNumber)
			if errorNumber ~= 0 then
				outputDebugString("fetchRemote error: " .. tostring(errorNumber))
				return false
			end			

			local trackInfo = htmlParser:parseTrackPage(responseData, id)
			if trackInfo then
				callback(trackInfo)
			end
		end
	)
	return true
end

addEvent("tws-onClientMusicSearch", true)
addEventHandler("tws-onClientMusicSearch", resourceRoot,
	function(searchString)
		if not musicDownloader:search(client, searchString) then
			outputChatBox("Search error", client)
		end
	end
)

addEvent("tws-onClientRequireMusicInfo", true)
addEventHandler("tws-onClientRequireMusicInfo", resourceRoot,
	function(id)
		local player = client
		musicDownloader:getInfo(id,
			function(info)
				triggerClientEvent(player, "tws-radioMusicInfo", resourceRoot, info)
			end
		)
	end
)

--[[
musicDownloader:getInfo("/30893/3089351",
	function(info)
		outputChatBox("found: " .. tostring(info.url))
		--triggerClientEvent()
	end
)]]