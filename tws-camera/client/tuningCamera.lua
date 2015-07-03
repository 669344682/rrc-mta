tuningCamera = {}
tuningCamera.name = "tuningCamera"

tuningCamera.centerDefault = {0, 0, 5}
tuningCamera.center = {unpack(tuningCamera.centerDefault)}
local tuningCameraCenterX_target = 0
local tuningCameraCenterY_target = 0
local tuningCameraCenterZ_target = 0


local tuningVehicle = nil

local atan2 = math.atan2
local sin = math.sin
local cos = math.cos

local isActive = false

-- Distance from car center to camera
local cameraDistanceDefault = 6
local cameraDistanceMax = 7
local cameraDistanceMin = 2
local cameraDistance = cameraDistanceDefault
local cameraTargetDistance = cameraDistanceDefault

-- Camera height
local cameraHeightDefault = 2
local cameraHeight = 2
local cameraHeightCurrent = cameraHeight

-- Camera rotation
local cameraRotationOffset = 0
local isRotationChanged = false
local cameraRotation = 0
local isCameraRotationFrozen = false
local cameraRotationSpeed = 0
local cameraAutorotationSpeed = 0.1
local cameraRotationSpeedMul = 0.8 -- Меньше - замедление скорости вращения камеры плавнее

-- Camera zoom
local cameraZoomValue = 0.5
local cameraZoomMul = 0.15 -- [0 - 1] Меньше - скорость зума плавнее

-- Mouse position (x)
local mousePosPrev = 0
local mousePrevState = false

local cameraControlEnabled = false

local cameraFOVDefault = 70
local cameraFOV = cameraFOVDefault
local cameraRoll = 0

local movementSpeed = 0.04

local function setCenterTarget(x, y, z)
	tuningCameraCenterX_target = x
	tuningCameraCenterY_target = y
	tuningCameraCenterZ_target = z
end

local function setCenterFast(x, y, z)
	tuningCameraCenterX_target = x
	tuningCameraCenterY_target = y
	tuningCameraCenterZ_target = z
	tuningCamera.center = {x, y, z}
end

function tuningCamera.reset()
	cameraHeight = cameraHeightDefault
	isCameraRotationFrozen = false
	cameraDistance = cameraDistanceDefault
	tuningCamera.center = tuningCamera.centerDefault
	cameraFOV = cameraFOVDefault
end

function tuningCamera.resetAnimated()
	cameraHeight_target = cameraHeightDefault
	cameraDistance_target = cameraDistanceDefault
	tuningCameraCenter_target = tuningCamera.centerDefault
	cameraFOV_target = cameraFOVDefault
	--cameraRotation_target = 45
	isCameraRotationFrozen = false
	setCenterTarget(unpack(tuningCamera.centerDefault))
end

function tuningCamera.start(vehicle)
	if not isElement(vehicle) then
		outputDebugString("tws-camera::tuningCamera: No vehicle element")
		return
	end
	tuningVehicle = vehicle
	local x, y, z = getElementPosition(vehicle)
	local rx, ry, rz = getElementRotation(vehicle)
	cameraRotationOffset = rz 
	tuningCamera.reset()
	cameras.startCamera(tuningCamera.name)
	tuningCamera.centerDefault = {x, y, z}
	tuningCamera.center = {unpack(tuningCamera.centerDefault)}
	setCameraMatrix(x, y + cameraDistance, z + cameraHeightCurrent, x, y, z)
	showCursor(true)
	isActive = true
	cameraRotation_target = 45
	cameraRotation = cameraRotation_target
	isRotationChanged = false
end

function tuningCamera.update()
	if not isActive then
		return
	end
	local c = tuningCamera.center
	local distanceX = math.cos(cameraRotation / 180 * math.pi) * cameraDistance
	local distanceY = math.sin(cameraRotation / 180 * math.pi) * cameraDistance

	-- Update position
	setCameraMatrix(c[1] + distanceX, c[2] + distanceY, c[3] + cameraHeightCurrent, c[1], c[2], c[3], cameraRoll, cameraFOV)

	-- Camera Movement
	cameraDistance = cameraDistance + (cameraTargetDistance - cameraDistance) * cameraZoomMul
	cameraHeightCurrent = cameraHeight * (cameraDistance / cameraDistanceDefault)

	if not isCameraRotationFrozen then
		cameraRotation_target = cameraRotation_target + cameraAutorotationSpeed 
	end

	-- Animations
	cameraRotation = cameraRotation + (cameraRotation_target - cameraRotation) * movementSpeed
	cameraHeight = cameraHeight + (cameraHeight_target - cameraHeight) * movementSpeed
	cameraDistance = cameraDistance + (cameraDistance_target - cameraDistance) * movementSpeed
	cameraFOV = cameraFOV + (cameraFOV_target - cameraFOV) * movementSpeed

	tuningCamera.center[1] = tuningCamera.center[1] + (tuningCameraCenterX_target - tuningCamera.center[1]) * movementSpeed
	tuningCamera.center[2] = tuningCamera.center[2] + (tuningCameraCenterY_target - tuningCamera.center[2]) * movementSpeed
	tuningCamera.center[3] = tuningCamera.center[3] + (tuningCameraCenterZ_target - tuningCamera.center[3]) * movementSpeed
end

addEventHandler("onClientRender", root, tuningCamera.update)

function tuningCamera.stop()
	isActive = false
	showCursor(false)
	setCameraTarget(localPlayer)
end

local function getComponentWorldPosition(name)
	local x, y, z = getElementPosition(tuningVehicle)
	local ox, oy, oz = getVehicleComponentPosition(tuningVehicle, name)
	return x + ox, y + oy, z + oz
end

local function getVehicleOffsetPosition(ox, oy, oz)
	local x, y, z = getElementPosition(tuningVehicle)
	return x + ox, y + oy, z + oz
end

function tuningCamera.setView(viewName)
	tuningCamera.resetAnimated()
	if viewName == "left" then
		cameraRotation_target = 180
		isCameraRotationFrozen = true
		cameraHeight_target = 1
	elseif viewName == "right" then
		cameraRotation_target = 0
		isCameraRotationFrozen = true
		cameraHeight_target = 1
	elseif viewName == "top" then
		cameraRotation_target = 90
		cameraHeight_target = 5
		isCameraRotationFrozen = true
	elseif viewName == "back" then
		cameraRotation_target = 270
		cameraHeight_target = 4
		isCameraRotationFrozen = true
		setCenterTarget(getComponentWorldPosition("boot_dummy"))
	elseif viewName == "front" then
		cameraHeight_target = 4
		cameraRotation_target = 90
		isCameraRotationFrozen = true
		setCenterTarget(getComponentWorldPosition("bonnet_dummy"))
	elseif viewName == "stickers" then -- Предпросмотр наклеек
		cameraRotation_target = 30
		cameraHeight_target = 0
		cameraFOV_target = 40
		isCameraRotationFrozen = true
		setCenterTarget(getVehicleOffsetPosition(1, 0, 0))
	elseif viewName == "bodyColor" then
		cameraHeight_target = 0.2
		cameraRotation_target = 50
		cameraFOV_target = 50
		isCameraRotationFrozen = true
		setCenterTarget(getVehicleOffsetPosition(0, 0.5, 0))
	elseif viewName == "neonColor" then
		cameraHeight_target = 3
		cameraRotation_target = 50
		cameraFOV_target = 40
		isCameraRotationFrozen = true
		setCenterTarget(getVehicleOffsetPosition(1, 2, 0))
	elseif viewName == "spoilerView" then
		cameraRotation_target = -55
		cameraHeight_target = 2
		isCameraRotationFrozen = true
		cameraFOV_target = 30
		setCenterTarget(getVehicleOffsetPosition(-0.2, -1.8, 0.6))
	elseif viewName == "topRight" then
		cameraRotation_target = 0
		isCameraRotationFrozen = true
		cameraHeight_target = 5
	elseif viewName == "wheelView" then
		setCenterTarget(getComponentWorldPosition("wheel_rf_dummy"))
		cameraHeight_target = 1
		isCameraRotationFrozen = true
		cameraRotation_target = 40
		cameraFOV_target = 40
	elseif viewName == "carPhoto" then
		cameraHeight = 0.2
		cameraRotation = 50
		cameraFOV = 47
		isCameraRotationFrozen = true
		setCenterFast(getVehicleOffsetPosition(0, 0.8, 0))
		tuningCamera.update()
	end
	cameraRotation_target = (cameraRotation_target + 180) % 360 - 180
	cameraRotation = (cameraRotation + 180) % 360 - 180
end

-- exports
startTuningCamera = tuningCamera.start
setTuningCameraView = tuningCamera.setView
