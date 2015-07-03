carshopInterior = {}
carshopInterior.interior = 0

function carshopInterior:start()
	localPlayer.interior = self.interior
end

function carshopInterior:stop()
	localPlayer.interior = 0
end