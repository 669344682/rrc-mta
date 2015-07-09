-- replacing skins
for index, skinModel in ipairs(VIPSkins) do
	setTimer(
		function()
			local txd = engineLoadTXD("skins/" .. tostring(skinModel) .. ".txd")
			engineImportTXD(txd, skinModel)
			local dff = engineLoadDFF("skins/" .. tostring(skinModel) .. ".dff", 0)
			engineReplaceModel(dff, skinModel, true)
		end, 100 * index, 1
	)
end
