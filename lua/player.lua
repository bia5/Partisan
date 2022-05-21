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
    player.onTUpdate = "nil"
    player.onCollision = "nil"
	
	return player
end

function getPlayer(id)
	return world.players[id]
end