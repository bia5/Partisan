--Player Name
local screen_op_name = TextView.new(font,"Player Name: "..settings.player_name,0,0,mya_getRenderer())
local screen_op_namebtn = Sprite.new(assets:getTexture("empty"))
screen_op_namebtn:setRenderOutline(true)
screen_op_namebtn:setOutlineColor(0, 0, 0, 32)
local screen_op_nameiswriting = false
--Effect Volume
--Music Volume

local screen_op_back = Sprite.new(assets:getTexture("screen_mm_logo"))

function screen_op_windowResize(w, h) 
	screen_op_name:setFont(font, mya_getRenderer())
	screen_op_name:setXY(mya_getWidth()/20, mya_getHeight()/10)
	screen_op_namebtn:setX(mya_getWidth()/20)
	screen_op_namebtn:setY(mya_getHeight()/10)
	
	screen_op_back:setX(mya_getWidth()/4)
	screen_op_back:setY(mya_getHeight()/10*7)
end
screen_op_windowResize(mya_getWidth(), mya_getHeight())

function screen_op_render()
	screen_op_namebtn:render(mya_getRenderer(),screen_op_name:getWidth(),screen_op_name:getHeight())
	screen_op_name:render(mya_getRenderer())

	screen_op_back:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
end

function screen_op_mouseButtonUp(btn) 
	if btn == "left" then
		if screen_op_namebtn:isPointColliding(mouseX, mouseY) then
			screen_op_nameiswriting = true
		else
			screen_op_nameiswriting = false

			if screen_op_back:isPointColliding(mouseX, mouseY) then
				variables_save()
				state = STATE_MAINMENU
				resizeFont(64)
			end
		end
	end
end

function screen_op_keyUp(key)
	if screen_op_nameiswriting then
		if key == "backspace" then
			settings.player_name = settings.player_name:sub(1,-2)
		elseif key == "enter" then
			screen_op_nameiswriting = false
		else
			settings.player_name = settings.player_name..key
		end

		screen_op_name:setText("Player Name: "..settings.player_name, mya_getRenderer())
	end
end