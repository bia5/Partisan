screen = newChild(0, 0, 1920, 1080)

screen_add(screen, "settings", newChild(0, 100, 1920, 830))
for k,v in pairs(settings) do
    screen_addTop(screen["settings"], k, newChild(0, 0, 1920, 50))
    screen_addLeft(screen["settings"][k], "name", newText(v.name, 0,"center", 1920/2, 50, font[64], {32, 32, 32}))

    t = type(v.value)
    if t == "string" then
        screen_add(screen["settings"][k], "value", newEditText(v.value, 1920/2, "center", 1920/2, 50, font[64], {32,32,32}))
    end
end

screen_add(screen, "bottom_buttons", newChild(0, 930, 1920, 150))
function scrBack()
    variables_save()
    state = STATE_MAINMENU
end
screen_add(screen["bottom_buttons"], "back", newButton("button_back", "center", "center", 380, 100, scrBack))

function update()
    settings.player_name.value = screen["settings"]["player_name"]["value"].text
end
screen.update = update

screen_addTop(screen, 1, newText("Options", "center", 10, 1920/8, 80, font[64], {255, 128, 50}))
screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))

addScreen(STATE_OPTIONS, screen)