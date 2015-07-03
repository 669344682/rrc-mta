--createBlip( float x, float y, float z [, int icon = 0, int size = 2, int r = 255, int g = 0, int b = 0, int a = 255, int ordering = 0, float visibleDistance = 99999.0, visibleTo = getRootElement( ) ] )
local icons = {
	-- Отель
	{327.47146606445, -1514.1811523438, 35.530982971191, 35},

	-- Тюнинг
	{1041, -1016, 32, 63},

	-- Автомагазины
	{1128, -1489, 22, 55}, -- маркет
	{1132, -1873, 13, 55}, -- лада

	-- Работы
	{1866.2255859375, -1760.8913574219, 13.3, 52}, -- механик
}

for _,icon in ipairs(icons) do
	createBlip(icon[1], icon[2], icon[3], icon[4], 0.5, 255, 255, 255, 255, 0 , 300)
end