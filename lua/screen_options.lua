screen = newChild(0, 0, 1920, 1080)

screen_add(screen, "settings", newChild(0, 100, 1920, 830))
for k,v in pairs(settings) do
    screen_addTop(screen["settings"], k, newChild(0, 0, 1920, 100))
    screen_addLeft(screen["settings"][k], "name", newText(v.name, 0,"center", 1920/2, 100, font[64], {223, 96, 50}))

    t = type(v.value)
    if t == "string" then
        screen_add(screen["settings"][k], "value", newEditText(v.value, 1920/2, "center", 1920/2, 100, font[64], {128,32,25}))
    end
end

screen_add(screen, "bottom_buttons", newChild(0, 930, 1920, 150))
function scrBack()
    variables_save()
    state = STATE_MAINMENU
end
screen_add(screen["bottom_buttons"], "back", newButton("button_back", "center", "center", 380, 100, scrBack))

function _update(screen)
    settings.player_name.value = screen["settings"]["player_name"]["value"].text
end
screen.update = _update

screen_addTop(screen, 1, newText("Options", "center", 10, 230, 80, font[64], {255, 128, 50}))
screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))

addScreen(STATE_OPTIONS, screen)