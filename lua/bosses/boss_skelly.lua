function spawnBoss_Skelly(x,y)
    local skelly = newEntity("boss_skelly")
    skelly.x = x
    skelly.y = y
    skelly.w = 1
    skelly.h = 1.25
    bear.velX = 0
    bear.velY = 0

    skelly.hp = 500 --lower hp but more agile
    skelly.data = ""
    skelly.tex = "skelly"
    skelly.maxhp = 500

    skelly.speed = 3
end