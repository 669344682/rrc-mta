local points = {}
for k,v in pairs(checkpointsTable) do
	for j, l in pairs(v) do
		local x,y = l.x, l.y
		local links = {}
		for id, zoneID in pairs(l.links) do
			table.insert(links, id)
		end
		points[j] = {x, y, links}
	end
end

for i,point in ipairs(points) do
	for j,id in ipairs(point[3]) do
		local newLinks = {}
		for k,id2 in ipairs(points[id][3]) do
			if id2 ~= id then
				table.insert(newLinks, id2)
			end
		end
		points[id][3] = newLinks
	end
end

function drawLines()
	for k,v in ipairs(checkpointsTable) do
		for j,l in pairs(v) do
			local x1, y1 = Map.worldPosToMapPos(l.x, l.y)
			for id, zoneID in pairs(l.links) do
				local l2 = checkpointsTable[zoneID][id]
				local x2, y2 = Map.worldPosToMapPos(l2.x, l2.y)
				dxDrawLine(x1, y1, x2, y2)
			end
			dxDrawRectangle(x1 - 3, y1 - 3, 6, 6, tocolor(0, 255, 0))
		end
	end

	--[[for i,point in ipairs(points) do
		local x1, y1 = Map.worldPosToMapPos(point[1], point[2])
		dxDrawRectangle(x1 - 3, y1 - 3, 6, 6, tocolor(0, 255, 0))
		for j,id in ipairs(point[3]) do
			local x2, y2 = Map.worldPosToMapPos(points[id][1], points[id][2])
			dxDrawLine(x1, y1, x2, y2)
		end
	end]]
end