local screen_mm_logo = Sprite.new(assets:getTexture("screen_mm_logo"))
local screen_mm_quit = Sprite.new(assets:getTexture("screen_mm_button_quit"))
local screen_mm_play = Sprite.new(assets:getTexture("screen_mm_button_play"))
local screen_mm_options = Sprite.new(assets:getTexture("screen_mm_button_settings"))

function screen_mm_windowResize(w, h)
	screen_mm_logo:setX(mya_getWidth()/4)
	screen_mm_logo:setY(mya_getHeight()/16)
	screen_mm_quit:setX(mya_getWidth()/8)
	screen_mm_quit:setY(mya_getHeight()/2)
	screen_mm_play:setX(mya_getWidth()/8*3)
	screen_mm_play:setY(mya_getHeight()/2)
	screen_mm_options:setX(mya_getWidth()/8*6)
	screen_mm_options:setY(mya_getHeight()/2)
end
screen_mm_windowResize(mya_getWidth(), mya_getHeight())

function screen_mm_render()
	screen_mm_logo:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/3)
	screen_mm_quit:render(mya_getRenderer(), mya_getWidth()/8, mya_getHeight()/3)
	screen_mm_play:render(mya_getRenderer(), mya_getWidth()/4, mya_getHeight()/3)
	screen_mm_options:render(mya_getRenderer(), mya_getWidth()/8, mya_getHeight()/3)
end

function screen_mm_mouseButtonUp(btn)
	if btn == "left" then
		if screen_mm_quit:isPointColliding(mouseX, mouseY) then 
			mya_exit()
		end
		if screen_mm_play:isPointColliding(mouseX, mouseY) then 
			state = STATE_CHOOSEPLAY
		end
		if screen_mm_options:isPointColliding(mouseX, mouseY) then
			state = STATE_OPTIONS
		end
	end
end