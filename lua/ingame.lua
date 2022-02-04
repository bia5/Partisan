local tileSize_ = 8
local tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

sprite_tile = Sprite.new(assets:getTexture("empty"))

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

function screen_ig_update()
	mya_deltaUpdate()

	local ammt = 1
	for k, v in pairs(world.players) do
		if v.isOnline then
			local speed = v.speed*(mya_getDelta()/1000)
			
			if v.w then v.y = v.y - speed end
			if v.s then v.y = v.y + speed end
			if v.a then v.x = v.x - speed end
			if v.d then v.x = v.x + speed end

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
	renderDistH = 8
	renderDistV = 4
	
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
					sprite_tile:render(mya_getRenderer(), tileSize, tileSize)
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
					sprite_tile:render(mya_getRenderer(), tileSize, tileSize)
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

	--Render Debug
	screen_ig_debug:render(mya_getRenderer())
end