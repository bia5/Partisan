local tileSize_ = 8
local tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

local sprite_players = {}
for i=1,4 do
	sprite_players[i] = Sprite.new(assets:getTexture("screen_button_back"))
end

function screen_ig_windowResize(w, h)
	tileSize = mya_getHeight()/tileSize_
end
screen_ig_windowResize(mya_getWidth(), mya_getHeight())

function player_up(isPressed) 
	message("w",{isPressed})
	getPlayer(getPlayerID()).w = isPressed
end
function player_down(isPressed) 
	message("s",{isPressed})
	getPlayer(getPlayerID()).s = isPressed
end
function player_left(isPressed) 
	message("a",{isPressed})
	getPlayer(getPlayerID()).a = isPressed
end
function player_right(isPressed) 
	message("d",{isPressed})
	getPlayer(getPlayerID()).d = isPressed
end

function screen_ig_tupdate()
	
end

function screen_ig_update()
	mya_deltaUpdate()
	offsetX = (mya_getWidth()/2)-(getPlayer(getPlayerID()).x*tileSize)
	offsetY = (mya_getHeight()/2)-(getPlayer(getPlayerID()).y*tileSize)

	local ammt = 1
	for k, v in pairs(world.players) do
		local speed = (v.speed/mya_getUPS())*mya_getDelta()
		local amt = 0
		if v.w then amt = amt + 1 end
		if v.s then amt = amt + 1 end
		if v.a then amt = amt + 1 end
		if v.d then amt = amt + 1 end
		if amt > 1 then speed = speed / 2 end
		if v.w then v.y = v.y - speed end
		if v.s then v.y = v.y + speed end
		if v.a then v.x = v.x - speed end
		if v.d then v.x = v.x + speed end

		sprite_players[ammt]:setX((v.x*tileSize)+offsetX)
		sprite_players[ammt]:setY((v.y*tileSize)+offsetY)
		ammt=ammt+1
	end
end

function screen_ig_render()
	local ammt = 1
	for k, v in pairs(world.players) do
		sprite_players[ammt]:render(mya_getRenderer(), tileSize, tileSize)
		ammt=ammt+1
	end
end