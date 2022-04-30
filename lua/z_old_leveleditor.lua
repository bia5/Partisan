--Tile Size Variable (Determines the size of everything)
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

--New Tile Screen
local tilePopup = false
tileButtons = {}

--New Tile Buttons
function newTileButton(id, x, y, w, h)
	btn = {}

	btn.id = id
	btn.x = x
	btn.y = y
	btn.w = w
	btn.h = h

	return btn
end

--Get tile button based on screen x,y
function getTileButton(x,y)
	for k, v in pairs(tileButtons) do
		if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
			return v.id
		end
	end
end

--Various Sprites
sprite_tile = Sprite.new(assets:getTexture("empty"))
sprite_entity = Sprite.new(assets:getTexture("empty"))

--New Tile Sprites
sprite_tilePopup = Sprite.new(assets:getTexture("empty"))
sprite_tilePopup:setRenderOutline(true)
sprite_tilePopup:setOutlineColor(0, 0, 0, 128)

--Build Tiles Info
buildTile = newTile("tile_grass_0")
layer = "undertiles"

--Easy Zoom functions for keybinds
function zoomOut()
	tileSize_ = tileSize_ + 5
	tileSize = mya_getHeight()/tileSize_
end
function zoomIn()
	tileSize_ = tileSize_ - 5
	tileSize = mya_getHeight()/tileSize_
end

--Button Handlers
local buttons = {}
local yval = mya_getHeight()/20
local function newButton(id, x, y, text, size)
	button = {}
	button.isPressed = false
	button.tv = TextView.new(font, text, x, y, mya_getRenderer())
	button.x = x
	button.y = y
	button.w = button.tv:getWidth()
	button.h = button.tv:getHeight()
	yval = yval + button.h
	buttons[id] = button
end

local function isButtonPressed(id)
	if buttons[id] ~= nil and tilePopup == false then
		return buttons[id].isPressed
	end
	return false
end

--Define all debug buttons
local function defineButtons()
	yval = mya_getHeight()/20
	--newButton("newworld", 0, yval, "New World", 32)
	--newButton("tiledropper", 0, yval, "Tile Dropper", 32)
	newButton("newtile", 0, yval, "New Tile", 32)
	newButton("edittile", 0, yval, "Edit Tile", 32)
	--newButton("gettile", 0, yval, "Get Tile", 32)
	--newButton("togglewalkable", 0, yval, "Toggle Walkable", 32)

	yval = tileSize
	--newButton("buildmode", mya_getWidth()/8*7, yval, "Build Mode", 32)
	--newButton("destroymode", mya_getWidth()/8*7, yval, "Destroy Mode", 32)
	newButton("togglelayer", mya_getWidth()/8*7, yval, "Toggle Layer", 32)

	yval = mya_getHeight()/2
	newButton("zoom", mya_getWidth()/8*7, yval, "Zoom", 32)
	newButton("speed", mya_getWidth()/8*7, yval, "Speed", 32)
	--newButton("save", mya_getWidth()/8*7, yval, "Save", 32)
	--newButton("load", mya_getWidth()/8*7, yval, "Load", 32)
	--newButton("worldid", mya_getWidth()/8*7, yval, "Set World ID", 32)
	newButton("objectid", mya_getWidth()/8*7, yval, "Set Object ID", 32)
end

--Debug Text
local screen_le_debug = TextView.new(font, "Debug", 0, 0, mya_getRenderer())

function screen_le_windowResize(w, h)
	tileSize = mya_getHeight()/tileSize_

	screen_le_debug:setFont(font, mya_getRenderer())
	
	--Resize all buttons
	buttons = {}
	defineButtons()
end
screen_le_windowResize(mya_getWidth(), mya_getHeight())

--Player movement keybind functions
function player_up_le(isPressed)
	if state == STATE_LEVELEDITOR and tilePopup == false then
		playerW = isPressed
	end
end
function player_down_le(isPressed) 
	if state == STATE_LEVELEDITOR and tilePopup == false then
		playerS = isPressed
	end
end
function player_left_le(isPressed) 
	if state == STATE_LEVELEDITOR and tilePopup == false then
		playerA = isPressed
	end
end
function player_right_le(isPressed) 
	if state == STATE_LEVELEDITOR and tilePopup == false then
		playerD = isPressed
	end
end

--Update every engine tick
function screen_le_tupdate()
end

--x,y coords of mouse in world
tilex = 0
tiley = 0

--Mouse click handler
mouseDown = false
--Button click handler
hovering = false

--Various mode variables
mode_dropper = false
mode_build = false
mode_destroy = false
function screen_le_mouseButtonUp(btn)
	mouseDown = false
	--Update mouse coords
	tilex = math.floor((mouseX-offsetX)/tileSize)
	tiley = math.floor((mouseY-offsetY)/tileSize)
	
	--If new tile context isn't open
	if tilePopup == false then
		hovering = false
		--Button click handler
		for k, v in pairs(buttons) do
			if mouseX < v.x + v.w and mouseX > v.x and mouseY < v.y + v.h and mouseY > v.y then
				v.isPressed = true
				hovering = true
			else
				v.isPressed = false
			end
		end

		--Tile Dropper
		if not hovering then
			if mode_dropper then
				if layer == "undertiles" then
					buildTile = world.undertiles[tilex.."-"..tiley]
				elseif layer == "tiles" then
					buildTile = world.tiles[tilex.."-"..tiley]
				end
				
				print("Tile Dropped")

				mode_dropper = false
			end
		end

		-- 		Button Handlers		--

		if isButtonPressed("newworld") then				-- Generate New World
			newWorld()

		elseif isButtonPressed("newtile") then			-- New Tile
			tilePopup = true
		elseif isButtonPressed("edittile") then			-- Edit Tile Meta
			print("Enter Tile Variable: ")
			variable = getInput("string")
			print("Enter Value: ")
			buildTile[variable] = getInput(type(buildTile[variable]))
		elseif isButtonPressed("tiledropper") then		-- Grabs an existing tile
			print("dropper mode enabled")
			mode_dropper = true
		elseif isButtonPressed("gettile") then			-- Prints Tile Info
			tprint(buildTile, 2)
		elseif isButtonPressed("togglewalkable") then	-- Toggles Walkable
			buildTile.walkable = not buildTile.walkable
			print("Walkable: "..tostring(buildTile.walkable))
		
		-- 		Right Buttons		--
		elseif isButtonPressed("buildmode") then		-- Toggle Build Mode
			mode_build = not mode_build
			print("Build Mode: "..tostring(mode_build))
		elseif isButtonPressed("destroymode") then		-- Toggle Destroy Mode
			mode_destroy = not mode_destroy
			print("Destroy Mode: "..tostring(mode_destroy))
		elseif isButtonPressed("togglelayer") then		-- Toggle Layer
			if layer == "undertiles" then
				layer = "tiles"
			elseif layer == "tiles" then
				layer = "object"
			else
				layer = "undertiles"
			end
			print("Undertile: "..tostring(layer))

		-- 		Bottom Right		--
		elseif isButtonPressed("zoom") then				-- Enter Zoom
			print("Enter Zoom Value (higher = futher out (def 16)): ")
			tileSize_ = getInput("number")
			tileSize = mya_getHeight()/tileSize_
		elseif isButtonPressed("speed") then 			-- Enter Speed
			print("Enter Speed Value (def 10): ")
			playerSpeed = getInput("number")
		elseif isButtonPressed("save") then				-- Save World
			saveWorld()
		elseif isButtonPressed("load") then				-- Load World
			loadWorld()
		elseif isButtonPressed("worldid") then			-- Set World ID
			print("Enter World ID: ")
			world_id = getInput("string")
		elseif isButtonPressed("objectid") then			-- Set Object ID
			print("Enter Object ID: ")
			world.objectIDs = getInput("number")
		end
		-- 		End Button Handlers		--

		--Place Object
		if mode_build then
			if not mode_dropper then
				if not hovering then
					if layer == "object" then
						offsetX = (mya_getWidth()/2)-(playerX*tileSize)-tileSize/2
						offsetY = (mya_getHeight()/2)-(playerY*tileSize)-tileSize/2
						addObject((mouseX-offsetX)/tileSize, (mouseY-offsetY)/tileSize, 1, 1, buildTile)
					end
				end
			end
		--Destroy Object
		elseif mode_destroy then
			if not hovering then
				if layer == "object" then
					offsetX = (mya_getWidth()/2)-(playerX*tileSize)-tileSize/2
					offsetY = (mya_getHeight()/2)-(playerY*tileSize)-tileSize/2
					objs = getObjectsColliding((mouseX-offsetX)/tileSize, (mouseY-offsetY)/tileSize, 1, 1)
					for k, v in pairs(objs) do
						world.objects[v] = nil
					end
				end
			end
		end
	else --If new tile context is open
		eid = getTileButton(mouseX, mouseY)
		if eid ~= nil then
			buildTile = newTile(eid)
			tilePopup = false
		end
	end
end

function screen_le_mouseButtonDown(btn)
	mouseDown = true
end

function screen_le_update()
	mya_deltaUpdate()

	--If new tile context isn't open
	if tilePopup == false then
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

		--Update x,y coords in world
		tilex = math.floor((mouseX-offsetX)/tileSize)
		tiley = math.floor((mouseY-offsetY)/tileSize)

		--Update button hovering
		hovering = false
		for k, v in pairs(buttons) do
			if mouseX < v.x + v.w and mouseX > v.x and mouseY < v.y + v.h and mouseY > v.y then
				hovering = true
			end
		end

		--Build mode place tiles
		if mode_build then
			if not mode_dropper then
				if not hovering then
					if mouseDown then
						if layer == "undertiles" then
							world.undertiles[tilex.."-"..tiley] = buildTile
						elseif layer == "tiles" then
							world.tiles[tilex.."-"..tiley] = buildTile
						end
					end
				end
			end
		--Destroy mode destroy tiles
		elseif mode_destroy then
			if not mode_dropper then
				if not hovering then
					if mouseDown then
						if layer == "undertiles" then
							world.undertiles[tilex.."-"..tiley] = nil
						elseif layer == "tiles" then
							world.tiles[tilex.."-"..tiley] = nil
						end
					end
				end
			end
		end
	else
		--Update new tile context pos
		sprite_tilePopup:setX(mya_getWidth()/20)
		sprite_tilePopup:setY(mya_getHeight()/20)
	end
	--Update debug text
	screen_le_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(math.floor(playerX*100)/100)..", Y: "..tostring(math.floor(playerY*100)/100)..", Delta: "..(mya_getDelta()/1000)..", tileX: "..tilex..", tileY: "..tiley..", Zoom: "..tileSize_, mya_getRenderer())
end

function screen_le_render()
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

	--Render Debug
	screen_le_debug:render(mya_getRenderer())

	for k, v in pairs(buttons) do
		v.tv:render(mya_getRenderer())
	end

	--Display new tile context
	if tilePopup then
		ex = mya_getWidth()/20+(tileSize/4)
		ey = mya_getHeight()/20+(tileSize/4)
		tileButtons = {}
		sprite_tilePopup:render(mya_getRenderer(), mya_getWidth()/20*18, mya_getHeight()/20*18)
		for k,v in pairs(assets_tiles) do
			if ex > mya_getWidth()/20*18 then
				ex = mya_getWidth()/20+(tileSize/4)
				ey = ey+tileSize+(tileSize/4)
			end
			table.insert(tileButtons,newTileButton(v, ex,ey,tileSize,tileSize))
			sprite_tile:setTexture(assets:getTexture(v))
			sprite_tile:setX(ex)
			sprite_tile:setY(ey)
			sprite_tile:render(mya_getRenderer(), tileSize, tileSize)
			ex=ex+tileSize+(tileSize/4)
		end
		for k,v in pairs(assets_objects) do
			if ex > mya_getWidth()/20*18 then
				ex = mya_getWidth()/20+(tileSize/4)
				ey = ey+tileSize+(tileSize/4)
			end
			table.insert(tileButtons,newTileButton(v, ex,ey,tileSize,tileSize))
			sprite_tile:setTexture(assets:getTexture(v))
			sprite_tile:setX(ex)
			sprite_tile:setY(ey)
			sprite_tile:render(mya_getRenderer(), tileSize, tileSize)
			ex=ex+tileSize+(tileSize/4)
		end
	end
end