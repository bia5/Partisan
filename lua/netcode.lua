network = Network.new()

--Server Variables

--clients:
--	-id
--	-name
--	-ip
--	-ping
clients = {}

--clients_simplified:
--	-id
--	-name
--	-ping
clients_simplified = {}

packets_s = {} --Packets to client
packets = {} --Packets to server

--Add message to packet
function message(msg, args)
	local packet = {}
	packet.msg = msg
	packet.args = args
	table.insert(packets, packet)
end

--Add packet to packet for server
function server_message(msg, args)
	local packet = {}
	packet.msg = msg
	packet.args = args
	table.insert(packets_s, packet)
end

--Alerts all clients and closes server
function close_server()
	server_message(NET_MSG_SERVERSHUTDOWN, {})
	if net_hasInit then
		net_hasInit = false
		network_update()
	end
	removeMyselfSafe()
end

--Disconnect without network message
function removeMyself()
	network:close()
	net_hasInit = false
	state = STATE_JOINSERVER

	--Reset world to empty
	newWorld()
end

--Disconnect
function removeMyselfSafe()
	if net_hasInit then
		message(NET_MSG_DISCONNECT, {id = getPlayerID()})
		network_update() --Send last packet before network closes
	end
	network:close()
	net_hasInit = false
	state = STATE_JOINSERVER

	--Reset world to empty
	newWorld()
end

--Add Client
function client_join(id, name, ip)
	if clients[id] == nil then
		client = {}
		client.id = id
		client.name = name
		client.ip = ip
		client.ping = 0
		client.isMainPlayer = (ip == "host")
		clients[id] = client
		print("(Server): New client: "..id.." ("..name..")")
	else
		print("(Server): Client already exists: "..id.." ("..name..")")
	end
end

--Remove Client
function client_remove(id)
	if clients[id] ~= nil then
		print("(Server): Client removed: "..id.." ("..clients[id].name..")")
		clients[id] = nil
	else
		print("(Server): Client does not exist: "..id)
	end
end

--Network startup
function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)

		client_join(getPlayerID(), settings.player_name.value, "host")

		--Send clients all clients
		sendAllClients()
	else
		network:init(isHosting)

		local args = {}
		args.name = settings.player_name
		args.id = getPlayerID()

		message(NET_MSG_JOIN, args)
	end
	net_hasInit = true
end

function sendAllClients()
	--Send clients all clients
	local args = {}
	for k, v in pairs(clients) do
		local client = {}
		client.id = v.id
		client.name = v.name
		client.ping = v.ping
		table.insert(args, client)
	end
	server_message(NET_MSG_ALLCLIENTS, args)
end

--Server packet handler
function server_handlePacket(packet)
	--Client join
	if packet.msg == NET_MSG_JOIN then
		if tablelength(clients) < net_max then
			--Add client to clients
			client_join(packet.args.id, packet.args.name, packet.ip)

			--Send clients all clients
			sendAllClients()
		else
			print("(Server): Server is full")

			--Tell client server is full
			local _packet = {}
			_packet.msg = NET_MSG_SERVERFULL
			network:sendMessage(json.encode({_packet}), packet.ip)
		end

	--Client disconnect
	elseif packet.msg == NET_MSG_DISCONNECT then
		--Remove client from clients
		client_remove(packet.args.id)

		--Notify clients
		server_message(NET_MSG_REMOVECLIENT, packet.args)

	--Update player info
	elseif packet.msg == NET_MSG_UPDATEPLAYER then
		server_message(NET_MSG_UPDATEPLAYER, packet.args)

	--Tile Update
	elseif packet.msg == NET_MSG_UPDATE_TILE then
		server_message(NET_MSG_UPDATE_TILE, packet.args)
	end
end

--Client packet handler
function handlePacket(packet)
	--New Client
	if packet.msg == NET_MSG_ALLCLIENTS then
		for k, v in pairs(packet.args) do
			if clients_simplified[v.id] == nil then
				clients_simplified[v.id] = v
				print("New client: "..v.id.." ("..v.name..")")
			end
		end
	
	--Remove Client
	elseif packet.msg == NET_MSG_REMOVECLIENT then
		if clients_simplified[packet.args.id] ~= nil then
			print("Client removed: "..packet.args.id.." ("..clients_simplified[packet.args.id].name..")")
			clients_simplified[packet.args.id] = nil
		end

	--Server Full Handler
	elseif packet.msg == NET_MSG_SERVERFULL then
		print("Server is full")
		removeMyselfSafe()
		state = STATE_JOINSERVER

	--Server Shutdown Handler
	elseif packet.msg == NET_MSG_SERVERSHUTDOWN then
		print("Server shutdown")
		if not isHosting then
			removeMyselfSafe()
		end
		state = STATE_JOINSERVER
	
	--Load level msg
	elseif packet.msg == NET_MSG_LOADLEVEL then
		world_id = packet.args.world_id
		loadWorld()
		if isHosting then
			--Server creates players
			for k, v in pairs(clients) do
				if v.isMainPlayer then
					server_message(NET_MSG_PLAYER, {player = newPlayer(v.id, v.name, world.spawn1X, world.spawn1Y, 1)})
				else
					server_message(NET_MSG_PLAYER, {player = newPlayer(v.id, v.name, world.spawn2X, world.spawn2Y, 2)})
				end
			end
		end
	
	--Switch screen
	elseif packet.msg == NET_MSG_SWITCHSCREEN then
		state = packet.args.state
	
	--Player Update Override
	elseif packet.msg == NET_MSG_PLAYER then
		world.players[packet.args.player.id] = packet.args.player
		print("New player: "..packet.args.player.id.." ("..packet.args.player.name..")")
		tprint(packet.args.player)
		print("\n")

	--Player Update
	elseif packet.msg == NET_MSG_UPDATEPLAYER then
		if packet.args.player.id ~= getPlayerID() then
			world.players[packet.args.player.id] = packet.args.player
		end

	--Tile Update
	elseif packet.msg == NET_MSG_UPDATE_TILE then
		if packet.args.layer == "under" then
			world.undertiles[packet.args.tile.x.."-"..packet.args.tile.y] = packet.args.tile
		elseif packet.args.layer == "tile" then
			world.tiles[packet.args.tile.x.."-"..packet.args.tile.y] = packet.args.tile
		--elseif packet.args.layer == "obj" then
		
		--		NOT READY FOR OBJECTS

		--
		end
	end
end

--Actual network packet handler
function event_networkMessage(clientMessage)
	msg = network:getDataFromClientMessage(clientMessage)
	ip = network:getIPFromClientMessage(clientMessage)
	pack = json.decode(msg)
	for k,v in pairs(pack) do
		v.ip = ip --Pack ip to packet for easy access
		if isHosting then
			server_handlePacket(v)
		else
			handlePacket(v)
		end
	end
end

--On network update (every mya_getUPS() tick)
function network_update()
	--Handle Packet Sending

	--If client is hosting gotta do funky stuff
	if isHosting then
		if tablelength(packets_s) > 0 then
			--Send packet to clients
			for k, v in pairs(clients) do
				if v.ip == "host" then
					--Handle packet locally for server-client
					for k2, v2 in pairs(packets_s) do
						v2.ip = "host"
						handlePacket(v2)
					end
				else
					network:sendMessage(json.encode(packets_s), v.ip)
				end
			end
			packets_s = {}
		end

		--Server-client send packets to server
		if tablelength(packets) > 0 then
			for k, v in pairs(packets) do
				server_handlePacket(v)
			end
			packets = {}
		end
	else
		--Check if there is a packet to send
		if tablelength(packets) > 0 then
			--Send packet
			network:sendMessage(json.encode(packets), network:getIP())
			packets = {}
		end
	end
end