gui = {}
gui.isVisible = false

gui.state = "login"

local blockWidth = 400
local blockHeight = 270
local blockX = (screenWidth - blockWidth) / 2 
local blockY = (screenHeight - blockHeight) / 2
local blockColor = tocolor(10, 10, 10, 150)

local backgroundTexture = dxCreateTexture("images/backgrounds/background" .. tostring(math.random(1, 17)) .. ".jpg")
local backgroundWidth, backgroundHeight = dxGetMaterialSize(backgroundTexture)
local backgroundScale = screenHeight / backgroundHeight
backgroundWidth, backgroundHeight = backgroundWidth * backgroundScale, backgroundHeight * backgroundScale

local logoTexture = dxCreateTexture("images/logo.png")
local logoWidth, logoHeight = dxGetMaterialSize(logoTexture)
local logoScale = blockWidth / logoWidth
local logoY = 0
logoWidth, logoHeight = logoWidth * logoScale, logoHeight * logoScale

local fadingProgress = 0

gui.login = {}
gui.login.accountEdit = guiCreateEdit(blockX, 100, blockWidth - 40, 30, "Username", false)
gui.login.passwordEdit = guiCreateEdit(blockX, 100, blockWidth - 40, 30, "PASSWORD", false)
guiEditSetMasked(gui.login.passwordEdit, true)

local messageFadingProgress = 0
local isFirstMessage = true

local messageText = ""

local function showMessage(msg)
	if isFirstMessage then
		isFirstMessage = false
	end
	messageFadingProgress = 0

	messageText = msg
end

--[[
login = {}
login.accountLabel = guiCreateLabel(0.1, 0.1, 0.8, 0.1, "Имя", true, login.window); guiLabelSetHorizontalAlign(login.accountLabel, "center")
login.passwordLabel = guiCreateLabel(0.1, 0.375, 0.8, 0.1, "Пароль", true, login.window); guiLabelSetHorizontalAlign(login.passwordLabel, "center")
login.accountEdit = guiCreateEdit(0.1, 0.175, 0.8, 0.125, "", true, login.window)
login.passwordEdit = guiCreateEdit(0.1, 0.45, 0.8, 0.125, "", true, login.window); guiEditSetMasked(login.passwordEdit, true)

register = {}
register.accountLabel = guiCreateLabel(0.1, 0.1, 0.8, 0.1, "Имя", true, register.window); guiLabelSetHorizontalAlign(register.accountLabel, "center")
register.passwordLabel = guiCreateLabel(0.1, 0.375, 0.8, 0.1, "Пароль", true, register.window); guiLabelSetHorizontalAlign(register.passwordLabel, "center")
register.accountEdit = guiCreateEdit(0.1, 0.175, 0.8, 0.125, "", true, register.window)
register.passwordEdit = guiCreateEdit(0.1, 0.45, 0.8, 0.125, "", true, register.window); guiEditSetMasked(register.passwordEdit, true)
]]

local function saveLoginData(username, password)
	local f
	if not fileExists("@autologin") then
		f = fileCreate("@autologin")
	else
		f = fileOpen("@autologin")
	end
	if not f then
		return
	end

	local fields = {}
	if username then
		fields.username = username
	end
	if password then
		fields.password = password
	end

	local jsonData = toJSON(fields)
	if not jsonData then
		return
	end
	fileWrite(f, jsonData)
	fileClose(f)
end

local function loadLoginData()
	if not fileExists("@autologin") then
		return
	end
	local f = fileOpen("@autologin")
	if not f then
		return
	end
	local jsonData = fileRead(f, fileGetSize(f))
	fileClose(f)

	if not jsonData then
		return
	end
	local fields = fromJSON(jsonData)
	if not fields then
		return
	end
	if fields.username then
		guiSetText(gui.login.accountEdit, tostring(fields.username))
	end
	if fields.password then
		guiSetText(gui.login.passwordEdit, tostring(fields.password))
	end
end

loadLoginData()
local function onLogin()
	local username = guiGetText(gui.login.accountEdit)
	local check = checkStr(username)
	if check ~= "ok" then
		if check == "no" then
			--outputChatBox("Введите имя пользователя!", 255, 0, 0)
			showMessage("Введите имя пользователя!")
		else
			--outputChatBox("Неверное имя пользователя!", 255, 0, 0)
			showMessage("Неверное имя пользователя!")
		end
		return
	end

	local password = guiGetText(gui.login.passwordEdit)
	local check = checkStr(password)
	if check ~= "ok" then
		if check == "no" then
			--outputChatBox("Введите пароль!", 255, 0, 0)
			showMessage("Введите пароль!")
		end
		return
	end
	triggerServerEvent("onPlayerLoginButtonClick", resourceRoot, username, password)
	saveLoginData(username, password)
end

local function onRegister()
	local username = guiGetText(gui.login.accountEdit)
	local check = checkStr(username)
	if check ~= "ok" then
		if check == "no" then
			--outputChatBox("Введите имя пользователя!", 255, 0, 0)
			showMessage("Введите имя пользователя!")
		else
			--outputChatBox("Неверное имя пользователя!", 255, 0, 0)
			showMessage("Неверное имя пользователя!")
		end
		return
	end

	local password = guiGetText(gui.login.passwordEdit)
	local check = checkPassword(password)
	if check ~= "ok" then
		if check == "no" then
			--outputChatBox("Введите пароль!", 255, 0, 0)
			showMessage("Введите пароль!")
		elseif check == "short" then
			showMessage("Пароль должен быть не короче 5 символов!")
		elseif check == "long" then
			showMessage("Пароль должен быть не длиннее 30 символов!")
		elseif check == "bad" then
			showMessage("Нельзя использовать такой пароль!")
		end
		return
	end
	triggerServerEvent("onPlayerRegisterButtonClick", resourceRoot, username, password)
end

addEventHandler("onClientGUIAccepted", resourceRoot, 
	function()
		if source == gui.login.passwordEdit then
			onLogin()
		elseif source == register.passwordEdit then
			onRegister()
		end
	end
)
--[[
addEventHandler("onClientGUIClick", resourceRoot, 
	function()
		if source == login.loginButton then
			onLogin()
		elseif source == register.registerButton then
			onRegister()
		elseif source == login.showRegButton then
			guiSetVisible(login.window, false)
			guiSetVisible(register.window, true)
		elseif source == register.backButton then
			guiSetVisible(login.window, true)
			guiSetVisible(register.window, false)
		end
	end
)]]

function gui.reset()
	fadingProgress = 0
	isFirstMessage = true
end

function gui.draw()
	fadingProgress = math.min(fadingProgress + 0.005, 1)
	dxDrawImage(0, 0, backgroundWidth, backgroundHeight, backgroundTexture, 0, 0, 0, tocolor(255*fadingProgress, 255*fadingProgress, 255*fadingProgress))
	local y = (screenHeight - (blockHeight + 10 + logoHeight + 40)) / 2
	dxDrawImage(blockX, y, logoWidth, logoHeight, logoTexture, 0, 0, 0, tocolor(255, 255, 255, 255 * fadingProgress))
	y = y + logoHeight + 10
	dxDrawRectangle(blockX, y, blockWidth, blockHeight, blockColor)
	--dxDrawRectangle(blockX, y, blockWidth, 50, tocolor(10, 10, 10, 50))

	local x = blockX
	--y = blockY
	local text = "Добро пожаловать"
	if gui.state == "register" then
		text = "Регистрация"
	end
	dxDrawShadowText(text, x, y, blockX + blockWidth, y + 60, tocolor(255, 255, 255), 2, "default-bold", "center", "center")
	y = y + 70
	x = x + 20
	dxDrawShadowText("Имя пользователя", x, y, x + blockWidth, y + 1, tocolor(255, 255, 255), 1.2, "arial")
	y = y + 25
	--dxDrawRectangle(x, y, blockWidth - 40, 30, tocolor(255, 255, 255, 100))
	guiSetPosition(gui.login.accountEdit, x, y, false)
	y = y + 50
	dxDrawShadowText("Пароль", x, y, x + blockWidth, blockY + y + 1, tocolor(255, 255, 255), 1.2, "arial")
	y = y + 25
	--dxDrawRectangle(x, y, blockWidth - 40, 30, tocolor(255, 255, 255, 100))
	guiSetPosition(gui.login.passwordEdit, x, y, false)
	y = y + 50
	x = blockX + (blockWidth - 230) / 2
	if gui.state == "login" then
		if dxDrawButton(x, y, 100, 30, "Вход") then
			onLogin()
		end
		x = x + 120
		if dxDrawButton(x, y, 100, 30, "Регистрация") then
			gui.state = "register"
			isFirstMessage = true
		end
	elseif gui.state == "register" then
		if dxDrawButton(x, y, 100, 30, "Регистрация") then
			onRegister()
		end
		x = x + 120
		if dxDrawButton(x, y, 100, 30, "Назад") then
			gui.state = "login"
			isFirstMessage = true
		end
	end

	if not isFirstMessage then
		x = blockX
		y = y + 55
		messageFadingProgress = math.min(messageFadingProgress + 0.05, 1)
		dxDrawRectangle(x, y, blockWidth, 30, tocolor(255, 0, 0, 170 * messageFadingProgress))
		dxDrawShadowText(messageText, x, y, x + blockWidth, y + 30, tocolor(255, 255, 255, 255 * messageFadingProgress), 1.2, "arial", "center", "center")
	end
	updateMouseClick()
end

addEvent("tws-loginRegisterError", true)
addEventHandler("tws-loginRegisterError", root,
	function(msg)
		showMessage(tostring(msg))
	end
)