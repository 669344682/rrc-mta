carshopCamera = {}
local twsCamera = exports["tws-camera"]

function carshopCamera:start()
	twsCamera:startGarageCamera(utils.unpackVector3(carshopMain.position))
end

function carshopCamera:stop()
	twsCamera:resetCamera()
end