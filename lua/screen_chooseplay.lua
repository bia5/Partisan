screen = newChild(0, 0, 1920, 1080)

function scr_leveleditor()
    registerBind("w", "Up", player_up_le)
    registerBind("s", "Down", player_down_le)
    registerBind("a", "Left", player_left_le)
    registerBind("d", "Right", player_right_le)

    state = STATE_LEVELEDITOR
end
screen["debug_leveleditor"] = newButton("button_leveleditor", 0, 0, 120, 68, scr_leveleditor)

screen["buttons"] = newChild("center", "center", 960, 864)

function scr_joinServer()
    registerBind("w", "Up", player_up)
    registerBind("s", "Down", player_down)
    registerBind("a", "Left", player_left)
    registerBind("d", "Right", player_right)

    state = STATE_JOINSERVER 
end
screen["buttons"]["join"] = newButton("button_joinserver", "center", "center", 960, 216, scr_joinServer)

function scr_host()
    isHosting = true
    network_start()

    registerBind("w", "Up", player_up)
    registerBind("s", "Down", player_down)
    registerBind("a", "Left", player_left)
    registerBind("d", "Right", player_right)

    state = STATE_HOST 
end
screen_addTop(screen["buttons"], "host", newButton("button_host", "center", 0, 960, 216, scr_host))

function scr_back() state = STATE_MAINMENU end
screen_addBottom(screen["buttons"], "back", newButton("button_back", "center", "center", 960, 216, scr_back))

addScreen(STATE_CHOOSEPLAY, screen)