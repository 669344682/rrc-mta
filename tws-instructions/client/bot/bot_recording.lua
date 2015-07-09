recording_colshapes = {}

local STRING_START = "RECORDING_DATA = {\n"
local STRING_END = "}"
local recording_index = 1
local recording = false
local string
local recordingTable = {}

addCommandHandler("recording",
	function()
		if not recording then
			outputChatBox("START RECORDING", 0, 200, 0)

			recordingTable = {}
			local recording_index = 1

			for _, v in ipairs(recording_colshapes) do
				v:destroy()
				v = nil
			end

			string = STRING_START
		else
			outputChatBox("STOP RECORDING", 0, 200, 200)

			string = string .. STRING_END

			triggerServerEvent("botRecording", resourceRoot, string)
		end
		
		recording = not recording
	end
)

setTimer(
	function()
		if recording then
			local vehicle = localPlayer.vehicle
			if not vehicle then
				return
			end

			local pos = vehicle.position
			local speed = getElementSpeed(vehicle, 1)

			local t = recordingTable[#recordingTable]
			if t then
				local x, y, z = t.x, t.y, t.z

				if getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, x, y, z) < 4 then
					return
				end
			end

			string = string .. "\t"
			string = string .. "[" .. recording_index .. "] = {"
			string = string .. "x = " .. pos.x .. ", "
			string = string .. "y = " .. pos.y .. ", "
			string = string .. "z = " .. pos.z .. ", "
			string = string .. "speed = " .. speed .. "},\n"
			
			table.insert(recordingTable, {x = pos.x, y = pos.y, z = pos.z, speed = speed})

			recording_index = recording_index + 1
		end
	end, 150, 0
)
