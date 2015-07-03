local models = {
	["6959"] = {
		txd = "texture.txd",
		dff = "vegasnbball1.dff"
	}--[[,
	["11317"] = {
		txd = "carshow_sfse_new.txd",
		--dff = "vegasnbball1.dff"
	}]]
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	setTimer(function()
		for id, data in pairs(models) do
			local n = tonumber(id)
			engineImportTXD(engineLoadTXD(data.txd), n)
			if data.dff then
				engineReplaceModel(engineLoadDFF(data.dff, n), n)
			end
		end
		local object = getElementByID("vazcarshop-main")
		local txdOld = engineLoadTXD("carshow_sfse_old.txd")
		local txdNew = engineLoadTXD("carshow_sfse_new.txd")

		if isElement(object) then
			addEventHandler("onClientElementStreamIn", object, 
				function()
					--outputChatBox("replace")
					engineImportTXD(txdNew, 11317)
				end)
		end
	end, 1000, 1)
end)
