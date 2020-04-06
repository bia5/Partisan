function saveTable(file, tablee)
	local test = assert(io.open(file, "w"))
	tablee = json.encode(tablee)
	test:write(tablee)
	test:close()
end

function loadTable(file)
	local test = io.open(file, "r")
	local readjson= test:read("*a")
	result = json.decode(readjson)
	test:close()
	return result
end