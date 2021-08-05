--Partisan by Alex Cooper Aug-4-2021
init = mya_init("Partisan", 1920, 1080)

math.randomseed(os.time()) math.random() math.random() math.random() --setup that random

-- Import Files
json = require "json"
require("file")
require("util")
require("variables")
require("world")
require("player")
require("ingame")
require("netcode")
require("assets")
require("mainmenu")


require("keybinds")
function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
end

function event_mouseButtonUp(btn)
	
end

function event_keyDown(key)
	
end

function event_keyUp(key)
	if devmode then
		--print("KeyUP: "..key)
	end
	callBind(key)
end

function event_windowResize(w, h)
	asset_updateFonts()

	if state == STATE_MAINMENU then
		screen_mm_windowResize(w, h)
	end
end

function event_update()
	if state == STATE_MAINMENU then
		screen_mm_update()
	end
end

function event_render()
	if state == STATE_MAINMENU then
		screen_mm_render()
	end
end

function event_quit()
	network:close()
end

while mya_isRunning() do
	mya_update()
	mya_render()
	network:update()
end