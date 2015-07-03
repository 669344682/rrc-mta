radio = {}
radio.rpc = {}
radio.localSound = nil

local remoteSounds = {}

function radio:playSound(url)
	if not localPlayer.vehicle then
		outputChatBox("not in vehicle")
		return
	end
	if isElement(self.localSound) then
		destroyElement(self.localSound)
	end
	self:rpcCall("remotePlay", localPlayer.vehicle, url)
	self.localSound = playSound(url)
	setSoundVolume(self.localSound, 0)
end

function radio.rpc.remotePlay(player, vehicle, url)
	remoteSounds[vehicle] = {url = url, sound = nil, player = player} 
	if isElementStreamedIn(vehicle) then
		remoteSounds[vehicle].sound = playSound3D(remoteSounds[vehicle].url, 0, 0, 0)
		attachElements(remoteSounds[vehicle].sound, vehicle)
	end
end

function radio.rpc.remotePause(player)
	for k, v in pairs(remoteSounds) do
		if v.player == player then
			if isElement(v.sound) then
				destroyElement(v.sound)
			end
			remoteSounds[k] = nil
			return
		end
	end
end

function radio.rpc.remoteStop(player)
	for k, v in pairs(remoteSounds) do
		if v.player == player then
			if isElement(v.sound) then
				destroyElement(v.sound)
			end
			remoteSounds[k] = nil
			return
		end
	end
end

-- RPC 
function radio:rpcCall(funcName, ...)
	triggerServerEvent("tws-radioClientRPC", resourceRoot, funcName, ...)
end

addEvent("tws-radioServerRPC", true)
addEventHandler("tws-radioServerRPC", resourceRoot,
	function(funcName, player, ...)
		if not isElement(player) then
			return
		end
		if radio.rpc[funcName] then
			radio.rpc[funcName](player, ...)
		end
	end
)

addEventHandler("onClientElementStreamIn", root,
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		local vehicle = source
		local remoteSound = remoteSounds[vehicle]
		if remoteSound then
			remoteSound.sound = playSound3D(remoteSound.url, 0, 0, 0)
			attachElements(remoteSound.sound, vehicle)			
			local position = localPlayer:getData("tws-radioSoundPosition")
			outputChatBox("in " .. tostring(position))
			setSoundPosition(remoteSound.sound, position)
			remoteSound.sound:setData("tws-soundTargetPosition", position)
		end
	end
)

addEventHandler("onClientElementStreamOut", root,
	function()
		if getElementType(source) ~= "vehicle" then
			return
		end
		local vehicle = source
		local remoteSound = remoteSounds[vehicle]
		if remoteSound then
			if isElement(remoteSound.sound) then
				destroyElement(remoteSound.sound)
			end
		end
	end
)

addEventHandler("onClientSoundFinishedDownload", root,
	function()
		local position = source:getData("tws-soundTargetPosition")
		if position then
			setSoundPosition(source, position)
			outputChatBox("Setting pos")
		end
	end
)