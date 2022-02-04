--TODO
--redo tile generation

world = {} --In display order :D
world.isLinked = false

world.undertiles = {}
world.tiles = {}
world.objects = {}

world.enemies = {}
world.enemyCount = 0
world.players = {}

--Per client variables
world.bullets = {}

function spawnEnemy(id,x,y,hp,speed,size)
	if not isHosting then
		world.enemies[id.spawnerID] = id
	else
		enemy = {}
		enemy.id = id
		enemy.x = x
		enemy.y = y
		enemy.sx = x
		enemy.sy = y
		enemy.hp = hp
		enemy.maxhp = hp
		enemy.speed = speed
		enemy.size = size
		enemy.spawnerID = world.enemyCount
		world.enemyCount=world.enemyCount+1

		world.enemies[enemy.spawnerID] = enemy
		server_message("enemy",enemy)
	end
end

function updateEnemies()
	for k,v in pairs(world.enemies) do
		local speed = v.speed*(mya_getDelta()/1000)
		gotoX = v.sx - v.x
		gotoY = v.sy - v.y

		if isHosting then
			sendUpdate = false
			if -1<gotoX and gotoX<1 then
				v.sx = (math.random()*14)+1
				sendUpdate = true
			end
			if -1<gotoY and gotoY<1 then
				v.sy = (math.random()*14)+1
				sendUpdate = true
			end
			if sendUpdate then
				enemy_update = {}
				enemy_update.id = k
				enemy_update.sx = v.sx
				enemy_update.sy = v.sy
				server_message("enemy_loc",enemy_update)
			end
		end

		if gotoX > 0 then
			v.x = v.x+speed
		else
			v.x = v.x-speed
		end

		if gotoY > 0 then
			v.y = v.y+speed
		else
			v.y = v.y-speed
		end
	end
end

--max tier lazy
function checkEnemyCollision(e, x, y)
	return isPointColliding(e.x,e.y,e.size,e.size,x,y)
end

--x can be table or number
--this is to make netcode easier
function spawnBullet(x,y,vx,vy,size,id,dmg)
	if type(x) == "table" then
		if x.id ~= getPlayerID() then
			table.insert(world.bullets, x)
		end
	else
		bullet = {}
		bullet.x = x
		bullet.y = y
		bullet.vx = vx
		bullet.vy = vy
		bullet.dmg = dmg
		bullet.id = id
		bullet.size = size
		table.insert(world.bullets, bullet)
		message("bullet",bullet)
	end
end

function updateBullets()
	for k, v in pairs(world.bullets) do
		v.x = v.x + (v.vx*(mya_getDelta()/1000))
		v.y = v.y + (v.vy*(mya_getDelta()/1000))

		--if bullet hits enemy
		for kk,vv in pairs(world.enemies) do
			if checkEnemyCollision(vv,v.x+(v.size/2), v.y+(v.size/2)) then
				if v.id == getPlayerID() then
					enemy_update = {}
					enemy_update.id = kk
					enemy_update.hp = v.dmg
					message("enemy_dmg",enemy_update)
				end
				world.bullets[k] = nil
			end
		end

		--if bullet hits wall destroy
		if isLocationCollision(v.x+(v.size/2), v.y+(v.size/2)) then
			world.bullets[k] = nil
		end
	end
end

function newTile(id)
	tile = {}
	tile.id = id
	tile.walkable = true
	return tile
end

function isLocationWalkable(x,y)
	x = math.floor(x)
	y = math.floor(y)
	walkable = true
	if world.undertiles[x.."-"..y] then
		if not world.undertiles[x.."-"..y].walkable then
			walkable = false
		end
	end
	if world.tiles[x.."-"..y] then
		if not world.tiles[x.."-"..y].walkable then
			walkable = false
		end
	end

	return walkable
end

function isLocationCollision(x,y)
	x = math.floor(x)
	y = math.floor(y)
	collision = true
	if world.tiles[x.."-"..y] then
		if world.tiles[x.."-"..y].collision then
			return true
		end
	end

	return false
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