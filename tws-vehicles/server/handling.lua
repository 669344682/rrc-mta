function parseHandlingString(str)
	for i = 1, 10 do
		str = string.gsub(str, "  ", " ")
	end

	local tab = {}
	local spacePos
	local i = 1
	while true do 
		spacePos = string.find(str, " ")
		if not spacePos then 
			tab[i] = string.sub(str, 1, str.len(str))
			break 
		end
		tab[i] = string.sub(str, 1, spacePos-1)
		str = string.sub(str, spacePos+1)
		i = i + 1
	end

	newTab = {}
	newTab["mass"] = tonumber(tab[1])
	newTab["turnMass"] = tonumber(tab[2])
	newTab["dragCoeff"] = tonumber(tab[3])
	newTab["centerOfMass"] = {tonumber(tab[4]), tonumber(tab[5]), tonumber(tab[6])} -- { [1]=posX, [2]=posY, [3]=posZ }
	newTab["percentSubmerged"] = tonumber(tab[7])
	newTab["tractionMultiplier"] = tonumber(tab[8])
	newTab["tractionLoss"] = tonumber(tab[9])
	newTab["tractionBias"] = tonumber(tab[10])
	newTab["numberOfGears"] = tonumber(tab[11])
	newTab["maxVelocity"] = tonumber(tab[12])
	newTab["engineAcceleration"] = tonumber(tab[13])
	newTab["engineInertia"] = tonumber(tab[14])

	local driveType
	if (tab[15] == "F") or (tab[15] == "f") then
		driveType = "fwd"
	elseif (tab[15] == "R") or (tab[15] == "r") then
		driveType = "rwd"
	else
		driveType = "awd"
	end
	newTab["driveType"] = driveType

	local engineType
	if (tab[16] == "P") or (tab[16] == "p") then
		engineType = "petrol"
	elseif (tab[16] == "D") or (tab[16] == "d") then
		engineType = "diesic"
	else
		engineType = "electric"
	end
	newTab["engineType"] = engineType

	newTab["brakeDeceleration"] = tonumber(tab[17])
	newTab["brakeBias"] = tonumber(tab[18])

	local ABS
	if (tab[19] == 0) then
		ABS = false
	else
		ABS = true
	end
	newTab["ABS"] = ABS

	newTab["steeringLock"] = tonumber(tab[20])
	newTab["suspensionForceLevel"] = tonumber(tab[21])
	newTab["suspensionDamping"] = tonumber(tab[22])
	newTab["suspensionHighSpeedDamping"] = tonumber(tab[23])
	newTab["suspensionUpperLimit"] = tonumber(tab[24])
	newTab["suspensionLowerLimit"] = tonumber(tab[25])
	newTab["suspensionFrontRearBias"] = tonumber(tab[26])
	newTab["suspensionAntiDiveMultiplier"] = tonumber(tab[27])
	newTab["seatOffsetDistance"] = tonumber(tab[28])
	newTab["collisionDamageMultiplier"] = tonumber(tab[29])
	newTab["monetary"] = tonumber(tab[30])
	--newTab[""] = tonumber(tab[])

	return newTab
end

function setVehicleHandlingType(vehicle, handlingType)
	if not handlingType then
		return
	end
	if not isElement(vehicle) then
		return
	end

	local model = getElementModel(vehicle)
	if not handlingConfig[model] then
		return
	end
	
	local handlingTable = parseHandlingString(handlingConfig[model][handlingType])

	for k, v in pairs(handlingTable) do
		setVehicleHandling(vehicle, k, v)
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		for model, h in pairs(handlingConfig) do
			local handlingTable = parseHandlingString(h.normal)

			for k, v in pairs(handlingTable) do
				setModelHandling(model, k, v)
			end
		end
	end
)