world = {}
world.player_ids = 0

function newWorld()

end

function saveWorld()
	saveTable(mya_getPath().."/worlds/"..world_id.."/world.world", world)
end

function loadWorld()
	world = loadTable(mya_getPath().."/worlds/"..world_id.."/world.world")
end