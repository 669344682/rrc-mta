local blips = {}
local function setBlip(p)
	local r = p:getData("nameColor_R") or 150
	local g = p:getData("nameColor_G") or 150
	local b = p:getData("nameColor_B") or 225
	blips[p] = createBlipAttachedTo(p, 0, 2, r, g, b, 0, 300)
	--setElementData(blips[p], "tws-isGlobalMapHiding", true) 
end

local function removeBlip(p)
	if blips[p] then
		destroyElement(blips[p])
		blips[p] = nil
	end
end

addEventHandler("onPlayerLogin", root,
	function()
		if not source:getData("tws-isGlobalMapHiding") then
			setBlip(source)
		end
	end, true, "low"
)

addEventHandler("onPlayerQuit", root,
	function()
		removeBlip(source)
	end
)

addEventHandler("onPlayerLogout", root,
	function()
		removeBlip(source)
	end
)

addEvent("onPlayerTogglesSelfBlip", true)
addEventHandler("onPlayerTogglesSelfBlip", root,
	function(state)
		local player = source
		if state then
			removeBlip(player)
		else
			setBlip(player)
		end
	end
)

for _, player in ipairs(getElementsByType("player")) do
	if not player:getData("tws-isGlobalMapHiding") then
		setBlip(player)
	end
end
