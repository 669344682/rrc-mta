function table.find(table, value)
	for k,v in ipairs(table) do
		if value == v then
			return k
		end
	end
	return false
end

function table.findByKey(table, key, value)
	for k,v in ipairs(table) do
		if v[key] == value then
			return k
		end
	end
	return false
end

function table.insert2(table, value)
	for i,v in ipairs(table) do
		if v == nil then
			table[i] = value
			return true
		end
	end
	table[#table+1] = value
	return true
end