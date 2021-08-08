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

local screen_ho_text_names_array = {}
local screen_ho_text_ping_array = {}
for i=0,3 do
	screen_ho_text_names_array[i] = TextView.new(font, "[Open Slot]", 0, mya_getHeight()/4*i, mya_getRenderer())
	screen_ho_text_ping_array[i] = TextView.new(font, "", 0, mya_getHeight()/4*i, mya_getRenderer())
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
	
	for i=0,3 do
		screen_ho_text_names_array[i] = nil
		screen_ho_text_names_array[i] = TextView.new(font, "[Open Slot]", 0, mya_getHeight()/4*i, mya_getRenderer())
		screen_ho_text_ping_array[i] = nil
		screen_ho_text_ping_array[i] = TextView.new(font, "", 0, (mya_getHeight()/4*i)+screen_ho_text_names_array[i]:getHeight(), mya_getRenderer())
	end
end
screen_ho_windowResize(mya_getWidth(), mya_getHeight())

function screen_ho_render()
	screen_ho_clientbkg1:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg2:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg3:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg4:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)

	for i=0,3 do
		if clients_simplified then
			if clients_simplified[1] then
				if clients_simplified[2][clients_simplified[1][i+1]] then
					screen_ho_text_names_array[i]:setText(clients_simplified[2][clients_simplified[1][i+1]].name, mya_getRenderer())
					screen_ho_text_ping_array[i]:setText("Ping: "..clients_simplified[2][clients_simplified[1][i+1]].ping.."ms", mya_getRenderer())
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

	end
end