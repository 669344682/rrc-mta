local permanentDataNames = {
	"tws-money",
	"tws-owner",
	"tws-vehicle-id",
	"tws-accountName",
	"tws-level",
	"tws-respects",
	"tws-playtime",
	"tws-loginTime"
}

addEventHandler("onElementDataChange", root,
	function(dataName, oldValue)
		if not client then 
			return
		end
		for k, v in ipairs(permanentDataNames) do
			if v == dataName then
				setElementData(source, dataName, oldValue)
			end
		end
	end
)