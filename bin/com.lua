local channel = 1337
local modem = nil
local side = nil
local protocol = 'remote'
--
local function getModem()
	local sides = { "front", "back", "left", "right", "top", "bottom" }
	for i = 1, #sides do
		if peripheral.isPresent(sides[i]) == true and tostring(peripheral.getType(sides[i])) == 'modem' then
			return peripheral.wrap(sides[i]), sides[i]
		end
	end
	return false
end

local function close()
	modem.close(channel)
end

local function list(sleepTime)
	if sleepTime == nil then sleepTime = 1 end
	local message = { messageType = 'function', message = 'getLabel' }
	rednet.broadcast(textutils.serialize(message), protocol)
	parallel.waitForAny(function() sleep(sleepTime) end, function()
		while true do
			local senderId, message, distance = rednet.receive(protocol)
			message = textutils.unserialize(message)
			if message ~= nil and message.label ~= nil then
				print(message.label)
			end
		end
	end)
end

local function getFuel(name, sleepTime)
	id = { rednet.lookup(protocol, name) }
	for i = 1, #id do
		local message = { messageType = 'function', message = 'getFuel' }
		rednet.send(id[i], textutils.serialize(message), protocol)
		parallel.waitForAny(function() sleep(sleepTime) end, function()
			while true do
				local senderId, message, distance = rednet.receive(protocol)
				message = textutils.unserialize(message)
				if message ~= nil and message.fuel ~= nil then
					print('id: ' .. id[i] .. ' fuel: ' .. message.fuel)
				end
			end
		end)
	end
end

local function sendCommand(name, arguments)
	local id = { rednet.lookup(protocol, name) }
	local commandArgs = ""
	for i = 1, #arguments do
		commandArgs = commandArgs .. " " .. arguments[i]
	end
	for i = 1, #id do
		message = { messageType = 'command', command = commandArgs }
		rednet.send(id[i], textutils.serialize(message), protocol)
		parallel.waitForAny(function() sleep(1) end, function()
			while true do
				local senderId, message, distance = rednet.receive(protocol)
				if message ~= nil and message.success ~= nil then
					print(message.success)
				end
			end
		end)
	end
end

local arg = { ... }

local function main()
	-- modem setup
	local modem, side = assert(getModem())
	if modem == false then
		print('no modem found!')
		return
	else
		--print('starting modem')
		if not modem.isOpen then
			modem.open(channel)
		end
		if not rednet.isOpen(side) then
			rednet.open(side)
		end
		rednet.host(protocol, os.getComputerLabel())
	end

	-- handle command
	argparse = require('argparse')
	local parser = argparse("apk", "core package manager")
	parser:option('-s --sleep')
	parser:command("list")
	parser:command("fuel"):argument('name')
	local command = parser:command("command cmd")
	command:argument('name')
	command:argument('message'):args('*')

	local args = parser:parse(arg)
	local sleep = args['sleep'] or 1

	if args['list'] then
		list(sleep)
	elseif args['fuel'] then
		getFuel(args['name'], sleep)
	elseif args['command'] then
		sendCommand(args['name'], args['message'])
	end

	close()
end

main()
