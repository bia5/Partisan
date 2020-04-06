
font_size = 8
assets_updateFonts()

mm_logo = Sprite.new(assets:getTexture("mm_logo"))
mm_end = Sprite.new(assets:getTexture("mm_end"))
mm_btn_top = Sprite.new(assets:getTexture("mm_btn_840x360"))
mm_btn_mid = Sprite.new(assets:getTexture("mm_btn_840x360"))
mm_btn_bot = Sprite.new(assets:getTexture("mm_btn_840x360"))

mm_tv_top = TextView.new(font, "Play Game", 0, 0, mya_getRenderer())
mm_tv_mid = TextView.new(font, "About", 0, 0, mya_getRenderer())
mm_tv_bot = TextView.new(font, "Quit Game", 0, 0, mya_getRenderer())
mm_tv_end = TextView.new(font, "Game completed in 0 turns!", 0, 0, mya_getRenderer())


function mm_mouseButtonUp(btn)
	if state == STATE_MAINMENU then
		if btn == "left" then
			if mm_btn_top:isPointColliding(mouseX, mouseY) then
				sound_click:play()
				state = STATE_INGAME
				font_size = 20
				assets_updateFonts()
				popups_windowResize(mya_getWidth(), mya_getHeight())
				ig_windowResize(mya_getWidth(), mya_getHeight())
				setLevel(game_level)
			elseif mm_btn_mid:isPointColliding(mouseX, mouseY) then
				sound_click:play()
				state = STATE_ABOUT
				mm_tv_mid:setText("   Back", mya_getRenderer())
				mm_logo:setTexture(assets:getTexture("mm_about"))
				mm_btn_top:setTexture(assets:getTexture("mm_btn_840x1080"))
			elseif mm_btn_bot:isPointColliding(mouseX, mouseY) then
				sound_click:play()
				mya_exit()
			end
		end
	end
	if state == STATE_ABOUT then
		if btn == "left" then
			if mm_btn_top:isPointColliding(mouseX, mouseY) then
				sound_click:play()
				state = STATE_MAINMENU
				mm_tv_mid:setText("About", mya_getRenderer())
				mm_logo:setTexture(assets:getTexture("mm_logo"))
				mm_btn_top:setTexture(assets:getTexture("mm_btn_840x360"))
			end
		end
	end
end

function mm_keyUp(key)
	if state == STATE_MAINMENU then
		if key == "esc" then
			mya_exit()
		end
	end
	if state == STATE_ABOUT then
		if key == "esc" then
			state = STATE_MAINMENU
			mm_tv_mid:setText("About", mya_getRenderer())
			mm_logo:setTexture(assets:getTexture("mm_logo"))
			mm_btn_top:setTexture(assets:getTexture("mm_btn_840x360"))
		end
	end
	if state == STATE_END then
		if key == " " then
			state = STATE_MAINMENU
		end
	end
end

function mm_windowResize(w, h)
	mm_logo:setX(0)
	mm_logo:setX(0)
	mm_end:setX(0)
	mm_end:setX(0)
	mm_btn_top:setX(mya_getHeight())
	mm_btn_top:setY(0)
	mm_btn_mid:setX(mya_getHeight())
	mm_btn_mid:setY(mya_getHeight()/3)
	mm_btn_bot:setX(mya_getHeight())
	mm_btn_bot:setY((mya_getHeight()/3)*2)
	
	mm_tv_top:setXY(mya_getHeight()+((mya_getWidth()-mya_getHeight())/8), (mya_getHeight()/12)*1)
	mm_tv_mid:setXY(mya_getHeight()+((mya_getWidth()-mya_getHeight())/4), (mya_getHeight()/12)*5)
	mm_tv_bot:setXY(mya_getHeight()+((mya_getWidth()-mya_getHeight())/8), (mya_getHeight()/12)*9)
	mm_tv_end:setXY(mya_getHeight()/7, (mya_getHeight()/12)*5)
end
mm_windowResize(mya_getWidth(), mya_getHeight())

function mm_render()
	if state == STATE_MAINMENU then
		mm_logo:render(mya_getRenderer(), mya_getHeight(), mya_getHeight())
		mm_btn_top:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight()/3)
		mm_btn_mid:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight()/3)
		mm_btn_bot:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight()/3)
		
		mm_tv_top:render(mya_getRenderer())
		mm_tv_mid:render(mya_getRenderer())
		mm_tv_bot:render(mya_getRenderer())
	end
	if state == STATE_ABOUT then
		mm_logo:render(mya_getRenderer(), mya_getHeight(), mya_getHeight())
		mm_btn_top:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight())
		mm_tv_mid:render(mya_getRenderer())
	end
	if state == STATE_END then
		mm_end:render(mya_getRenderer(), mya_getWidth(), mya_getHeight())
		mm_tv_end:setText("Game completed in "..game_turns.." turns!", mya_getRenderer())
		mm_tv_end:render(mya_getRenderer())
	end
end