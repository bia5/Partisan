screen = newChild(0, 0, 1920, 1080)

screen_add(screen, "debug_tv", newText("Debug", 0, 1000, 1920, 45, {16,16,16}))

screen_add(screen, "hud", newChild(0, 0, 1920, 1080))
screen_addTop(screen["hud"], "empty1", newEmpty(0, 0, 1920, 10))
screen_addTop(screen["hud"], "player_info", newChild(10, 0, 1910, 110))

--Player HP Bar
screen_addTop(screen["hud"]["player_info"], "hp", newLoadingBar(0,0,960,50,{126,17,20},{232,18,22}))
screen_addTop(screen["hud"]["player_info"], "empty1", newEmpty(0, 0, 1920, 10))

--Player Inventory

--Coop Player HP
screen_addTop(screen["hud"], "coop_player_info", newChild(10, 0, 1910, 110))
screen_addTop(screen["hud"]["coop_player_info"], "player1_hp", newLoadingBar(0,0,120,25,{126,17,20},{232,18,22}))

--Death Screen
screen_add(screen["hud"], "death_popup", newChild("center","center",1080,720))
screen_add(screen["hud"]["death_popup"], "you_died", newText("YOU DIED", "center", "center", 0, 0, {255,16,16}))
screen["hud"]["death_popup"]["you_died"].ratio = 3
screen["hud"]["death_popup"].render = false

tileSize_ = 16
local offsetX = 0
local offsetY = 0
sprite_player = Sprite.new(assets:getTexture("empty"))
sprite_tile = Sprite.new(assets:getTexture("empty"))
sprite_entity = Sprite.new(assets:getTexture("empty"))

function scr_ingame_tupdate()
	tUpdateWorld()
	if not isHosting then
		if tablelength(clients_simplified) ~= tablelength(world.players) then
			print("Player count mismatch")
			message(NET_MSG_SENDPLAYER, {})
		end
	end
end
screen.onTUpdate = scr_ingame_tupdate

function scr_ingame_update()
	updateWorld()

	scr = getScreen(STATE_INGAME)
	scr["hud"]["coop_player_info"].render = false

    --Update Player
	for k, v in pairs(world.players) do
		if v.id == getPlayerID() then
			--Toggles dead popup when player dies
			if v.health < 1 then
				scr["hud"]["death_popup"].render = true
			else
				scr["hud"]["death_popup"].render = false
			end
			offsetX = (mya_getWidth()/2)-(v.x*tileSize)
			offsetY = (mya_getHeight()/2)-(v.y*tileSize)

			scr["hud"]["player_info"]["hp"].w = v.maxHealth*8
			scr["hud"]["player_info"]["hp"].ratio = v.health/v.maxHealth

			tilex = math.floor((mouseX-offsetX)/tileSize)
			tiley = math.floor((mouseY-offsetY)/tileSize)
			scr["debug_tv"].text = "FPS: "..mya_getFPS()..", X: "..tostring(math.floor(v.x*100)/100)..", Y: "..tostring(math.floor(v.y*100)/100)..", Delta: "..(mya_getDelta()/1000)..", Zoom: "..tileSize_..", MouseX: "..mouseX..", MouseY: "..mouseY..", TileX: "..tilex..", TileY: "..tiley
		else
			scr["hud"]["coop_player_info"].render = true
			scr["hud"]["coop_player_info"]["player1_hp"].ratio = v.health/v.maxHealth
		end
	end
end
screen.onUpdate = scr_ingame_update

function scr_ingame_render()
    tileSize = mya_getHeight()/tileSize_

    --Get render distance for tiles
	renderDistH = tileSize_
	renderDistV = tileSize_/2+1

	t_tiles = {}
	
	if getPlayer(getPlayerID()) ~= nil then
		x = math.floor(getPlayer(getPlayerID()).x+.5)
		y = math.floor(getPlayer(getPlayerID()).y+.5)

		--Render Tiles
		for ii = y-renderDistV, y+renderDistV do
			for i = x-renderDistH, x+renderDistH do
				tiles = getTile(i,ii)
				if tiles ~= nil then
					for k,tile in pairs(tiles) do
						if k > 50 then
							table.insert(t_tiles, tile)
						else
							sprite_tile:setTexture(assets:getTexture(tile.tex))
							sprite_tile:setX((i*tileSize)+offsetX)
							sprite_tile:setY((ii*tileSize)+offsetY)
							sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
						end
					end
				end
			end
		end
	end

	local es = table.copy(world.entities)
	for k,v in pairs(world.players) do
		table.insert(es, v)
	end

	for k, v in spairs(es, function(t, a, b) return t[a].y < t[b].y end) do
		if v ~= nil then
			if v.number ~= nil then
				sprite_player:setTexture(assets:getTexture("player"..v.number.."_"..v.deg.."_0"))
				sprite_player:setX(((v.x-(v.w/2))*tileSize)+offsetX)
				sprite_player:setY(((v.y-v.h)*tileSize)+offsetY)
				sprite_player:render(mya_getRenderer(), tileSize*v.w, tileSize*v.h)
			else
				sprite_entity:setTexture(assets:getTexture(v.tex))
				sprite_entity:setX(((v.x-(v.w/2))*tileSize)+offsetX)
				sprite_entity:setY(((v.y-v.h)*tileSize)+offsetY)
				sprite_entity:renderFlip(mya_getRenderer(), tileSize*v.w, tileSize*v.h, v.deg, false)
			end
		end
	end
	es = nil

	for k,tile in pairs(t_tiles) do
		sprite_tile:setTexture(assets:getTexture(tile.tex))
		sprite_tile:setX((i*tileSize)+offsetX)
		sprite_tile:setY((ii*tileSize)+offsetY)
		sprite_tile:renderFlip(mya_getRenderer(), tileSize+1, tileSize+1,tile.deg, false)
	end
end
screen.onRender = scr_ingame_render

addScreen(STATE_INGAME, screen)