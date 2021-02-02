--handles assets

assets = mya_getAssets()
font_size = 27

--Fonts
function assets_updateFonts()
	if font ~= nil then
		font:destroy()
	end
	font = Font.new("assets/font.ttf",mya_getHeight()/font_size)
end
assets_updateFonts()

assets:loadTexture("mm_btn_840x360","assets/gui/mm_btn_840x360.png")
assets:loadTexture("mm_btn_840x1080","assets/gui/mm_btn_840x1080.png")
assets:loadTexture("mm_logo","assets/gui/mm_logo.png")
assets:loadTexture("mm_about","assets/gui/mm_about.png")
assets:loadTexture("mm_end","assets/gui/mm_end.png")
assets:loadTexture("text_popup","assets/gui/text_popup.png")
assets:loadTexture("ui_heart_empty","assets/gui/ui_heart_empty.png")
assets:loadTexture("ui_heart_full","assets/gui/ui_heart_full.png")

assets:loadTexture("void","assets/tiles/void.png")

print("Finished loading "..assets:getTotalAssets().." assets!")