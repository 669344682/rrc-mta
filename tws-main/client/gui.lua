loadstring(exports["tws-shared"]:include("utils"))()
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		exports["tws-utils"]:toggleHUD(true)
	end
)