addEvent("twsTp", true)
addEventHandler("twsTp", root, 
	function(dimension, interior)
		if not dimension then
			setElementDimension(source, 0)
		else
			setElementDimension(source, exports["tws-main"]:getPlayerID(source))
		end
		if interior then
			setElementInterior(source, interior)
		end
	end
)