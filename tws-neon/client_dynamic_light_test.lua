function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

local lightArgs = {
	x=20, y=10, z=2.6, 
	r = 0.4, g = 0.6, b = 1, a = 0.8, 
	rx=-45, ry=0, rz=0, 
	euler=true, 
	falloff=math.pi / 2, 
	theta=math.pi * 0.4, 
	phi=math.pi * 0.48, 
	power=10}

local neonColor = {1, 0, 0, 3}
local lightsSettings = {
	{
		x = 0, y = 0, z = -0.4,
		rx = -60, ry = 0, rz = 90,
		power = 5
	}
}

local lightsElements = {}

for i,v in ipairs(lightsSettings) do
	--[[local light = exports.dynamic_lighting:createSpotLight(
		lightArgs.x, lightArgs.y, lightArgs.z, 
		neonColor[1], neonColor[2], neonColor[3], neonColor[4],
		lightArgs.rx, lightArgs.ry, lightArgs.rz,
		lightArgs.euler,
		lightArgs.falloff,
		lightArgs.theta,
		lightArgs.phi,
		v.power
	)]]

	local light = exports.dynamic_lighting:createPointLight(0,0,0,neonColor[1], neonColor[2], neonColor[3], neonColor[4],v.power)

	table.insert(lightsElements, light)
end

--exports.dynamic_lighting:createSpotLight(20, 10, 4, 0.4, 0.6, 1, 0.8, 0, 0, 0, true, math.pi / 2, --[[theta]]math.pi / 10, --[[phi]]math.pi / 4, 2000)
addEventHandler("onClientPreRender", root, 
	function()
		local veh = localPlayer.vehicle
		if not isElement(veh) then
			return
		end
		for i,light in ipairs(lightsElements) do
			local ls = lightsSettings[i]
			local x, y, z = getPositionFromElementOffset(veh, ls.x, ls.y, ls.z)
			exports.dynamic_lighting:setLightPosition(light, x, y, z)
		end
	end
)