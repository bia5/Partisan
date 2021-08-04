keys = {}

function e()
	isHosting = not isHosting
end

function registerBinds()
	registerBind("1","test",network_start)
	registerBind("2","e",e)
end

function registerBind(key, name, _function)
	keys[key] = {}
	keys[key].name = name
	keys[key]._function = _function
end

function callBind(key)
	if keys[key] then
		keys[key]._function()
	end
end

registerBinds()