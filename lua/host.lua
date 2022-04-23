local selected_level = "world_partisan_1" --selected world level

local ho_clients = {}
local _x = mya_getWidth()/20
local _y = mya_getHeight()/20
local _h = mya_getHeight()/20
function ho_newClient()
	local client = {}
	client[1] = TextView.new(font[48], "name (ping)", _x, _y, mya_getRenderer())
	_y = _y + _h
	client[2] = TextView.new(font[48], "id", _x, _y, mya_getRenderer())
	_y = _y + _h
	return client
end
for i=1,net_max do
	ho_clients[i] = ho_newClient()
end


local screen_ho_playerBkg = Sprite.new(assets:getTexture("empty"))

local screen_ho_bkg = Sprite.new(assets:getTexture("art_tree"))
screen_ho_bkg:setX(0)
screen_ho_bkg:setY(0)

local screen_ho_play = Sprite.new(assets:getTexture("button_play"))
screen_ho_play:setRenderOutline(true)
screen_ho_play:setOutlineColor(0, 0, 0, 128)

function screen_ho_windowResize(w, h) 
	screen_ho_play:setX((mya_getWidth()/2)-(mya_getWidth()/16))
	screen_ho_play:setY(mya_getHeight()/16*13)
end
screen_ho_windowResize(mya_getWidth(), mya_getHeight())

function screen_ho_render()
	screen_ho_bkg:render(mya_getRenderer(), mya_getWidth(), mya_getHeight())
	
	--Render Clients
	local loc = 1
	for k, v in pairs(clients_simplified) do
		if ho_clients[loc] ~= nil then
			ho_clients[loc][1]:setText(v.name.." ("..v.ping.."ms)", mya_getRenderer())
			ho_clients[loc][1]:render(mya_getRenderer())
			ho_clients[loc][2]:setText(v.id, mya_getRenderer())
			ho_clients[loc][2]:render(mya_getRenderer())
		end
		loc = loc + 1
	end

	if isHosting then
		screen_ho_play:render(mya_getRenderer(), mya_getWidth()/8, mya_getHeight()/6)
	end
end

function screen_ho_mouseButtonUp(btn) 
	if btn == "left" then
		if isHosting then
			if screen_ho_play:isPointColliding(mouseX, mouseY) then
				--Make players load level
				server_message(NET_MSG_LOADLEVEL,{world_id = selected_level})

				--Create players
				for k, v in pairs(clients) do
					if v.ip == "host" then
						server_message(NET_MSG_PLAYER,{player = newPlayer(v.id, v.name, world.spawn1X, world.spawn1Y)})
					else
						server_message(NET_MSG_PLAYER,{player = newPlayer(v.id, v.name, world.spawn2X, world.spawn2Y)})
					end
				end

				--Switch clients screen to in game
				server_message(NET_MSG_SWITCHSCREEN, {state = STATE_INGAME})
			end
		end
	end
end