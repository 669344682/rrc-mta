local raceCheckpoints = {}
local cp1, cp2 = {}, {}
local currentCheckpont = 1

local function createCheckpoint(x, y, z)
	local checkpoint = createMarker(x, y, z, "checkpoint", 7)
	local checkpointCollision = createMarker(x, y, z, "cylinder", 11, 255, 255, 255, 0)
	local blip = createBlipAttachedTo(checkpoint, 0, 2, 0, 0, 255, 255)
	return checkpoint, blip, checkpointCollision
end

function showCheckpoint(id)
	if not id or not raceCheckpoints[id] then
		return
	end
	if isElement(cp1.checkpoint) then
		destroyElement(cp1.checkpoint)
	end
	if isElement(cp1.blip) then
		destroyElement(cp1.blip)
	end
	if isElement(cp1.collision) then
		destroyElement(cp1.collision)
	end
	if cp2.checkpoint then
		cp1.checkpoint = cp2.checkpoint
		cp1.collision = cp2.collision
		cp1.blip = cp2.blip
	else
		cp1.checkpoint, cp1.blip, cp1.collision = createCheckpoint(raceCheckpoints[id][1], raceCheckpoints[id][2], raceCheckpoints[id][3])
	end
	if id < #raceCheckpoints then
		cp2.checkpoint, cp2.blip, cp2.collision = createCheckpoint(raceCheckpoints[id + 1][1], raceCheckpoints[id + 1][2], raceCheckpoints[id + 1][3])
		local tx, ty, tz = getElementPosition(cp2.checkpoint)
		setMarkerTarget(cp1.checkpoint, tx, ty, tz)
	end
	if id == #raceCheckpoints - 1 then
		setMarkerIcon(cp2.checkpoint, "finish")
		setMarkerColor(cp2.checkpoint, 255, 255, 255, 255)
	end
	if id == #raceCheckpoints then
		setMarkerIcon(cp1.checkpoint, "finish")
		setMarkerColor(cp1.checkpoint, 255, 255, 255, 255)
	end
end

function removeCheckpoints()
	if isElement(cp1.checkpoint) then
		destroyElement(cp1.checkpoint)
	end
	if isElement(cp1.blip) then
		destroyElement(cp1.blip)
	end
	if isElement(cp1.collision) then
		destroyElement(cp1.collision)
	end

	if isElement(cp2.checkpoint) then
		destroyElement(cp2.checkpoint)
	end
	if isElement(cp2.blip) then
		destroyElement(cp2.blip)
	end
	if isElement(cp2.collision) then
		destroyElement(cp2.collision)
	end
	cp1, cp2 = {}, {}
	raceCheckpoints = {}
	currentCheckpont = 0
end

--[[addCommandHandler("challenge",
	function()
		outputChatBox("Генерация трассы...")
		triggerServerEvent("tws-requireChallengeCheckpoints", resourceRoot)
	end
)]]

addEvent("tws-challengeCheckpointsReady", true)
addEventHandler("tws-challengeCheckpointsReady", resourceRoot, 
	function(markers)
		if isElement(cp1.checkpoint) then
			destroyElement(cp1.checkpoint)
		end
		if isElement(cp1.blip) then
			destroyElement(cp1.blip)
		end
		if isElement(cp1.collision) then
			destroyElement(cp1.collision)
		end

		if isElement(cp2.checkpoint) then
			destroyElement(cp2.checkpoint)
		end
		if isElement(cp2.blip) then
			destroyElement(cp2.blip)
		end
		if isElement(cp2.collision) then
			destroyElement(cp2.collision)
		end
		cp1, cp2 = {}, {}

		outputChatBox("Гонка началась!", 0, 255, 0)
		raceCheckpoints = markers
		if not markers or #markers == 0 then
			return
		end
		currentCheckpont = 1
		showCheckpoint(currentCheckpont)
	end
)

function markerHit(hitPlayer)
	if hitPlayer == localPlayer then
		if source == cp1.collision then
			if currentCheckpont == #raceCheckpoints then
				Race.finish()
			end
			playSoundFrontEnd(43)
			currentCheckpont = currentCheckpont + 1
			showCheckpoint(currentCheckpont)
		end
	end
end
addEventHandler("onClientMarkerHit", root, markerHit)