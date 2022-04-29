screen = newChild(0, 0, 1920, 1080)

function scr_leveleditor()
    registerBind("W", "Up", player_up_le)
    registerBind("S", "Down", player_down_le)
    registerBind("A", "Left", player_left_le)
    registerBind("D", "Right", player_right_le)

    state = STATE_LEVELEDITOR
end
screen_add(screen, "debug_leveleditor", newButton("button_leveleditor", 0, 0, 120, 68, scr_leveleditor))

screen_add(screen, "buttons", newChild("center", "center", 500, 864))

function scr_joinServer()
    registerBind("W", "Up", player_up)
    registerBind("S", "Down", player_down)
    registerBind("A", "Left", player_left)
    registerBind("D", "Right", player_right)

    state = STATE_JOINSERVER 
end
screen_add(screen["buttons"], "join", newTextButton("Join", "center", "center", 500, 216, font[64], {96, 48, 16}, scr_joinServer))

function scr_host()
    isHosting = true
    network_start()

    registerBind("W", "Up", player_up)
    registerBind("S", "Down", player_down)
    registerBind("A", "Left", player_left)
    registerBind("D", "Right", player_right)

    state = STATE_HOST 
end
screen_addTop(screen["buttons"], "host", newTextButton("Host", "center", 0, 500, 216, font[64], {96, 48, 16}, scr_host))

function scr_back() state = STATE_MAINMENU end
screen_addBottom(screen["buttons"], "back", newTextButton("Back", "center", "center", 500, 216, font[64], {96, 48, 16}, scr_back))

screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))

addScreen(STATE_CHOOSEPLAY, screen)