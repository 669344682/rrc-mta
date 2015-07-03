screenX, screenY = guiGetScreenSize()


-- skins

notAllowedSkins = {3, 4, 5, 6, 8, 42, 65, 74, 86, 119, 149, 208, 273, 289}
VIPSkins = {}
normalSkins = {}


function refreshSkins()
	local resource = getResourceFromName("tws-skins")
	if resource and resource.state == "running" then
		VIPSkins = exports["tws-skins"]:getVIPSkins()

		normalSkins = {}
		-- filling normalSkins table
		for skin = 1, 312 do
			local isBadSkin = false
			for _, badSkin in ipairs(notAllowedSkins) do
				if skin == badSkin then
					isBadSkin = true
					break
				end
			end

			if not isBadSkin then
				for _, badSkin in ipairs(VIPSkins) do
					if skin == badSkin then
						isBadSkin = true
						break
					end
				end
			end

			if not isBadSkin then
				table.insert(normalSkins, skin)
			end
		end

	end
end

refreshSkins()

addEventHandler("onClientResourceStart", root,
	function(resourceStarted)
		if resourceStarted == getResourceFromName("tws-skins") then
			refreshSkins()
		end
	end
)