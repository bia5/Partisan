tileFunctions = {}
function newTileFunction(name, func)
    tileFunctions[name] = func
end

function getTileFunction(name)
    return tileFunctions[name]
end

function exeTileFunction(name, ...)
    if tileFunctions[name] ~= nil then
        tileFunctions[name](...)
    end
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
    tile.deg = 0
	tile.tex = tex
	tile.walkable = true
    
    --Data
    tile.data = ""

    -- Functions
    tile.onUpdate = "nil"
    tile.onUse = "nil"
    tile.onRender = "nil"

	return tile
end

function tileToString(v)
	local str = ""
    local splitter0 = "]"
    local splitter1 = "["

    str = str .. "i" .. splitter1 .. v.id .. splitter0          --id
    if v.x ~= 0 then
        str = str .. "x" .. splitter1 .. v.x .. splitter0           --x
    end
    if v.y ~= 0 then
        str = str .. "y" .. splitter1 .. v.y .. splitter0           --y
    end
    if v.w ~= 1 then
        str = str .. "w" .. splitter1 .. v.w .. splitter0           --w
    end
    if v.h ~= 1 then
        str = str .. "h" .. splitter1 .. v.h .. splitter0           --h
    end
    if v.deg ~= 0 then
        str = str .. "deg" .. splitter1 .. v.deg .. splitter0           --h
    end
    str = str .. "t" .. splitter1 .. v.tex .. splitter0         --tex
    if v.walkable ~= true then
        str = str .. "wk" .. splitter1 .. tostring(v.walkable) .. splitter0  --walkable
    end
    if v.data ~= "" then
        str = str .. "dt" .. splitter1 .. type(v.data) .. splitter0        --data
        str = str .. "d" .. splitter1 .. tostring(v.data) .. splitter0        --data
    end

    if v.onUpdate ~= "nil" then
        str = str .. "oup" .. splitter1 .. v.onUpdate .. splitter0 --onUpdate
    end
    if v.onUse ~= "nil" then
        str = str .. "ous" .. splitter1 .. v.onUse .. splitter0 --onUpdate
    end
    if v.onRender ~= "nil" then
        str = str .. "ore" .. splitter1 .. v.onUse .. splitter0 --onUpdate
    end

	return str
end

function stringToTile(str)
    tile = newTile("null")  --create a blank to allow for forward compatibility
    local splitter0 = "]"
    local splitter1 = "["
    local inputs = mysplit(str, splitter0)
    local dtype = ""
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
        elseif key == "deg" then
            tile.deg = tonumber(value)
        elseif key == "wk" then
            tile.walkable = toboolean(value)
        elseif key == "dt" then
            dtype = value
        elseif key == "d" then
            if value ~= nil then
                tile.data = stringToValue(value, dtype)
            end

        elseif key == "oup" then
            tile.onUpdate = value
        elseif key == "ous" then
            tile.onUse = value
        elseif key == "ore" then
            tile.onRender = value
        end
    end

    return tile
end