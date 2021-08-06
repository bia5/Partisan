network = Network.new()
local net_clients = 0
local net_ping_tick = 0
net_connected = 0
clients = {}

function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)
	else
		network:init(isHosting)

		network:sendMessage("hi-"..settings.player_name, network:getIP())
	end
end

function addClient(_ip, _name)
	net_connected = net_connected + 1
	net_clients = net_clients + 1
	if _ip == "host" then
		print("New Client: ".._name.." (host)")
	else
		print("New Client: ".._name.." (internet)")
	end
	clients[net_clients] = {}
	clients[net_clients].ip = _ip
	clients[net_clients].name = _name
	clients[net_clients].player = -1
	clients[net_clients].ping = 0
	clients[net_clients].ping_ = 0
	clients[net_clients].ping_r = true
end

function removeClient(_id)
	net_connected = net_connected - 1
	print("Client Leaving: "..clients[_id].name)
	clients[_id] = nil
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

	msgd = mysplit(msg,"-") -- Splits incoming messages by "-"

	if isHosting then --Server stuffs
		if msgd[1] == "hi" then
			if net_connected ~= net_max then
				addClient(ip, msgd[2])
				network:sendMessage("newNumber-"..findClient(ip), ip)
			else
				print("Max clients connected, rejecting: ".._name)
				network:sendMessage("full", ip)
			end
		elseif msgd[1] == "bye" then
			removeClient(tonumber(msgd[2]))
		elseif msgd[1] == "_pong" then
			clients[tonumber(msgd[2])].ping = clients[tonumber(msgd[2])].ping_
			clients[tonumber(msgd[2])].ping_ = 0
			clients[tonumber(msgd[2])].ping_r = true
			--print(clients[tonumber(msgd[2])].name.."'s ping: "..clients[tonumber(msgd[2])].ping.."ms")
		end
	else -- Not Server Stuff
		if msgd[1] == "newNumber" then
			net_number = tonumber(msgd[2])
			print("Server Responded.")
		elseif msgd[1] == "full" then
			print("Server is full.")
			state = STATE_MAINMENU
		elseif msgd[1] == "_ping" then
			network:sendMessage("_pong-"..msgd[2], network:getIP())
		end
	end
end

function network_update()
	net_ping_tick = net_ping_tick + 1
	if net_ping_tick == mya_getUPS() then
		net_ping_tick = 0
		for k, v in pairs(clients) do
			if v.ping_r then
				if v.ip ~= "host" then
					v.ping_r = false
					v.ping_ = 0
					network:sendMessage("_ping-"..k, v.ip)
				end
			end
		end
	end

	for k, v in pairs(clients) do
		v.ping_ = v.ping_ + 1
	end
end