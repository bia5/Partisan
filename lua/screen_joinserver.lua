screen = newChild(0, 0, 1920, 1080)

function scrJoin()
    isHosting = false

    --net_ip = ip["ip"]

	saveTable(mya_getPath().."lastip.save",ip)
	network_start()
	state = STATE_HOST
end

function scrBack()
    state = STATE_CHOOSEPLAY
end

screen_addTop(screen, "tv_join", newText("Join Server", "center", 10, 350, 80, font[64], {255, 128, 50}))

screen_add(screen, "things", newChild("center", "center", 1440, 880))

addScreen(STATE_JOINSERVER, screen)