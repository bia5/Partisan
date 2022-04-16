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
    tile.w = 1
    tile.h = 1
	tile.tex = tex
	tile.walkable = true
    
    --Data
    tile.data = ""

    -- Functions
    tile.onColBullet = "nil"
    tile.onColPlayer = "nil"
    tile.onColEntity = "nil"

    tile.onUpdate = "nil"
    tile.onDraw = "nil"
    tile.onClick = "nil"
    tile.oneRelease = "nil"
    tile.onMouseOver = "nil"

	return tile
end

function tileToString(v)
	local str = ""
    local splitter0 = "]"
    local splitter1 = "["

    str = str .. "i" .. splitter1 .. v.id .. splitter0          --id
    str = str .. "x" .. splitter1 .. v.x .. splitter0           --x
    str = str .. "y" .. splitter1 .. v.y .. splitter0           --y
    str = str .. "w" .. splitter1 .. v.w .. splitter0           --y
    str = str .. "h" .. splitter1 .. v.h .. splitter0           --y
    str = str .. "t" .. splitter1 .. v.tex .. splitter0         --tex
    str = str .. "wk" .. splitter1 .. tostring(v.walkable) .. splitter0    --walkable
    str = str .. "d" .. splitter1 .. v.data .. splitter0        --data

    str = str .. "ocb" .. splitter1 .. v.onColBullet .. splitter0 --onColBullet
    str = str .. "ocp" .. splitter1 .. v.onColPlayer .. splitter0 --onColPlayer
    str = str .. "oce" .. splitter1 .. v.onColEntity .. splitter0 --onColEntity

    str = str .. "ou" .. splitter1 .. v.onUpdate .. splitter0   --onUpdate
    str = str .. "od" .. splitter1 .. v.onDraw .. splitter0     --onDraw
    str = str .. "oc" .. splitter1 .. v.onClick .. splitter0    --onClick
    str = str .. "or" .. splitter1 .. v.oneRelease .. splitter0 --oneRelease
    str = str .. "om" .. splitter1 .. v.onMouseOver .. splitter0--onMouseOver

	return str
end

function stringToTile(str)
    tile = {}
    local splitter0 = "]"
    local splitter1 = "["
    local inputs = mysplit(str, splitter0)

    for k, v in pairs(inputs) do
        local key = mysplit(v, splitter1)[1]
        local value = mysplit(v, splitter1)[2]

        if key == "i" then
            tile.id = value
        elseif key == "x" then
            tile.x = tonumber(value)
        elseif key == "y" then
            tile.y = tonumber(value)
            tile.id = value
        elseif key == "w" then
            tile.w = tonumber(value)
        elseif key == "h" then
            tile.h = tonumber(value)
        elseif key == "t" then
            tile.tex = value
        elseif key == "wk" then
            tile.walkable = toboolean(value)
        elseif key == "d" then
            if value == nil then
                tile.data = ""
            else
                tile.data = value
            end

        elseif key == "ocb" then
            tile.onColBullet = value
        elseif key == "ocp" then
            tile.onColPlayer = value
        elseif key == "oce" then
            tile.onColEntity = value

        elseif key == "ou" then
            tile.onUpdate = value
        elseif key == "od" then
            tile.onDraw = value
        elseif key == "oc" then
            tile.onClick = value
        elseif key == "or" then
            tile.oneRelease = value
        elseif key == "om" then
            tile.onMouseOver = value
        end
    end

    return tile
end