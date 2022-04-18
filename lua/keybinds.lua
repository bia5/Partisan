keys = {}

function registerBinds()
	registerBind("esc", "Leave", client_leave)
	registerBind("=", "Zoom Out", zoomOut)
	registerBind("-", "Zoom In", zoomIn)
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