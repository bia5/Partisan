--This whole file barely has any comments and it scares me :(

--Variables
local bearDist_wander = 10

local bearDist_toSentry = 45
local bearSpeed_sentry = 3

local bearDist_toAnger = 25
local bearSpeed_anger = 2

local bearDist_toChase = 15
local bearDist_toChaseWhenAngry = 20
local bearDist_toCalmFromAnger = 35
local bearSpeed_chase = 2.5

local bearDist_toAttack = 3

local bearDist_toSwing = 1
local bearDist_swingReach = 2.5
local bearTime_swing = .5
local bearDmg_swing = 15
local bearSpeed_swing = 3

function spawnBoss_Bear(x,y)
    local bear = newEntity("boss_bear")
    bear.x = x
    bear.y = y
    bear.w = 1.9
    bear.h = 1.9
    bear.velX = 0
    bear.velY = 0
    bear.onUpdate = "boss_bear_update"
    bear.onTUpdate = "boss_bear_tupdate"
    bear.onCollision = "boss_bear_collision"
    bear.hp = 1250 --thickkk as fuckkkkk
    bear.data = "0,"..x..","..y..",".."idle" --timer,x,y,state
    bear.tex = "angry_bear_idle"
    bear.maxhp = 1250

    bear.speed = 2

    print("spawn bear")
    print("nil -> idle")

    return bear
end

function bear_closeToTarget(bear, dist)
    if dist == nil then
        dist = .1
    end
    local strs = mysplit(bear.data, ",")
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])

    return bear.x < tX + dist and bear.x > tX - dist and bear.y < tY + dist and bear.y > tY - dist  
end

function bear_walk(bear)
    local strs = mysplit(bear.data, ",")
    local timer = tonumber(strs[1])
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])
    local bState = strs[4]

    local speed = bear.speed*(mya_getDelta()/1000)
    x = 0
	y = 0
    dist = .5

    if not (bear.x < tX + dist and bear.x > tX - dist) then
        if tX-bear.x >= 0 then
            bear.velX = bear.speed
        else
            bear.velX = -bear.speed
        end
    end
    
    if not (bear.y < tY + dist and bear.y > tY - dist) then
        if tY-bear.y >= 0 then
            bear.velY = bear.speed
        else
            bear.velY = -bear.speed
        end
    end

    if bear.velX > 0 then
        if not isEntityCollision(bear, speed, 0) then
            x=x+1
        end
    elseif bear.velX < 0 then
        if not isEntityCollision(bear, -speed, 0) then
            x=x-1
        end
    end

    if bear.velY > 0 then
        if not isEntityCollision(bear, 0, speed) then
            y=y+1
        end
    elseif bear.velY < 0 then
        if not isEntityCollision(bear, 0, -speed) then
            y=y-1
        end
    end
    --print(x..","..y)
    if x ~= 0 or y ~= 0 then
        rad = math.atan2(y, x)
        bear.x = bear.x + (math.cos(rad) * speed)
        bear.y = bear.y + (math.sin(rad) * speed)
    else
        return false
    end

    if bear.x > tX-.5 and bear.x < tX+.5 then
        bear.velX = 0
    end
    if bear.y > tY-.5 and bear.y < tY+.5 then
        bear.velY = 0
    end
    return true
end

function bear_clearPath(bear, x, y)
    speed = .1
    dist = .5

    while true do
        finish = true
        if not (x > -dist and x < dist) then
            finish = false
            if x > 0 then
                x = x - speed
            else
                x = x + speed
            end
        end

        if not (y > -dist and y < dist) then
            finish = false

            if y > 0 then
                y=y-speed
            else
                y=y+speed
            end
        end
        
        local e = isEntityCollision(bear, x, y,false)
        if e ~= false then
            return false
        end

        if finish then
            return true
        end
    end
end

--Bear AI
function ef_boss_bear_update(bear)
    local strs = mysplit(bear.data, ",")
    local timer = tonumber(strs[1])
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])
    local bState = strs[4]

    local anger = 1-(bear.hp/bear.maxhp)

    if bState == "idle" then
        for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-bear.x
            local ry = y-bear.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < bearDist_toSentry then
                bState = "sentry"
                break
            end
        end

    elseif bState == "sentry" then
        bear.speed = bearSpeed_sentry

        for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-bear.x
            local ry = y-bear.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < bearDist_toAnger then
                bState = "angrysentry"
                break
            end
        end
        --why the fuck did i add this if statement... its funny now so it stays.
        if bState == "sentry" then
            --if is close to target change target
            if bear_closeToTarget(bear) then
                local ran = math.random(1, 100)
                if ran == 1 then
                    bState = "forceidle"
                end

                passed = false
                while passed == false do
                    _tX = math.random(-bearDist_wander, bearDist_wander)
                    _tY = math.random(-bearDist_wander, bearDist_wander)

                    if bear_clearPath(bear, _tX, _tY) then
                        passed = true
                        tX = _tX+bear.x
                        tY = _tY+bear.y
                    end
                end
            else
                bear_walk(bear)
            end
        end

    elseif bState == "forceidle" then
        for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-bear.x
            local ry = y-bear.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < bearDist_toAnger then
                if dist < distance then
                    distance = dist
                end

                _tX = v.x - bear.x
                _tY = v.y - bear.y

                if bear_clearPath(bear, _tX, _tY) then
                    bState = "chase"
                    tX = _tX+bear.x
                    tY = _tY+bear.y
                    break
                end
            end
        end
        if bState == "forceidle" then
            local ran = math.random(1, 1000)
            if ran == 1 then
                bState = "sentry"
            end
        end

    elseif bState == "angrysentry" then
        bear.speed = bearSpeed_anger

        distance = bearDist_toCalmFromAnger+5
        for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-bear.x
            local ry = y-bear.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < bearDist_toChaseWhenAngry then
                if dist < distance then
                    distance = dist
                end

                _tX = v.x - bear.x
                _tY = v.y - bear.y

                if bear_clearPath(bear, _tX, _tY) then
                    bState = "chase"
                    tX = _tX+bear.x
                    tY = _tY+bear.y
                    break
                end
            elseif dist < distance then
                distance = dist
            end
        end
        if bState == "angrysentry" then
            if distance > bearDist_toCalmFromAnger then
                bState = "sentry"
            end
        end
        if bState == "angrysentry" then
            --if is close to target change target
            if bear_closeToTarget(bear) then
                passed = false
                while passed == false do
                    _tX = math.random(-bearDist_wander, bearDist_wander)
                    _tY = math.random(-bearDist_wander, bearDist_wander)
                    if bear_clearPath(bear, _tX, _tY) then
                        passed = true
                        tX = _tX+bear.x
                        tY = _tY+bear.y
                    end
                end
            else
                if not bear_walk(bear) then
                    passed = false
                    while passed == false do
                        _tX = math.random(-bearDist_wander, bearDist_wander)
                        _tY = math.random(-bearDist_wander, bearDist_wander)
                        if bear_clearPath(bear, _tX, _tY) then
                            passed = true
                            tX = _tX+bear.x
                            tY = _tY+bear.y
                        end
                    end
                end
            end
        end
    elseif bState == "chase" then
        bear.speed = bearSpeed_chase
        distance = bearDist_toChase
        p = nil
        for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-bear.x
            local ry = y-bear.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < bearDist_toAttack then
                tX = v.x - bear.x
                tY = v.y - bear.y

                if bear_clearPath(bear, tX, tY) then
                    tX = bear.x + tX
                    tY = bear.y + tY
                    --choose attack
                    local ran = math.random(1, 100)
                    bState = "swing"

                    break
                end
            elseif dist < distance then
                distance = dist
                p = v
            end
        end
        if bState == "chase" then
            if p == nil then
                bState = "angrysentry"
                bear.velX = 0
                bear.velY = 0
            else
                _tX = p.x - bear.x
                _tY = p.y - bear.y

                if bear_clearPath(bear, _tX, _tY) then
                    tX = bear.x + _tX
                    tY = bear.y + _tY
                    bear.data = timer..","..tX..","..tY..","..bState

                    bear_walk(bear)
                else
                    if bear_closeToTarget(bear) then
                        bState = "angrysentry"
                    else
                        if not bear_walk(bear) then
                            bState = "angrysentry"
                        end
                    end
                end
            end
        end

    elseif bState == "swing" then
        if timer < 1000 then
            distance = bearDist_toChase
            p = nil
            for k, v in pairs(world.players) do
                local x = v.x
                local y = v.y
                local rx = x-bear.x
                local ry = y-(bear.y-(bear.h/4))


                --gives the bear 3 spheres to attempt to collide with player for swing
                local dist = math.sqrt((rx*rx)+(ry*ry))

                local rx1 = rx+(bear.w/3)
                local dist1 = math.sqrt((rx1*rx1)+(ry*ry))
                
                local rx2 = rx-(bear.w/3)
                local dist2 = math.sqrt((rx2*rx2)+(ry*ry))

                if dist > dist1 then
                    dist = dist1
                end
                if dist > dist2 then
                    dist = dist2
                end

                if dist < bearDist_toSwing then
                    bear.speed = 1
                    --swing
                    timer = 1000 + (bearTime_swing * mya_getUPS())
                    break
                elseif dist < distance then
                    distance = dist
                    p = v
                end
            end
            if bState == "swing" then
                bear.speed = bearSpeed_swing
                if p == nil then
                    timer = timer - 1
                    if timer <= 0 then
                        bState = "angrysentry"
                        bear.velX = 0
                        bear.velY = 0
                    end
                else
                    timer = 200
                    _tX = p.x - bear.x
                    _tY = p.y - bear.y
                    
                    if bear_clearPath(bear, _tX, _tY) then
                        tX = bear.x + _tX
                        tY = bear.y + _tY
                        bear.data = timer..","..tX..","..tY..","..bState

                        bear_walk(bear)
                    else
                        local tX = tonumber(strs[2])
                        local tY = tonumber(strs[3])
                        if bear_closeToTarget(bear) then
                            bState = "angrysentry"
                        else
                            --print(bear_walk(bear))
                            --print("x: "..bear.x.." y: "..bear.y.." tX: "..tX.." tY: "..tY.." velX: "..bear.velX.." velY: "..bear.velY)
                            if not bear_walk(bear) then
                                bState = "angrysentry"
                            end
                        end
                    end
                end
            end
        end

        --idk what i was doing here
        --I repeat, do NOT let him cook.
    elseif bState == "roll" then
        bState = "chase"
    elseif bState == "jump" then
        bState = "chase"
    end

    printInfo = false
    bear.data = timer..","..tX..","..tY..","..bState
end
newEntityFunction("boss_bear_update", ef_boss_bear_update)

function ef_boss_bear_tupdate(bear)
    local strs = mysplit(bear.data, ",")
    local timer = tonumber(strs[1])
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])
    local bState = strs[4]

    local anger = 1-(bear.hp/bear.maxhp)

    if bState == "swing" then
        if timer > 999 then
            timer = timer -1
            if timer == 1000 then
                timer = 0
                for k, v in pairs(world.players) do
                    local x = v.x
                    local y = v.y
                    local rx = x-bear.x
                    local ry = y-bear.y

                    local dist = math.sqrt((rx*rx)+(ry*ry))
                    
                    if dist < bearDist_swingReach then
                        v.health = v.health - bearDmg_swing
                    end
                end
                bState = "angrysentry"
            end
        end
    end
    bear.data = timer..","..tX..","..tY..","..bState
    if bear.hp <= 0 then
        world.entities[bear.spawnID] = nil
    end
end
newEntityFunction("boss_bear_tupdate", ef_boss_bear_tupdate)

function spawnBossBear(pressed)
    if pressed == false then
        eid = entity_add(spawnBoss_Bear(0,0))
    end
end