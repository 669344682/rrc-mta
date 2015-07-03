local numberLetters = {"A", "B", "C", "E", "H", "K", "M", "O", "P", "T", "X", "Y"}

function setVehicleNumberPlate(vehicle, text, region)
	setElementData(vehicle, "tws-numberPlate", {text, region})
	triggerClientEvent(root, "tws-setVehicleNumberPlate", vehicle, text, region)
end

function resetVehicleNumberPlate(vehicle)
	triggerClientEvent(root, "tws-setVehicleNumberPlate", vehicle, nil)
end

function generateRandomNumberPlateText()
	local str = numberLetters[math.random(1, #numberLetters)]
	str = str .. tostring(math.random(100, 999))
	str = str .. numberLetters[math.random(1, #numberLetters)] .. numberLetters[math.random(1, #numberLetters)]
	return str
end

function generateRandomRegion()
	return math.random(10, 199)
end

function generateRandomNumberPlate()
	return {generateRandomNumberPlateText(), generateRandomRegion()}
end

function applyVehicleNumberPlate(vehicle, text, region)
	if not isElement(vehicle) then
		return
	end
	if not text or not region then
		return
	end
	local currentInfo = getVehicleInfo(vehicle)
	currentInfo.number = {text, region}
	setVehicleInfo(vehicle, currentInfo)
	setVehicleNumberPlate(vehicle, text, region)
end