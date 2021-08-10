-- This is the file that defines most global variables.

devmode = true

settings = {}
_playerid = {}

function createPlayerID()
	return "1"..os.time()..math.floor(math.random()*1000000000)
end

function savePlayerID()
	saveTable(mya_getPath().."id.save", _playerid)
end

function loadPlayerID() 
	if devmode then
		_playerid = {}
		_playerid.id = createPlayerID()
	else
		_playerid = loadTable(mya_getPath().."id.save")
		if not _playerid then
			_playerid = {}
			_playerid.id = createPlayerID()
			savePlayerID()
		end
	end
end
loadPlayerID()

function getPlayerID() 
	return _playerid.id
end

function variables_save()
	saveTable(mya_getPath().."/options.save", settings)
end

function variables_load()
	local setting = loadTable(mya_getPath().."/options.save")
	if setting then
		settings = setting
	end
end
variables_load()

-- Sound Variables
if settings.snd_music_v == nil then
	settings.snd_music_v = 0.5
end
if settings.snd_effects_v == nil then
	settings.snd_effects_v = 0.5
end

if settings.player_name == nil then
	settings.player_name = "Player"
end

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
net_max = 4
net_split1 = "|"

-- Game Variables
isHosting = true
playerid = 0
if settings.world_ids == nil then
	settings.world_ids = 0
end
world_id = 0
local_player_id = 0