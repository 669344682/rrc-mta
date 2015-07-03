colors = {}

local white 		= tocolor(255, 255, 255)
local black 		= tocolor(0, 0, 0)
local grey 			= tocolor(220, 220, 220)
local grey_dark 	= tocolor(170, 170, 170)
local grey_dark2 	= tocolor(80, 80, 80)
local main_light 	= tocolor(0, 40 * 1.2, 51 * 1.2)
local main_light2 	= tocolor(10, 40 * 1.5, 51 * 1.5)
local main_light3 	= tocolor(15, 40 * 2, 51 * 2)
local main 			= tocolor(0, 40, 51)
local main_dark 	= tocolor(0, 40 * 0.8, 51 * 0.8)
local secondary 	= tocolor(50, 52, 71)

-- Disabled grey
local d_green_light = tocolor(110 * 1.2, 110 * 1.2, 110 * 1.2)
local d_green 		= tocolor(110, 110, 110)
local d_green_dark 	= tocolor(110 * 0.8, 110 * 0.8, 110 * 0.8)

--[[
colors.window = {}
colors.window.border = main_dark
colors.window.frame = main
colors.window.background = grey
colors.window.header = main
colors.window.header_text = white

colors.button = {}
colors.button.border = main_dark
colors.button.backgroundOut = main
colors.button.backgroundOver = main_light
colors.button.text = white
colors.button.disabled_border = d_green_dark
colors.button.disabled_background = d_green
colors.button.disabled_text = grey

colors.label = {}
colors.label.text = black

colors.toggle = {}
colors.toggle.border = main_dark
colors.toggle.mainOut = main
colors.toggle.mainOver = main_light
colors.toggle.background = grey
colors.toggle.border_disabled = grey_dark2
colors.toggle.main_disabled = grey_dark

colors.checkbox = {}
colors.checkbox.border = main_dark
colors.checkbox.mainOut = main
colors.checkbox.mainOver = main_light
colors.checkbox.background = grey

colors.edit = {}
colors.edit.text = black
colors.edit.background = grey
colors.edit.backgroundActive = main
colors.edit.backgroundOver = main_light
colors.edit.border = main_dark
colors.edit.disabled_border = grey_dark2
colors.edit.disabled_text = grey_dark2
colors.edit.disabled_background = grey_dark]]

colors.window = {}
colors.window.border = main_dark
colors.window.frame = main
colors.window.background = main_light2
colors.window.header = main
colors.window.header_text = white

colors.button = {}
colors.button.border = main_dark
colors.button.backgroundOut = main
colors.button.backgroundOver = main_light3
colors.button.text = white
colors.button.disabled_border = d_green_dark
colors.button.disabled_background = d_green
colors.button.disabled_text = grey

colors.label = {}
colors.label.text = white

colors.toggle = {}
colors.toggle.border = main_dark
colors.toggle.mainOut = main
colors.toggle.mainOver = main_light3
colors.toggle.background = colors.window.background
colors.toggle.border_disabled = grey_dark2
colors.toggle.main_disabled = grey_dark

colors.checkbox = {}
colors.checkbox.border = main_dark
colors.checkbox.mainOut = main
colors.checkbox.mainOver = main_light
colors.checkbox.background = colors.window.background

colors.edit = {}
colors.edit.text = white
colors.edit.background = main_light
colors.edit.backgroundActive = main_light3
colors.edit.backgroundOver = main_light3
colors.edit.border = main_dark
colors.edit.disabled_border = grey_dark2
colors.edit.disabled_text = grey_dark2
colors.edit.disabled_background = grey_dark