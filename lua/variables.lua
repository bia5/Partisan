-- This is the file that defines most global variables.

devmode = true

settings = {}

function variables_save()
	saveTable(mya_getPath().."/options.save", settings)
end

function variables_load()
	local setting = loadTable(mya_getPath().."/options.save")
	if setting then
		settings = setting
	end
end

-- Sound Variables
settings.snd_music_v = 0.5
settings.snd_effects_v = 0.5

settings.player_name = "Player"

-- Mouse Coords
mouseX = 0
mouseY = 0

-- States
STATE_MAINMENU = "mainmenu" -- done
STATE_OPTIONS = "options"
STATE_ABOUT = "about"
STATE_CHOOSEPLAY = "chooseplay" -- done
STATE_LEVELEDITOR = "leveleditor"
STATE_HOST = "host"
STATE_JOINSERVER = "joinserver" --done
STATE_INGAME = "ingame"
state = STATE_MAINMENU

-- Netcode
net_ip = "localhost"
net_port = 9999
net_number = 0

-- Game Variables
isHosting = true
settings.world_ids = 0
world_id = 0
local_player_id = 0

variables_load() -- needs to be executed last