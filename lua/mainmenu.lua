local screen_mm_logo = Sprite.new(assets:getTexture("screen_mm_logo"))

function screen_mm_windowResize(w, h)
	screen_mm_logo:setX(mya_getWidth()/4)
	screen_mm_logo:setY(mya_getHeight()/16)
end
screen_mm_windowResize(mya_getWidth(), mya_getHeight())

function screen_mm_render()
	screen_mm_logo:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/3)
end

function screen_mm_update()
	
end