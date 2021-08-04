--Partisan by Alex Cooper Aug-4-2021
init = mya_init("Partisan", 1280, 720)

math.randomseed(os.time()) math.random() math.random() math.random() --setup that random

-- Import Files
json = require "json"
require("file")
require("util")
require("variables")
require("keybinds")
require("world")
require("player")

function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
end

function event_mouseButtonUp(btn)
	
end

function event_keyDown(key)
	if devmode then
		--print("KeyDN: "..key)
	end
end

function event_keyUp(key)
	if devmode then
		--print("KeyUP: "..key)
	end
	callBind(key)
end

function event_windowResize(w, h)

end

function event_update()

end

function event_render()

end

while mya_isRunning() do
	mya_update()
	mya_render()
end