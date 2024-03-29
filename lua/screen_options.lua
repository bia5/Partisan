screen = newChild(0, 0, 1920, 1080)

screen_add(screen, 1, newSprite("art_tree", 0, 0, 1920, 1080))
screen_addTop(screen, 2, newText("Options", "center", 10, 230, 80, {255, 128, 50}))

screen_add(screen, "settings", newChild(0, 100, 1920, 830))
for k,v in pairs(settings) do
    screen_addTop(screen["settings"], k, newChild(0, 0, 1920, 100))
    screen_addLeft(screen["settings"][k], "name", newText(v.name, 0,"center", 1920/2, 100, {223, 96, 50}))

    t = type(v.value)
    if t == "string" then
        screen_add(screen["settings"][k], "value", newEditText(v.value, 1920/2, "center", 1920/2, 100, {128,32,25}))
    end
end

screen_add(screen, "bottom_buttons", newChild(0, 930, 1920, 150))
function scr_Back()

    settings.player_name.value = getScreen(STATE_OPTIONS)["settings"]["player_name"]["value"].text
    variables_save()
    state = STATE_MAINMENU
end
screen_add(screen["bottom_buttons"], "back", newTextButton("Back", "center", "center", 230, 100, {96, 48, 16}, scr_Back))

addScreen(STATE_OPTIONS, screen)