entityFucntions = {}
function newEntityFunction(name, func)
    entityFucntions[name] = func
end

function getEntityFunction(name)
    return entityFucntions[name]
end

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
    entity.onCollision = "nil"

    return entity
end