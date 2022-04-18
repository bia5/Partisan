local tileSize_ = 16
local tileSize = mya_getHeight()/tileSize_

local offsetX = 0
local offsetY = 0

local playerX = 0
local playerY = 0
local playerSpeed = 10
local playerW = false
local playerA = false
local playerS = false
local playerD = false

local tilePopup = false
tileButtons = {}

function newTileButton(id, x, y, w, h)
	btn = {}

	btn.id = id
	btn.x = x
	btn.y = y
	btn.w = w
	btn.h = h

	return btn
end

function getTileButton(x,y)
	for k, v in pairs(tileButtons) do
		if x >= v.x and x <= v.x+v.w and y >= v.y and y <= v.y+v.h then
			return v.id
		end
	end
end

sprite_tile = Sprite.new(assets:getTexture("empty"))
spr_boss = Sprite.new(assets:getTexture("empty"))

sprite_tilePopup = Sprite.new(assets:getTexture("empty"))
sprite_tilePopup:setRenderOutline(true)
sprite_tilePopup:setOutlineColor(0, 0, 0, 128)

buildTile = newTile("tile_grass_0")
layer = "undertiles"

function zoomOut()
	tileSize_ = tileSize_ + 5
	tileSize = mya_getHeight()/tileSize_
end
function zoomIn()
	tileSize_ = tileSize_ - 5
	tileSize = mya_getHeight()/tileSize_
end

--buttons
local buttons = {}

local yval = mya_getHeight()/20
local function newButton(id, x, y, text, size)
	button = {}
	button.isPressed = false
	button.tv = TextView.new(font[size], text, x, y, mya_getRenderer())
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

local function defineButtons()
	yval = mya_getHeight()/20
	newButton("newworld", 0, yval, "New World", 32)
	newButton("tiledropper", 0, yval, "Tile Dropper", 32)
	newButton("newtile", 0, yval, "New Tile", 32)
	newButton("edittile", 0, yval, "Edit Tile", 32)
	newButton("gettile", 0, yval, "Get Tile", 32)

	yval = tileSize
	newButton("buildmode", mya_getWidth()/8*7, yval, "Build Mode", 32)
	newButton("destroymode", mya_getWidth()/8*7, yval, "Destroy Mode", 32)
	newButton("togglelayer", mya_getWidth()/8*7, yval, "Toggle Layer", 32)

	yval = mya_getHeight()/2
	newButton("zoom", mya_getWidth()/8*7, yval, "Zoom", 32)
	newButton("speed", mya_getWidth()/8*7, yval, "Speed", 32)
	newButton("save", mya_getWidth()/8*7, yval, "Save", 32)
	newButton("load", mya_getWidth()/8*7, yval, "Load", 32)
	newButton("worldid", mya_getWidth()/8*7, yval, "Set World ID", 32)
	newButton("objectid", mya_getWidth()/8*7, yval, "Set Object ID", 32)
end

function getInput(type)
	print("Value Type: "..type)
	input = io.read()
	if type == "number" then
		return tonumber(input)
	elseif type == "string" then
		return input
	elseif type == "boolean" then
		if input == "true" then
			return true
		elseif input == "false" then
			return false
		end
	end
	return nil
end

local screen_le_debug = TextView.new(font[32], "Debug", 0, 0, mya_getRenderer())

function screen_le_windowResize(w, h)
	tileSize = mya_getHeight()/tileSize_

	screen_le_debug:setFont(font[32], mya_getRenderer())
	
	buttons = {}
	defineButtons()
end
screen_le_windowResize(mya_getWidth(), mya_getHeight())

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

function screen_le_tupdate()
	
end

tilex = 0
tiley = 0

mouseDown = false
hovering = false

mode_dropper = false
mode_build = false
mode_destroy = false
function screen_le_mouseButtonUp(btn)
	mouseDown = false
	tilex = math.floor((mouseX-offsetX)/tileSize)
	tiley = math.floor((mouseY-offsetY)/tileSize)
	
	if tilePopup == false then
		hovering = false
		for k, v in pairs(buttons) do
			if mouseX < v.x + v.w and mouseX > v.x and mouseY < v.y + v.h and mouseY > v.y then
				v.isPressed = true
				hovering = true
			else
				v.isPressed = false
			end
		end

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
	else
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

	if tilePopup == false then
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
		
		offsetX = (mya_getWidth()/2)-(playerX*tileSize)-tileSize/2
		offsetY = (mya_getHeight()/2)-(playerY*tileSize)-tileSize/2
		tilex = math.floor((mouseX-offsetX)/tileSize)
		tiley = math.floor((mouseY-offsetY)/tileSize)


		hovering = false
		for k, v in pairs(buttons) do
			if mouseX < v.x + v.w and mouseX > v.x and mouseY < v.y + v.h and mouseY > v.y then
				v.isPressed = true
				hovering = true
			else
				v.isPressed = false
			end
		end
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
		sprite_tilePopup:setX(mya_getWidth()/20)
		sprite_tilePopup:setY(mya_getHeight()/20)
	end
	screen_le_debug:setText("FPS: "..mya_getFPS()..", X: "..tostring(math.floor(playerX*100)/100)..", Y: "..tostring(math.floor(playerY*100)/100)..", Delta: "..(mya_getDelta()/1000)..", tileX: "..tilex..", tileY: "..tiley..", Zoom: "..tileSize_, mya_getRenderer())
end

function screen_le_render()
	renderDistH = tileSize_
	renderDistV = tileSize_/2
	x = math.floor(playerX+.5)
	y = math.floor(playerY+.5)
	
	--Render Undertiles
	for ii = y-renderDistV, y+renderDistV do
		for i = x-renderDistH, x+renderDistH do
			tile = world.undertiles[i.."-"..ii]
			if tile ~= nil then
				sprite_tile:setTexture(assets:getTexture(tile.tex))
				sprite_tile:setX((i*tileSize)+offsetX)
				sprite_tile:setY((ii*tileSize)+offsetY)
				sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
			end

			tile = world.tiles[i.."-"..ii]
			if tile ~= nil then
				sprite_tile:setTexture(assets:getTexture(tile.tex))
				sprite_tile:setX((i*tileSize)+offsetX)
				sprite_tile:setY((ii*tileSize)+offsetY)
				sprite_tile:render(mya_getRenderer(), tileSize+1, tileSize+1)
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
				sprite_tile:render(mya_getRenderer(), v.w*tileSize, v.h*tileSize)
			end
		end
	end

	--Render Entities
	for k, v in pairs(world.entities) do
		spr_boss:setTexture(assets:getTexture(v.id))
		spr_boss:setX((v.x*tileSize)+offsetX)
		spr_boss:setY((v.y*tileSize)+offsetY)
		spr_boss:render(mya_getRenderer(), tileSize*v.w, tileSize*v.h)
	end

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