tileSize_ = 16
tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

sprite_tile = Sprite.new(assets:getTexture("empty"))

spr_bullet = Sprite.new(assets:getTexture("tile_brick"))

spr_boss = Sprite.new(assets:getTexture("empty"))

eff_swipe = Animation.new("effect_sword_", 5, 20, assets)

local sprite_players = {}
for i=1,4 do
	sprite_players[i] = Sprite.new(assets:getTexture("entity_ninja_0"))
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

shoot = false
skip = 0
mSkip = 10
function screen_ig_tupdate()
	if shoot then
		skip = skip+1
		vx = (mouseX - (mya_getWidth()/2))
		vy = (mouseY - (mya_getHeight()/2))
		rad = math.atan2(vy, vx)
		velX = math.cos(rad) * 10
		velY = math.sin(rad) * 10
		if getPlayer(getPlayerID()) ~= nil then
			bx = getPlayer(getPlayerID()).x+.5
			by = getPlayer(getPlayerID()).y+.5
			if skip > mSkip then
				skip = 0
				entity_add(spawnBullet(bx, by, velX, velY, .25, 1, 5, "entity_arrow_0", radToDeg(rad)+90))
			end
		end
	end

	if not isHosting then
		if getPlayer(getPlayerID()) ~= nil then
			message("player",{getPlayerID(), getPlayer(getPlayerID()).x, getPlayer(getPlayerID()).y})
		end
	end
end

function screen_ig_mouseButtonDown(btn)
	shoot = true
end

function screen_ig_mouseButtonUp(btn)
	shoot = false
end

function screen_ig_update()
	mya_deltaUpdate()
	updateWorld()

	local ammt = 1
	for k, v in pairs(world.players) do
		if v.isOnline then
			local speed = v.speed*(mya_getDelta()/1000)
			
			x = 0
			y = 0

			if v.w then 
				y=y-1
			end
			if v.s then 
				y=y+1
			end
			if v.a then 
				x=x-1
			end
			if v.d then 
				x=x+1
			end

			if x ~= 0 or y ~= 0 then
				rad = math.atan2(y, x)
				v.x = v.x + (math.cos(rad) * speed)
				v.y = v.y + (math.sin(rad) * speed)
			end

			sprite_players[ammt]:setX((v.x*tileSize)+offsetX)
			sprite_players[ammt]:setY((v.y*tileSize)+offsetY)
			ammt=ammt+1
		end
	end

	if getPlayer(getPlayerID()) ~= nil then
		offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)-tileSize/2
		offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)-tileSize/2
		screen_ig_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(math.floor(getPlayer(getPlayerID()).x*100)/100)..", Y: "..tostring(math.floor(getPlayer(getPlayerID()).y*100)/100)..", Delta: "..(mya_getDelta()/1000)..", Zoom: "..tileSize_, mya_getRenderer())
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
					sprite_tile:setTexture(assets:getTexture(tile.tex))
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
					sprite_tile:setTexture(assets:getTexture(tile.tex))
					sprite_tile:setX((i*tileSize)+offsetX)
					sprite_tile:setY((ii*tileSize)+offsetY)
					sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
				end
			end
		end
	end

	--Render Objects
	for k, v in pairs(world.objects) do
		if type(v) == "table" then
			if v.x >= x-renderDistH-1 and v.x <= x+renderDistH+1 and v.y >= y-renderDistV-1 and v.y <= y+renderDistV+1 then
				sprite_tile:setTexture(assets:getTexture(v.tex))
				sprite_tile:setX((v.x*tileSize)+offsetX)
				sprite_tile:setY((v.y*tileSize)+offsetY)
				sprite_tile:render(mya_getRenderer(), v.w*tileSize, v.h*tileSize)
			end
		end
	end

	--Render Players
	local ammt = 1
	for k, v in pairs(world.players) do
		if v.isOnline then
			sprite_players[ammt]:render(mya_getRenderer(), tileSize, tileSize)
			ammt=ammt+1
			eff_swipe:setX((v.x*tileSize)+offsetX-(tileSize/2))
			eff_swipe:setY((v.y*tileSize)+offsetY-(tileSize/2))
			eff_swipe:renderFlip(mya_getRenderer(), tileSize*2, tileSize*2, 0, false)
		end
	end

	--Render Entities
	for k, v in pairs(world.entities) do
		spr_boss:setTexture(assets:getTexture(v.tex))
		spr_boss:setX((v.x*tileSize)+offsetX)
		spr_boss:setY((v.y*tileSize)+offsetY)
		spr_boss:renderFlip(mya_getRenderer(), tileSize*v.w, tileSize*v.h,v.deg,false)
	end

	--Render Debug
	screen_ig_debug:render(mya_getRenderer())
end