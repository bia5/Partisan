screen = newChild(0, 0, 1920, 1080)
local selected_level = "world" --selected world level

screen_addTop(screen, "tv_host", newText("Host Server", "center", 10, 350, 80, {255, 128, 50}))

screen_add(screen, "footer", newChild(0, 930, 1920, 150))

screen_addLeft(screen["footer"], "left", newChild(0, "center", 960, 150))
function scr_host_back() 
    event_quit()
    state = STATE_CHOOSEPLAY 
end
screen_add(screen["footer"]["left"], "back", newTextButton("Back", "center", "center", 230, 100, {96, 48, 16}, scr_host_back))

screen_addRight(screen["footer"], "right", newChild(0, "center", 960, 150))
function scr_host_play()
    --Make players load level
    server_message(NET_MSG_LOADLEVEL,{world_id = selected_level})

    --Switch clients screen to in game
    server_message(NET_MSG_SWITCHSCREEN, {state = STATE_INGAME})
end
screen_add(screen["footer"]["right"], "play", newTextButton("Play", "center", "center", 230, 100, {96, 48, 16}, scr_host_play))
screen["footer"]["right"]["play"].render = isHosting


screen_add(screen, "content", newChild(0, 150, 1920, 730))
screen_addLeft(screen["content"], "clients", newChild(0, 0, 950, 730))
screen_addRight(screen["content"], "settings", newChild(0, 0, 950, 730))

screen_addTop(screen["content"]["clients"], "player1", newChild(0, 0, 950, 360))
screen_addBottom(screen["content"]["clients"], "player2", newChild(0, 0, 950, 360))

for i=1,2 do
    screen_addTop(screen["content"]["clients"]["player"..i], "player", newText("Player "..i, "center", "center", 950, 69, {255, 128, 50}))
    screen_addTop(screen["content"]["clients"]["player"..i], "name", newText("Name", "center", "center", 950, 69, {255, 128, 50}))
    screen_addTop(screen["content"]["clients"]["player"..i], "ping", newText("Ping", "center", "center", 950, 69, {255, 128, 50}))
end
screen["content"]["clients"]["player1"]["player"].text = "Player 1 (host)"

function screen_host_update()
    local scr = getScreen(STATE_HOST)


    local cl = {}
    for k, v in pairs(clients_simplified) do
        table.insert(cl,v)
    end
    
    local is = true
    for x=1,2 do
        local c = cl[x]
        if c then
            if c.isMainPlayer then
                i = 1
                is = false
            else
                i = 2
            end

            scr["content"]["clients"]["player"..i]["name"].text = "Name: "..c.name
            scr["content"]["clients"]["player"..i]["ping"].text = "Ping: "..c.ping.."(ms)"
        else
            if is then
                i = 1
            else
                i = 2
            end

            scr["content"]["clients"]["player"..i]["name"].text = "[OPEN]"
            scr["content"]["clients"]["player"..i]["ping"].text = ""
        end
    end
end
screen.onUpdate = screen_host_update

screen_add(screen, "bkgrd", newSprite("art_tree", 0, 0, 1920, 1080))
addScreen(STATE_HOST, screen)