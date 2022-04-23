--TODO: Chest popup

--Switch Flick
function tf_switch_use(switch,layer)
    switch.data = not switch.data
    message(NET_MSG_TILEUPDATE, {tile = switch, layer = layer})
end
newTileFunction("switch_use", tf_switch_use)

--Pressure Plate
function tf_pressureplate_update(plate)
    plate.data = false
    for k, v in pairs(world.players) do
        local x = entity.x
        local y = entity.y
        local w = entity.w
        local h = entity.h

        if isTileCollision(x,y) == plate then
            plate.data = true
        elseif isTileCollision(x+w,y+h) == plate then
            plate.data = true
        elseif isTileCollision(x+w,y) == plate then
            plate.data = true
        elseif isTileCollision(x,y+h) == plate then
            plate.data = true
        end
    end
end
newTileFunction("pressureplate_update", tf_pressureplate_update)

--Spikes
function tf_spikes_timed_update(spikes)
    strs = mysplit(spikes.data, ",")
    --time in ticks
    time = tonumber(strs[1])
    maxTime = tonumber(strs[2])
    --state 0 == up
    --state 1 == down
    state = toboolean(strs[3])

    time = time + 1
    if time == maxTime then
        time = 0
        state = not state

        if state == true then -- spikes are up
            tile.walkable = false

            --check if player was on spike
            for k, v in pairs(world.players) do
                local x = entity.x
                local y = entity.y
                local w = entity.w
                local h = entity.h
        
                if isTileCollision(x,y) == plate then
                    v.hp = 0
                elseif isTileCollision(x+w,y+h) == plate then
                    v.hp = 0
                elseif isTileCollision(x+w,y) == plate then
                    v.hp = 0
                elseif isTileCollision(x,y+h) == plate then
                    v.hp = 0
                end
            end
        else -- spikes are down
            tile.walkable = true
        end
    end

    spikes.data = time..","..maxTime..","..tostring(state)
end
newTileFunction("spikes_timed_update", tf_spikes_timed_update)

--Projectile Spawner
function tf_arrowspawner_update(spawner)
    strs = mysplit(spawner.data, ",")
    --time in ticks
    time = tonumber(strs[1])
    maxTime = tonumber(strs[2])

    time = time + 1
    if time == maxTime then
        time = 0

        --spawn projectile
        x = tonumber(strs[3])
        y = tonumber(strs[4])
        vx = tonumber(strs[5])
        vy = tonumber(strs[6])
        deg = tonumber(strs[7])

        entity_add(arrow(x,y,velX,velY,deg))
    end
    spawner.data = time..","..maxTime..","..x..","..y..","..vx..","..vy..","..deg
end
newTileFunction("arrowspawner_update", tf_arrowspawner_update)

--Fire
function tf_fire_update(fire)
    --check if player is on the fire
    for k, v in pairs(world.players) do
        local x = entity.x
        local y = entity.y
        local w = entity.w
        local h = entity.h

        if isTileCollision(x,y) == plate then
            v.hp = v.hp - 1
        elseif isTileCollision(x+w,y+h) == plate then
            v.hp = v.hp - 1
        elseif isTileCollision(x+w,y) == plate then
            v.hp = v.hp - 1
        elseif isTileCollision(x,y+h) == plate then
            v.hp = v.hp - 1
        end
    end
end
newTileFunction("fire_update", tf_fire_update)

--Teleporter
function tf_teleporter_update(teleporter)
    for k, v in pairs(world.players) do
        local x = entity.x
        local y = entity.y
        local w = entity.w
        local h = entity.h
        local e = false

        if isTileCollision(x,y) == plate then
            e = true
        elseif isTileCollision(x+w,y+h) == plate then
            e = true
        elseif isTileCollision(x+w,y) == plate then
            e = true
        elseif isTileCollision(x,y+h) == plate then
            e = true
        end
        if e then
            strs = mysplit(spawner.data, ",")
            x = tonumber(strs[1])
            y = tonumber(strs[2])
            v.x = x
            v.y = y
        end
    end
end
newTileFunction("teleporter_update", tf_teleporter_update)

--Chest
function tf_chest_onUse(chest)
    strs = mysplit(chest.data, "|")
    --popup text
end
newTileFunction("chest_onUse", tf_chest_onUse)

--Locked Door
function tf_lockeddoor_update(door)
    strs = mysplit(door.data, "|")
    door.walkable = true
    for k, v in pairs(strs) do
        strss = mysplit(v, ",")
        layer = toboolean(strss[1])
        x = tonumber(strss[2])
        y = tonumber(strss[3])
        invert = toboolean(strss[4])
        local tile = nil
        if layer then
            tile = world.tiles[x.."-"..y]
        else
            tile = world.undertiles[x.."-"..y]
        end
        if tile ~= nil then
            if tile.id == "switch" or tile.id == "pressureplate" then
                if invert then
                    if tile.data then
                        door.walkable = false
                    end
                else
                    if tile.data == false then
                        door.walkable = false
                    end
                end
            end
        end
    end
end
newTileFunction("lockeddoor_update", tf_lockeddoor_update)