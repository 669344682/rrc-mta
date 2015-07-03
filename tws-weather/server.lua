local PERIOD_MIN = 20 * 30000
local PERIOD_MAX = 40 * 30000
local RARE_WEATHER_CHANCE = 0.1
local RARE_WEATHER_DURATION = 3 * 60000

-- 20 - пасмурная погода
-- 8, 16 - дождь
-- 9 - туман
-- 19 - песочная буря

local rareWeather = {20, 8, 16, 9, 19}
local normalWeather = {0, 1, 2, 3, 4, 5, 6, 7, 10, 11, 12, 13, 14, 15, 17, 18}
local weatherLocked = false
local timer = nil

function changingWeather()
	local weather
	local currentWeather, blending = getWeather()

	if not blending and not weatherLocked then
		if currentWeather == 20 then -- повышаем вероятность дождя после пасмурной погоды
			if math.random() < 0.5 then
				weather = 8
			end
		elseif currentWeather == 8 or currentWeather == 16 then -- повышаем вероятность тумана после дождя
			if math.random() < 0.4 then
				weather = 9
			end
		end

		if not weather then
			local weatherType = math.random()

			if weatherType < RARE_WEATHER_CHANCE then
				weather = rareWeather[math.random(#rareWeather)]
			else
				weather = normalWeather[math.random(#normalWeather)]
			end
		end

		setWeatherBlended(weather)

		root:setData("weatherCurrent", currentWeather)
		root:setData("weatherBlending", weather)

		setTimer(
			function()	
				root:setData("weatherCurrent", weather)
				root:setData("weatherBlending", false)
			end, 60000, 1
		)
	end

	local period = math.random(PERIOD_MIN, PERIOD_MAX)
	for _, rareWeatherID in ipairs(rareWeather) do
		if weather == rareWeatherID then
			period = RARE_WEATHER_DURATION
			break
		end
	end
	setTimer(changingWeather, period, 1)
end
changingWeather()

function changeWeather(id, time)
	if not id then
		return
	end

	weatherLocked = false

	if timer then
		killTimer(timer)
	end

	setWeather(id)

	root:setData("weatherCurrent", id)
	root:setData("weatherBlending", false)

	if time then
		weatherLocked = true
		timer = setTimer(
			function()
				weatherLocked = false
			end, time, 1
		)
	end
end
