-- showMessage(string title, string text, string icon, int time = false, bool wordWrappingEnabled = true)
-- чтобы не было заголовка title = ""
--
-- icons = {ok, error, list, info, plus, question, race, warning, cash, cashbag}
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
-- в параметрах ID
addEvent("tws-message.onClientMessageClick")