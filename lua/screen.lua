screen_debug = false

--SCREEN HANDLER
screens = {}

function addScreen(_state, screen)
    screens[_state] = screen
end

function getScreen(_state)
    return screens[_state]
end

child_sprite = Sprite.new(assets:getTexture("empty"))
child_sprite:setRenderOutline(true)
child_sprite:setOutlineColor(255, 255, 255, 64)

function renderChild(child, offsetX, offsetY)
    if child ~= nil then
        local width_ratio = mya_getWidth() / 1920
        local height_ratio = mya_getHeight() / 1080
        for k, v in pairs(child) do
            if type(v) == "table" then
                if v.x == "center" then
                    v.x = (child.w / 2) - (v.w / 2)
                end
                if v.y == "center" then
                    v.y = (child.h / 2) - (v.h / 2)
                end
                
                if v.id == "child" then
                    if screen_debug then
                        child_sprite:setX((v.x + offsetX) * width_ratio)
                        child_sprite:setY((v.y + offsetY) * height_ratio)
                        child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                    end
                    renderChild(v, offsetX + v.x, offsetY + v.y)
                elseif v.id == "sprite" then
                    if screen_debug then
                        child_sprite:setX((v.x + offsetX) * width_ratio)
                        child_sprite:setY((v.y + offsetY) * height_ratio)
                        child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                    end
                    v.sprite:setX((v.x + offsetX) * width_ratio)
                    v.sprite:setY((v.y + offsetY) * height_ratio)
                    v.sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                elseif v.id == "button" then
                    if screen_debug then
                        child_sprite:setX((v.x + offsetX) * width_ratio)
                        child_sprite:setY((v.y + offsetY) * height_ratio)
                        child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                    end
                    v.sprite:setX((v.x + offsetX) * width_ratio)
                    v.sprite:setY((v.y + offsetY) * height_ratio)
                    v.sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                end
            end
        end
    end
end

function render(screen)
    local width_ratio = mya_getWidth() / 1920
    local height_ratio = mya_getHeight() / 1080

    renderChild(screen, 0, 0)
end

function mouseMotion(child, x, y)
    
end

function mouseButtonDown(screen, button)
    if screen ~= nil then
        for k, v in pairs(screen) do
            if type(v) == "table" then
                if v.id == "child" then
                    mouseButtonDown(v, button)
                elseif v.id == "button" then
                    if v.sprite:isPointColliding(mouseX,mouseY) then
                        v.clicked = true
                        v.sprite:setRenderOutline(true)
                    end
                end
            end
        end
    end
end

function mouseButtonUp(screen, button)
    if screen ~= nil then
        for k, v in pairs(screen) do
            if type(v) == "table" then
                if v.id == "child" then
                    mouseButtonUp(v, button)
                elseif v.id == "button" then
                    if v.clicked then
                        v.clicked = false
                        v.sprite:setRenderOutline(false)
                        if v.onClick then
                            v.onClick()
                        end
                    end
                end
            end
        end
    end
end


--OBJECTS
function newChild(x, y, w, h)
    child = {}

    child.id = "child"
    child.x = x
    child.y = y
    child.w = w
    child.h = h

    child.left = 0
    child.right = w
    child.top = 0
    child.bottom = h

    return child
end

function screen_addLeft(child, obj_name, obj)
    obj.x = child.left
    child.left = child.left + obj.w
    child[obj_name] = obj
end

function screen_addRight(child, obj_name, obj)
    obj.x = child.right - obj.w
    child.right = child.right - obj.w
    child[obj_name] = obj
end

function screen_addTop(child, obj_name, obj)
    obj.y = child.top
    child.top = child.top + obj.h
    child[obj_name] = obj
end

function screen_addBottom(child, obj_name, obj)
    obj.y = child.bottom - obj.h
    child.bottom = child.bottom - obj.h
    child[obj_name] = obj
end

function newEmpty(x, y, w, h)
    empty = {}

    empty.id = "empty"
    empty.x = x
    empty.y = y
    empty.w = w
    empty.h = h

    return empty
end

function newSprite(tex, x, y, width, height)
    sprite = {}

    sprite.id = "sprite"
    sprite.sprite = Sprite.new(assets:getTexture(tex))
    sprite.tex = tex
    sprite.x = x
    sprite.y = y
    sprite.w = width
    sprite.h = height
    
    return sprite
end

function newButton(tex, x, y, width, height, onClick)
    button = {}

    button.id = "button"
    button.sprite = Sprite.new(assets:getTexture(tex))
    button.sprite:setOutlineColor(0, 0, 0, 64)

    button.tex = tex
    button.x = x
    button.y = y
    button.w = width
    button.h = height

    button.hovering = false
    button.clicked = false
    button.onClick = onClick
    
    return button
end