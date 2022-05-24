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

	player.key_forward = false
	player.key_left = false
	player.key_back = false
	player.key_right = false
	player.speed = 5
	player.skipCollision = false

	player.state = "idle"

	--Stats
	player.health = 100
	player.maxHealth = 100

	player.inventory = {}

	--functions
	player.onUpdate = "player_update"
    player.onTUpdate = "player_tupdate"
    player.onCollision = "nil"
	
	return player
end

function getPlayer(id)
	return world.players[id]
end

function player_update(player)
	player.state = "idle"
	local speed = player.speed*(mya_getDelta()/1000)
	x = 0
	y = 0

	if player.key_forward then
		if not isEntityCollision(player, 0, -speed) or player.skipCollision then
			y=y-1
		end
		player.deg = 270
		player.state = "running"
	end
	if player.key_back then
		if not isEntityCollision(player, 0, speed) or player.skipCollision then
			y=y+1
		end
		player.deg = 0
		player.state = "running"
	end
	if player.key_left then 
		if not isEntityCollision(player, -speed, 0) or player.skipCollision then
			x=x-1
		end
		player.deg = 180
		player.state = "running"
	end
	if player.key_right then 
		if not isEntityCollision(player, speed, 0) or player.skipCollision then
			x=x+1
		end
		player.deg = 90
		player.state = "running"
	end

	if x ~= 0 or y ~= 0 then
		rad = math.atan2(y, x)
		player.x = player.x + (math.cos(rad) * speed)
		player.y = player.y + (math.sin(rad) * speed)
	end
end
newEntityFunction("player_update", player_update)

function player_tupdate()
	if getPlayer(getPlayerID()) then
		message(NET_MSG_UPDATEPLAYER,{player = getPlayer(getPlayerID())})
	end
end
newEntityFunction("player_tupdate", player_tupdate)

function player_up(isPressed)
	if state == STATE_INGAME or state == STATE_LEVELEDITOR then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_forward = isPressed
		end
	end
end
function player_down(isPressed) 
	if state == STATE_INGAME or state == STATE_LEVELEDITOR then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_back = isPressed
		end
	end
end
function player_left(isPressed) 
	if state == STATE_INGAME or state == STATE_LEVELEDITOR then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_left = isPressed
		end
	end
end
function player_right(isPressed) 
	if state == STATE_INGAME or state == STATE_LEVELEDITOR then
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_right = isPressed
		end
	end
end