assets = mya_getAssets()
font = Font.new("assets/font.ttf",64)

assets_tiles = {}
assets_objects = {}

files = fileHandler:listDir("assets\\")
for i = 0, fileHandler:getSize(files)-1 do
	path = fileHandler:get(files, i)
	temp = mysplit(path,"\\")
	name = temp[#temp]
	truename = mysplit(name,".")
	if truename[#truename] == "png" then
		print("Loading texture: "..path)
		assets:loadTexture(truename[1], path)
		e = string.sub(truename[1],1,4)
		if e == "tile" then
			table.insert(assets_tiles,truename[1])
		elseif e == "obj_" then
			table.insert(assets_tiles,truename[1])
		end
	end
end

print("Finished loading "..assets:getTotalAssets().." assets!")