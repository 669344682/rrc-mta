instructions = {}

addEvent("onButtonClick", true)

function instructions:show(noFade, keepClientFrozen)
	if self.before then
		self.before()
	end
	if not self.default then
		if self.main then
			self.main()
		end

		return
	end
	setTimer(
		function()
			showChat(true)
		end,
	self.duration, 1)
	local function t()
		fadeCamera(true)
		toggleControlAndHud(false)
		showChat(false)
		setCameraMatrix(self.cameraPos, self.cameraTarget)
		drawText(self.text, self.duration, self.cameraPos, self.cameraTarget, keepClientFrozen)

		if self.after then
			setTimer(
				function()
					self.after()
				end, self.duration, 1
			)
		end
	end
	if not noFade then
		fadeCamera(false)
		setTimer(t, 1000, 1)
	else
		t()
	end
end

function drawText(text, duration, cameraPos, cameraTarget, keepClientFrozen)
	--playSFX("genrl", 52, 14, false)
	playSoundFrontEnd(33)
	toggleControlAndHud(false)

	setCameraMatrix(cameraPos, cameraTarget)

	local function drawStuff()
		dxDrawRectangle(0, 0, screenX, screenY/5, tocolor(0, 0, 0, 255 ), true)
		dxDrawRectangle(0, screenY-screenY/5, screenX, screenY, tocolor(0, 0, 0, 255 ), true)
		dxDrawText(text, 0, screenY-screenY/5, screenX, screenY, tocolor ( 255, 255, 255, 255 ), 2, "default-bold", "center", "center", false, true, true)
	end
	
	addEventHandler("onClientRender", root, drawStuff)
	setTimer(
		function()
			if not keepClientFrozen then
				fadeCamera(false)
			end
			setTimer(
				function()
					removeEventHandler("onClientRender", root, drawStuff)
					if not keepClientFrozen then 
						toggleControlAndHud(true)
						fadeCamera(true)
					end
				end, keepClientFrozen and 50 or 1000, 1
			)
		end, keepClientFrozen and duration or duration - 1000, 1
	)
end


addEvent("onInstructionsLoaded", true)
addEventHandler("onInstructionsLoaded", resourceRoot,
	function()
		for funcName, func in pairs(instructions) do
			if type(func) == "function" then
				for tableName, table in pairs(instructions) do
					if type(table) == "table" then
						if not instructions[tableName][funcName] then
							instructions[tableName][funcName] = func
						end
					end
				end
			end
		end
	end
)

addEventHandler("onButtonClick", resourceRoot,
	function()
		if instructions[button.current].buttonClick then
			instructions[button.current]:buttonClick()
		end
	end
)


function startInstruction(instruction)
	if not isInitialized then
		--outputDebugString("Instructions were not initialized! Initializating...", 1)
		init()
	end

	if not instructions[instruction] then
		outputDebugString("Wrong instruction (instruction: " .. tostring(instruction) .. ")", 1)
		return
	end

	if button.visible or window.visible then
		outputDebugString("Starting a new instruction when another one is active", 2)
	end

	button.current = instruction

	instructions[instruction]:show()
end
addEvent("startInstruction", true)
addEventHandler("startInstruction", resourceRoot, startInstruction)

addCommandHandler("startInstruction",
	function(_, instruction)
		startInstruction(instruction)
	end
)