network = Network.new()
local net_ping_tick = 0
local net_ask_tick = 0
net_connected = 0
clients = {}
clients_simplified = {}
clients_simplified[1] = {}
clients_simplified[2] = {}

packet_out = {}
packet_inc = {}
packet_out_s = {}
packet_inc_s = {}

function removeMyself()
	network:close()
	state = STATE_JOINSERVER

	--Reset world to empty
	world = {} --In display order :D
	world.isLinked = false

	world.undertiles = {}
	world.tiles = {}
	world.objects = {}

	world.players = {}
end

function client_leave()
	message("remove", {getPlayerID()})
	network_update()
	network:close()
	state = STATE_JOINSERVER

	--Reset world to empty
	world = {} --In display order :D
	world.isLinked = false

	world.undertiles = {}
	world.tiles = {}
	world.objects = {}

	world.players = {}
end

function message(_id, _args)
	if not packet_out["messages"] then
		packet_out["messages"] = {}
	end
	local pack = {}
	pack.id = _id
	pack.args = _args
	table.insert(packet_out["messages"], pack)
end

function server_message(_id, _args)
	if not packet_out_s["messages"] then
		packet_out_s["messages"] = {}
	end
	local pack = {}
	pack.id = _id
	pack.args = _args
	table.insert(packet_out_s["messages"], pack)
end

function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)
	else
		network:init(isHosting)

		message("join", {settings.player_name, getPlayerID()})
	end
end

function addClient(_ip, _name, _id)
	net_connected = net_connected + 1
	if _ip == "host" then
		print("New Client: ".._name.." (host)")
	else
		print("New Client: ".._name.." (internet), id:".._id)
	end
	clients[_id] = {}
	clients[_id].ip = _ip
	clients[_id].name = _name
	clients[_id].player = -1
	clients[_id].ping = 0
	clients[_id].ping_ = 0
	clients[_id].ping_r = true

	newPlayer(_id, _name, 2.5, 2.5)
	var = getPlayer(_id)
	var.isOnline = true

	table.insert(clients_simplified[1],_id)
	clients_simplified[2][_id] = {}
	clients_simplified[2][_id].name = _name
	clients_simplified[2][_id].ping = 0

	packet_out_s["clients_simplified"] = clients_simplified
end

function removeClient(_id)
	net_connected = net_connected - 1
	print("Client Leaving: "..clients[_id].name)
	clients[_id] = nil
	clients_simplified[2][_id] = nil
	removeFromTable(clients_simplified[1],_id)
	clients_simplified_ = clients_simplified
	clients_simplified = {}
	clients_simplified[1] = {}
	clients_simplified[2] = {}
	for k,v in pairs(clients_simplified_[1]) do
		table.insert(clients_simplified[1], v)
	end
	clients_simplified[2] = clients_simplified_[2]

	var = getPlayer(_id)
	if var then
		var.isOnline = false
	end
end

function findClient(_ip)
	for k,v in pairs(clients) do
		if v.ip == _ip then
			return k
		end
	end
end

function sendWorld()
	server_message("world",{json.encode(world)})
end
function sendPlayers()
	server_message("players",{json.encode(world.players)})
end
function sendUndertiles()
	server_message("undertiles",{json.encode(world.undertiles)})
end
function sendTiles()
	server_message("tiles",{json.encode(world.tiles)})
end
function sendObjects()
	server_message("objects",{json.encode(world.objects)})
end

function server_handlePacket()
	if packet_inc_s["messages"] then
		for k, v in pairs(packet_inc_s["messages"]) do
			--print("server: "..json.encode(v))

			if v.id == "join" then
				if net_connected ~= net_max then
					addClient(ip, v.args[1], v.args[2])
				else
					print("Max clients connected, rejecting: "..v.args[1])
					network:sendMessage("full", ip)
				end
			elseif v.id == "remove" then
				server_message("remove", {v.args[1]})
				network:sendMessage("packet"..net_split1..json.encode(packet_out_s), clients[v.args[1]].ip)
				removeClient(v.args[1])
				sendPlayers() -- update all client's player info
			elseif v.id == "pong" then
				if clients[v.args[1]] then
					clients[v.args[1]].ping = clients[v.args[1]].ping_*(1000/mya_getUPS())
					clients[v.args[1]].ping_ = 0
					clients[v.args[1]].ping_r = true

					clients_simplified[2][v.args[1]].ping = clients[v.args[1]].ping
					packet_out_s["clients_simplified"] = clients_simplified
				end
			elseif v.id == "w" then
				getPlayer(v.args[1]).w = v.args[2]
				server_message(v.id,v.args)
			elseif v.id == "s" then
				getPlayer(v.args[1]).s = v.args[2]
				server_message(v.id,v.args)
			elseif v.id == "a" then
				getPlayer(v.args[1]).a = v.args[2]
				server_message(v.id,v.args)
			elseif v.id == "d" then
				getPlayer(v.args[1]).d = v.args[2]
				server_message(v.id,v.args)
			elseif v.id == "player" then
				getPlayer(v.args[1]).x = v.args[2]
				getPlayer(v.args[1]).y = v.args[3]
			elseif v.id == "gib_players" then
				sendPlayers()
				print("sending players...")
			elseif v.id == "gib_undertiles" then
				sendUndertiles()
				print("sending undertiles...")
			elseif v.id == "gib_tiles" then
				sendTiles()
				print("sending tiles...")
			elseif v.id == "gib_objects" then
				sendObjects()
				print("sending objects...")
			end
		end
	end
end

function handlePacket()
	if packet_inc["messages"] then
		for k,v in pairs(packet_inc["messages"]) do
			--print(json.encode(v))

			if v.id == "remove" then
				if v.args[1] == getPlayerID() then
					removeMyself()
				end
			elseif v.id == "quitting" then
				network:close()
				clients_simplified = {}
				state = STATE_JOINSERVER
			elseif v.id == "ingame" then
				state = STATE_INGAME
			elseif v.id == "world" then
				world = json.decode(v.args[1])
			elseif v.id == "players" then
				world.players = json.decode(v.args[1])
			elseif v.id == "undertiles" then
				world.undertiles = json.decode(v.args[1])
			elseif v.id == "tiles" then
				world.tiles = json.decode(v.args[1])
			elseif v.id == "objects" then
				world.objects = json.decode(v.args[1])
			elseif v.args[1] ~= getPlayerID() then
				if getPlayer(v.args[1]) ~= nil then
					if v.id == "w" then
						if v.args[1] ~= getPlayerID() then
							getPlayer(v.args[1]).w = v.args[2]
						end
					elseif v.id == "s" then
						if v.args[1] ~= getPlayerID() then
							getPlayer(v.args[1]).s = v.args[2]
						end
					elseif v.id == "a" then
						if v.args[1] ~= getPlayerID() then
							getPlayer(v.args[1]).a = v.args[2]
						end
					elseif v.id == "d" then
						if v.args[1] ~= getPlayerID() then
							getPlayer(v.args[1]).d = v.args[2]
						end
					elseif v.id == "player" then
						if getPlayer(v.args[1]) ~= nil then
							getPlayer(v.args[1]).x = v.args[2]
							getPlayer(v.args[1]).y = v.args[3]
						end
					end
				end
			end
		end
	end
end

function event_networkMessage(clientMessage)
	msg = network:getDataFromClientMessage(clientMessage)
	ip = network:getIPFromClientMessage(clientMessage)
	msgd = mysplit(msg, net_split1)

	if isHosting then --Server stuffs
		if msgd[1] == "packet_s" then
			packet_inc_s = json.decode(msgd[2])

			if packet_inc_s then
				server_handlePacket()
			end
		end
	else -- Not Server Stuff
		if msgd[1] == "full" then
			print("Server is full.")
			state = STATE_JOINSERVER
		elseif msgd[1] == "_ping" then
			message("pong",{msgd[2]})
		elseif msgd[1] == "packet" then -- Recieves packet from server
			packet_inc = json.decode(msgd[2])

			if packet_inc then
				if packet_inc["clients_simplified"] then
					clients_simplified = packet_inc["clients_simplified"]
				end

				handlePacket()
			end
		end
	end
end

function network_update()
	if isHosting then
		if tablelength(packet_out_s) > 0 then
			for k, v in pairs(clients) do
				if v.ip == "host" then
					packet_inc = packet_out_s
					handlePacket()
				else
					--print(string.len("packet"..net_split1..json.encode(packet_out_s)).." - ".."packet"..net_split1..json.encode(packet_out_s))
					network:sendMessage("packet"..net_split1..json.encode(packet_out_s), v.ip)
				end
				--print(json.encode(packet_out_s))
			end
			packet_out_s = {}
		end

		-- TEST PING
		net_ping_tick = net_ping_tick + 1
		if net_ping_tick == mya_getUPS() then
			net_ping_tick = 0

			--update player location
			if state == STATE_INGAME then
				server_message("ingame", {})
				for k, v in pairs(world.players) do
					server_message("player",{k,v.x,v.y})
					--print(v.name..": "..v.x..", "..v.y)
				end
			end

			for k, v in pairs(clients) do
				if v.ping_r then
					if v.ip ~= "host" then
						v.ping_r = false
						v.ping_ = 0
						--server_message("ping", {k})
						--network:sendMessage("_ping"..net_split1..k, v.ip)
					end
				end
			end
		end

		for k, v in pairs(clients) do
			v.ping_ = v.ping_ + 1
		end
		-- END OF TEST PING
	end

	if isHosting == false then
		if world.isLinked == false then
			net_ask_tick = net_ask_tick + 1
			if net_ask_tick == mya_getUPS() then
				net_ask_tick = 0
				if tablelength(world.players) < 2 then
					print("gib players")
					message("gib_players",{})
				else
					if tablelength(world.undertiles) < 1 then
						print("gib undertiles")
						message("gib_undertiles",{})
					else
						if tablelength(world.tiles) < 1 then
							print("gib tiles")
							message("gib_tiles",{})
						else
							if tablelength(world.objects) < 1 then
								print("gib objects")
								message("gib_objects",{})
							else
								print("linked :D")
								world.isLinked = true
							end
						end
					end
				end
			end
		end
	end

	-- Sends Packet_out to server
	if tablelength(packet_out) > 0 then
		if isHosting then
			packet_inc_s = packet_out
			server_handlePacket()
		else
			local pack = "packet_s"..net_split1..json.encode(packet_out)
			network:sendMessage(pack, network:getIP())
		end
		packet_out = {}
	end
end