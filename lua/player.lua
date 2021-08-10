function newPlayer(id, name, x, y)
	world.players[id] = {}
	world.players[id].name = name
	world.players[id].x = x
	world.players[id].y = y
	world.players[id].speed = 1
	world.players[id].w = false
	world.players[id].s = false
	world.players[id].a = false
	world.players[id].d = false
end

function getPlayer(id)
	return world.players[id]
end