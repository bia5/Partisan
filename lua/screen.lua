--SCREEN HANDLER
screens = {}
sprite_empty = Sprite.new(assets:getTexture("empty"))

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
                if v.render then
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
                    elseif v.id == "togglebutton" then
                        if screen_debug then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        end
                        v.sprite:setX((v.x + offsetX) * width_ratio)
                        v.sprite:setY((v.y + offsetY) * height_ratio)
                        v.sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        if v.toggle then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        end
                    elseif v.id == "text" then
                        wR = ((v.w * width_ratio) / v.tv:getWidth())
                        hR = ((v.h * height_ratio) / v.tv:getHeight())
                        if screen_debug then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                            child_sprite:render(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        end
                        v.tv:setText(v.text, mya_getRenderer())
                        centerOffsetX = 0
                        centerOffsetY = 0
                        if v.centeredX then
                            centerOffsetX = -(v.tv:getWidth()*v.ratio)/4
                        end
                        if v.centeredY then
                            centerOffsetY = -(v.tv:getHeight()*v.ratio)/2
                        end
                        v.tv:setXY((v.x + offsetX+centerOffsetX) * width_ratio, (v.y + offsetY+centerOffsetY) * height_ratio)
                        if v.stretch == true then
                            v.tv:renderWH(mya_getRenderer(), (v.w * wR)*v.ratio, (v.h * hR)*v.ratio)
                        else
                            v.tv:renderWH(mya_getRenderer(), (v.tv:getWidth() * wR)*v.ratio, (v.tv:getHeight() * hR)*v.ratio)
                        end
                    elseif v.id == "etext" then
                        hR = ((v.h * height_ratio) / v.tv:getHeight())
                        if screen_debug then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                            child_sprite:render(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        end
                        if v.editing then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        end
                        child_sprite:setX((v.x + offsetX) * width_ratio)
                        child_sprite:setY((v.y + offsetY) * height_ratio)
                        child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        v.tv:setText(v.text, mya_getRenderer())
                        v.tv:setXY((v.x + offsetX) * width_ratio, (v.y + offsetY) * height_ratio)
                        v.tv:renderWH(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                    elseif v.id == "tbutton" then
                        hR = (((v.h * height_ratio) / v.tv:getHeight()))*v.textRatio
                        v.sprite:setX((v.x + offsetX) * width_ratio)
                        v.sprite:setY((v.y + offsetY) * height_ratio)
                        v.sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        
                        v.tv:setText(v.text, mya_getRenderer())
                        v.tv:setXY(((v.x + offsetX) * width_ratio)+(((v.w * width_ratio)/2)-((v.tv:getWidth() * hR)/2)), ((v.y + offsetY) * height_ratio)+(((v.h*height_ratio)/2)-((v.tv:getHeight() * hR)/2)))
                        v.tv:renderWH(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        
                        if screen_debug then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                            child_sprite:setX(((v.x + offsetX) * width_ratio)+(((v.w * width_ratio)/2)-((v.tv:getWidth() * hR)/2)))
                            child_sprite:setY(((v.y + offsetY) * height_ratio)+(((v.h*height_ratio)/2)-((v.tv:getHeight() * hR)/2)))
                            child_sprite:render(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        end
                    elseif v.id == "ttbutton" then
                        hR = (((v.h * height_ratio) / v.tv:getHeight()))*v.textRatio
                        v.sprite:setX((v.x + offsetX) * width_ratio)
                        v.sprite:setY((v.y + offsetY) * height_ratio)
                        v.sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        
                        if v.toggle then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        end

                        v.tv:setText(v.text, mya_getRenderer())
                        v.tv:setXY(((v.x + offsetX) * width_ratio)+(((v.w * width_ratio)/2)-((v.tv:getWidth() * hR)/2)), ((v.y + offsetY) * height_ratio)+(((v.h*height_ratio)/2)-((v.tv:getHeight() * hR)/2)))
                        v.tv:renderWH(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        
                        if screen_debug then
                            child_sprite:setX((v.x + offsetX) * width_ratio)
                            child_sprite:setY((v.y + offsetY) * height_ratio)
                            child_sprite:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                            child_sprite:setX(((v.x + offsetX) * width_ratio)+(((v.w * width_ratio)/2)-((v.tv:getWidth() * hR)/2)))
                            child_sprite:setY(((v.y + offsetY) * height_ratio)+(((v.h*height_ratio)/2)-((v.tv:getHeight() * hR)/2)))
                            child_sprite:render(mya_getRenderer(), (v.tv:getWidth() * hR), (v.tv:getHeight() * hR))
                        end
                    elseif v.id == "loadingbar" then
                        sprite_empty:setX((v.x + offsetX) * width_ratio)
                        sprite_empty:setY((v.y + offsetY) * height_ratio)
                        sprite_empty:setRenderOutline(true)
                        sprite_empty:setOutlineColor(v.color1[1], v.color1[2], v.color1[3], 255)
                        sprite_empty:render(mya_getRenderer(), v.w * width_ratio, v.h * height_ratio)
                        sprite_empty:setOutlineColor(v.color2[1], v.color2[2], v.color2[3], 255)
                        sprite_empty:render(mya_getRenderer(), (v.w*v.ratio) * width_ratio, v.h * height_ratio)
                    end
                end
            end
        end
    end
end

function render(screen)
    if screen.onRender then
        screen:onRender()
    end
    renderChild(screen, 0, 0)
end

function update(screen)
    if screen ~= nil then
        if screen.onUpdate then
            screen:onUpdate()
        end
    end
end

function tupdate(screen)
    if screen ~= nil then
        if screen.onTUpdate then
            screen:onTUpdate()
        end
    end
end

function mouseButtonDown(screen, button, offsetX, offsetY)
    local width_ratio = mya_getWidth() / 1920
    local height_ratio = mya_getHeight() / 1080

    if screen ~= nil then
        for k, v in pairs(screen) do
            if type(v) == "table" then
                if v.render then
                    if v.id == "child" then
                        mouseButtonDown(v, button, offsetX + v.x, offsetY + v.y)
                    elseif v.id == "button" or v.id == "tbutton" or v.id == "togglebutton" or v.id == "ttbutton" then
                        x = (v.x + offsetX)*width_ratio
                        y = (v.y + offsetY)*height_ratio
                        w = (v.x + v.w + offsetX)*width_ratio
                        h = (v.y + v.h + offsetY)*height_ratio
                        if mouseX > x and mouseX < w and mouseY > y and mouseY < h then
                            v.clicked = true
                            v.sprite:setRenderOutline(true)
                        end
                    end
                end
            end
        end
    end
end

function mouseButtonUp(screen, button, offsetX, offsetY)
    local width_ratio = mya_getWidth() / 1920
    local height_ratio = mya_getHeight() / 1080
    edit = false

    if screen ~= nil then
        for k, v in pairs(screen) do
            if type(v) == "table" then
                if v.id == "child" then
                    if screen.render and v.render then
                        ed = mouseButtonUp(v, button, offsetX + v.x, offsetY + v.y)
                        if ed then
                            edit = true
                        end
                    end
                elseif v.id == "button" or v.id == "tbutton" or v.id == "togglebutton" or v.id == "ttbutton" then
                    if screen.render and v.render then
                        if v.clicked then
                            if v.id == "togglebutton" or v.id == "ttbutton" then
                                v.toggle = not v.toggle
                            end
                            v.clicked = false
                            v.sprite:setRenderOutline(false)
                            if v.render and v.onClick then
                                if v.args then
                                    v.onClick(v.args)
                                else
                                    v.onClick()
                                end
                            end
                        end
                    end
                elseif v.id == "etext" then
                    if screen.render and v.render then
                        x = (v.x + offsetX)*width_ratio
                        y = (v.y + offsetY)*height_ratio
                        w = (v.x + v.w + offsetX)*width_ratio
                        h = (v.y + v.h + offsetY)*height_ratio

                        if mouseX > x and mouseX < w and mouseY > y and mouseY < h then
                            v.editing = true
                            edit = true
                        else
                            v.editing = false
                        end
                    end
                end
            end
        end
    end

    return edit
end

upspace = false
function keyDown(screen, key)
    if screen ~= nil then
        for k, v in pairs(screen) do
            if type(v) == "table" then
                if v.id == "child" then
                    keyDown(v, key)
                elseif v.id == "etext" then
                    if v.editing then
                        if key == "Backspace" then
                            backspace = false
                            v.text = string.sub(v.text, 1, -2)
                        elseif key == "Return" or key == "Tab" or key == "Escape" then
                            v.editing = false
                        elseif key == "Space" then
                            v.text = v.text .. " "
                        elseif key == "LSHIFT" then
                            upspace = true
                        elseif key == "RSHIFT" then
                            upspace = true
                        else
                            if upspace then
                                if key == ";" then
                                    v.text = v.text .. ":"
                                elseif key == "," then
                                    v.text = v.text .. "<"
                                elseif key == "." then
                                    v.text = v.text .. ">"
                                elseif key == "/" then
                                    v.text = v.text .. "?"
                                elseif key == "\\" then
                                    v.text = v.text .. "|"
                                elseif key == "=" then
                                    v.text = v.text .. "+"
                                elseif key == "-" then
                                    v.text = v.text .. "_"
                                elseif key == "`" then
                                    v.text = v.text .. "~"
                                elseif key == "1" then
                                    v.text = v.text .. "!"
                                elseif key == "2" then
                                    v.text = v.text .. "@"
                                elseif key == "3" then
                                    v.text = v.text .. "#"
                                elseif key == "4" then
                                    v.text = v.text .. "$"
                                elseif key == "5" then
                                    v.text = v.text .. "%"
                                elseif key == "6" then
                                    v.text = v.text .. "^"
                                elseif key == "7" then
                                    v.text = v.text .. "&"
                                elseif key == "8" then
                                    v.text = v.text .. "*"
                                elseif key == "9" then
                                    v.text = v.text .. "("
                                elseif key == "0" then
                                    v.text = v.text .. ")"
                                else
                                    v.text = v.text .. key
                                end
                            else
                                if type(key) == "table" then
                                    tprint(key)
                                end
                                v.text = v.text .. string.lower(key)
                            end
                        end
                    end
                end
            end
        end
    end
end

function keyUp(screen, key)
    if key == "LSHIFT" then
        upspace = false
    elseif key == "RSHIFT" then
        upspace = false
    end
end

function screen_addLeft(child, obj_name, obj)
    if obj.x == "center" then
        obj.x = (child.w / 2) - (obj.w / 2)
    end
    if obj.y == "center" then
        obj.y = (child.h / 2) - (obj.h / 2)
    end

    obj.x = child.left
    child.left = child.left + obj.w
    child[obj_name] = obj
end

function screen_addRight(child, obj_name, obj)
    if obj.x == "center" then
        obj.x = (child.w / 2) - (obj.w / 2)
    end
    if obj.y == "center" then
        obj.y = (child.h / 2) - (obj.h / 2)
    end

    obj.x = child.right - obj.w
    child.right = child.right - obj.w
    child[obj_name] = obj
end

function screen_addTop(child, obj_name, obj)
    if obj.x == "center" then
        obj.x = (child.w / 2) - (obj.w / 2)
    end
    if obj.y == "center" then
        obj.y = (child.h / 2) - (obj.h / 2)
    end

    obj.y = child.top
    child.top = child.top + obj.h
    child[obj_name] = obj
end

function screen_addBottom(child, obj_name, obj)
    if obj.x == "center" then
        obj.x = (child.w / 2) - (obj.w / 2)
    end
    if obj.y == "center" then
        obj.y = (child.h / 2) - (obj.h / 2)
    end

    obj.y = child.bottom - obj.h
    child.bottom = child.bottom - obj.h
    child[obj_name] = obj
end

function screen_add(child, obj_name, obj)
    if obj.x == "center" then
        obj.x = (child.w / 2) - (obj.w / 2)
    end
    if obj.y == "center" then
        obj.y = (child.h / 2) - (obj.h / 2)
    end
    child[obj_name] = obj
end

function isCursorIn(child)
    local width_ratio = mya_getWidth() / 1920
    local height_ratio = mya_getHeight() / 1080

    if mouseX > child.x*width_ratio and mouseX < (child.x + child.w)*width_ratio and mouseY > child.y*height_ratio and mouseY < (child.y + child.h)*height_ratio then
        return true
    end
    return false
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

    child.render = true

    child.onMouseButtonUp = nil
    child.onMouseButtonDown = nil
    
    child.onUpdate = nil
    child.onTUpdate = nil
    child.onRender = nil

    return child
end

function newEmpty(x, y, w, h)
    empty = {}

    empty.id = "empty"
    empty.x = x
    empty.y = y
    empty.w = w
    empty.h = h
    empty.render = false

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

    sprite.render = true
    
    return sprite
end

function newButton(tex, x, y, width, height, onClick, _args)
    button = {}

    button.id = "button"
    button.sprite = Sprite.new(assets:getTexture(tex))
    button.sprite:setOutlineColor(0, 0, 0, 64)

    button.tex = tex
    button.x = x
    button.y = y
    button.w = width
    button.h = height

    button.render = true

    button.hovering = false
    button.clicked = false
    button.onClick = onClick

    button.args = _args

    return button
end

function newText(_text, x, y, width, height, color)
    text = {}

    xx = x
    yy = y
    
    text.centeredX = false
    text.centeredY = false
    if x == "center" then
        xx = 0
        text.centeredX = true
    end
    if y == "center" then
        yy = 0
        text.centeredY = true
    end

    text.id = "text"
    text.tv = TextView.new(font, _text, xx, yy, mya_getRenderer())
    text.tv:setColor(mya_getRenderer(), color[1], color[2], color[3])

    text.text = _text
    text.x = x
    text.y = y

    text.stretch = false
    text.ratio = 1

    if width == 0 then
        text.w = text.tv:getWidth()
    else
        text.w = width
    end

    if height == 0 then
        text.h = text.tv:getHeight()
    else
        text.h = height
    end

    text.render = true

    return text
end

function newEditText(defaultText, x, y, width, height, color)
    text = {}

    xx = x
    yy = y
    if x == "center" then
        xx = 0
    end
    if y == "center" then
        yy = 0
    end

    text.id = "etext"
    text.tv = TextView.new(font, defaultText, xx, yy, mya_getRenderer())
    text.tv:setColor(mya_getRenderer(), color[1], color[2], color[3])

    text.text = defaultText
    text.x = x
    text.y = y
    text.w = width
    text.h = height

    text.render = true
    text.editing = false

    return text
end

function newTextButton(defaultText, x, y, w, h, color, onClick)
    button = {}

    button.id = "tbutton"
    button.sprite = Sprite.new(assets:getTexture("button"))
    button.sprite:setOutlineColor(0, 0, 0, 64)

    button.tv = TextView.new(font, defaultText, xx, yy, mya_getRenderer())
    button.tv:setColor(mya_getRenderer(), color[1], color[2], color[3])
    button.textRatio = 1

    button.text = defaultText
    button.x = x
    button.y = y
    button.w = w
    button.h = h

    button.render = true

    button.hovering = false
    button.clicked = false
    button.onClick = onClick
    
    return button
end

function newTextToggleButton(defaultText, x, y, w, h, color, onClick)
    button = {}

    button.id = "ttbutton"
    button.sprite = Sprite.new(assets:getTexture("button"))
    button.sprite:setOutlineColor(0, 0, 0, 64)

    button.tv = TextView.new(font, defaultText, xx, yy, mya_getRenderer())
    button.tv:setColor(mya_getRenderer(), color[1], color[2], color[3])
    button.textRatio = 1

    button.text = defaultText
    button.x = x
    button.y = y
    button.w = w
    button.h = h
    button.toggle = false

    button.render = true

    button.hovering = false
    button.clicked = false
    button.onClick = onClick
    
    return button
end

function newToggleButton(tex, x, y, width, height, onClick)
    button = {}

    button.id = "togglebutton"
    button.sprite = Sprite.new(assets:getTexture(tex))
    button.sprite:setOutlineColor(0, 0, 0, 64)

    button.tex = tex
    button.x = x
    button.y = y
    button.w = width
    button.h = height
    button.toggle = false

    button.render = true

    button.hovering = false
    button.clicked = false
    button.onClick = onClick
    
    return button
end

function newLoadingBar(x, y, width, height, color1, color2)
    bar = {}

    bar.id = "loadingbar"
    bar.x = x
    bar.y = y
    bar.w = width
    bar.h = height

    bar.ratio = 1

    bar.render = true

    bar.color1 = color1
    bar.color2 = color2

    return bar
end