--TODO: SAVING/LOADING
--TODO: Functions

function newPlayer(id, name, x, y, number)
	player = newEntity(id, -1)

	--Info
	player.id = id
	player.name = name
	--player.tex = "player" --Cleaned for netcode optimization

	--Position
	player.x = x
	player.y = y
	player.w = .99
	player.h = .99
	player.deg = 0 --Degrees

	player.number = number --Player number for texture (I want to nullify)

	player.key_w = false
	player.key_a = false
	player.key_s = false
	player.key_d = false
	player.speed = 5

	--Stats
	player.health = 100
	player.maxHealth = 100

	player.inventory = {}

	--functions
	player.onUpdate = "nil"
    player.onTUpdate = "player_tupdate"
    player.onCollision = "nil"
	
	return player
end

function getPlayer(id)
	return world.players[id]
end

function player_tupdate()
	if getPlayer(getPlayerID()) then
		message(NET_MSG_UPDATEPLAYER,{player = getPlayer(getPlayerID())})
	end
end
newEntityFunction("player_tupdate", player_tupdate)

function player_up(isPressed)
	if state == STATE_INGAME then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_w = isPressed
		end
	end
end
function player_down(isPressed) 
	if state == STATE_INGAME then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_s = isPressed
		end
	end
end
function player_left(isPressed) 
	if state == STATE_INGAME then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_a = isPressed
		end
	end
end
function player_right(isPressed) 
	if state == STATE_INGAME then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_d = isPressed
		end
	end
end