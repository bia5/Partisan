--Core entity setup

--TODO: SAVING/LOADING
--maybe state handling using the same system that the entityfunctions use?

--I just noticed the mistype, I think i might be dyslexic ~Alex 9/6/2024

--Purpose for the next 3 functions are to make handling stray functions for entities easier.
--newEntityFunction delcares a new function and adds it to the list
entityFucntions = {}
function newEntityFunction(name, func)
    entityFucntions[name] = func
end

--getEntityFunction reuturns the function (idk why this is important i forgor)
function getEntityFunction(name)
    return entityFucntions[name]
end

--executes entity function
function exeEntityFunction(name, ...)
    if entityFucntions[name] ~= nil then
        entityFucntions[name](...)
    end
end

--entity
function newEntity(id, spawnID)
    if spawnID == nil then
        spawnID = world.entityIDs
        world.entityIDs = world.entityIDs + 1
    end
    entity = {}
    entity.id = id
    entity.spawnID = spawnID

    entity.x = x
    entity.y = y
    entity.w = 1
    entity.h = 1
    entity.deg = 0

    entity.velX = 0
    entity.velY = 0
    entity.speed = 5

    entity.tex = id

    entity.hp = 100
    entity.maxhp = 100

    --Data
    entity.data = ""

    --functions
    entity.onUpdate = "nil"
    entity.onTUpdate = "nil"
    entity.onCollision = "nil"

    return entity
end