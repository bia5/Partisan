function newPlayer(id, name, x, y)
	if world.players[id] == nil then
		world.players[id] = {}

		world.players[id].name = name

		world.players[id].x = x
		world.players[id].y = y

		world.players[id].speed = 5

		world.players[id].w = false
		world.players[id].s = false
		world.players[id].a = false
		world.players[id].d = false

		world.players[id].online = false

		world.players[id].hp = 100
		world.players[id].maxhp = 100
	end
end

function getPlayer(id)
	return world.players[id]
end