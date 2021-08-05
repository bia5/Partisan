network = Network.new()
local net_clients = 0
clients = {}

function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)
	else
		network:init(isHosting)

		network:sendMessage("hi-"..player_name, network:getIP())
	end
end

function addClient(_ip, _name)
	net_clients = net_clients + 1
	clients[net_clients] = {}
	clients[net_clients].ip = _ip
	clients[net_clients].name = _name
end

function removeClient(_id)
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
		print("net_inc: "..msg)
	end

	msgd = mysplit(msg,"-") -- Splits incoming messages by "-"

	if isHosting then --Server stuffs
		if msgd[1] == "hi" then
			addClient(ip, msgd[2])
			network:sendMessage("newNumber-"..findClient(ip), ip)
		elseif msgd[1] == "bye" then
			removeClient(tonumber(msgd[2]))
		end
	else -- Not Server Stuff
		if msgd[1] == "newNumber" then
			net_number = tonumber(msgd[2])
		end
	end
end