--TODO: SAVING/LOADING
--TODO: Functions

function newPlayer(id, name, x, y)
	player = {}

	--Info
	player.id = id
	player.name = name
	player.tex = "entity_ninja_0"

	--Position
	player.x = x
	player.y = y
	player.w = .99
	player.h = .99
	player.deg = 0 --Degrees

	--Movement
	player.velX = 0
	player.velY = 0

	player.speed = 5

	player.key_w = false
	player.key_a = false
	player.key_s = false
	player.key_d = false

	--Stats
	player.health = 100
	player.maxHealth = 100

	--Netcode
	player.isOnline = false

	--Functions
	player.onUpdate = "nil"
	player.onCollision = "nil"

	return player
end

function getPlayer(id)
	return world.players[id]
end