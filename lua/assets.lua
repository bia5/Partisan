assets = mya_getAssets()

function asset_updateFonts()
	if font ~= nil then
		font:destroy()
	end
	font = Font.new("assets/font.ttf",mya_getHeight()/32)
end
asset_updateFonts()

assets:loadTexture("screen_mm_logo","assets/mainmenu/logo.png")

print("Finished loading "..assets:getTotalAssets().." assets!")