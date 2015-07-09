function init(forPlayer)
	if not forPlayer then
		outputDebug("player expected in function init()", 1)
		return
	end

	triggerClientEvent(forPlayer, "initInstructions", resourceRoot)
end

function deinit(forPlayer)
	if not forPlayer then
		outputDebugString("player expected in function deinit()", 1)
		return
	end

	triggerClientEvent(forPlayer, "deinitInstructions", resourceRoot)
end

function startInstruction(forPlayer, instruction)
	if not forPlayer then
		outputDebugString("player expected (arg #1) in function startInstruction()", 1)
		return
	end

	if not instruction then
		outputDebugString("instruction expected (arg #2) in function startInstruction()", 1)
		return
	end

	triggerClientEvent(forPlayer, "startInstruction", resourceRoot, instruction)
end

