keys = {}

function registerBinds()
	
end

function registerBind(key, name, _function)
	keys[key] = {}
	keys[key].name = name
	keys[key]._function = _function
end

function callBind(key, isPressed)
	if keys[key] then
		keys[key]._function(isPressed)
	end
end

registerBinds()