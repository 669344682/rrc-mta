local mapPath, mapRoot
local beginning = {}

mapPath = "stuff/new-town.map"
mapRoot = resource:getMapRootElement(mapPath)
mapRoot.dimension = -1

beginning.position = Vector3(5485.843, -1619.541, 15.528)


addEvent("instructions.onClientBeginnerTutorialStart", true)
addEventHandler("instructions.onClientBeginnerTutorialStart", resourceRoot,
	function()
		local id = client:getData("tws-id")
		if not id then
			outputDebugString("no player id", 3)
			return
		end

		--client.vehicle.position = Vector3(5298.661, -2075.063, 14.975)
		--client.vehicle.position = beginning.position
		--client.position = beginning.position
		client.dimension = id

		triggerClientEvent("instructions.serverBeginningMapRoot", resourceRoot, mapRoot, id)
	end
)
