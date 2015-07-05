tuningConfig = {}

tuningConfig.sounds = {
	-- Покупка/выбор
	buy = 32,
	-- Выбор в горизонтальном меню
	select = "1",
	-- Возврат
	back = "2",
	-- Выбор элемента в вертикальном подменю
	select_items = "1"
}

local carColorPrice = 500
local colors = {
	{ name = "Красный", 	color = {220, 0, 0}},
	{ name = "Оранжевый", 	color = {255, 150, 0}},
	{ name = "Желтый", 		color = {255, 255, 0}},
	{ name = "Зеленый", 	color = {83, 219, 83}},
	{ name = "Голубой", 	color = {98, 227, 226}},
	{ name = "Синий", 		color = {49, 49, 173}},
	{ name = "Фиолетовый", 	color = {171, 45, 196}},
	{ name = "Белый", 		color = {255, 255, 255}},
	{ name = "Серый", 		color = {200, 200, 200}},
	{ name = "Серый", 		color = {100, 100, 150}},
	{ name = "Черный", 		color = {25, 25, 25}},
}
tuningConfig.colors = colors

tuningConfig.mainSections = {
	{name = "upgrades", text = "УЛУЧШЕНИЯ"},
	{name = "vinyls", text = "ВИНИЛЫ"},
	{name = "visuals", text = "КУЗОВ И КОМПОНЕНТЫ"}
}

tuningConfig.subsectionsCaptions = {
	["upgrades"] = "УЛУЧШЕНИЯ",
	["vinyls"] = "ВИНИЛЫ",
	["visuals"] = "КУЗОВ И КОМПОНЕНТЫ"
}

tuningConfig.subsections = {
	["upgrades"] = {
		{name = "engine", text = "ДВИГАТЕЛЬ"},
		{name = "brakes", text = "ТОРМОЗА"},
		{name = "suspension", text = "ПОДВЕСКА"}
	},
	["vinyls"] = {
		{name = "shapes", text = "ФИГУРЫ"},
		{name = "flames", text = "ПЛАМЯ"},
		{name = "logo", text = "ЛОГО"},
		{name = "paintjobs", text = "РАСКРАСКИ"},
		{name = "removing", text = "УДАЛЕНИЕ НАКЛЕЕК"},
	},
	["visuals"] = {
		{name = "bodyColor", text = "ЦВЕТ КУЗОВА"},
		{name = "windows", text = "ТОНИРОВКА"},
		{name = "spoilers", text = "СПОЙЛЕР"},
		{name = "neon", text = "НЕОН"},
		{name = "carbon", text = "КАРБОН"},
		{name = "wheels", text = "ДИСКИ"},
		{name = "wheelsColor", text = "ЦВЕТ ДИСКОВ"}
	}
}

tuningConfig.subsectionsItems = {
	["upgrades-engine"] = {
		{name = "engine1", text = "Сток"},
		{name = "engine2", text = "Двигатель 1", price = 5000},
		{name = "engine3", text = "Двигатель 2", price = 10000}
	},
	["upgrades-suspension"] = {
		{name = "1", text = "Стоковая подвеска", 		price = 0},
		{name = "2", text = "Слабое занижение",	 		price = 2500},
		{name = "3", text = "Максимальное занижение", 	price = 5000}
	},
	["visuals-carbon"] = {
		{name = "bonnet-default", text = "Обычный капот", price = 0},
		{name = "bonnet", text = "Карбоновый капот", 	  price = 1000}
	},
	["visuals-spoilers"] = {
		{name = "spoiler0", text = "Сток"},
		{name = "spoiler1", text = "Спойлер 1",		price = 1000},
		{name = "spoiler2", text = "Спойлер 2",		price = 1000},
		{name = "spoiler3", text = "Спойлер 3",		price = 1000},
		{name = "spoiler4", text = "Спойлер 4",		price = 1000},
		{name = "spoiler5", text = "Спойлер 5",		price = 1000},
		{name = "spoiler6", text = "Спойлер 6",		price = 1000},
		{name = "spoiler7", text = "Спойлер 7",		price = 1000},
		{name = "spoiler8", text = "Спойлер 8",		price = 1000},
		{name = "spoiler9", text = "Спойлер 9",		price = 1000},
		{name = "spoiler10", text = "Спойлер 10",	price = 1000},
		{name = "spoiler11", text = "Спойлер 11",	price = 1000},
		{name = "spoiler12", text = "Спойлер 12",	price = 1000},
		{name = "spoiler13", text = "Спойлер 13",	price = 1000},
		{name = "spoiler14", text = "Спойлер 14",	price = 1000},
		{name = "spoiler15", text = "Спойлер 15",	price = 1000},
		{name = "spoiler16", text = "Спойлер 16",	price = 1000},
		{name = "spoiler17", text = "Спойлер 17",	price = 1000}
	},
	["visuals-wheels"] = {
		{name = "0", text = "Сток",			price = 0},
		{name = "1", text = "Диски 1",		price = 1000},
		{name = "2", text = "Диски 2",		price = 1100},
		{name = "3", text = "Диски 3",		price = 1200},
		{name = "4", text = "Диски 4",		price = 1300},
		{name = "5", text = "Диски 5",		price = 1400},
		{name = "6", text = "Диски 6",		price = 1500},
		{name = "7", text = "Диски 7",		price = 1600},
		{name = "8", text = "Диски 8",		price = 1700},
		{name = "9", text = "Диски 9",		price = 1800},
		{name = "10", text = "Диски 10",	price = 1900},
		{name = "11", text = "Диски 11",	price = 2000},
		{name = "12", text = "Диски 12",	price = 2100},
		{name = "13", text = "Диски 13",	price = 2200},
		{name = "14", text = "Диски 14",	price = 2300},
		{name = "15", text = "Диски 15",	price = 2400},
		{name = "16", text = "Диски 16",	price = 2500},
		{name = "17", text = "Диски 17",	price = 2600}
	},
	["visuals-neon"] = {
		{name = "none", text = "Без неона"},
		{name = "enabled-sides", text = "По бокам", 	 price = 2500},
		{name = "enabled-full", text = "Со всех сторон", price = 5000}
	},
	["visuals-windows"] = {
		{name = "0", text = "Без тонировки", 		  price = 0},
		{name = "1", text = "Средняя тонировка",	  price = 500},
		{name = "2", text = "Максимальная тонировка", price = 1500}
	},
	["vinyls-shapes"] = {
		{name = "none", text = "---"},
		{name = "14", text = "Наклейка 1", 	price = 500},
		{name = "15", text = "Наклейка 2", 	price = 500},
		{name = "19", text = "Наклейка 3", 	price = 500},
		{name = "20", text = "Наклейка 4",	price = 500},
		{name = "21", text = "Наклейка 5", 	price = 500},
		{name = "1", text = "Наклейка 6", 	price = 500},
		{name = "6", text = "Наклейка 7", 	price = 500}
	},
	["vinyls-logo"] = {
		{name = "none", text = "---"},
		{name = "10", text = "Наклейка 1", 	price = 500},
		{name = "11", text = "Наклейка 2", 	price = 500},
		{name = "4", text = "Наклейка 3", 	price = 500},
		{name = "5", text = "Наклейка 4",	price = 500},
		{name = "3", text = "Наклейка 5", 	price = 500},
	},
	["vinyls-flames"] = {
		{name = "none", text = "---"},
		{name = "7", text = "Пламя 1", 		price = 500},
		{name = "12", text = "Пламя 2", 	price = 500},
		{name = "13", text = "Пламя 3", 	price = 500},
		{name = "17", text = "Пламя 4", 	price = 500},
		{name = "22", text = "Пламя 5", 	price = 500},
		{name = "23", text = "Пламя 6", 	price = 500},
		{name = "24", text = "Пламя 7", 	price = 500},
		{name = "25", text = "Пламя 8", 	price = 500},
		{name = "26", text = "Пламя 9", 	price = 500},
		{name = "27", text = "Пламя 10", 	price = 500},
		{name = "28", text = "Пламя 11", 	price = 500},
		{name = "29", text = "Пламя 12", 	price = 500},
		{name = "30", text = "Пламя 13", 	price = 500},
		{name = "31", text = "Пламя 14", 	price = 500},
		{name = "32", text = "Пламя 15", 	price = 500},
		{name = "33", text = "Пламя 16", 	price = 500}
	},
	["vinyls-paintjobs"] = {
		{name = "none", text = "Без раскраски"},
		{name = "1", text = "Раскраска", 		price = 500},
		{name = "2", text = "Раскраска 1", 		price = 500},
		{name = "3", text = "Раскраска 2", 		price = 500},
		{name = "4", text = "Раскраска 3", 		price = 500},
		{name = "5", text = "Раскраска 4", 		price = 500},
		{name = "6", text = "Раскраска 5", 		price = 500},
		{name = "7", text = "Раскраска 6", 		price = 500},
		{name = "8", text = "Раскраска 7", 		price = 500},
		{name = "9", text = "Раскраска 8", 		price = 500},
		{name = "10", text = "Раскраска 9", 	price = 500},
		{name = "11", text = "Раскраска 10", 	price = 500},
		{name = "12", text = "Раскраска 11", 	price = 500},
		{name = "13", text = "Раскраска 12", 	price = 500},
		{name = "14", text = "Раскраска 13", 	price = 500},
		{name = "15", text = "Раскраска 14", 	price = 500},
		{name = "16", text = "Раскраска 15", 	price = 500},
		{name = "17", text = "Раскраска 16", 	price = 500},
		{name = "18", text = "Раскраска 17", 	price = 500},
		{name = "19", text = "Раскраска 18", 	price = 500},
		{name = "20", text = "Раскраска 19", 	price = 500},
		{name = "21", text = "Раскраска 20", 	price = 500},
		{name = "22", text = "Раскраска 21", 	price = 500},
		{name = "23", text = "Раскраска 22", 	price = 500},
		{name = "24", text = "Раскраска 23", 	price = 500},
		{name = "25", text = "Раскраска 24", 	price = 500},
		{name = "26", text = "Раскраска 25", 	price = 500}
	},
}

local isDoubleSized = {
	[404] = {false, false},
	[529] = {false, false},
	[420] = {false, false},
	[550] = {false, true},
	[546] = {false, false},
	[540] = {false, true},
	[580] = {false, false},
	[527] = {false, false},
	[587] = {true, false},
	[426] = {true, false},
	[436] = {true, false},
	[526] = {true, false},
	[401] = {true, false},
	[559] = {true, true},
	[562] = {true, true},
	[477] = {true, true},
	[480] = {true, true},
	[533] = {true, false},
	[517] = {true, true},
	[405] = {true, false},
	[560] = {true, true},
	[542] = {true, false},
	[439] = {true, false}
}
tuningConfig.isDoubleSized = isDoubleSized 