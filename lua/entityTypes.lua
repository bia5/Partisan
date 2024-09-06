function spawnBullet(x,y,velX,velY,size,hp,dmg,tex,deg)
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
    bullet.data = 0 --I want max hp here
    bullet.tex = tex
    bullet.maxhp = dmg --Entity's maxhp = bullet damage
    bullet.deg = deg --Degrees

    return bullet
end

function arrow(x,y,velX,velY,deg)
    entity_add(spawnBullet(x,y,velX,velY,0.2,1,10,"arrow",deg))
end

require("bosses/boss_bear")