-- This is the file that defines most global variables.

devmode = true
screen_debug = false

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


function newVariables()
	settings = {}
	settings.snd_music_v = {name="Music Volume",value=0.5}
	settings.snd_effects_v = {name="Effect Volume",value=0.5}
	settings.player_name = {name="Player Name",value="Player"}
end

function variables_load()
	newVariables()
	local setting = loadTable(mya_getPath().."/options.save")
	if setting then
		settings = setting
	end
end
variables_load()

-- Mouse Coords
mouseX = 0
mouseY = 0

-- States
STATE_MAINMENU = "mainmenu" --done
STATE_CHOOSEPLAY = "chooseplay" --done
STATE_OPTIONS = "options" --Mostly done :D
STATE_JOINSERVER = "joinserver" --done
STATE_HOST = "host" --Mostly done :D

STATE_LEVELEDITOR = "leveleditor"
STATE_INGAME = "ingame"

state = STATE_MAINMENU

-- Netcode
net_ip = "localhost"
function loadIP()
	local ip = loadTable(mya_getPath().."lastip.save")
	if ip then
		net_ip = ip.ip
	end
end
loadIP()

function saveIP()
	local ip = {}
	ip.ip = net_ip
	saveTable(mya_getPath().."lastip.save", ip)
end

net_port = 9999
net_max = 2
net_hasInit = false
--Netcode messages
NET_MSG_JOIN = "join"
NET_MSG_FULL = "full"
NET_MSG_DISCONNECT = "disconnect"
NET_MSG_ALLCLIENTS = "clients"
NET_MSG_REMOVECLIENT = "remove_client"
NET_MSG_SERVERSHUTDOWN = "shutdown"
NET_MSG_LOADLEVEL = "loadlevel"
NET_MSG_SWITCHSCREEN = "screen_switch"
NET_MSG_PLAYER = "player"
NET_MSG_SENDPLAYER = "send_players"
NET_MSG_UPDATEPLAYER = "update_player"
NET_MSG_TILEUPDATE = "tile_update"
NET_MSG_ = ""

-- Game Variables
isHosting = true
playerid = 0
world_id = "world_partisan_1"
local_player_id = 0