--[[
Purpose of file is to handle AABB collisions

Side note: I got really tired of the collision code being weird and also not working so I decided to get a fresh start
]]--

function aabb(x,y,w,h)
    local _aabb = {}
    _aabb.x = x
    _aabb.y = y
    _aabb.w = w
    _aabb.h = h
    return _aabb
end

function aabb_collision(aabb1, aabb2, modified)
    if modified then
        aabb1.h=aabb1.h/2
        aabb2.h=aabb2.h/2

        aabb1.x=aabb1.x-(aabb1.w/2)
        aabb1.y=aabb1.y-aabb1.h
        aabb2.x=aabb2.x-(aabb2.w/2)
        aabb2.y=aabb2.y-aabb2.h
    end

    return aabb1.x < aabb2.x+aabb2.w and
         aabb2.x < aabb1.x+aabb1.w and
         aabb1.y < aabb2.y+aabb2.h and
         aabb2.y < aabb1.y+aabb1.h
end