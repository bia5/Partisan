local screen_cp_host = Sprite.new(assets:getTexture("button_host"))
local screen_cp_join = Sprite.new(assets:getTexture("button_joinserver"))
local screen_cp_back = Sprite.new(assets:getTexture("button_back"))
local screen_cp_lvleditor = Sprite.new(assets:getTexture("button_leveleditor"))

function screen_cp_windowResize(w, h)
    screen_cp_host:setX(mya_getWidth()/4)
    screen_cp_host:setY(mya_getHeight()/10)
    screen_cp_join:setX(mya_getWidth()/4)
    screen_cp_join:setY(mya_getHeight()/10*4)
    screen_cp_back:setX(mya_getWidth()/4)
    screen_cp_back:setY(mya_getHeight()/10*7)
end
screen_cp_windowResize(mya_getWidth(),mya_getHeight())

function screen_cp_render()
    screen_cp_host:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
    screen_cp_join:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
    screen_cp_back:render(mya_getRenderer(), mya_getWidth()/2, mya_getHeight()/5)
    if devmode then
        screen_cp_lvleditor:render(mya_getRenderer(), mya_getWidth()/16, mya_getHeight()/16)
    end
end

function screen_cp_mouseButtonUp(btn)
    if btn == "left" then
        if screen_cp_host:isPointColliding(mouseX, mouseY) then
            isHosting = true
            network_start()
            
            state = STATE_HOST

            registerBind("w", "Up", player_up)
            registerBind("s", "Down", player_down)
            registerBind("a", "Left", player_left)
            registerBind("d", "Right", player_right)
        end
        if screen_cp_join:isPointColliding(mouseX, mouseY) then
            state = STATE_JOINSERVER

            registerBind("w", "Up", player_up)
            registerBind("s", "Down", player_down)
            registerBind("a", "Left", player_left)
            registerBind("d", "Right", player_right)
        end
        if screen_cp_back:isPointColliding(mouseX, mouseY) then
            state = STATE_MAINMENU
        end
        if devmode then
            if screen_cp_lvleditor:isPointColliding(mouseX, mouseY) then
                state = STATE_LEVELEDITOR
                registerBind("w", "Up", player_up_le)
                registerBind("s", "Down", player_down_le)
                registerBind("a", "Left", player_left_le)
                registerBind("d", "Right", player_right_le)
            end
        end
    end
end