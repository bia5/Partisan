player_x = 12
player_y = 12
player_sprite_x = 0
player_sprite_y = 0
player_vel_x = 0
player_vel_y = 0
player_animation_frames = 3
player_animation_cur_frame = 0
player_animation_wait = 10
player_animation_tick = 0
player_movement_speed = ig_size/(player_animation_frames*10)
player_flip = false
player_health = 3

player_STATE_IDLE = "idle"
player_STATE_RUNNING = "run"
player_state = player_STATE_IDLE

player_sprite = Sprite.new(assets:getTexture("knight_f_idle_anim_f0"))

function player_windowResize(w, h)
	player_movement_speed = ig_size/30
	player_sprite_x = player_x*ig_size
	player_sprite_y = player_y*ig_size
	player_vel_x = 0
	player_vel_y = 0
end
player_windowResize(w, h)

function player_moveUp()
	if not isTileCollision(player_x,player_y - 1) then
		player_y = player_y - 1
		player_vel_y = player_vel_y - ig_size
		sound_walking:play()
	end
	game_turns = game_turns + 1
end

function player_moveDown()
	if not isTileCollision(player_x,player_y + 1) then
		player_y = player_y + 1
		player_vel_y = player_vel_y + ig_size
		sound_walking:play()
	end
	game_turns = game_turns + 1
end

function player_moveLeft()
	if not isTileCollision(player_x-1,player_y) then
		player_x = player_x - 1
		player_vel_x = player_vel_x - ig_size
		sound_walking:play()
	end
	game_turns = game_turns + 1
end

function player_moveRight()
	if not isTileCollision(player_x+1,player_y) then
		player_x = player_x + 1
		player_vel_x = player_vel_x + ig_size
		sound_walking:play()
	end
	game_turns = game_turns + 1
end

function player_interact()
	game_turns = game_turns + 1
	hintObj(player_x,player_y, false)
	hintObj(player_x,player_y-1, false)
	hintObj(player_x,player_y+1, false)
	hintObj(player_x+1,player_y, false)
	hintObj(player_x-1,player_y, true)
end

function player_stab()
	game_turns = game_turns + 1
	stab(player_x,player_y)
end

function player_update()
	if player_vel_x > 0 then
		player_flip = false
		player_vel_x = player_vel_x - player_movement_speed
		player_sprite_x = player_sprite_x + player_movement_speed
		if player_vel_x < 0 then
			player_vel_x = 0
			player_sprite_x = player_x*ig_size
		end
	end
	if player_vel_x < 0 then
		player_flip = true
		player_vel_x = player_vel_x + player_movement_speed
		player_sprite_x = player_sprite_x - player_movement_speed
		if player_vel_x > 0 then
			player_vel_x = 0
			player_sprite_x = player_x*ig_size
		end
	end
	if player_vel_y > 0 then
		player_vel_y = player_vel_y - player_movement_speed
		player_sprite_y = player_sprite_y + player_movement_speed
		if player_vel_y < 0 then
			player_vel_y = 0
			player_sprite_y = player_y*ig_size
		end
	end
	if player_vel_y < 0 then
		player_vel_y = player_vel_y + player_movement_speed
		player_sprite_y = player_sprite_y - player_movement_speed
		if player_vel_y > 0 then
			player_vel_y = 0
			player_sprite_y = player_y*ig_size
		end
	end
	
	
	if player_vel_x == 0 and player_vel_y == 0 then
		if player_state == player_STATE_RUNNING then
			player_animation_cur_frame = 0
			player_state = player_STATE_IDLE
			if level[game_level] and game_hasWon == true then
				if level[game_level].tiles[player_x.."-"..player_y] then
					if level[game_level].tiles[player_x.."-"..player_y].tile == "coin" then
						setLevel(level[game_level].tiles[player_x.."-"..player_y].data)
					end
				end
			end
		end
	else
		if player_state == player_STATE_IDLE then
			player_animation_cur_frame = 0
			player_state = player_STATE_RUNNING
		end
	end
	
	player_sprite:setX(player_sprite_x)
	player_sprite:setY(player_sprite_y)
end

function player_render()
	player_animation_tick = player_animation_tick + 1
	if player_animation_tick >= player_animation_wait then
		player_animation_tick = 0
		player_sprite:setTexture(assets:getTexture("knight_f_"..player_state.."_anim_f"..player_animation_cur_frame))
		player_animation_cur_frame = player_animation_cur_frame + 1
		if player_animation_cur_frame >= player_animation_frames then
			player_animation_cur_frame = 0
		end
	end
	
	player_sprite:renderFlip(mya_getRenderer(), ig_size, ig_size, player_flip)
end