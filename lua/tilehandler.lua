tileFunctions = {}
function newTileFunction(name, func)
    tileFunctions[name] = func
end

function getTileFunction(name)
    return tileFunctions[name]
end

function newTile(id, tex)
	if tex == nil then
		tex = id;
	end
	tile = {}
	tile.id = id
    tile.x = 0
    tile.y = 0
	tile.tex = tex
	tile.walkable = true
    
    --Data
    tile.data = {}

    -- Functions
    tile.onCollisionWithBullet = "nil"
    tile.onCollisionWithPlayer = "nil"
    tile.onCollisionWithEntity = "nil"

    tile.onUpdate = "nil"
    tile.onDraw = "nil"


	return tile
end