-- showMessage(string title, string text, string icon, int time = false, bool wordWrappingEnabled = true, string buttonYes = false, string buttonNo = false)
-- title - заголовок (чтобы не было title = "")
-- buttonYes - название левой кнопки ("yes" при клике)
-- buttonNo - название правой кнопки ("no" при клике)
--
-- icons = {ok, error, list, info, plus, minus, question, race, warning, cash, cashbag}
--
-- возвращает ID сообщения
function showMessage(...)
	return manager:showMessage(...)
end

-- hideMessage(int ID)
--
-- возвращает true при успешном скрытии
function hideMessage(...)
	return manager:hideMessage(...)
end

-- hideAllMessages()
--
-- возвращает true при успешном скрытии
function hideAllMessages()
	return manager:hideAllMessages()
end


-- срабатывает один раз при клике на сообщение (после клика оно скрывается)
--
-- в параметрах ID, button (может быть равен false, "yes", "no")
addEvent("tws-message.onClientMessageClick")