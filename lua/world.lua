world_standard = "0.0.1"
function newWorld() --creates an empty box world based on world size input
	world = {} --In display order :D
	world.isLinked = false
	world.version = world_standard

	world.spawnX = 0
	world.spawnY = 0

	world.undertiles = {}
	world.tiles = {}
	world.objectIDs = 1
	world.objects = {}

	world.entityIDs = 1
	world.entities = {}

	world.players = {}
end
newWorld()

function worldToString()
	--variables
	local splitter0 = "|"
	local splitter1 = "="
	local splitter2 = ","
	local splitter3 = "&"
	local str = ""
	
	--world details
	str = str.."v="..world.version..splitter0
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

	--enemies	--TODO: update enemy
	str = str.."e"..splitter1
	for k,v in pairs(world.entities) do
		
	end
	str = str..splitter0

	--players	--TODO: update player
	str = str.."p"..splitter1
	for k,v in pairs(world.players) do
		
	end
	str = str..splitter0

	return str
end

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
		elseif inputs2[1] == "e" then
		elseif inputs2[1] == "p" then
		end
	end
end

function addObject(x,y,w,h,tile)
	local newTile = newTile(tile.id)
	newTile.x = math.floor(x*100)/100
	newTile.y = math.floor(y*100)/100
	newTile.w = w
	newTile.h = h
	world.objects[world.objectIDs] = newTile
	world.objectIDs = world.objectIDs+1
end

function getObjectsColliding(x,y)
	objects_ = {}
	for k,v in pairs(world.objects) do
		if isPointColliding(v.x,v.y,v.w,v.h,x,y) then
			table.insert(objects_,k)
		end
	end
	return objects_
end

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

function loadWorld()
	if fileHandler:fileExists(mya_getPath().."/worlds/"..world_id.."/world.partisan") then
		stringToWorld(loadString(mya_getPath().."/worlds/"..world_id.."/world.partisan"))
		print("World loaded: "..world_id)
	else
		print("File doesn't exist")
	end
end

function isTileCollision(x,y)
	--under
	local tile = world.undertiles[math.floor(x).."-"..math.floor(y)]
	if tile ~= nil then
		if not tile.walkable then
			return tile
		end
	end

	--tiles
	tile = world.tiles[math.floor(x).."-"..math.floor(y)]
	if tile ~= nil then
		if not tile.walkable then
			return tile
		end
	end

	--objects
	for k,v in pairs(world.objects) do
		if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
			if not v.walkable then
				return v
			end
		end
	end

	return false
end

function entity_add(entity)
	entity.spawnID = world.entityIDs
	world.entities[world.entityIDs] = entity
	world.entityIDs = world.entityIDs+1
end

function updateWorld()
	for k,v in pairs(world.entities) do
		exeEntityFunction(v.onUpdate,v)
	end
end