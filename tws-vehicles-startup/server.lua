addEventHandler("onResourceStart", resourceRoot,
	function()
		for i, name in ipairs(vehiclesResources) do
			local resource = getResourceFromName(name)
			if resource then
				startResource(resource)
				--outputDebugString("Car: " .. name)
			end
		end
	end
)

addEventHandler("onResourceStop", resourceRoot,
	function()
		for i, name in ipairs(vehiclesResources) do
			local resource = getResourceFromName(name)
			if resource then
				stopResource(resource)
			end
		end
	end
)


for i, name in ipairs(vehiclesResources) do
	local resource = getResourceFromName(name)
	--local dff = fileOpen(":" .. name .. "/car.dff")
	--local str = fileRead(dff, 32)
	--fileClose(dff)
	if resource then
		--startResource(resource)
		--decodeVehicleResource(name)
	end
end