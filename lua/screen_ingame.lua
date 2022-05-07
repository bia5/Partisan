screen = newChild(0, 0, 1920, 1080)

tileSize_ = 16
local offsetX = 0
local offsetY = 0
sprite_player = Sprite.new(assets:getTexture("empty"))
sprite_tile = Sprite.new(assets:getTexture("empty"))
sprite_entity = Sprite.new(assets:getTexture("empty"))

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

function scr_ingame_tupdate()
    if getPlayer(getPlayerID()) then
		message(NET_MSG_UPDATEPLAYER,{player = getPlayer(getPlayerID())})
	end
	if tablelength(clients_simplified) ~= tablelength(world.players) then
		print("Player count mismatch")
		message(NET_MSG_SENDPLAYER, {})
	end
end
screen.onTUpdate = scr_ingame_tupdate

function scr_ingame_update()
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

    if getPlayer(getPlayerID()) ~= nil then
		offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)-tileSize/2
		offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)-tileSize/2
	end
end
screen.onUpdate = scr_ingame_update

function scr_ingame_render()
    tileSize = mya_getHeight()/tileSize_

    --Get render distance for tiles
	renderDistH = tileSize_
	renderDistV = tileSize_/2
	
	if getPlayer(getPlayerID()) ~= nil then
		x = math.floor(getPlayer(getPlayerID()).x+.5)
		y = math.floor(getPlayer(getPlayerID()).y+.5)

		--Render Tiles
		for ii = y-renderDistV, y+renderDistV do
			for i = x-renderDistH, x+renderDistH do
				tiles = getTile(i,ii)
				if tiles ~= nil then
					for k,tile in pairs(tiles) do
						sprite_tile:setTexture(assets:getTexture(tile.tex))
						sprite_tile:setX((i*tileSize)+offsetX)
						sprite_tile:setY((ii*tileSize)+offsetY)
						sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
					end
				end
			end
		end
	end

	--Render Players
	for k, v in spairs(world.players, function(t, a, b) return t[a].y+t[a].h < t[b].y+t[b].h end) do
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
end
screen.onRender = scr_ingame_render

addScreen(STATE_INGAME, screen)