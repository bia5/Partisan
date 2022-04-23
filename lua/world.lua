--TODO: Entity cleaner

--World version to help with debugging
world_standard = "0.0.1"

--creates an empty box world based on world size input
function newWorld()
	world = {}
	world.isLinked = false
	world.version = world_standard

	world.spawn1X = 0
	world.spawn1Y = 0
	world.spawn2X = 0
	world.spawn2Y = 0

	world.undertiles = {}
	world.tiles = {}
	world.objectIDs = 1
	world.objects = {}

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
	local str = ""
	
	--world details
	str = str.."v="..world.version..splitter0
	str = str.."s1x="..world.spawn1X..splitter0
	str = str.."s1y="..world.spawn1Y..splitter0
	str = str.."s2x="..world.spawn2X..splitter0
	str = str.."s2y="..world.spawn2Y..splitter0
	str = str.."oid="..world.objectIDs..splitter0
	
	--undertiles
	str = str.."ut"..splitter1
	for k,v in pairs(world.undertiles) do
		if v ~= nil then
			str = str..k..splitter3..tileToString(v)..splitter2
		end
	end
	str = str..splitter0
	
	--tiles
	str = str.."t"..splitter1
	for k,v in pairs(world.tiles) do
		if v ~= nil then
			str = str..k..splitter3..tileToString(v)..splitter2
		end
	end
	str = str..splitter0

	--objects & id
	str = str.."o"..splitter1
	for k,v in pairs(world.objects) do
		if v ~= nil then
			str = str..k..splitter3..tileToString(v)..splitter2
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
	local inputs = mysplit(str, splitter0)

	for k, v in pairs(inputs) do
		local inputs2 = mysplit(v, splitter1)
		if inputs2[1] == "v" then
			world.version = inputs2[2]
		elseif inputs2[1] == "s1x" then
			world.spawn1X = tonumber(inputs2[2])
		elseif inputs2[1] == "s1y" then
			world.spawn1Y = tonumber(inputs2[2])
		elseif inputs2[1] == "s2x" then
			world.spawn2X = tonumber(inputs2[2])
		elseif inputs2[1] == "s2y" then
			world.spawn2Y = tonumber(inputs2[2])
		elseif inputs2[1] == "oid" then
			world.objectIDs = tonumber(inputs2[2])
		elseif inputs2[1] == "ut" then
			if inputs2[2] ~= nil then
				local inputs3 = mysplit(inputs2[2], splitter2)
				for k2, v2 in pairs(inputs3) do
					local inputs4 = mysplit(v2, splitter3)
					world.undertiles[inputs4[1]] = stringToTile(inputs4[2])
				end
			end
		elseif inputs2[1] == "t" then
			if inputs2[2] ~= nil then
				local inputs3 = mysplit(inputs2[2], splitter2)
				for k2, v2 in pairs(inputs3) do
					local inputs4 = mysplit(v2, splitter3)
					world.tiles[inputs4[1]] = stringToTile(inputs4[2])
				end
			end
		elseif inputs2[1] == "o" then
			if inputs2[2] ~= nil then
				local inputs3 = mysplit(inputs2[2], splitter2)
				for k2, v2 in pairs(inputs3) do
					local inputs4 = mysplit(v2, splitter3)
					world.objects[tonumber(inputs4[1])] = stringToTile(inputs4[2])
				end
			end
		end
	end
end

--Help to easily add an object to the world
function addObject(x,y,w,h,tile)
	local newTile = newTile(tile.id)
	newTile.x = math.floor(x*100)/100
	newTile.y = math.floor(y*100)/100
	newTile.w = w
	newTile.h = h
	world.objects[world.objectIDs] = newTile
	world.objectIDs = world.objectIDs+1
end

--Gets all the objects in a world x,y
function getObjectsColliding(x,y)
	objects_ = {}
	for k,v in pairs(world.objects) do
		if isPointColliding(v.x,v.y,v.w,v.h,x,y) then
			table.insert(objects_,k)
		end
	end
	return objects_
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

--Gets if x,y is colliding with any tile or object and returns the tile
function isTileCollision(x,y)
	noTile = true
	--under
	local tile = world.undertiles[math.floor(x).."-"..math.floor(y)]
	if tile ~= nil then
		noTile = false
		if not tile.walkable then
			return tile
		end
	end

	--tiles
	tile = world.tiles[math.floor(x).."-"..math.floor(y)]
	if tile ~= nil then
		noTile = false
		if not tile.walkable then
			return tile
		end
	end

	--objects
	for k,v in pairs(world.objects) do
		if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
			noTile = false
			if not v.walkable then
				return v
			end
		end
	end

	if noTile then
		return true
	end

	return false
end

--Entity collision detection with tile
function isEntityCollision(entity,offX,offY)
	local x = entity.x+offX
	local y = entity.y+offY
	local w = entity.w
	local h = entity.h

	if isTileCollision(x,y) then
		return true
	elseif isTileCollision(x+w,y+h) then
		return true
	elseif isTileCollision(x+w,y) then
		return true
	elseif isTileCollision(x,y+h) then
		return true
	end
	return false
end

--Easily adds an entity to the world
function entity_add(entity)
	entity.spawnID = world.entityIDs
	world.entities[world.entityIDs] = entity
	world.entityIDs = world.entityIDs+1
end

--World updater
function updateWorld()
	for k,v in pairs(world.entities) do
		exeEntityFunction(v.onUpdate,v)
	end
end