loadstring(exports["tws-shared"]:include("utils"))()
loadstring(exports["tws-shared"]:include("mouse_utils"))()
loadstring(exports["tws-shared"]:include("dxGUI"))()
gui = exports["tws-gui"]
canvas = gui:createCanvas(resourceRoot)

function dxDrawTextRect(text, x, y, w, h, ...)
	if w and h then
		dxDrawText(text, x, y, x + w, y + h, ...)
	else
		dxDrawText(text, x, y)
	end
end