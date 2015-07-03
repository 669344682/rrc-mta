addEvent("tws-clientPlayMusic", true)
addEventHandler("tws-clientPlayMusic", resourceRoot,
	function(url)
		triggerClientEvent("tws-serverPlayMusic", resourceRoot, client, url)
	end
)

addEvent("tws-radioClientRPC", true)
addEventHandler("tws-radioClientRPC", resourceRoot,
	function(funcName, ...)
		triggerClientEvent("tws-radioServerRPC", resourceRoot, funcName, client, ...)
	end
)