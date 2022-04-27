--Partisan by Alex Cooper Aug-4-2021
init = mya_init("Partisan", 1280, 720)

math.randomseed(os.time()) math.random() math.random() math.random() --setup that random
fileHandler = FileHandler.new()

-- Import Files
json = require "json"
require("file")
require("util")
require("variables")
require("netcode")
require("assets")
require("screen")

require("screen_mainmenu")
require("screen_chooseplay")
require("screen_options")

require("joinserver")
require("host")
require("ingame")

require("tileHandler")
require("tileFunctions")
require("tileTypes")

require("entityHandler")
require("entityFunctions")
require("entityTypes")

require("world")
require("player")

require("leveleditor")

require("keybinds")

function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
	mouseMotion(getScreen(state), x, y)
end

function event_mouseButtonDown(btn)
	if state == STATE_LEVELEDITOR then
		screen_le_mouseButtonDown(btn)
	elseif state == STATE_INGAME then
		screen_ig_mouseButtonDown(btn)
	end

	mouseButtonDown(getScreen(state), btn)
end

function event_mouseButtonUp(btn)
	if state == STATE_JOINSERVER then
		screen_js_mouseButtonUp(btn)
	elseif state == STATE_HOST then
		screen_ho_mouseButtonUp(btn)
	elseif state == STATE_INGAME then
		screen_ig_mouseButtonUp(btn)
	elseif state == STATE_LEVELEDITOR then
		screen_le_mouseButtonUp(btn)
	end
	
	mouseButtonUp(getScreen(state), btn)
end

function event_keyDown(key)
	callBind(key, true)
end

function event_keyUp(key)
	callBind(key, false)

	if state == STATE_JOINSERVER then
		screen_js_keyUp(key)
	end
end

function event_windowResize(w, h)
	asset_updateFonts()

	screen_js_windowResize(w, h)
	screen_ho_windowResize(w, h)
	screen_ig_windowResize(w, h)
	screen_le_windowResize(w, h)
end

function event_update()
	if state == STATE_INGAME then
		screen_ig_update()
	elseif state == STATE_LEVELEDITOR then
		screen_le_update()
	end
end

function event_render()
	if state == STATE_JOINSERVER then
		screen_js_render()
	elseif state == STATE_HOST then
		screen_ho_render()
	elseif state == STATE_INGAME then
		screen_ig_render()
	elseif state == STATE_LEVELEDITOR then
		screen_le_render()
	end

	render(getScreen(state))
end

function event_quit()
	if isHosting then
		close_server()
	else
		removeMyselfSafe()
	end
end

mya_setUPS(20)

function event_tupdate()
	network:update()
	network_update()

	if state == STATE_INGAME then
		screen_ig_tupdate()
	elseif state == STATE_LEVELEDITOR then
		screen_le_tupdate()
	end
end

while mya_isRunning() do
	mya_update()
	mya_render()
end

mya_close()