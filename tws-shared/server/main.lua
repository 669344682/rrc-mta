function include(name)
	if not name then 
		return
	end
	local filePath = "server/shared/" .. name .. ".lua"
	if not fileExists(filePath) then
		return
	end
	local f = fileOpen(filePath)
	local luaString = fileRead(f, fileGetSize(f))
	fileClose(f)
	
	return luaString
end