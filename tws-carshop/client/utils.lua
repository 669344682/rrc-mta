-- include shared code
require = function(moduleName)
	local moduleString = exports["tws-shared"]:include(moduleName)
	local func = loadstring(moduleString)
	if not func then
		outputDebugString("require: Error loading module \"" .. tostring(moduleName) .."\"")
		return false
	end

	return func()
end

assetsManager = require("assetsManager")