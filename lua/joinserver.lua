local ip = {}
ip["ip"] = "192.168.1.x"
local screen_js_ip = TextView.new(font,ip,0,0,mya_getRenderer())
local screen_js_ipbtn = Sprite.new(assets:getTexture("empty"))
local screen_js_join = Sprite.new(assets:getTexture("screen_mm_logo"))
local screen_js_back = Sprite.new(assets:getTexture("screen_mm_logo"))
local isWriting = false

ipe = loadTable(mya_getPath().."lastip.save")
if ipe then
	ip = ipe
end

function screen_js_windowResize(w,h)
	screen_js_ip:setText(ip["ip"], mya_getRenderer())
	screen_js_ip:setXY((mya_getWidth()/2)-(screen_js_ip:getWidth()/2),mya_getHeight()/16)
	screen_js_ipbtn:setX((mya_getWidth()/2)-(screen_js_ip:getWidth()/2))
	screen_js_ipbtn:setY(mya_getHeight()/10)
	screen_js_join:setX(mya_getWidth()/4)
	screen_js_join:setY(mya_getHeight()/10*3)
	screen_js_back:setX(mya_getWidth()/4)
	screen_js_back:setY(mya_getHeight()/10*6)
	
end
screen_js_windowResize(mya_getWidth(),mya_getHeight())

function screen_js_render()
	screen_js_ip:render(mya_getRenderer())
	screen_js_ipbtn:render(mya_getRenderer(),screen_js_ip:getWidth(),screen_js_ip:getHeight())
	screen_js_join:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
	screen_js_back:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
end

function screen_js_keyUp(key)
	if isWriting then
		if key == "backspace" then
			ip["ip"] = ip["ip"]:sub(1,-2)
		elseif key == "enter" then
			isHosting = false
			net_ip = ip["ip"]
			saveTable(mya_getPath().."lastip.save",ip)
			network_start()
			state = STATE_HOST
		else
			ip["ip"] = ip["ip"]..key
		end
		screen_js_ip:setText(ip["ip"], mya_getRenderer())
		screen_js_ip:setXY((mya_getWidth()/2)-(screen_js_ip:getWidth()/2),mya_getHeight()/16)
		screen_js_ipbtn:setX((mya_getWidth()/2)-(screen_js_ip:getWidth()/2))
	end
end

function screen_js_mouseButtonUp(btn)
	if btn == "left" then
		if screen_js_ipbtn:isPointColliding(mouseX, mouseY) then
			isWriting = true
		else
			isWriting = false
			if screen_js_join:isPointColliding(mouseX, mouseY) then
				isHosting = false
				net_ip = ip["ip"]
				saveTable(mya_getPath().."lastip.save",ip)
				network_start()
				state = STATE_HOST
			elseif screen_js_back:isPointColliding(mouseX, mouseY) then
				state = STATE_CHOOSEPLAY
			end
		end
	end
end