addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "tws-money" then
			setPlayerMoney(getElementData(localPlayer, "tws-money"))
		end
	end
)