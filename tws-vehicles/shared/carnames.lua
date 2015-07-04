local modelNames = {
	[404] = "LADA 2101", 
	[529] = "LADA 2103",
	[420] = "LADA 2106",
	[550] = "LADA 2109",
	[546] = "LADA 2110",
	[540] = "LADA 2112",
	[580] = "LADA Priora",
	[527] = "Honda Civic Si",
	[587] = "Nissan Silvia S14",
	[436] = "Nissan Silvia S15",
	[426] = "BMW E39",
	[526] = "BMW E34",
	[401] = "Nissan Skyline R34",
	[559] = "Toyota Supra",
	--[562] = "Mitsubishi Eclipse",
	[477] = "Mazda RX7",
	[480] = "Porsche 911",
	[533] = "Honda S2000",
	[517] = "Toyota Celica",
	[405] = "Toyota Chaser Tourer V",
	--[560] = "Subaru Impreza",
	[542] = "Dodge Challenger",
	[439] = "Chevrolet Camaro Z28"
}

function getVehicleNameFromModel(model)
	if not model then
		return false
	end
	if not modelNames[model] then
		return "No name for: " .. model
	end
	return modelNames[model]
end

function getAllVehiclesModels()
	local models = {}
	for k,_ in pairs(modelNames) do
		table.insert(models, tonumber(k))
	end
	return models
end