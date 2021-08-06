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

function screen_ho_windowResize(w, h) 
	screen_ho_clientbkg1:setX(0)
	screen_ho_clientbkg1:setY(0)
	screen_ho_clientbkg2:setX(0)
	screen_ho_clientbkg2:setY(mya_getHeight()/4)
	screen_ho_clientbkg3:setX(0)
	screen_ho_clientbkg3:setY(mya_getHeight()/4*2)
	screen_ho_clientbkg4:setX(0)
	screen_ho_clientbkg4:setY(mya_getHeight()/4*3)
end
screen_ho_windowResize(mya_getWidth(), mya_getHeight())

function screen_ho_render() 
	screen_ho_clientbkg1:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg2:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg3:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
	screen_ho_clientbkg4:render(mya_getRenderer(), mya_getWidth()/3, mya_getHeight()/4)
end

function screen_ho_mouseButtonUp(btn) 
	if btn == "left" then

	end
end