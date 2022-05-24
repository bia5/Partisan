--TODO: Entity cleaner

--World version to help with debugging
world_standard = "0.0.1"

--creates an empty box world based on world size input
function newWorld()
	world = {}
	world.isLinked = false
	world.version = world_standard

	--Remove eventually
	world.spawn1X = 0
	world.spawn1Y = 0
	world.spawn2X = 0
	world.spawn2Y = 0

	world.tiles = {}

	world.entityIDs = 1
	world.entities = {}

	world.players = {}
end
newWorld()

--Converts world to a string
function worldToString()
	--variables
	local splitter0 = "|"
	local splitter1 = "="
	local splitter2 = ","
	local splitter3 = "&"
	local splitter4 = "["
	local str = ""
	
	--world details
	str = str.."v="..world.version..splitter0
	
	--tiles
	str = str.."t"..splitter1
	for k,v in pairs(world.tiles) do
		for k2,v2 in pairs(v) do
			for k3,v3 in pairs(v2) do
				tile = getTile(k, k2, k3)
				if tile ~= nil then
					str = str..k..splitter4..k2..splitter4..k3..splitter3..tileToString(tile)..splitter2
				end
			end
		end
	end
	str = str..splitter0

	return str
end

--Converts a string to world
function stringToWorld(str)
	newWorld()
	local splitter0 = "|"
	local splitter1 = "="
	local splitter2 = ","
	local splitter3 = "&"
	local splitter4 = "["
	local inputs = mysplit(str, splitter0)

	for k, v in pairs(inputs) do
		local inputs2 = mysplit(v, splitter1)
		if inputs2[1] == "v" then
			world.version = inputs2[2]
		elseif inputs2[1] == "t" then
			if inputs2[2] ~= nil then
				local inputs3 = mysplit(inputs2[2], splitter2)
				for k2, v2 in pairs(inputs3) do
					local inputs4 = mysplit(v2, splitter3)
					local inputs5 = mysplit(inputs4[1], splitter4)
					setTile(tonumber(inputs5[1]),tonumber(inputs5[2]),tonumber(inputs5[3]),stringToTile(inputs4[2]))
				end
			end
		end
	end
end

--Saves the world to a file
function saveWorld()
	if not fileHandler:dirExists("worlds") then
		fileHandler:createDir(mya_getPath().."worlds")
	end
	if not fileHandler:dirExists("worlds/"..world_id) then
		fileHandler:createDir(mya_getPath().."worlds/"..world_id)
	end
	if not fileHandler:fileExists(mya_getPath().."/worlds/"..world_id.."/world.lua") then
		fileHandler:createFile(mya_getPath().."/worlds/"..world_id.."/world.partisan")
	end
	saveString(mya_getPath().."/worlds/"..world_id.."/world.partisan", worldToString())
	print("Saved world: "..world_id)
end

--Loads the world from a file
function loadWorld()
	if fileHandler:fileExists(mya_getPath().."/worlds/"..world_id.."/world.partisan") then
		stringToWorld(loadString(mya_getPath().."/worlds/"..world_id.."/world.partisan"))
		print("World loaded: "..world_id)
	else
		print("File doesn't exist")
	end
end

function setTile(x, y, layer, tile)
	if world.tiles[x] == nil then
		world.tiles[x] = {}
	end
	if world.tiles[x][y] == nil then
		world.tiles[x][y] = {}
	end
	world.tiles[x][y][layer] = tile
end

function getTile(x, y, layer)
	if world.tiles[x] == nil then
		return nil
	end
	if world.tiles[x][y] == nil then
		return nil
	end
	if layer == nil then
		return world.tiles[x][y]
	end
	return world.tiles[x][y][layer]
end

--Gets if x,y is colliding with any tile or object and returns the tile
function isTileCollision(x,y,entityCheck)
	noTile = true

	tiles = getTile(math.floor(x), math.floor(y))
	if tiles ~= nil then
		for k,v in pairs(tiles) do
			if v ~= nil then
				noTile = false
				if not v.walkable then
					return v
				end
			end
		end
	end

	if entityCheck then
		for k,entity in pairs(world.entities) do
			if entity ~= nil then
				if x > entity.x-(entity.w/2)+(entity.w/4) and x < entity.x+(entity.w/2)-(entity.w/4) and y>entity.y-(entity.w/2) and y<entity.y then
					return entity
				end
			end
		end
		for k,entity in pairs(world.players) do
			if entity ~= nil then
				if x > entity.x-(entity.w/2)+(entity.w/4) and x < entity.x+(entity.w/2)-(entity.w/4) and y>entity.y-(entity.w/2) and y<entity.y then
					return entity
				end
			end
		end
	end

	if noTile then
		return true
	end

	return false
end

--Entity collision detection with tile
function isEntityCollision(entity,offX,offY,entityCheck)
	if entityCheck == nil then
		entityCheck = true
	end
	local x = entity.x+offX
	local y = entity.y+offY
	local w = entity.w
	local h = entity.h

	e = isTileCollision(x-(w/2)+(w/8),y,entityCheck)
	if e then
		return e
	end
	e = isTileCollision(x-(w/2)+(w/8),y-(w/2),entityCheck)
	if e then
		return e
	end
	e = isTileCollision(x+(w/2)-(w/8),y,entityCheck)
	if e then
		return e
	end
	e = isTileCollision(x+(w/2)-(w/8),y-(w/2),entityCheck)
	if e then
		return e
	end
	return false
end

--Easily adds an entity to the world
function entity_add(entity)
	entity.spawnID = world.entityIDs
	world.entities[world.entityIDs] = entity
	world.entityIDs = world.entityIDs+1

	return world.entityIDs-1
end

--World updater
function updateWorld()
	for k,v in pairs(world.players) do
		exeEntityFunction(v.onUpdate,v)
	end

	for k,v in pairs(world.entities) do
		exeEntityFunction(v.onUpdate,v)
	end

	for k,v in pairs(world.tiles) do
		for k2,v2 in pairs(v) do
			for k3,v3 in pairs(v2) do
				exeTileFunction(v3.onUpdate,v3)
			end
		end
	end
end

function tUpdateWorld()
	for k,v in pairs(world.players) do
		exeEntityFunction(v.onTUpdate,v)
	end

	for k,v in pairs(world.entities) do
		exeEntityFunction(v.onTUpdate,v)
	end

	for k,v in pairs(world.tiles) do
		for k2,v2 in pairs(v) do
			for k3,v3 in pairs(v2) do
				exeTileFunction(v3.onTUpdate,v3)
			end
		end
	end
end