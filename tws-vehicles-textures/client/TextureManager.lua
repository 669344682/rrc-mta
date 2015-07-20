-- textureManager.lua
-- Управление текстурами автомобилей
-- Синхронизация текстуры

textureManager = {}

-- Названия текстур машины
local vehicleTextureNames = {
	body = "tws-body",
	body_dam = "tws-body-dam"
}
local textureReplaceShaderPath = "shaders/texreplace.fx" -- Путь к шейдеру для замены текстуры

function textureManager:init()
	-- Шейдеры и текстуры для каждой машины
	self.texturesShadersList = {} -- [vehicle] = {shader = шейдер, texture = renderTarget}
end

function textureManager:setupTextureShader(vehicle, renderTarget)
	if not self.texturesShadersList[vehicle] then
		-- Создание шейдера и текустуры для машины
		local vehicleTexture = renderTarget
		if not isElement(renderTarget) then
			vehicleTexture = dxCreateRenderTarget(textureDrawing.renderTargetSize.width, textureDrawing.renderTargetSize.height)
		end
		self.texturesShadersList[vehicle] = {
			shader = dxCreateShader(textureReplaceShaderPath),
			texture = vehicleTexture
		}
		-- Применение шейдера к машине и повреждениям
		engineApplyShaderToWorldTexture(self.texturesShadersList[vehicle].shader, vehicleTextureNames.body, vehicle)
		engineApplyShaderToWorldTexture(self.texturesShadersList[vehicle].shader, vehicleTextureNames.body_dam, vehicle)
	end
end

function textureManager:updateVehicleTexture(vehicle, renderTarget)
	if not isElement(vehicle) then
		-- Машина не существует
		outputDebugString("WARNING: textureManager:updateVehicleTexture: Vehicle is not an element")
		return
	end
	if not isElementStreamedIn(vehicle) then
		return
	end
	-- Тюнинг автомобиля
	local vehicleTuningTable = getElementData(vehicle, "tws-tuning")
	if not vehicleTuningTable then
		--outputDebugString("WARNING: textureManager:updateVehicleTexture: Vehicle tuning table is nil")
		return
	end
	-- Если для машины не создан шейдер и текстура 
	textureManager:setupTextureShader(vehicle, renderTarget)
	-- Рисование текстуры на renderTarget автомобиля
	textureDrawing:drawTextureFromTuningTable(vehicle, vehicleTuningTable, self.texturesShadersList[vehicle].texture)
	dxSetShaderValue(self.texturesShadersList[vehicle].shader, "gTexture", self.texturesShadersList[vehicle].texture)
end

function textureManager:removeVehicleTexture(vehicle)
	if not vehicle then
		-- Машина не существует
		outputDebugString("WARNING: textureManager:removeVehicleTexture: Vehicle is '" .. tostring(vehicle) .. "'")
		return
	end
	if not self.texturesShadersList[vehicle] then
		-- На машину не наложена текстура и шейдер
		return
	end
	-- Удаление шейдера
	if isElement(self.texturesShadersList[vehicle].shader) then
		destroyElement(self.texturesShadersList[vehicle].shader)
	end
	-- Удаление текстуры
	if isElement(self.texturesShadersList[vehicle].texture) then
		destroyElement(self.texturesShadersList[vehicle].texture)
	end
	self.texturesShadersList[vehicle] = nil
end

addEventHandler("onClientElementStreamIn", root, function()
	if source.type == "vehicle" then
		textureManager:updateVehicleTexture(source)
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if source.type == "vehicle" then
		textureManager:removeVehicleTexture(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if source.type == "vehicle" then
		textureManager:removeVehicleTexture(source)
	end
end)

addEventHandler("onClientRestore", root, function(didClearRenderTargets)
		if not didClearRenderTargets then
			outputDebugString("TextureManager: didClearRenderTargets = false")
			return
		end
		for vehicle, _ in pairs(textureManager.texturesShadersList) do
			textureManager:updateVehicleTexture(vehicle)
		end
		outputDebugString("TextureManager: Текстуры автомобилей были перерисованы.")
	end
)

addEventHandler("onClientResourceStart", resourceRoot, function()
		for i, vehicle in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(vehicle) then
				textureManager:updateVehicleTexture(vehicle)
			end
		end
	end
)

addCommandHandler("textures_info", function()
	local count = 0
	for vehicle, _ in pairs(textureManager.texturesShadersList) do
		count = count + 1
	end	
	outputChatBox("Textures and shaders count: " .. count)
end)

addEventHandler("onClientVehicleDamage", root,
	function()
		textureManager:updateVehicleTexture(source)
	end
)

addEvent("tws-onServerUpdateVehicleTexture", true)
addEventHandler("tws-onServerUpdateVehicleTexture", root,
	function()
		textureManager:updateVehicleTexture(source)
	end
)