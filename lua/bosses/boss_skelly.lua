--Alex Sep/6/2024
--Purpose is to handle everything for the skelly boss

--Vars
local skellyDist_toSentry = 45 --idk this seems high but i honestly dont care rn
local skellySpeed_sentry = 3

local skellyTime_shoot = 1

local skellyArrow_speed = 15

--Creates a skelly boss entity
function spawnBoss_Skelly(x,y)
    local skelly = newEntity("boss_skelly")
    skelly.x = x
    skelly.y = y
    skelly.w = 1.2
    skelly.h = 1.5
    skelly.velX = 0
    skelly.velY = 0
    skelly.onUpdate = "boss_skelly_update"
    skelly.onTUpdate = "boss_skelly_tupdate"
    skelly.onCollision = "boss_skelly_collision"
    skelly.hp = 500 --lower hp but more agile
    skelly.data = "0,"..x..","..y..",".."shoot" --timer,x,y,state
    skelly.tex = "skelly"
    skelly.maxhp = 500

    skelly.speed = 3
    return skelly
end

--Handles the skelly AI
function ef_boss_skelly_update(skelly)
    --data
    local strs = mysplit(skelly.data, ",")
    local timer = tonumber(strs[1])
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])
    local state = strs[4]

	--idle to sentry
	if state == "idle" then --This was copied from the bear
		for k, v in pairs(world.players) do
            local x = v.x
            local y = v.y
            local rx = x-skelly.x
            local ry = y-skelly.y

            local dist = math.sqrt(rx*rx+ry*ry)

            if dist < skellyDist_toSentry then
                bState = "sentry"
                break
            end
        end
	elseif state == "sentry" then --Everything below is rewritten for the skelly :)
		--[[
			So lets think of some lore for the skelly.

			A skelly wants bones to make themself stronger,
			so it would hunt prey for bones occasionally

			the way it hunts is by shooting arrows from cover

			its also a fast and weak fucker. :)
		]]

		--No small animals rn so itll only hunt for players


		--roam
		--if sees player then target
		state = "shoot"
	elseif state == "angrysentry" then
		--keeps looking in the direction
	elseif state == "chase" then

	elseif state == "shoot" then
        if timer < 1 then
            p = nil
            distance = 99
            for k, v in pairs(world.players) do
                local x = v.x
                local y = v.y
                local rx = x-skelly.x
                local ry = y-(skelly.y-(skelly.h/4))

                local dist = math.sqrt(rx*rx+ry*ry)

                if dist < distance then
                    distance = dist
                    p = v
                end
            end
            local xx = p.x - skelly.x
            local yy = p.y - skelly.y
            local angle = math.atan(yy/xx)
            if xx > 0 then
                arrow(skelly.x,skelly.y,skellyArrow_speed*(math.cos(angle)),skellyArrow_speed*(math.sin(angle)),skelly.deg, 15,skelly.spawnID)
            else
                arrow(skelly.x,skelly.y,-skellyArrow_speed*(math.cos(angle)),-skellyArrow_speed*(math.sin(angle)),skelly.deg, 15,skelly.spawnID)
            end
            timer = skellyTime_shoot * mya_getUPS()
        end
	end
    skelly.data = timer..","..tX..","..tY..","..state
end
newEntityFunction("boss_skelly_update", ef_boss_skelly_update)

function ef_boss_skelly_tupdate(skelly)
    local strs = mysplit(skelly.data, ",")
    local timer = tonumber(strs[1])
    local tX = tonumber(strs[2])
    local tY = tonumber(strs[3])
    local state = strs[4]

    timer = timer - 1
    
    skelly.data = timer..","..tX..","..tY..","..state
end
newEntityFunction("boss_skelly_tupdate", ef_boss_skelly_tupdate)

function spawnBossSkelly(pressed)
    if pressed == false then
        eid = entity_add(spawnBoss_Skelly(0,0))
    end
end