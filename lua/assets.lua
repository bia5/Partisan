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

for temp_0 = 1, 8 do
	assets:loadTexture("floor_"..temp_0,"assets/tiles/floor_"..temp_0..".png")
end
for temp_0 = 0, 3 do
	assets:loadTexture("knight_f_idle_anim_f"..temp_0,"assets/entities/knight_f_idle_anim_f"..temp_0..".png")
end
for temp_0 = 0, 3 do
	assets:loadTexture("knight_f_run_anim_f"..temp_0,"assets/entities/knight_f_run_anim_f"..temp_0..".png")
end

assets:loadTexture("mm_btn_840x360","assets/gui/mm_btn_840x360.png")
assets:loadTexture("mm_btn_840x1080","assets/gui/mm_btn_840x1080.png")
assets:loadTexture("mm_btn_840x540","assets/gui/mm_btn_840x540.png")
assets:loadTexture("mm_btn_840x720","assets/gui/mm_btn_840x720.png")
assets:loadTexture("mm_logo","assets/gui/mm_logo.png")
assets:loadTexture("mm_about","assets/gui/mm_about.png")
assets:loadTexture("mm_end","assets/gui/mm_end.png")
assets:loadTexture("text_popup","assets/gui/text_popup.png")
assets:loadTexture("ig_btn_up","assets/gui/ig_btn_up.png")
assets:loadTexture("ig_btn_dn","assets/gui/ig_btn_dn.png")
assets:loadTexture("ig_btn_lt","assets/gui/ig_btn_lt.png")
assets:loadTexture("ig_btn_rt","assets/gui/ig_btn_rt.png")
assets:loadTexture("ig_btn_interact","assets/gui/ig_btn_interact.png")
assets:loadTexture("ig_btn_stab","assets/gui/ig_btn_stab.png")
assets:loadTexture("ui_heart_empty","assets/gui/ui_heart_empty.png")
assets:loadTexture("ui_heart_full","assets/gui/ui_heart_full.png")

assets:loadTexture("void","assets/tiles/void.png")
assets:loadTexture("coin","assets/tiles/coin.png")
assets:loadTexture("crate","assets/tiles/crate.png")
assets:loadTexture("hole","assets/tiles/hole.png")
assets:loadTexture("ghost","assets/tiles/ghost.png")
assets:loadTexture("skull","assets/tiles/skull.png")
assets:loadTexture("chest","assets/tiles/chest.png")
assets:loadTexture("door","assets/tiles/door.png")
assets:loadTexture("flask_big_blue","assets/tiles/flask_big_blue.png")
assets:loadTexture("flask_big_green","assets/tiles/flask_big_green.png")
assets:loadTexture("flask_big_red","assets/tiles/flask_big_red.png")
assets:loadTexture("flask_big_yellow","assets/tiles/flask_big_yellow.png")
assets:loadTexture("flask_blue","assets/tiles/flask_blue.png")
assets:loadTexture("flask_green","assets/tiles/flask_green.png")
assets:loadTexture("flask_red","assets/tiles/flask_red.png")
assets:loadTexture("flask_yellow","assets/tiles/flask_big_yellow.png")
assets:loadTexture("wall_banner_blue","assets/tiles/wall_banner_blue.png")
assets:loadTexture("wall_banner_red","assets/tiles/wall_banner_red.png")
assets:loadTexture("wall_banner_green","assets/tiles/wall_banner_green.png")
assets:loadTexture("wall_banner_yellow","assets/tiles/wall_banner_yellow.png")
assets:loadTexture("wall_inner_corner_l_top_left","assets/tiles/wall_inner_corner_l_top_left.png")
assets:loadTexture("wall_inner_corner_l_top_right","assets/tiles/wall_inner_corner_l_top_rigth.png")
assets:loadTexture("wall_hole_1","assets/tiles/wall_hole_1.png")
assets:loadTexture("wall_hole_2","assets/tiles/wall_hole_2.png")
assets:loadTexture("wall_left","assets/tiles/wall_left.png")
assets:loadTexture("wall_mid","assets/tiles/wall_mid.png")
assets:loadTexture("wall_right","assets/tiles/wall_right.png")
assets:loadTexture("sword","assets/tiles/sword.png")
assets:loadTexture("wall_top_mid","assets/tiles/wall_top_mid.png")
assets:loadTexture("wall_side_mid_left","assets/tiles/wall_side_mid_left.png")
assets:loadTexture("wall_side_mid_right","assets/tiles/wall_side_mid_right.png")

print("Finished loading "..assets:getTotalAssets().." assets!")