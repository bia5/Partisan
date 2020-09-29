--Them by Alex Cooper March-29-2020
init = mya_init("Partisan - By Alex Cooper - QUARANTINE JAM", 1280, 720)
--mya_setFullscreen(true)

STATE_MAINMENU = "MM"
STATE_ABOUT = "ABT"
STATE_INGAME = "IG"
STATE_END = "END"
state = STATE_MAINMENU

songs = {Music.new("assets/music/TremLoadingloopl.wav"),Music.new("assets/music/ruski.mp3"),Music.new("assets/music/song18.mp3")}
cur_song = 1

sound_click = Sound.new("assets/sounds/click.wav")
sound_click:setVolume(4)
sound_swoosh = Sound.new("assets/sounds/swoosh.wav")
sound_swoosh:setVolume(8)
sound_swoosh2 = Sound.new("assets/sounds/swoosh2.wav")
sound_swoosh2:setVolume(8)
sound_paper = Sound.new("assets/sounds/paper.wav")
sound_paper:setVolume(8)
sound_walking = Sound.new("assets/sounds/walking.wav")
sound_walking:setVolume(32)
sound_coin = Sound.new("assets/sounds/coin.wav")
sound_coin:setVolume(8)

devmode = true
playMusic = false

mouseX = 0
mouseY = 0

math.randomseed(os.time()) math.random() math.random() math.random() --setup that random

json = require "json"
require("file")
require("assets")
require("util")
require("popups")
require("mainmenu")
require("game")
require("ingame")
require("player")

text_fps = TextView.new(font, "Fps 0", 0, 0, mya_getRenderer())
text_fps:setColor(mya_getRenderer(), 15, 15, 15)

function event_mouseMotion(x, y)
	mouseX = x
	mouseY = y
end

function event_mouseButtonDown(btn)
end

function event_mouseButtonUp(btn)
	mm_mouseButtonUp(btn)
	ig_mouseButtonUp(btn)
	popups_mouseButtonUp(btn)
end

function event_keyDown(key)
	ig_keyDown(key)
end

function event_keyUp(key)
	if key == "D" then
		mya_setFullscreen(not mya_getFullscreen())
	end
	
	mm_keyUp(key)
	ig_keyUp(key)
	popups_keyUp(key)
end

function event_windowResize(w, h)
	assets_updateFonts()
	mm_windowResize(w, h)
	ig_windowResize(w, h)
	popups_windowResize(w, h)
	player_windowResize(w, h)
end

function event_update()
	ig_update()
	popups_update()
	text_fps:setText("FPS "..mya_getFPS(), mya_getRenderer())
	
	if playMusic then
		if songs[cur_song]:isPlaying() == false then
			cur_song = cur_song + 1
			if cur_song > tablelength(songs) then
				cur_song = 1
			end
			songs[cur_song]:setVolume(8)
			songs[cur_song]:play()
		end
	end
end

function event_render()
	mm_render()
	ig_render()
	popups_render()
	if devmode == true then
		text_fps:render(mya_getRenderer())
	end
end


while mya_isRunning() do
	mya_update()
	mya_render()
end