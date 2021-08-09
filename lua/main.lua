--Partisan by Alex Cooper Aug-4-2021
init = mya_init("Partisan", 1280, 720)

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
require("chooseplay")
require("joinserver")
require("host")
require("options")

require("keybinds")
function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
end

function event_mouseButtonDown(btn)

end

function event_mouseButtonUp(btn)
	if state == STATE_MAINMENU then
		screen_mm_mouseButtonUp(btn)
	elseif state == STATE_CHOOSEPLAY then
		screen_cp_mouseButtonUp(btn)
	elseif state == STATE_JOINSERVER then
		screen_js_mouseButtonUp(btn)
	elseif state == STATE_OPTIONS then
		screen_op_mouseButtonUp(btn)
	elseif state == STATE_HOST then
		screen_ho_mouseButtonUp(btn)
	end
end

function event_keyDown(key)
	
end

function event_keyUp(key)
	callBind(key)

	if state == STATE_JOINSERVER then
		screen_js_keyUp(key)
	elseif state == STATE_OPTIONS then
		screen_op_keyUp(key)
	end
end

function event_windowResize(w, h)
	asset_updateFonts()

	screen_mm_windowResize(w, h)
	screen_cp_windowResize(w, h)
	screen_js_windowResize(w, h)
	screen_op_windowResize(w, h)
	screen_ho_windowResize(w, h)
end

function event_update() end

function event_render()
	if state == STATE_MAINMENU then
		screen_mm_render()
	elseif state == STATE_CHOOSEPLAY then
		screen_cp_render()
	elseif state == STATE_JOINSERVER then
		screen_js_render()
	elseif state == STATE_OPTIONS then
		screen_op_render()
	elseif state == STATE_HOST then
		screen_ho_render()
	end
end

function event_quit()
	if isHosting then
		for k,v in pairs(clients) do
			if v.ip ~= "host" then
				network:sendMessage("quitting", v.ip)
			end
		end
	else
		network:sendMessage("bye"..net_split1..getPlayerID(), network:getIP())
	end
	network:close()
end

mya_setUPS(10)

function event_tupdate()
	network:update()
	network_update()
end

while mya_isRunning() do
	mya_update()
	mya_render()
end

mya_close()