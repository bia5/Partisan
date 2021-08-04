players = {}

function newPlayer(name, islocal, x, y)
	world.player_ids = world.player_ids + 1
	players[world.player_ids] = {name, islocal, x, y}
end

function savePlayer(id)
	saveTable(mya_getPath().."/worlds/"..world_id.."/players/"..id..".player", players[id])
end

function loadPlayer(id)
	players[id] = loadTable(mya_getPath().."/worlds/"..world_id.."/players/"..id..".player")
end