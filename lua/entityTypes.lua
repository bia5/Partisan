function spawnBullet(x,y,velX,velY,size,hp,dmg,tex,deg)
    local bullet = newEntity("bullet",0)
    bullet.x = x
    bullet.y = y
    bullet.w = size
    bullet.h = size
    bullet.velX = velX
    bullet.velY = velY
    bullet.onUpdate = "bullet_update"
	bullet.onCollision = "bullet_collision"
    bullet.hp = hp
    bullet.data = 0
    bullet.tex = tex
    bullet.maxhp = dmg
    bullet.deg = deg

    return bullet
end