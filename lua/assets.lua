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

assets:loadTexture("screen_mm_logo","assets/mainmenu/logo.png")
assets:loadTexture("screen_mm_button_play","assets/mainmenu/button_play.png")
assets:loadTexture("screen_mm_button_quit","assets/mainmenu/button_quit.png")
assets:loadTexture("screen_mm_button_settings","assets/mainmenu/button_settings.png")

assets:loadTexture("screen_cp_button_host","assets/chooseplay/button_host.png")
assets:loadTexture("screen_cp_button_joinserver","assets/chooseplay/button_joinserver.png")
assets:loadTexture("screen_cp_button_leveleditor","assets/chooseplay/button_leveleditor.png")

assets:loadTexture("screen_js_button_leveleditor","assets/joinserver/button_joinserver.png")

assets:loadTexture("screen_ho_button_kick","assets/host/button_kick.png")

assets:loadTexture("screen_art_tree","assets/art/tree.png")

assets:loadTexture("screen_button_back","assets/button_back.png")
assets:loadTexture("empty","assets/empty.png")

assets:loadTexture("enemy_boss","assets/enemies/boss.png")

assets:loadTexture("tile_brick","assets/tiles/brick.png")
assets:loadTexture("tile_grey","assets/tiles/grey.png")

print("Finished loading "..assets:getTotalAssets().." assets!")