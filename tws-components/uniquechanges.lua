local wheels = {
	["wheel_lf_dummy"] = -1,
	["wheel_lb_dummy"] = -1,

	["wheel_rf_dummy"] = 1,
	["wheel_rb_dummy"] = 1
}

function extendDistanceBetweenWheels(vehicle, distance)
	for wheel, direction in pairs(wheels) do
		resetVehicleComponentPosition(vehicle, wheel)

		if distance ~= 0 then
			local x, y, z = getVehicleComponentPosition(vehicle, wheel)

			setVehicleComponentPosition(vehicle, wheel, x + distance * direction, y, z)
		end
	end
end

function componentChanged(vehicle, component, level)
	if vehicle.model == 438 then
		if component == "tws-skirts" then
			if level == 1 then
				extendDistanceBetweenWheels(vehicle, 0.09)
			else
				extendDistanceBetweenWheels(vehicle, 0)
			end
		end
	end
end