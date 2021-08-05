assets = mya_getAssets()

fontsize = 8
function asset_updateFonts()
	if font ~= nil then
		font:destroy()
	end
	font = Font.new("assets/font.ttf",mya_getHeight()/fontsize)
end
asset_updateFonts()

assets:loadTexture("screen_mm_logo","assets/mainmenu/logo.png")
assets:loadTexture("empty","assets/empty.png")

print("Finished loading "..assets:getTotalAssets().." assets!")