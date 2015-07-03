local doorAngle = 60
local doors = {["door_lf_ok"] = {2, 1}, ["door_rf_ok"] = {3, -1}, ["door_lr_ok"] = {4, 1}, ["door_rr_ok"] = {5, -1}}
local visibleVehicles = {}

for i,v in ipairs(getElementsByType("vehicle")) do
	if isElementStreamedIn(v) then
		visibleVehicles[v] = true
	end
end

addEventHandler("onClientElementStreamIn", root,
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		visibleVehicles[source] = true
	end
)

addEventHandler("onClientElementStreamOut", root,
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		visibleVehicles[source] = nil
	end
)

addEventHandler("onClientRender", root,
	function()
		for v, _ in pairs(visibleVehicles) do
			if isElement(v) then
				for n,i in pairs(doors) do
					setVehicleComponentRotation(v, n, 0, 0, i[2] * doorAngle * getVehicleDoorOpenRatio(v, i[1]))
				end
			else
				visibleVehicles[v] = nil
			end
		end
	end
)