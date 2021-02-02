game_level = "level_1"
game_hasWon = false
game_last_level = game_level

game_edit = false
game_undertiles = true
game_edit_tile = "void"
game_edit_data = "" --for triggers
game_edit_collision = false
updatePlayerOnLvlChange = true;

level = loadTable("assets/levels/partisan_02.lvl")
level_sprites = {}

function generateSprites()
	for ff = 0, ig_blocks_y do
		for f = 0, ig_blocks_x do
			level_sprites[f.."-"..ff] = Sprite.new(assets:getTexture("void"))
			level_sprites[f.."-"..ff]:setX(f*ig_size)
			level_sprites[f.."-"..ff]:setY(ff*ig_size)
		end
	end
end

function generateVoid()
	level[game_level] = {undertiles={},tiles={},defaultPlayerX=0,defaultPlayerY=0,immediatePopups={}}
	for ff = 0, ig_blocks_y do
		for f = 0, ig_blocks_x do
			level[game_level].undertiles[f.."-"..ff] = {tile="void",data="",collision=true}
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
	if updatePlayerOnLvlChange then
		--player_x = level[game_level].defaultPlayerX
		--player_y = level[game_level].defaultPlayerY
	end
	updatePlayerOnLvlChange = true
	if tablelength(level[game_level].immediatePopups) > 0 then
		for k=1,tablelength(level[game_level].immediatePopups) do
			v = level[game_level].immediatePopups[tostring(k)]
			addPopup(v["1"],v["2"],v["3"])
		end
	end
	game_hasWon = false
end