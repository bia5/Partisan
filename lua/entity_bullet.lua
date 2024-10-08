--Handles Bullet Behavior (which is a projectile ie: arrow)
--also includes arrow spawner

--Bullet update
function ef_bullet_update(bullet)
    --Move Bullet
    bullet.x = bullet.x + (bullet.velX*(mya_getDelta()/1000))
    bullet.y = bullet.y + (bullet.velY*(mya_getDelta()/1000))

    --check if in wall
    local input = isTileCollision(bullet.x, bullet.y)
    if input ~= false then
        exeEntityFunction(bullet.onCollision, bullet)
        if input ~= true then
            exeTileFunction(input.onColBullet, input, bullet)
        end
    end

    --check if in entity
    for k, v in pairs(world.entities) do
        if v.id ~= bullet.id and v.spawnID ~= bullet.ignoreEntityID then
            --dont ask why the hitbox is so weird... I forgot why i did it honestly...
            if bullet.x > v.x-(v.w/2) 
            and bullet.x < (v.x-(v.w/2))+v.w 
            and bullet.y > v.y-v.h 
            and bullet.y < v.y then
                exeEntityFunction(bullet.onCollision, bullet)
                v.hp = v.hp - bullet.maxhp
            end
        end
    end

    --check if in players
    for k, v in pairs(world.players) do
        if v.id ~= bullet.id and v.spawnID ~= bullet.ignoreEntityID then
            --dont ask why the hitbox is so weird... I forgot why i did it honestly...
            if bullet.x > v.x-(v.w/2) 
            and bullet.x < (v.x-(v.w/2))+v.w 
            and bullet.y > v.y-v.h 
            and bullet.y < v.y then
                exeEntityFunction(bullet.onCollision, bullet)
                v.health = v.health - bullet.maxhp
            end
        end
    end

    --kills bullet after a second
    bullet.data = bullet.data + (1*(mya_getDelta()/1000))
    if bullet.data > 1 then
        world.entities[bullet.spawnID] = nil
    end
end
newEntityFunction("bullet_update", ef_bullet_update)

--Bullet collision
function ef_bullet_collision(bullet)
    bullet.hp = bullet.hp - 1

    if bullet.hp <= 0 then
        world.entities[bullet.spawnID] = nil
    end
end
newEntityFunction("bullet_collision", ef_bullet_collision)

--Handles spawning bullet
function spawnBullet(x,y,velX,velY,size,hp,dmg,tex,deg,ignoreEntityID)
    local bullet = newEntity("bullet")
    bullet.x = x
    bullet.y = y
    bullet.w = size
    bullet.h = size
    bullet.velX = velX
    bullet.velY = velY
    bullet.onUpdate = "bullet_update"
	bullet.onCollision = "bullet_collision"
    bullet.hp = hp
    bullet.data = 0 --Bullet's timeout counter
    bullet.ignoreEntityID = ignoreEntityID
    bullet.tex = tex
    bullet.maxhp = dmg --Entity's maxhp = bullet damage
    bullet.deg = deg --Degrees

    return bullet
end

--spawns arrow
function arrow(x,y,velX,velY,deg,dmg,ignoreEntityID)
    if dmg == nil then
        dmg = 1
    end
    entity_add(spawnBullet(x,y,velX,velY,0.5,1,dmg,"arrow",deg,ignoreEntityID))
end