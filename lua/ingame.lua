local tileSize_ = 16
local tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

sprite_tile = Sprite.new(assets:getTexture("empty"))

spr_bullet = Sprite.new(assets:getTexture("tile_brick"))

spr_boss = Sprite.new(assets:getTexture("empty"))

local sprite_players = {}
for i=1,4 do
	sprite_players[i] = Sprite.new(assets:getTexture("empty"))
	if i == 1 then
	sprite_players[i]:setRenderOutline(true)
	sprite_players[i]:setOutlineColor(255, 0, 0, 128)
	elseif i == 2 then
	sprite_players[i]:setRenderOutline(true)
	sprite_players[i]:setOutlineColor(0, 255, 0, 128)
	elseif i == 3 then
	sprite_players[i]:setRenderOutline(true)
	sprite_players[i]:setOutlineColor(0, 0, 255, 128)
	elseif i == 4 then
	sprite_players[i]:setRenderOutline(true)
	sprite_players[i]:setOutlineColor(0, 0, 0, 128)
	end
end

local screen_ig_debug = TextView.new(font[32], "Debug", 0, 0, mya_getRenderer())

function screen_ig_windowResize(w, h)
	tileSize = mya_getHeight()/tileSize_

	screen_ig_debug:setFont(font[32], mya_getRenderer())
end
screen_ig_windowResize(mya_getWidth(), mya_getHeight())

function player_up(isPressed)
	if state == STATE_INGAME then
		message("w",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).w = isPressed
		end
	end
end
function player_down(isPressed) 
	if state == STATE_INGAME then
		message("s",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).s = isPressed
		end
	end
end
function player_left(isPressed) 
	if state == STATE_INGAME then
		message("a",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).a = isPressed
		end
	end
end
function player_right(isPressed) 
	if state == STATE_INGAME then
		message("d",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).d = isPressed
		end
	end
end

function screen_ig_tupdate()
	if not isHosting then
		if getPlayer(getPlayerID()) ~= nil then
			message("player",{getPlayerID(), getPlayer(getPlayerID()).x, getPlayer(getPlayerID()).y})
		end
	end
end

function screen_ig_mouseButtonUp(btn)
	vx = (mouseX - (mya_getWidth()/2))/30
	vy = (mouseY - (mya_getHeight()/2))/30
	if getPlayer(getPlayerID()) ~= nil then
		bx = getPlayer(getPlayerID()).x+.5
		by = getPlayer(getPlayerID()).y+.5
		spawnBullet(bx,by,vx,vy,0.2,getPlayerID(),10)
	end
end

function spawnBoss(e)
	if isHosting then
		if not e then
			spawnEnemy("enemy_boss",8,8,100,1.5,2.5,getPlayerID())
		end
	end
end

function screen_ig_update()
	mya_deltaUpdate()
	updateEnemies()
	updateBullets()

	local ammt = 1
	for k, v in pairs(world.players) do
		if v.isOnline then
			local speed = v.speed*(mya_getDelta()/1000)
			
			if v.w then 
				if isLocationWalkable(v.x, v.y - speed) then
					v.y = v.y - speed 
				end
			end
			if v.s then 
				if isLocationWalkable(v.x, v.y + 1 + speed) then
					v.y = v.y + speed 
				end
			end
			if v.a then 
				if isLocationWalkable(v.x - speed, v.y) then
					v.x = v.x - speed 
				end
			end
			if v.d then 
				if isLocationWalkable(v.x + 1 + speed, v.y) then
					v.x = v.x + speed
				end
			end

			sprite_players[ammt]:setX((v.x*tileSize)+offsetX)
			sprite_players[ammt]:setY((v.y*tileSize)+offsetY)
			ammt=ammt+1
		end
	end

	if getPlayer(getPlayerID()) ~= nil then
		offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)-tileSize/2
		offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)-tileSize/2
		screen_ig_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(math.floor(getPlayer(getPlayerID()).x*100)/100)..", Y: "..tostring(math.floor(getPlayer(getPlayerID()).y*100)/100)..", Delta: "..mya_getDelta()/1000, mya_getRenderer())
	end
end

function screen_ig_render()
	renderDistH = tileSize_
	renderDistV = tileSize_/2
	
	if getPlayer(getPlayerID()) ~= nil then
		x = math.floor(getPlayer(getPlayerID()).x+.5)
		y = math.floor(getPlayer(getPlayerID()).y+.5)

		--Render Undertiles
		for ii = y-renderDistV, y+renderDistV do
			for i = x-renderDistH, x+renderDistH do
				tile = world.undertiles[i.."-"..ii]
				if tile ~= nil then
					sprite_tile:setTexture(assets:getTexture(tile.id))
					sprite_tile:setX((i*tileSize)+offsetX)
					sprite_tile:setY((ii*tileSize)+offsetY)
					sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
				end
			end
		end

		--Render Tiles
		for ii = y-renderDistV, y+renderDistV do
			for i = x-renderDistH, x+renderDistH do
				tile = world.tiles[i.."-"..ii]
				if tile ~= nil then
					sprite_tile:setTexture(assets:getTexture(tile.id))
					sprite_tile:setX((i*tileSize)+offsetX)
					sprite_tile:setY((ii*tileSize)+offsetY)
					sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
				end
			end
		end
	end

	--Render Players
	local ammt = 1
	for k, v in pairs(world.players) do
		if v.isOnline then
			sprite_players[ammt]:render(mya_getRenderer(), tileSize, tileSize)
			ammt=ammt+1
		end
	end

	--Render Enemies
	for k, v in pairs(world.enemies) do
		spr_boss:setTexture(assets:getTexture(v.id))
		spr_boss:setX((v.x*tileSize)+offsetX)
		spr_boss:setY((v.y*tileSize)+offsetY)
		spr_boss:render(mya_getRenderer(), tileSize*v.size, tileSize*v.size)
	end

	--Render Debug
	screen_ig_debug:render(mya_getRenderer())

	for k, v in pairs(world.bullets) do
		spr_bullet:setX((v.x*tileSize)+offsetX)
		spr_bullet:setY((v.y*tileSize)+offsetY)
		spr_bullet:render(mya_getRenderer(), tileSize*v.size, tileSize*v.size)
	end
end