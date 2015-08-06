function continueAfterEvent(event, attachedTo, func, ...)
	local function continue()
		removeEventHandler(event, attachedTo, continue)

		func(unpack(arg))
	end

	addEventHandler(event, attachedTo, continue)
end