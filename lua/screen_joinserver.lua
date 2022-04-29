screen = newChild(0, 0, 1920, 1080)

function scrJoin()
    isHosting = false

    net_ip = screen["things"]["ip"].text

	saveTable(mya_getPath().."lastip.save",ip)
	network_start()
	state = STATE_HOST
end

function scrBack()
    state = STATE_CHOOSEPLAY
end

screen_addTop(screen, "tv_join", newText("Join Server", "center", 10, 350, 80, font[64], {255, 128, 50}))

screen_add(screen, "things", newChild("center", 1080/5, 1440, 150))
screen_addLeft(screen["things"], "tv_ip", newText("IP:", "center", 10, 100, 125, font[64], {255, 128, 50}))
screen_addRight(screen["things"], "ip", newEditText(net_ip, 0, 10, 1250, 125, font[64], {255, 128, 50}))

screen_add(screen, "buttons", newChild("center", 500, 500, 500))
screen_addTop(screen["buttons"], "host", newTextButton("Join", "center", 0, 500, 216, font[64], {96, 48, 16}, scrJoin))
function scr_back() state = STATE_CHOOSEPLAY end
screen_addBottom(screen["buttons"], "back", newTextButton("Back", "center", "center", 500, 216, font[64], {96, 48, 16}, scr_back))

screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))

addScreen(STATE_JOINSERVER, screen)