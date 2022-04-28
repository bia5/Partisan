screen = newChild(0, 0, 1920, 1080)

--LOGO
screen_add(screen, "logo", newSprite("art_logo", "center", 1080*.1, 1920*.5, 1080*.3))

--Buttons
screen_add(screen, "buttons", newChild("center", 650, 1440, 270))

function choosePlay() state = STATE_CHOOSEPLAY end
--screen_add(screen["buttons"], "play", newButton("button_play", "center", "center", 350, 250, choosePlay))
screen_add(screen["buttons"], "play", newTextButton("Play", "center", "center", 375, 200, font[64], {96, 48, 16}, choosePlay))
screen["buttons"]["play"].textRatio = .5

screen_addLeft(screen["buttons"], "left_empty", newEmpty(0, 0, 25, 0))
screen_addLeft(screen["buttons"], "quit", newTextButton("Quit", 25, "center", 375, 200, font[64], {96, 48, 16}, mya_exit))
screen["buttons"]["quit"].textRatio = .5

screen_addRight(screen["buttons"], "right_empty", newEmpty(0, 0, 25, 0))
function chooseOptions() state = STATE_OPTIONS end
screen_addRight(screen["buttons"], "settings", newTextButton("Settings", 1065, "center", 375, 200, font[64], {96, 48, 16}, chooseOptions))
screen["buttons"]["settings"].textRatio = .5

screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))

addScreen(STATE_MAINMENU, screen)