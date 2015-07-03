garageCamera = {}
garageCamera.name = "garageCamera"

garageCamera.centerDefault = {0, 0, 5}
garageCamera.center = garageCamera.centerDefault

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
local isRotationChanged = false
local cameraRotation = 0
local isCameraRotationFrozen = false
local cameraRotationSpeed = 0
local cameraAutorotationSpeed = 0.003
local cameraRotationSpeedMul = 0.8 -- Меньше - замедление скорости вращения камеры плавнее

-- Camera zoom
local cameraZoomValue = 0.5
local cameraZoomMul = 0.15 -- [0 - 1] Меньше - скорость зума плавнее

-- Mouse position (x)
local mousePosPrev = 0
local mousePrevState = false

local cameraControlEnabled = true

local cameraFOV = 70
local cameraRoll = 0

function garageCamera.reset()
	cameraHeight = cameraHeightDefault
	isCameraRotationFrozen = false
	cameraDistance = cameraDistanceDefault
	cameraTargetDistance = cameraDistanceDefault
	cameraControlEnabled = true
	garageCamera.center = garageCamera.centerDefault
	cameraFOV = 70
	cameraRoll = 0
end

function garageCamera.start(x, y, z)
	garageCamera.reset()
	cameras.startCamera(garageCamera.name)
	garageCamera.centerDefault = {x, y, z}
	garageCamera.center = garageCamera.centerDefault
	setCameraMatrix(x, y + cameraDistance, z + cameraHeightCurrent, x, y, z)
	showCursor(true)
	isActive = true
	isRotationChanged = false
end

function garageCamera.update()
	if not isActive then
		return
	end
	local c = garageCamera.center
	local distanceX = math.cos(cameraRotation) * cameraDistance
	local distanceY = math.sin(cameraRotation) * cameraDistance

	-- Update position
	setCameraMatrix(c[1] + distanceX, c[2] + distanceY, c[3] + cameraHeightCurrent, c[1], c[2], c[3], cameraRoll, cameraFOV)

	-- Camera Movement
	cameraRotationSpeed = cameraRotationSpeed * cameraRotationSpeedMul
	cameraDistance = cameraDistance + (cameraTargetDistance - cameraDistance) * cameraZoomMul
	cameraHeightCurrent = cameraHeight * (cameraDistance / cameraDistanceDefault)

	if isCameraRotationFrozen then
		cameraRotationSpeed = 0
	else
		cameraRotation = cameraRotation + cameraRotationSpeed
		if not isRotationChanged then
			cameraRotation = cameraRotation + cameraAutorotationSpeed
		end
		-- Mouse control
		if cameraControlEnabled then
			if getKeyState("mouse1") and mousePrevState then
				local mousePos = getCursorPosition()

				cameraRotationSpeed = cameraRotationSpeed - (mousePos - mousePosPrev)

				mousePosPrev = mousePos
				mousePrevState = true
			end
			if getKeyState("mouse1") and not mousePrevState then
				mousePosPrev =  getCursorPosition()
				mousePrevState = true
				isRotationChanged = true
			end
		end
		if not getKeyState("mouse1") then
			mousePrevState = false
		end
	end

end

function garageCamera.stop()
	isActive = false
	showCursor(false)
	setCameraTarget(localPlayer)
end

function garageCamera.setRotation(newRotation)
	if not newRotation then
		return
	end
	cameraRotation = newRotation / 180 * math.pi
end

function garageCamera.setHeight(newHeight)
	if not newHeight then
		cameraHeight = cameraHeightDefault
		return
	end
	cameraHeight = newHeight
end

function garageCamera.setCenter(x, y, z)
	if not x or not y or not z then
		garageCamera.center = garageCamera.centerDefault
		return
	end
	garageCamera.center = {x ,y, z}
end

function garageCamera.setRotationFrozen(isFrozen)
	isCameraRotationFrozen = isFrozen
	if not isFrozen then
		cameraRotationSpeed = cameraAutorotationSpeed
		isRotationChanged = false
	end
end

function garageCamera.setDistance(newDistance)
	if not newDistance then
		return
	end
	cameraTargetDistance = newDistance
end

function garageCamera.setControlEnabled(isEnabled)
	cameraControlEnabled = isEnabled
end

function garageCamera.setFOV(fov)
	if not fov then
		fov = 70
	end
	cameraFOV = fov
end

function garageCamera.setRoll(roll)
	if not roll then
		roll = 0
	end
	cameraRoll = roll
end

addEventHandler("onClientRender", root, garageCamera.update)

local function zoomIn()
	if not cameraControlEnabled then
		return
	end
	cameraTargetDistance = cameraTargetDistance - cameraZoomValue 
	if cameraTargetDistance < cameraDistanceMin then
		cameraTargetDistance = cameraDistanceMin
	end
end
bindKey("mouse_wheel_up", "down", zoomIn)

local function zoomOut()
	if not cameraControlEnabled then
		return
	end
	cameraTargetDistance = cameraTargetDistance + cameraZoomValue 
	if cameraTargetDistance > cameraDistanceMax then
		cameraTargetDistance = cameraDistanceMax
	end
end
bindKey("mouse_wheel_down", "down", zoomOut)

-- exports
startGarageCamera = garageCamera.start
resetGarageCamera = garageCamera.reset
setGarageCameraRotation = garageCamera.setRotation
setGarageCameraHeight = garageCamera.setHeight
setGarageCameraRotationFrozen = garageCamera.setRotationFrozen
setGarageCameraDistance = garageCamera.setDistance
setGarageCameraCenter = garageCamera.setCenter
setGarageCameraFOV = garageCamera.setFOV
setGarageCameraRoll = garageCamera.setRoll
setControlEnabled = garageCamera.setControlEnabled
