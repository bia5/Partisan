assets = mya_getAssets()

fontSizes = {16,32,48,64,96}
font = {}

function asset_updateFonts()
	font = {}
	for k, v in pairs(fontSizes) do
		font[v] = Font.new("assets/font.ttf",v*(mya_getHeight()/720))
	end
	print("Loaded "..tablelength(fontSizes).." fonts.")
end
asset_updateFonts()

files = fileHandler:listDir("assets\\")
for i = 0, fileHandler:getSize(files)-1 do
	path = fileHandler:get(files, i)
	temp = mysplit(path,"\\")
	name = temp[#temp]
	truename = mysplit(name,".")
	if truename[#truename] == "png" then
		print("Loading texture: "..path)
		assets:loadTexture(truename[1], path)
	end
end

print("Finished loading "..assets:getTotalAssets().." assets!")