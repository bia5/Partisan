screen = newChild(0, 0, 1920, 1080)

screen_add(screen, "debug_tv", newText("Debug", 0, 0, 1920, 50, {16,16,16}))

screen_addLeft(screen, "left_buttons", newChild(0,60,200,1020))
screen_addRight(screen, "right_buttons", newChild(0,60,200,1020))

--World Info
function screen_leveleditor_init()
    screen["worldinfo"].render = not screen["worldinfo"].render
end
screen_addTop(screen["left_buttons"], "worldinfotoggle", newTextButton("World Info", 0,0,200,50, {16,16,16}, screen_leveleditor_init))
screen["left_buttons"]["worldinfotoggle"].textRatio = .75
screen_add(screen, "worldinfo", newChild("center","center",1280,720))
screen["worldinfo"].render = false
screen_add(screen["worldinfo"], "bkg", newSprite("context", 0, 0, 1280, 720))
screen_add(screen["worldinfo"], "context", newChild("center","center",1210,650))
screen_addTop(screen["worldinfo"]["context"], "worldinfo_title", newText("World Info", "center", 0, 200, 50, {16,16,16}))
screen_addTop(screen["worldinfo"]["context"], "worldidcontext", newChild("center",0,1210,60))
screen_addLeft(screen["worldinfo"]["context"]["worldidcontext"], "worldid_tv", newText("World ID: ", 0,"center",200,60,{16,16,16}))
screen_addRight(screen["worldinfo"]["context"]["worldidcontext"], "worldid_et", newEditText(world_id, 0,"center",950,60,{16,16,16}))
screen_addBottom(screen["worldinfo"]["context"], "buttons", newChild("center",0,1210,60))
screen_addLeft(screen["worldinfo"]["context"]["buttons"], "load_button", newTextButton("Load", 0,"center",150,50, {16,16,16}, loadWorld))
screen_addRight(screen["worldinfo"]["context"]["buttons"], "save_button", newTextButton("Save", 0,"center",150,50, {16,16,16}, saveWorld))
screen_add(screen["worldinfo"]["context"]["buttons"], "empty_button", newTextButton("New World", "center","center",250,50, {16,16,16}, newWorld))
screen_addTop(screen["left_buttons"], "empty1", newEmpty(0,0,200,10))

--Mode Buttons
screen_addTop(screen["right_buttons"], "build_mode", newTextToggleButton("Build Mode", 0,0,200,50, {16,16,16}, nil))
screen["right_buttons"]["build_mode"].textRatio = .75
screen_addTop(screen["right_buttons"], "empty1", newEmpty(0,0,200,10))
screen_addTop(screen["right_buttons"], "destroy_mode", newTextToggleButton("Destroy Mode", 0,0,200,50, {16,16,16}, nil))
screen["right_buttons"]["destroy_mode"].textRatio = .65
screen_addTop(screen["right_buttons"], "empty2", newEmpty(0,0,200,10))
screen_addTop(screen["right_buttons"], "dropper_mode", newTextToggleButton("Dropper Mode", 0,0,200,50, {16,16,16}, nil))
screen["right_buttons"]["dropper_mode"].textRatio = .65
screen_addTop(screen["right_buttons"], "empty3", newEmpty(0,0,200,10))

--new tile
--edit tile
--toggle layer

--zoom
--speed
--object id

tileSize_ = 16
tileSize = mya_getHeight()/tileSize_

--Offset variables, moves based on the camera
local offsetX = 0
local offsetY = 0

--Camera Movement
local playerX = 0
local playerY = 0
local playerSpeed = 10
local playerW = false
local playerA = false
local playerS = false
local playerD = false

--Various Sprites
sprite_tile = Sprite.new(assets:getTexture("empty"))
sprite_entity = Sprite.new(assets:getTexture("empty"))

--Easy Zoom functions for keybinds
function zoomOut()
	tileSize_ = tileSize_ + 5
	tileSize = mya_getHeight()/tileSize_
end
function zoomIn()
	tileSize_ = tileSize_ - 5
	tileSize = mya_getHeight()/tileSize_
    loadWorld()
end

--Player movement keybind functions
function player_up_le(isPressed)
	if state == STATE_LEVELEDITOR then
		playerW = isPressed
	end
end
function player_down_le(isPressed) 
	if state == STATE_LEVELEDITOR then
		playerS = isPressed
	end
end
function player_left_le(isPressed) 
	if state == STATE_LEVELEDITOR then
		playerA = isPressed
	end
end
function player_right_le(isPressed) 
	if state == STATE_LEVELEDITOR then
		playerD = isPressed
	end
end

function scr_leveleditor_tupdate()

end
screen.onTUpdate = scr_leveleditor_tupdate

function scr_leveleditor_update()
    mya_deltaUpdate()

    tilex = math.floor((mouseX-offsetX)/tileSize)
	tiley = math.floor((mouseY-offsetY)/tileSize)

    --Handle camera movement
	local speed = playerSpeed*(mya_getDelta()/1000)
		
	if playerW then 
		playerY = playerY - speed
	end
	if playerS then 
		playerY = playerY + speed 
	end
	if playerA then 
		playerX = playerX - speed 
	end
	if playerD then 
		playerX = playerX + speed
	end
	
	--Update Camera Offset
	offsetX = (mya_getWidth()/2)-(playerX*tileSize)-tileSize/2
	offsetY = (mya_getHeight()/2)-(playerY*tileSize)-tileSize/2

    scr = getScreen(STATE_LEVELEDITOR)
    scr["debug_tv"].text = "FPS: "..mya_getFPS()..", X: "..tostring(math.floor(playerX*100)/100)..", Y: "..tostring(math.floor(playerY*100)/100)..", Delta: "..(mya_getDelta()/1000)..", Zoom: "..tileSize_
end
screen.onUpdate = scr_leveleditor_update

function scr_leveleditor_render()
    tileSize = mya_getHeight()/tileSize_

    --Get render distance for tiles
    renderDistH = tileSize_
    renderDistV = tileSize_/2
    x = math.floor(playerX+.5)
    y = math.floor(playerY+.5)

    --Render Tiles
    for ii = y-renderDistV, y+renderDistV do
        for i = x-renderDistH, x+renderDistH do
            tile = world.undertiles[i.."-"..ii]
            if tile ~= nil then
                sprite_tile:setTexture(assets:getTexture(tile.tex))
                sprite_tile:setX((i*tileSize)+offsetX)
                sprite_tile:setY((ii*tileSize)+offsetY)
                sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
            end

            tile = world.tiles[i.."-"..ii]
            if tile ~= nil then
                sprite_tile:setTexture(assets:getTexture(tile.tex))
                sprite_tile:setX((i*tileSize)+offsetX)
                sprite_tile:setY((ii*tileSize)+offsetY)
                sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
            end
        end
    end

    --Render Objects
    for k, v in pairs(world.objects) do
        if type(v) == "table" then
            if v.x >= x-renderDistH-1 and v.x <= x+renderDistH+1 and v.y >= y-renderDistV-1 and v.y <= y+renderDistV+1 then
                sprite_tile:setTexture(assets:getTexture(v.tex))
                sprite_tile:setX((v.x*tileSize)+offsetX)
                sprite_tile:setY((v.y*tileSize)+offsetY)
                sprite_tile:render(mya_getRenderer(), v.w*tileSize, v.h*tileSize,v.deg, false)
            end
        end
    end

    --Render Entities
    for k, v in pairs(world.entities) do
        sprite_entity:setTexture(assets:getTexture(v.id))
        sprite_entity:setX((v.x*tileSize)+offsetX)
        sprite_entity:setY((v.y*tileSize)+offsetY)
        sprite_entity:render(mya_getRenderer(), tileSize*v.w, tileSize*v.h)
    end

    --Display build tile @ top right
    if buildTile ~= nil then
        sprite_tile:setTexture(assets:getTexture(buildTile.tex))
        sprite_tile:setX(mya_getWidth()-tileSize)
        sprite_tile:setY(0)
        sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
    end
end
screen.onRender = scr_leveleditor_render

addScreen(STATE_LEVELEDITOR, screen)