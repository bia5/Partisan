ig_blocks_x = 48
ig_blocks_y = 26

function ig_mouseButtonUp(btn)
	if state == STATE_INGAME then
		if btn == "left" then
			if devmode == true then
				if game_edit == true then
					for ff = 0, ig_blocks_y do
						for f = 0, ig_blocks_x do
							if level_sprites[f.."-"..ff]:isPointColliding(mouseX, mouseY) then
								if game_undertiles == true then
									level[game_level].undertiles[f.."-"..ff] = {tile=game_edit_tile,data=game_edit_data,collision=game_edit_collision}
								else
									level[game_level].tiles[f.."-"..ff] = {tile=game_edit_tile,data=game_edit_data,collision=game_edit_collision}
								end
							end
						end
					end
				end
			end
		else
			if devmode == true then
				if game_edit == true then
					for ff = 0, ig_blocks_y do
						for f = 0, ig_blocks_x do
							if level_sprites[f.."-"..ff]:isPointColliding(mouseX, mouseY) then
								if game_undertiles == true then
									game_edit_tile = level[game_level].tiles[f.."-"..ff].tile
									game_edit_data = level[game_level].tiles[f.."-"..ff].data
									game_edit_collision = level[game_level].tiles[f.."-"..ff].collision
								else
									game_edit_tile = level[game_level].tiles[f.."-"..ff].tile
									game_edit_data = level[game_level].tiles[f.."-"..ff].data
									game_edit_collision = level[game_level].tiles[f.."-"..ff].collision
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
				if key == "0" then
					saveTable("assets/levels/partisan_02.lvl", level)
					print("saved levels!")
				end
			end
		end
	end
end

function ig_windowResize(w, h)
	ig_size = math.ceil(mya_getHeight()/ig_blocks_y)
	
	generateSprites()
end
ig_windowResize(mya_getWidth(), mya_getHeight())

function ig_update()
	if state == STATE_INGAME then
	end
end

function ig_render()
	if state == STATE_INGAME then
		for ff = 0, ig_blocks_y do
			for f = 0, ig_blocks_x do
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
	end
end