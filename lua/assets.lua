assets = mya_getAssets()

fontsize = 64
function asset_updateFonts()
	if font ~= nil then
		font:destroy()
	end
	font = Font.new("assets/font.ttf",fontsize*(mya_getHeight()/720))
end
asset_updateFonts()

function resizeFont(_s)
	fontsize = _s
	event_windowResize(mya_getWidth(), mya_getHeight())
end

assets:loadTexture("screen_mm_logo","assets/mainmenu/logo.png")
assets:loadTexture("empty","assets/empty.png")

print("Finished loading "..assets:getTotalAssets().." assets!")