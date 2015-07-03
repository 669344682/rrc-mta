carshopVehicle = {}

local function arrow_l() carshopVehicle:showNext() end
local function arrow_r() carshopVehicle:showPrev() end

function carshopVehicle:start(rotation, vehicles)
	if not rotation then
		rotation = Vector3(0, 0, 0)
	end
	self.vehicles = vehicles
	if not self.vehicles then
		self.vehicles = {}
	end
	self.vehicle = Vehicle(411, carshopMain.position)
	self.vehicle.rotation = rotation
	self.vehicle.interior = carshopInterior.interior
	self.vehicle.dimension = localPlayer.dimension
	self.vehicle.frozen = true

	bindKey("arrow_l", "down", arrow_l)
	bindKey("arrow_r", "down", arrow_r)

	self.currentVehicle = 1
	setTimer(function() self:update() end, 100, 1)
end

function carshopVehicle:stop()
	if isElement(self.vehicle) then
		destroyElement(self.vehicle)
	end

	unbindKey("arrow_l", "down", arrow_l)
	unbindKey("arrow_r", "down", arrow_r)
end

function carshopVehicle:update()
	local vehicleInfo = self.vehicles[self.currentVehicle]
	if not vehicleInfo then
		return
	end
	self.vehicle.model = vehicleInfo.model
	self.vehicle:setColor(255, 255, 255)

	local vehicleName = exports["tws-vehicles"]:getVehicleNameFromModel(self.vehicle.model)
	carshopGUI:setInfoText(vehicleName, vehicleInfo.price)
	self.price = vehicleInfo.price
end

function carshopVehicle:showNext()
	self.currentVehicle = self.currentVehicle + 1
	if self.currentVehicle > #self.vehicles then
		self.currentVehicle = 1
	end
	carshopVehicle:update()
end

function carshopVehicle:showPrev()
	self.currentVehicle = self.currentVehicle - 1
	if self.currentVehicle < 1 then
		self.currentVehicle = #self.vehicles
	end
	carshopVehicle:update()
end