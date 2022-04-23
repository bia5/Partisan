--TODO: add textures and animations

function newSwitch(tex)
    switch = newTile("switch")
    switch.data = false
    switch.onUse = "switch_use"
    switch.tex = tex

    return switch
end

function newPressurePlate(tex)
    plate = newTile("pressureplate")
    plate.data = false
    plate.onUpdate = "pressureplate_update"
    plate.tex = tex

    return plate
end

--ANIMATION
function newSpikes(tex,maxTick)
    spikes = newTile("spikes")
    spikes.data = "0,"..maxTick..",false"
    spikes.onUpdate = "spikes_timed_update"

    return spikes
end

function newArrowSpawner(tex,maxTick,x,y,velX,velY,deg)
    spawner = newTile("arrowspawner")
    spawner.data = "0,"..maxTick..","..x..","..y..","..velX..","..velY..","..deg
    spawner.onUpdate = "arrowspawner_update"
    spawner.tex = tex

    return spawner
end

--ANIMATION
function newFire()
    fire = newTile("fire")
    fire.onUpdate = "fire_update"

    return fire
end

function newTeleporter(tex,x,y)
    teleporter = newTile("teleporter")
    teleporter.data = x..","..y
    teleporter.onUpdate = "tf_teleporter_update"
    teleporter.tex = tex

    return teleporter
end

--strs
--strings split by |
function newChest(tex,strs)
    chest = newTile("chest")
    chest.data = strs
    chest.onUse = "chest_use"
    chest.tex = tex

    return chest
end

--multiple textures

--strs (array split by |)
-- 1: boolean: layer (true = top, false = bottom)
-- 2: int: x
-- 3: int: y
-- 4: bool: invert input
--
--Ex: "true,0,0,false|true,1,0,false"
function newDoor(tex,strs)
    door = newTile("door")
    door.data = strs
    door.onUpdate = "lockeddoor_update"

    return door
end