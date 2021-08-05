function saveTable(file, tablee)
	local test = assert(io.open(file, "w"))
	tablee = json.encode(tablee)
	test:write(tablee)
	test:close()
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
 end
 

function loadTable(file)
	if file_exists(file) then
		local test = io.open(file, "r")
		local readjson= test:read("*a")
		result = json.decode(readjson)
		test:close()
		return result
	end
	return nil
end