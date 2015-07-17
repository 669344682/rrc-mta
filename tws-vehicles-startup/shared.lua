vehiclesResources = {
	"BMW_E34",
	"BMW_E39",
	"Chevrolet_Camaro_Z28",
	"Dodge_Challenger",
	"Honda_Civic_Si_1999",
	"Honda_S2000",
	"Mazda_RX7",
	"Mitsubishi_Eclipse",
	"Nissan_Silvia_S14",
	"Nissan_Silvia_S15",
	"Nissan_Skyline_R34",
	"Porsche_911",
	"Subaru_Impreza",
	"Toyota_Celica",
	"Toyota_Chaser",
	"Toyota_Supra",
	"vaz2101",
	"vaz2103",
	"vaz2106",
	"vaz2109",
	"vaz2110",
	"vaz2112",
	"vaz2170",
	"BMW_850CSI",
}

local encodeBytesCount = 1024
local randomCharacters = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
local key = "IOQoqfwiwqjfqIJWQFI1958151ijwfjqigoijqafas"

local function generateRandomString(len)
	local str = ""
	for i = 1, len do
		str = str .. randomCharacters[math.random(1, #randomCharacters)]
	end
	return str
end

local function decodeFile(path)
	if not fileExists(path .. ".png") then
		return false
	end
	if not fileExists(path) then
		return false
	end
	local fData = fileOpen(path .. ".png")
	local data = fileRead(fData, fileGetSize(fData))
	data = base64Decode(data)
	data = teaDecode(data, key)
	fileClose(fData)

	local f = fileOpen(path)
	fileSetPos(f, 0)
	fileWrite(f, data)
	fileClose(f)
end


local function encodeFile(path)
	--if fileExists(path .. ".png") then
	--	decodeFile(path)
	--end
	local f = fileOpen(path)
	local data = fileRead(f, encodeBytesCount)
	fileSetPos(f, 0)
	fileWrite(f, generateRandomString(encodeBytesCount))
	fileClose(f)

	local fData = fileCreate(path .. ".png")
	data = teaEncode(data, key)
	data = base64Encode(data)
	fileWrite(fData, data)
	fileClose(fData)
end

function encodeVehicleResource(name)
	if not name then
		return false
	end
	name = tostring(name)
	print("Encoding vehicle: \"" .. name .. "\"")
	encodeFile(":" .. name .. "/car.dff")
	encodeFile(":" .. name .. "/car.txd")
end

function decodeVehicleResource(name)
	if not name then
		return false
	end
	name = tostring(name)
	decodeFile(":" .. name .. "/car.dff")
	decodeFile(":" .. name .. "/car.txd")
end