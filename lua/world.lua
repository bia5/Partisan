--TODO
--redo tile generation

world = {} --In display order :D
world.isLinked = false

world.undertiles = {}
world.tiles = {}
world.objects = {}

world.players = {}

function newTile(id)
	tile = {}
	tile.id = id
	tile.walkable = true
	tile.collision = false
	return tile
end

function newWorld(worldsize) --creates an empty box world based on world size input
	--generates left to right, then up to down
	for ii=1,worldsize do
		for i=1,worldsize do
			world.undertiles[i.."-"..ii] = newTile("tile_grey") --create empty array
		end
	end

	for i=1,worldsize do --top row of brick
		world.tiles[i.."-1"] = newTile("tile_brick") --create empty array
		tile = world.tiles[i.."-1"] --makes it easier to call
		tile.walkable = false
		tile.collision = true
	end

	for i=1,worldsize do --bottom row of brick
		world.tiles[i.."-"..worldsize] = newTile("tile_brick") --create empty array
		tile = world.tiles[i.."-"..worldsize] --makes it easier to call
		tile.walkable = false
		tile.collision = true
	end

	for i=1,worldsize do --left column of brick
		world.tiles["1-"..i] = newTile("tile_brick") --create empty array
		tile = world.tiles["1-"..i] --makes it easier to call
		tile.walkable = false
		tile.collision = true
	end

	for i=1,worldsize do --right column of brick
		world.tiles[worldsize.."-"..i] = newTile("tile_brick") --create empty array
		tile = world.tiles[worldsize.."-"..i] --makes it easier to call
		tile.walkable = false
		tile.collision = true
	end

	world.objects["null"] = 1
end

function saveWorld()
	os.execute("mkdir "..mya_getPath().."/worlds/"..world_id)
	saveTable(mya_getPath().."/worlds/"..world_id.."/world.world", world)
end

function loadWorld()
	world = loadTable(mya_getPath().."/worlds/"..world_id.."/world.world")
end