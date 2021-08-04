network = Network.new()

function network_start()
	network:setServerName(net_ip)
	network:setPort(net_port)

	if isHosting then
		network:init(isHosting)
	else
		network:init(isHosting)

		network:sendMessage("hi host!!!", network:getIP())
	end
end

function event_networkMessage(clientMessage) 
	if isHosting then --Server stuffs
		msg = network:getDataFromClientMessage(clientMessage)
		ip = network:getIPFromClientMessage(clientMessage)

		if msg == "hi host!!!" then
			network:sendMessage("hey...", ip) -- temp
		end
	else
		--Not server stuffs
	end
end