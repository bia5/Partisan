--Partisan by Alex Cooper Aug-4-2021
--Hi from April 28th 2022
init = mya_init("Partisan", 720, 480)

math.randomseed(os.time()) math.random() math.random() math.random() --setup that random
fileHandler = FileHandler.new()

-- Import Files
json = require "util/util_json"
require("util/util")
require("util/util_file")
require("util/util_assets")
require("variables")
require("netcode")
require("screen")

require("tileHandler")
require("tileFunctions")
require("tileTypes")
require("entityHandler")
require("entityFunctions")
require("entityTypes")

require("world")
require("player")

require("screens/screen_mainmenu")
require("screens/screen_chooseplay")
require("screens/screen_options")
require("screens/screen_joinserver")
require("screens/screen_host")
require("screens/screen_ingame")
require("screens/screen_leveleditor")

require("util/util_keybinds")

function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
end

collision = false
function event_mouseButtonDown(btn)
	screen = getScreen(state)
	if screen ~= nil then
        if screen.onMouseButtonDown then
            screen.onMouseButtonDown(btn)
        end
    end
	mouseButtonDown(getScreen(state), btn, 0, 0)
end

function event_mouseButtonUp(btn)
	screen = getScreen(state)
	if screen ~= nil then
        if screen.onMouseButtonUp then
            screen.onMouseButtonUp(btn)
        end
    end
	global_editing = mouseButtonUp(getScreen(state), btn, 0, 0)
end

function event_keyDown(key)
	callBind(key, true)
	keyDown(getScreen(state), key)
end

function event_keyUp(key)
	--print(math.floor(os.clock()).."."..mya_getTime())
	callBind(key, false)
	keyUp(getScreen(state), key)
end

function event_update()
	mya_deltaUpdate()
	update(getScreen(state))
end

function event_render()
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
	tupdate(getScreen(state))
end

while mya_isRunning() do
	mya_update()
	mya_render()
end

mya_close()