ig_blocks = 25
ig_uwu = 5
ig_size = 1
ig_bg_top = Sprite.new(assets:getTexture("mm_btn_840x540"))
ig_bg_bot = Sprite.new(assets:getTexture("mm_btn_840x540"))

ig_btn_up = Sprite.new(assets:getTexture("ig_btn_up"))
ig_btn_dn = Sprite.new(assets:getTexture("ig_btn_dn"))
ig_btn_lt = Sprite.new(assets:getTexture("ig_btn_lt"))
ig_btn_rt = Sprite.new(assets:getTexture("ig_btn_rt"))
ig_btn_interact = Sprite.new(assets:getTexture("ig_btn_interact"))
ig_btn_stab = Sprite.new(assets:getTexture("ig_btn_stab"))

ig_gui_heart = Sprite.new(assets:getTexture("ui_heart_full"))

ig_tv_turns = TextView.new(font, "Turn "..game_turns, 0, 0, mya_getRenderer())
ig_tv_turns:setColor(mya_getRenderer(), 0, 0, 0)

function ig_mouseButtonUp(btn)
	if state == STATE_INGAME then
		if btn == "left" then
			if ig_btn_up:isPointColliding(mouseX, mouseY) then
				player_moveUp()
			elseif ig_btn_dn:isPointColliding(mouseX, mouseY) then
				player_moveDown()
			elseif ig_btn_rt:isPointColliding(mouseX, mouseY) then
				player_moveRight()
			elseif ig_btn_lt:isPointColliding(mouseX, mouseY) then
				player_moveLeft()
			elseif ig_btn_interact:isPointColliding(mouseX, mouseY) then
				player_interact()
			elseif ig_btn_stab:isPointColliding(mouseX, mouseY) then
				player_stab()
			end
			if devmode == true then
				if game_edit == true then
					for ff = 0, ig_blocks do
						for f = 0, ig_blocks do
							if level_sprites[f.."-"..ff]:isPointColliding(mouseX, mouseY) then
								if game_undertiles == true then
									level[game_level].undertiles[f.."-"..ff] = {tile=game_edit_tile,data=game_edit_data,hint=game_edit_hint,collision=game_edit_collision,hintable=game_edit_hintable}
								else
									level[game_level].tiles[f.."-"..ff] = {tile=game_edit_tile,data=game_edit_data,hint=game_edit_hint,collision=game_edit_collision,hintable=game_edit_hintable}
								end
							end
						end
					end
				end
			end
		else
			if devmode == true then
				if game_edit == true then
					for ff = 0, ig_blocks do
						for f = 0, ig_blocks do
							if level_sprites[f.."-"..ff]:isPointColliding(mouseX, mouseY) then
								if game_undertiles == true then
									game_edit_tile = level[game_level].tiles[f.."-"..ff].tile
									game_edit_data = level[game_level].tiles[f.."-"..ff].data
									game_edit_hint = level[game_level].tiles[f.."-"..ff].hint
									game_edit_collision = level[game_level].tiles[f.."-"..ff].collision
									game_edit_hintable = level[game_level].tiles[f.."-"..ff].hintable
								else
									game_edit_tile = level[game_level].tiles[f.."-"..ff].tile
									game_edit_data = level[game_level].tiles[f.."-"..ff].data
									game_edit_hint = level[game_level].tiles[f.."-"..ff].hint
									game_edit_collision = level[game_level].tiles[f.."-"..ff].collision
									game_edit_hintable = level[game_level].tiles[f.."-"..ff].hintable
								end
							end
						end
					end
				end
			end
		end
	end
end

function ig_keyDown(key)
	if key == "w" then
		player_up = true
	end
	if key == "a" then
		player_lt = true
	end
	if key == "s" then
		player_dn = true
	end
	if key == "d" then
		player_rt = true
	end
end

function ig_keyUp(key)
	if state == STATE_INGAME then
		if popup_active == false then
			if key == "esc" then
				state = STATE_MAINMENU
				font_size = 8
				assets_updateFonts()
				popups_windowResize(mya_getWidth(), mya_getHeight())
			end
			if key == "w" then
				player_up = false
			end
			if key == "a" then
				player_lt = false
			end
			if key == "s" then
				player_dn = false
			end
			if key == "d" then
				player_rt = false
			end
			if key == "e" then
				player_interact()
			end
			if key == "q" then
				player_stab()
			end
			if devmode == true then
				if key == "p" then
					print("======================================")
					print("1: game_level: "..game_level)
					print("2: game_edit: "..tostring(game_edit))
					print("3: game_edit_tile: "..game_edit_tile)
					print("4: game_undertiles: "..tostring(game_undertiles))
					print("5: set default player pos")
					print("6: game_edit_data: "..game_edit_data)
					print("7: game_edit_collision: "..tostring(game_edit_collision))
					print("8: generate void")
					print("9: game_edit_hint: "..json.encode(game_edit_hint))
					print("o: game_edit_hintable: "..tostring(game_edit_hintable))
					print("")
				end
				if key == "1" then
					game_level = io.read()
				end
				if key == "2" then
					game_edit = not game_edit
				end
				if key == "3" then
					game_edit_tile = io.read()
				end
				if key == "4" then
					game_undertiles = not game_undertiles
				end
				if key == "5" then
					level[game_level].defaultPlayerX = player_x
					level[game_level].defaultPlayerY = player_y
				end
				if key == "6" then
					game_edit_data = io.read()
				end
				if key == "7" then
					game_edit_collision = not game_edit_collision
				end
				if key == "8" then
					generateVoid()
				end
				if key == "9" then
					game_edit_hint = json.decode(io.read())
				end
				if key == "o" then
					game_edit_hintable = not game_edit_hintable
				end
				if key == "0" then
					saveTable("assets/levels/level.them", level)
					print("saved levels!")
				end
			end
		end
	end
end

function ig_windowResize(w, h)
	ig_size = math.ceil(mya_getHeight()/ig_blocks)
	
	ig_bg_top:setX(mya_getHeight())
	ig_bg_top:setY(0)
	ig_bg_bot:setX(mya_getHeight())
	ig_bg_bot:setY(mya_getHeight()/2)
	
	ig_btn_up:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)-((mya_getHeight()/ig_uwu)/2))
	ig_btn_up:setY(mya_getHeight()/64*34)
	ig_btn_dn:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)-((mya_getHeight()/ig_uwu)/2))
	ig_btn_dn:setY(mya_getHeight()/32*24)
	ig_btn_lt:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)-((mya_getHeight()/ig_uwu)/4*6)-5)
	ig_btn_lt:setY(mya_getHeight()/32*24)
	ig_btn_rt:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)+((mya_getHeight()/ig_uwu)/2)+5)
	ig_btn_rt:setY(mya_getHeight()/32*24)
	ig_btn_interact:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)+((mya_getHeight()/ig_uwu)/2)+5)
	ig_btn_interact:setY(mya_getHeight()/64*34)
	ig_btn_stab:setX(mya_getHeight()+((mya_getWidth()-mya_getHeight())/2)-((mya_getHeight()/ig_uwu)/4*6)-5)
	ig_btn_stab:setY(mya_getHeight()/64*34)
	
	ig_gui_heart:setY(mya_getHeight()/32*7)
	
	ig_tv_turns:setXY(mya_getHeight()+(mya_getHeight()/64), mya_getHeight()/64)
	ig_tv_turns:setFont(font, mya_getRenderer())
	
	generateSprites()
end
ig_windowResize(mya_getWidth(), mya_getHeight())

function ig_update()
	if state == STATE_INGAME then
		player_update()
		if level[game_level].tiles[math.floor(player_x).."-"..math.floor(player_y)] then
			ig_tv_turns:setText("X: "..player_x..", Y: "..player_y..", Tile: "..level[game_level].tiles[math.floor(player_x).."-"..math.floor(player_y)].tile, mya_getRenderer())
		else
			ig_tv_turns:setText("X: "..player_x..", Y: "..player_y..", Tile: NULL", mya_getRenderer())
		end
	end
end

function ig_render()
	if state == STATE_INGAME then
		for ff = 0, ig_blocks do
			for f = 0, ig_blocks do
				if level[game_level] == nil then else
					if level[game_level].undertiles[f.."-"..ff] == nil then else
						level_sprites[f.."-"..ff]:setTexture(assets:getTexture(level[game_level].undertiles[f.."-"..ff].tile))
						level_sprites[f.."-"..ff]:render(mya_getRenderer(), ig_size, ig_size)
					end
				end
				
				if level[game_level] == nil then else
					if level[game_level].tiles[f.."-"..ff] == nil then else
						if level[game_level].tiles[f.."-"..ff].tile == "coin" and game_hasWon == false then else
							level_sprites[f.."-"..ff]:setTexture(assets:getTexture(level[game_level].tiles[f.."-"..ff].tile))
							level_sprites[f.."-"..ff]:render(mya_getRenderer(), ig_size, ig_size)
						end
					end
				end
			end
		end
		
		ig_bg_top:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight()/2)
		ig_bg_bot:render(mya_getRenderer(), mya_getWidth()-mya_getHeight(), mya_getHeight()/2)
		
		ig_btn_up:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		ig_btn_dn:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		ig_btn_lt:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		ig_btn_rt:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		ig_btn_interact:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		ig_btn_stab:render(mya_getRenderer(), mya_getHeight()/ig_uwu, mya_getHeight()/ig_uwu)
		
		ig_tv_turns:render(mya_getRenderer())
		player_render()
		ig_gui_heart:setTexture(assets:getTexture("ui_heart_full"))
		for iii = 0, player_health-1 do
			ig_gui_heart:setX((mya_getHeight()+10)+((((mya_getWidth()-mya_getHeight())/3))*iii))
			ig_gui_heart:render(mya_getRenderer(), (mya_getWidth()-mya_getHeight())/3, (mya_getWidth()-mya_getHeight())/3)
		end
		ig_gui_heart:setTexture(assets:getTexture("ui_heart_empty"))
		
		if player_health == 3 then else
			for iii = player_health, 2 do
				ig_gui_heart:setX((mya_getHeight()+10)+((((mya_getWidth()-mya_getHeight())/3))*iii))
			ig_gui_heart:render(mya_getRenderer(), (mya_getWidth()-mya_getHeight())/3, (mya_getWidth()-mya_getHeight())/3)
			end
		end
	end
end