htmlParser = {}

function htmlParser:parseSearchResults(data)
	local artistClassStr = 'class="musicset-track__artist musicset-track__link"'
	local nameClassStr = 'target="_blank"'

	local result = {}
	local substr = "data-dkey=\""
	local pos = data:find(substr, 1, true)
	while pos do
		pos = pos + substr:len()
		qPos = data:find("\"", pos, true)
		if not qPos then
			break
		end
		local urlStr = data:sub(pos, qPos - 1 - (".mp3"):len())

		local artistName = "Unknown"
		local trackName = "Unknown"

		local artistClassPos = data:find(artistClassStr, qPos, true)
		if artistClassPos then
			local closeBracketPos = data:find(">", artistClassPos + artistClassStr:len(), true)
			if closeBracketPos then
				local openBraketPos = data:find("<", closeBracketPos, true)
				if openBraketPos then
					artistName = data:sub(closeBracketPos + 1, openBraketPos - 1)
				end
			end
			local nameClassPos = data:find(nameClassStr, artistClassPos, true)
			if nameClassPos then
				local closeBracketPos = data:find(">", nameClassPos + nameClassStr:len(), true)
				if closeBracketPos then
					local openBraketPos = data:find("<", closeBracketPos, true)
					if openBraketPos then
						trackName = data:sub(closeBracketPos + 1, openBraketPos - 1)
					end
				end
			end
		end

		if urlStr then
			table.insert(result, {
				id  = urlStr, 
				artist = artistName,
				name = trackName
			})
		end
		pos = data:find(substr, qPos, true)
	end
	return result
end

function htmlParser:parseTrackPage(data, id)
	local result = {}

	local dlString = "http://dl.zaycev.net"
	local dlPos = data:find(dlString, 1, true)
	if dlPos then
		mp3Pos = data:find(".mp3", dlPos, true)
		if mp3Pos then
			local mp3url = data:sub(dlPos, mp3Pos + (".mp3"):len() - 1)
			result.url = mp3url
		end
	end

	return result
end