local dimensionsMaps = {
	"tws-map-garageint",
	"tws-map-tuning-garage",
}

addEventHandler("onClientResourceStart", resourceRoot, 
	function() 
		triggerServerEvent("twsRequireDimensions", localPlayer)
	end
)

function setupDimensions(id)
	for i,name in ipairs(dimensionsMaps) do
		setElementDimension(getResourceRootElement(getResourceFromName(name)), id)
	end
	triggerEvent("updateMyDimension", root, id)
end

addEvent("twsSetupDimensions", true)
addEventHandler("twsSetupDimensions", root, setupDimensions)