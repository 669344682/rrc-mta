cameras = {}
local currentCamera = nil

function cameras.startCamera(name)
	if currentCamera then
		cameras.resetCamera()
	end
	currentCamera = name
end

function cameras.resetCamera()
	if currentCamera == garageCamera.name then
		garageCamera.stop()
	elseif currentCamera == tuningCamera.name then
		tuningCamera.stop()
	end
	currentCamera = nil
end

-- exports
resetCamera = cameras.resetCamera