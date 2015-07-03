local objectsLOD = {
	[11317] = 11321
} 

local mapRoot = getResourceRootElement(getThisResource())
local objects = getElementsByType("object", mapRoot)

for _, object in ipairs(objects) do
	local model = getElementModel(object)
	--engineSetModelLODDistance(model, 300)
	local LOD_model = nil
	for obj, lod in pairs(objectsLOD) do
		if model == obj then
			LOD_model = lod
			break
		end
	end

	local x, y, z = getElementPosition(object)
	local rx, ry, rz = getElementRotation(object)

	if LOD_model then
		local LOD_object = createObject(LOD_model, x, y, z, rx, ry, rz)
		if not setLowLODElement(object, LOD_object) then
			destroyElement(LOD_object)
			engineSetModelLODDistance(model, 300)
		end
	else
		engineSetModelLODDistance(model, 300)
	end
end


