
game_turns = 1
game_level = "level_1"
game_hasWon = false
game_last_level = game_level

game_edit = false
game_undertiles = true
game_edit_tile = "void"
game_edit_data = "" --for triggers
game_edit_collision = false
game_edit_hint = {}
game_edit_hintable = false

level = loadTable("assets/levels/level.them")
level_sprites = {}

function generateSprites()
	for ff = 0, ig_blocks do
		for f = 0, ig_blocks do
			level_sprites[f.."-"..ff] = Sprite.new(assets:getTexture("void"))
			level_sprites[f.."-"..ff]:setX(f*ig_size)
			level_sprites[f.."-"..ff]:setY(ff*ig_size)
		end
	end
end

function generateVoid()
	level[game_level] = {undertiles={},tiles={},defaultPlayerX=0,defaultPlayerY=0,coinX=0,coinY=0,immediatePopups={}}
	for ff = 0, ig_blocks do
		for f = 0, ig_blocks do
			level[game_level].undertiles[f.."-"..ff] = {tile="void",data="",hint={},collision=true,hintable=false}
		end
	end
end

function hintObj(xxx,yyy,tey)
	sound_paper:play()
	if level[game_level] then
		if level[game_level].tiles[xxx.."-"..yyy] then
			if level[game_level].tiles[xxx.."-"..yyy].hintable == true then
				addPopup(false,"You found a clue!")
				addPopup(level[game_level].tiles[xxx.."-"..yyy].hint["1"],level[game_level].tiles[xxx.."-"..yyy].hint["2"],level[game_level].tiles[xxx.."-"..yyy].hint["3"])
			elseif level[game_level].tiles[xxx.."-"..yyy].tile == "sword" then
				addPopup(true,"You found the Sword of Etheral!","You can now see the enemies and escape!")
				state = STATE_END
			elseif tey == true and popup_active == false then
				addPopup(false,"You search the area and find nothing")
			end
		elseif tey == true and popup_active == false then
			addPopup(false,"You search the area and find nothing")
		end
	end
end

function stab(xxx,yyy)
	sound_swoosh2:play()
	if level[game_level] then
		xxxx = math.floor(xxx)
		yyyy = math.floor(yyy)+1
		if level[game_level].tiles[xxxx.."-"..yyyy] then
			if level[game_level].tiles[xxxx.."-"..yyyy].tile == "ghost" then
				addPopup(false,"You stabbed the ghost!")
				game_hasWon = true
				sound_coin:play()
			else
				player_health = player_health - 1
				if player_health == 0 then
					addPopup(true,"You missed! The ghost spooked you to death!", "You have awoken in a previous place")
					setLevel(game_last_level)
					player_health = 3
				else
					addPopup(true,"You missed!", "The ghost spooked you! You are hurt!")
				end
			end
		else
			player_health = player_health - 1
			if player_health == 0 then
				addPopup(true,"You missed! The ghost spooked you to death!", "You have awoken in a previous place")
				setLevel(game_last_level)
				player_health = 3
			else
				addPopup(true,"You missed!", "The ghost spooked you! You are hurt!")
			end
		end
	end
end

function isTileCollision(xxx,yyy)
	yyeett = false
	if level[game_level] then
		xxxx = math.floor(xxx)
		yyyy = math.floor(yyy)+1
		if level[game_level].undertiles[xxxx.."-"..yyyy] then
			if level[game_level].undertiles[xxxx.."-"..yyyy].collision == true then
				yyeett = true
			end
		elseif level[game_level].tiles[xxxx.."-"..yyyy] then
			if level[game_level].tiles[xxxx.."-"..yyyy].collision == true then
				yyeett = true
			end
		end
	end
	return yyeett
end

function setLevel(lvl)
	sound_swoosh2:play()
	game_last_level = game_level
	game_level = lvl
	player_x = level[game_level].defaultPlayerX
	player_y = level[game_level].defaultPlayerY
	player_vel_x = 0
	player_vel_y = 0
	player_windowResize(w, h)
	if tablelength(level[game_level].immediatePopups) > 0 then
		for k=1,tablelength(level[game_level].immediatePopups) do
			v = level[game_level].immediatePopups[tostring(k)]
			addPopup(v["1"],v["2"],v["3"])
		end
	end
	game_hasWon = false
end