local textureCubeVeh = dxCreateTexture ("images/cube_veh256.dds" )

local windowsShaders = {}
local windowsShadersDam = {}

local levels = {
	0.7,
	0.9
}

function setVehicleWindowsLevel(vehicle, level)
	if level == 0 or not level then
		if windowsShaders[vehicle] then
			engineRemoveShaderFromWorldTexture(windowsShaders[vehicle], "tws-windows", vehicle)
		end	
		if windowsShadersDam[vehicle] then
			engineRemoveShaderFromWorldTexture(windowsShadersDam[vehicle], "tws-windows-dam", vehicle)
		end		
	else
		local transp = levels[level]

		if not windowsShaders[vehicle] then
			windowsShaders[vehicle] = dxCreateShader("shaders/car_windows.fx")
			dxSetShaderValue(windowsShaders[vehicle], "sReflectionTexture", textureCubeVeh );
		end
		engineApplyShaderToWorldTexture(windowsShaders[vehicle], "tws-windows", vehicle)
		dxSetShaderValue(windowsShaders[vehicle], "windowTransparency", transp)
		dxSetShaderValue(windowsShaders[vehicle], "brightnessFactor", (1 - transp) * 0.15)

		if not windowsShadersDam[vehicle] then
			windowsShadersDam[vehicle] = dxCreateShader("shaders/color_replace.fx")
		end
		engineApplyShaderToWorldTexture(windowsShadersDam[vehicle], "tws-windows-dam", vehicle)
		dxSetShaderValue(windowsShadersDam[vehicle], "gColor", {0.1, 0.1, 0.1, math.min(1, transp + 0.05)} );
	end
end