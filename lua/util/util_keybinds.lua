keys = {}

function registerBinds()
    registerBind("W", "Forward", player_up)
    registerBind("S", "Back", player_down)
    registerBind("A", "Left", player_left)
    registerBind("D", "Right", player_right)

	registerBind("L", "Shoot", player_shootarrow)
	if devmode then
		registerBind("P", "spawn boss bear", spawnBossBear)
		registerBind("O", "spawn boss skelly", spawnBossSkelly)
	end
end

function registerBind(key, name, _function)
	keys[key] = {}
	keys[key].name = name
	keys[key]._function = _function
end

function callBind(key, isPressed)
	if keys[key] then
		if not global_editing then
			keys[key]._function(isPressed)
		end
	end
end

registerBinds()