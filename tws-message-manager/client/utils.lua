loadstring(exports["tws-shared"]:include("utils"))()

_, speedoY, _, speedoY2 = exports["tws-speedometer"]:getPosition()
speedoH = speedoY2 - speedoY
--




--[[
	Алгоритм:
	1. Создаём новый пустой слог.
	2. Просматриваем слово с конца. Пока буквы согласные, добавляем их в слог.
	при обнаружении гласной добавляем её в слог, смотрим букву перед ней.
	если эта буква гласная - слог завершён, создаём новый.
	если эта буква согласная - добавляем в слог, смотрим следующую:
	если это гласная - слог завершён.
	если это согласная, то смотрим кол-во букв до предыдущей гласной:
	если это расстояние 1 буква, слог завершён. Ибо эта одна буква принадлежит следующему слогу
	если это расстояние больше 1 буквы, добавляем согласную в текущий слог.
	3. При достижении начала слова перейти к просмотру следующего.
]]--

--[[
function makeStringWordWrap(str)
	local originalString = str
	local words = {}

	local i = 1
	while true do
		local spacePos = string.find(str, " ")
		local word = string.sub(str, 1, spacePos and spacePos-1 or -1)

		outputChatBox("START \"" .. word .. "\" END")


		str = spacePos and string.sub(str, spacePos + 1, -1) or ""

		if not spacePos then
			break
		end

		i = i + 1
		if i > 100 then
			break
		end

	end
end
]]--
