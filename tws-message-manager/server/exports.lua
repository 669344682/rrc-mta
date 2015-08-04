-- showMessage(showTo, string title, string text, string icon, int time = false, bool wordWrappingEnabled = true)
--
-- showTo может быть:
-- nil - показывает всем игрокам
-- player - показывает конкретному игроку
-- table - показывает игрокам в массиве
--
-- icons = {ok, error, list, info, plus, question, race, warning, cash, cashbag}
--
-- ничего не возвращает
function showMessage(...)
	manager:showMessage(...)
end