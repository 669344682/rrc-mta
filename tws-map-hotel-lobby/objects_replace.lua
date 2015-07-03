local models = {
	["3917"] = {
		txd = "garageLabel.txd",
		dff = "square.dff",
		col = "square.col",
		lod = 100,
	},
	["3923"] = {
		txd = "roomsLabel.txd",
		dff = "square.dff",
		col = "square.col",
		lod = 100,
	}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	setTimer(function()
		for id, data in pairs(models) do
			local n = tonumber(id)
			engineImportTXD(engineLoadTXD(data.txd), n)
			engineReplaceModel(engineLoadDFF(data.dff, n), n)
			engineReplaceCOL(engineLoadCOL(data.col, n), n)
			engineSetModelLODDistance(n, data.lod)
		end
	end, 1000, 1)
end)
