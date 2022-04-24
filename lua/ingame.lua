--Tile Size Variable (Determines the size of everything)
tileSize_ = 16
tileSize = mya_getHeight()/tileSize_

--Offset variables, moves based on the camera
local offsetX = 0
local offsetY = 0

--Various Sprites
sprite_player = Sprite.new(assets:getTexture("empty"))
sprite_tile = Sprite.new(assets:getTexture("empty"))
sprite_entity = Sprite.new(assets:getTexture("empty"))

--Debug stats
local screen_ig_debug = TextView.new(font[32], "Debug", 0, 0, mya_getRenderer())

function screen_ig_windowResize(w, h)
	tileSize = mya_getHeight()/tileSize_

	screen_ig_debug:setFont(font[32], mya_getRenderer())
end
screen_ig_windowResize(mya_getWidth(), mya_getHeight())

--Player movement functions
--I want this to become player based
function player_up(isPressed)
	if state == STATE_INGAME then
		message("w",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_w = isPressed
		end
	end
end
function player_down(isPressed) 
	if state == STATE_INGAME then
		message("s",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_s = isPressed
		end
	end
end
function player_left(isPressed) 
	if state == STATE_INGAME then
		message("a",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_a = isPressed
		end
	end
end
function player_right(isPressed) 
	if state == STATE_INGAME then
		message("d",{getPlayerID(),isPressed})
		if getPlayer(getPlayerID()) ~= nil then
			getPlayer(getPlayerID()).key_d = isPressed
		end
	end
end

--Player Attack Functions
--I want this to become player based
shoot = false
skip = 0
mSkip = 10
function screen_ig_tupdate()
	--Update the player's netcode
	message(NET_MSG_UPDATEPLAYER,{player = getPlayer(getPlayerID())})
end

function screen_ig_mouseButtonDown(btn)
end

function screen_ig_mouseButtonUp(btn)
end

function screen_ig_update()
	mya_deltaUpdate()
	updateWorld()

	--Update Player
	--Once again, move to player based
	for k, v in pairs(world.players) do
		local speed = v.speed*(mya_getDelta()/1000)
			
		x = 0
		y = 0

		if v.key_w then 
			if not isEntityCollision(v, 0, -speed) then
				y=y-1
				v.deg = 270
			end
		end
		if v.key_s then
			if not isEntityCollision(v, 0, speed) then
				y=y+1
				v.deg = 0
			end
		end
		if v.key_a then 
			if not isEntityCollision(v, -speed, 0) then
				x=x-1
				v.deg = 180
			end
		end
		if v.key_d then 
			if not isEntityCollision(v, speed, 0) then
				x=x+1
				v.deg = 90
			end
		end

		if x ~= 0 or y ~= 0 then
			rad = math.atan2(y, x)
			v.x = v.x + (math.cos(rad) * speed)
			v.y = v.y + (math.sin(rad) * speed)
		end
	end

	--Update offset based on main player
	if getPlayer(getPlayerID()) ~= nil then
		offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)-tileSize/2
		offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)-tileSize/2
		screen_ig_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(math.floor(getPlayer(getPlayerID()).x*100)/100)..", Y: "..tostring(math.floor(getPlayer(getPlayerID()).y*100)/100)..", Delta: "..(mya_getDelta()/1000)..", Zoom: "..tileSize_..", bps: "..network:getTotalBitsSent()..", tbps: "..network:getTimedBitsSent(), mya_getRenderer())
	end
end

function screen_ig_render()
	--Get render distance for tiles
	renderDistH = tileSize_
	renderDistV = tileSize_/2
	
	if getPlayer(getPlayerID()) ~= nil then
		x = math.floor(getPlayer(getPlayerID()).x+.5)
		y = math.floor(getPlayer(getPlayerID()).y+.5)

		--Render Tiles
		for ii = y-renderDistV, y+renderDistV do
			for i = x-renderDistH, x+renderDistH do
				tile = world.undertiles[i.."-"..ii]
				if tile ~= nil then
					if tile.onRender ~= "nil" then
						exeTileFunction(tile.onRender, tile)
					else
						sprite_tile:setTexture(assets:getTexture(tile.tex))
						sprite_tile:setX((i*tileSize)+offsetX)
						sprite_tile:setY((ii*tileSize)+offsetY)
						sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
					end
				end

				tile = world.tiles[i.."-"..ii]
				if tile ~= nil then
					if tile.onRender ~= "nil" then
						exeTileFunction(tile.onRender, tile)
					else
						sprite_tile:setTexture(assets:getTexture(tile.tex))
						sprite_tile:setX((i*tileSize)+offsetX)
						sprite_tile:setY((ii*tileSize)+offsetY)
						sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
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
					sprite_tile:render(mya_getRenderer(), v.w*tileSize, v.h*tileSize,v.deg, false)
				end
			end
		end
	end

	--Render Players
	for k, v in pairs(world.players) do
		if v ~= nil then
			if v.number ~= nil then
				sprite_player:setTexture(assets:getTexture("player"..v.number.."_"..v.deg.."_0"))
				sprite_player:setX((v.x*tileSize)+offsetX)
				sprite_player:setY((v.y*tileSize)+offsetY)
				sprite_player:render(mya_getRenderer(), tileSize, tileSize)
			end
		end
	end

	--Render Entities
	for k, v in pairs(world.entities) do
		sprite_entity:setTexture(assets:getTexture(v.tex))
		sprite_entity:setX((v.x*tileSize)+offsetX)
		sprite_entity:setY((v.y*tileSize)+offsetY)
		sprite_entity:renderFlip(mya_getRenderer(), tileSize*v.w, tileSize*v.h,v.deg,false)
	end

	--Render Debug
	if devmode then
		screen_ig_debug:render(mya_getRenderer())
	end
end