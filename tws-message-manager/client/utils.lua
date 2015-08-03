screenX, screenY = guiGetScreenSize()
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


local string = "qwe asd zxc rty"
local space = string.find(string, " ", 10, true)

--outputChatBox("oldSpace: " .. space)


function makeStringWordWrap(string, wrapAfter)
	local wrapAfter = math.floor(wrapAfter) or 60
	local newString = ""
	local pos = 1
	local space = false

	local counter = 1
	while pos < string.len(string) do
		space = string.find(string, " ", wrapAfter, true)

		shit = true
		if shit then
			if space then
				local tempString = string.sub(string, 1, space)
				space = string.len(tempString) - string.find(string.reverse(tempString), " ", 2) + 1
			end
		end


		newString = newString .. string.sub(string, 1, space or -1) .. "\n"

		if not space then
			break
		end

		string = string.sub(string, space + 1)

		counter = counter + 1

		if counter > 100 then
			break
		end
	end
	return newString, counter, nextLine
end
