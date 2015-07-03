loadstring(exports["tws-shared"]:include("utils"))()
loadstring(exports["tws-shared"]:include("mouse_utils"))()
loadstring(exports["tws-shared"]:include("dxGUI"))()

function customSetVisible(t, isVisible)
	for k,v in pairs(t) do
		guiSetVisible(v, isVisible)
	end
end

function checkStr(str)
	if not str or str:len() == 0 then
		return "no"
	end
	return "ok"
end

function checkPassword(str)
	local check = checkStr(str)
	if check ~= "ok" then
		return check
	end
	if str:len() < 5 then
		return "short"
	end
	if str:len() > 30 then
		return "long"
	end
	if str == "*****" then
		return "bad"
	end
	return "ok"
end
