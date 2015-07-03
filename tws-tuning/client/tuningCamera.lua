tuningCamera = {}
tuningCamera.currentMode = ""

function tuningCamera.start()
	exports["tws-camera"]:startTuningCamera(tuningVehicle.vehicle)
	tuningCamera.setLookMode("default", false)
end

function tuningCamera.setLookMode(mode)
	if not tuning.isActive then
		return
	end
	if mode == tuningCamera.currentMode and mode ~= "default" then
		return false
	end
	tuningCamera.currentMode = mode
	exports["tws-camera"]:setTuningCameraView(mode)
	return true
end

function tuningCamera.stop()
	exports["tws-camera"]:resetCamera()
	tuningCamera.currentMode = ""
end