local screen_ho_clientbkg1 = Sprite.new(assets:getTexture("empty"))
screen_ho_clientbkg1:setRenderOutline(true)
screen_ho_clientbkg1:setOutlineColor(0, 0, 0, 32)
local screen_ho_clientbkg2 = Sprite.new(assets:getTexture("empty"))
screen_ho_clientbkg2:setRenderOutline(true)
screen_ho_clientbkg2:setOutlineColor(0, 0, 0, 64)
local screen_ho_clientbkg3 = Sprite.new(assets:getTexture("empty"))
screen_ho_clientbkg3:setRenderOutline(true)
screen_ho_clientbkg3:setOutlineColor(0, 0, 0, 32)
local screen_ho_clientbkg4 = Sprite.new(assets:getTexture("empty"))
screen_ho_clientbkg4:setRenderOutline(true)
screen_ho_clientbkg4:setOutlineColor(0, 0, 0, 64)

local screen_ho_bkg = Sprite.new(assets:getTexture("screen_art_tree"))
screen_ho_bkg:setX(0)
screen_ho_bkg:setY(0)

local screen_ho_play = Sprite.new(assets:getTexture("screen_mm_button_play"))
screen_ho_play:setRenderOutline(true)
screen_ho_play:setOutlineColor(0, 0, 0, 128)

local screen_ho_text_names_array = {}
local screen_ho_text_ping_array = {}
local screen_ho_btn_kick = {}
screen_ho_btn_kick[1] = {}
screen_ho_btn_kick[2] = {}
for i=0,3 do
	screen_ho_text_names_array[i] = TextView.new(font[48], "[Open Slot]", 0, mya_getHeight()/4*i, mya_getRenderer())
	screen_ho_text_names_array[i]:setColor(mya_getRenderer(), 16,16,16)
	screen_ho_text_ping_array[i] = TextView.new(font[48], "", 0, (mya_getHeight()/4*i)+screen_ho_text_names_array[i]:getHeight(), mya_getRenderer())
	screen_ho_text_ping_array[i]:setColor(mya_getRenderer(), 16,16,16)
	screen_ho_btn_kick[2][i] = Sprite.new(assets:getTexture("screen_ho_button_kick"))
	screen_ho_btn_kick[1][i] = false
end

function screen_ho_windowResize(w, h) 
	screen_ho_clientbkg1:setX(0)
	screen_ho_clientbkg1:setY(0)
	screen_ho_clientbkg2:setX(0)
	screen_ho_clientbkg2:setY(mya_getHeight()/4)
	screen_ho_clientbkg3:setX(0)
	screen_ho_clientbkg3:setY(mya_getHeight()/4*2)
	screen_ho_clientbkg4:setX(0)
	screen_ho_clientbkg4:setY(mya_getHeight()/4*3)

	screen_ho_play:setX((mya_getWidth()/2)-(mya_getWidth()/16))
	screen_ho_play:setY(mya_getHeight()/16*13)
	
	for i=0,3 do
		screen_ho_text_names_array[i]:setFont(font[48], mya_getRenderer())
		screen_ho_text_names_array[i]:setXY(0,mya_getHeight()/4*i)
		screen_ho_text_ping_array[i]:setFont(font[48], mya_getRenderer())
		screen_ho_text_ping_array[i]:setXY(0,(mya_getHeight()/4*i)+screen_ho_text_names_array[i]:getHeight())
		screen_ho_btn_kick[2][i]:setX(mya_getWidth()/18*5)
		screen_ho_btn_kick[2][i]:setY(mya_getHeight()/4*i)
	end
end
screen_ho_windowResize(mya_getWidth(), mya_getHeight())

function screen_ho_render()
	screen_ho_bkg:render(mya_getRenderer(), mya_getWidth(), mya_getHeight())
	screen_ho_clientbkg1:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg2:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg3:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg4:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)

	if isHosting then
		screen_ho_play:render(mya_getRenderer(), mya_getWidth()/8, mya_getHeight()/6)
	end

	for i=0,3 do
		if clients_simplified then
			if clients_simplified[1] then
				if clients_simplified[2][clients_simplified[1][i+1]] then
					screen_ho_text_names_array[i]:setText(clients_simplified[2][clients_simplified[1][i+1]].name, mya_getRenderer())
					screen_ho_text_ping_array[i]:setText("Ping: "..clients_simplified[2][clients_simplified[1][i+1]].ping.."ms", mya_getRenderer())
					if isHosting or clients_simplified[1][i+1] == getPlayerID() then
						screen_ho_btn_kick[1][i] = true
						screen_ho_btn_kick[2][i]:render(mya_getRenderer(), mya_getWidth()/18, mya_getHeight()/18)
					else
						screen_ho_btn_kick[1][i] = false
					end
				else
					screen_ho_text_names_array[i]:setText("[Open Slot]", mya_getRenderer())
					screen_ho_text_ping_array[i]:setText("", mya_getRenderer())
				end
			end
		end
		screen_ho_text_names_array[i]:render(mya_getRenderer())
		screen_ho_text_ping_array[i]:render(mya_getRenderer())
	end
end

function screen_ho_mouseButtonUp(btn) 
	if btn == "left" then
		for i=0,3 do
			if screen_ho_btn_kick[1][i] then
				if screen_ho_btn_kick[2][i]:isPointColliding(mouseX, mouseY) then
					if getPlayerID() == clients_simplified[1][i+1] then
						if isHosting then
							server_message("quitting", {})
							network_update()
							network:close()
							state = STATE_CHOOSEPLAY
						else
							message("remove", {clients_simplified[1][i+1]})
							network_update()
							network:close()
							state = STATE_JOINSERVER
						end
					else
						message("remove", {clients_simplified[1][i+1]})
					end
				end
			end
		end

		if isHosting then
			if screen_ho_play:isPointColliding(mouseX, mouseY) then
				newWorld(16)
				world.isLinked = true
				server_message("ingame", {})
			end
		end
	end
end