-- showMessage(showTo, string title, string text, string icon, int time = false, bool wordWrappingEnabled = true, string buttonYes = false, string buttonNo = false)
--
-- showTo может быть:
-- "all" - показывает всем игрокам
-- player - показывает конкретному игроку
-- table - показывает игрокам в массиве
--
-- title - заголовок (чтобы не было title = "")
-- buttonYes - название левой кнопки ("yes" при клике)
-- buttonNo - название правой кнопки ("no" при клике)
--
-- icons = {ok, error, list, info, plus, question, race, warning, cash, cashbag}
--
-- ничего не возвращает
function showMessage(...)
	manager:showMessage(...)
end