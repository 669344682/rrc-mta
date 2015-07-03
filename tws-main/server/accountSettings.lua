defaultAccountData = {}

-- Машины игрока по умолчанию
defaultAccountData["vehicles"] = toJSON({
	--[[{
		model = 404,
		tuning = {
			color = {255, 150, 0},
		}
	}]]
})

-- Деньги по умолчанию
defaultAccountData["money"] = 70000
defaultAccountData["level"] = 1
defaultAccountData["respects"] = 0
defaultAccountData["playtime"] = 0

-- Переменные, которые нужно загружать из аккаунта в player data
-- После записи в дату ко всем ключам приписыается "tws-"
-- Например, "money" => "tws-money"
accountDataToPlayerData = {
	"money",
	"skin",
	"level",
	"respects",
	"playtime"
}


-- Переменные, которые нужно сохранять из player data в аккаунт при logout'е
accountDataToSaveOnLogout = {
	"tws-money",
	"tws-level",
	"tws-respects"
}

levelsRequirements = {
	[2] = {
		respects = 8,
		money = 50000
	},
	[3] = {
		respects = 10,
		money = 75000
	},
	[4] = {
		respects = 12,
		money = 135000
	},
	[5] = {
		respects = 14,
		money = 235000
	},
	[6] = {
		respects = 16,
		money = 435000
	},
	[7] = {
		respects = 18,
		money = 835000
	},
	[8] = {
		respects = 20,
		money = 835000
	},
	[9] = {
		respects = 22,
		money = 835000
	},
	[10] = {
		respects = 24,
		money = 835000
	}
}