network = Network.new()
local net_ping_tick = 0
net_connected = 0
clients = {}
clients_simplified = {}
clients_simplified[1] = {}
clients_simplified[2] = {}

packet_out = {}
packet_inc = {}
packet_out_s = {}
packet_inc_s = {}

function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)
	else
		network:init(isHosting)

		network:sendMessage("hi"..net_split1..settings.player_name..net_split1..getPlayerID(), network:getIP())
	end
end

function addClient(_ip, _name, _id)
	net_connected = net_connected + 1
	if _ip == "host" then
		print("New Client: ".._name.." (host)")
	else
		print("New Client: ".._name.." (internet)")
	end
	clients[_id] = {}
	clients[_id].ip = _ip
	clients[_id].name = _name
	clients[_id].player = -1
	clients[_id].ping = 0
	clients[_id].ping_ = 0
	clients[_id].ping_r = true


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
end

function findClient(_ip)
	for k,v in pairs(clients) do
		if v.ip == _ip then
			return k
		end
	end
end

function event_networkMessage(clientMessage)
	msg = network:getDataFromClientMessage(clientMessage)
	ip = network:getIPFromClientMessage(clientMessage)
	
	if devmode then
		--print("net_inc: "..msg)
	end

	msgd = mysplit(msg,net_split1) -- Splits incoming messages by "-"

	if isHosting then --Server stuffs
		if msgd[1] == "hi" then
			if net_connected ~= net_max then
				addClient(ip, msgd[2], msgd[3])
			else
				print("Max clients connected, rejecting: "..msgd[2])
				network:sendMessage("full", ip)
			end
		elseif msgd[1] == "bye" then
			removeClient(msgd[2])
		elseif msgd[1] == "_pong" then
			clients[msgd[2]].ping = clients[msgd[2]].ping_*(1000/mya_getUPS())
			clients[msgd[2]].ping_ = 0
			clients[msgd[2]].ping_r = true

			clients_simplified[2][msgd[2]].ping = clients[msgd[2]].ping
			packet_out_s["clients_simplified"] = clients_simplified
			--print(clients[msgd[2]].name.."'s ping: "..clients[msgd[2]].ping-(1000/mya_getUPS()).."-"..clients[msgd[2]].ping.."ms")
		elseif msgd[1] == "packet_s" then
			packet_inc_s = json.decode(msgd[2])
			--print("Recieved Packet from Client!")
		end
	else -- Not Server Stuff
		if msgd[1] == "full" then
			print("Server is full.")
			state = STATE_MAINMENU
		elseif msgd[1] == "_ping" then
			network:sendMessage("_pong"..net_split1..msgd[2], network:getIP())
		elseif msgd[1] == "quitting" then
			network:close()
			clients_simplified = {}
			state = STATE_MAINMENU
		elseif msgd[1] == "packet" then -- Recieves packet from server
			packet_inc = json.decode(msgd[2])
			--print("Recieved Packet from Server!")

			if packet_inc["clients_simplified"] then
				clients_simplified = packet_inc["clients_simplified"]
			end
		end
	end
end

function network_update()
	if isHosting then
		if tablelength(packet_out_s) > 0 then
			--print("Server Packet Out!")
			for k, v in pairs(clients) do
				if v.ip == "host" then
					packet_inc = packet_out_s
					--print("Recieved Packet from Server!")
				else
					network:sendMessage("packet"..net_split1..json.encode(packet_out_s), v.ip)
				end
			end
			packet_out_s = {}
		end

		-- TEST PING
		net_ping_tick = net_ping_tick + 1
		if net_ping_tick == mya_getUPS() then
			net_ping_tick = 0
			for k, v in pairs(clients) do
				if v.ping_r then
					if v.ip ~= "host" then
						v.ping_r = false
						v.ping_ = 0
						network:sendMessage("_ping"..net_split1..k, v.ip)
					end
				end
			end
		end

		for k, v in pairs(clients) do
			v.ping_ = v.ping_ + 1
		end
		-- END OF TEST PING
	end

	-- Sends Packet_out to server
	if tablelength(packet_out) > 0 then
		if isHosting then
			packet_inc_s = packet_out
		else
			network:sendMessage("packet_s"..net_split1..json.encode(packet_out), network:getIP())
		end
		packet_out = {}
		--print("Client Packet Out!")
	end
end