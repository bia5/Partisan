local tileSize_ = 8
local tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

local sprite_players = {}
for i=1,4 do
	sprite_players[i] = Sprite.new(assets:getTexture("screen_button_back"))
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
	message("w",{getPlayerID(),isPressed})
	getPlayer(getPlayerID()).w = isPressed
end
function player_down(isPressed) 
	message("s",{getPlayerID(),isPressed})
	getPlayer(getPlayerID()).s = isPressed
end
function player_left(isPressed) 
	message("a",{getPlayerID(),isPressed})
	getPlayer(getPlayerID()).a = isPressed
end
function player_right(isPressed) 
	message("d",{getPlayerID(),isPressed})
	getPlayer(getPlayerID()).d = isPressed
end

function screen_ig_tupdate()
	if not isHosting then
		message("player",{getPlayerID(), getPlayer(getPlayerID()).x, getPlayer(getPlayerID()).y})
	end
end

function screen_ig_update()
	mya_deltaUpdate()

	local ammt = 1
	for k, v in pairs(world.players) do
		local speed = v.speed*(mya_getDelta()/1000)
		
		if v.w then v.y = v.y - speed end
		if v.s then v.y = v.y + speed end
		if v.a then v.x = v.x - speed end
		if v.d then v.x = v.x + speed end

		sprite_players[ammt]:setX((v.x*tileSize)+offsetX)
		sprite_players[ammt]:setY((v.y*tileSize)+offsetY)
		ammt=ammt+1
	end

	offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)
	offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)
	screen_ig_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(getPlayer(getPlayerID()).x)..", Y: "..tostring(getPlayer(getPlayerID()).y)..", Delta: "..mya_getDelta()/1000, mya_getRenderer())
end

function screen_ig_render()
	local ammt = 1
	for k, v in pairs(world.players) do
		sprite_players[ammt]:render(mya_getRenderer(), tileSize, tileSize)
		ammt=ammt+1
	end

	screen_ig_debug:render(mya_getRenderer())
end