function getCurrentWeather()
	local weather = root:getData("weatherCurrent")
	local blending = root:getData("weatherBlending")
	return weather, blending
end

function restoreWeather()
	local weather, blending = getCurrentWeather()

	if weather then
		if blending then 
			setWeatherBlended(blending)
		else
			setWeather(weather)
		end
	end
end