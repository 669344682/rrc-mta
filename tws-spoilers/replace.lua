local spoilers = {
	[1000] = "1",
	[1001] = "2",
	[1002] = "3",
	[1003] = "4",
	[1023] = "5",
	[1014] = "6",
	[1015] = "7",
	[1016] = "8",
	[1049] = "9",
	[1050] = "10", 
	[1058] = "11", 
	[1060] = "12",
	[1138] = "13",
	[1139] = "14",
	[1146] = "15",
	[1147] = "16",
	[1158] = "17",
--[[	[1162] = "18",
	[1163] = "19",
	[1164] = "20"]]--
}

function replaceModel()
	setTimer(
		function()
			engineImportTXD(engineLoadTXD("spoilers.txd", 1000), 1000)
			for model, name in pairs(spoilers) do
				if name ~= nil then
					engineReplaceModel(engineLoadDFF(name .. ".dff", model), model)
				end
			end
		end, 1000, 1
	)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)