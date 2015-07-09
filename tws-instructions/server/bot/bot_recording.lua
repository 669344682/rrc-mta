addEvent("botRecording", true)
addEventHandler("botRecording", resourceRoot,
	function(string)
		local file = fileCreate("client/bot/bot_path.lua")
		if file then
			outputDebugString("RECORDING WAS SUCCESFULLY SAVED", 3)
			file:write(string)
			file:close()
		else
			outputDebugString("RECORDING FILE WAS NOT CREATED", 3)
		end
	end
)