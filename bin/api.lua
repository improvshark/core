local vocal = true;

function isApi(path)
	return true
end

local function loadApi(path)
	if isApi(path) then
		if os.loadAPI(path) and vocal then
			print('+ loaded: ' .. fs.getName(path))
			return true
		end
	else
		return false
	end
end

local function unloadApi(path)
	if isApi(path) then
		local name = string.gsub(fs.getName(path), '.lua$', '')
		os.unloadAPI(name)
		if vocal then
			print('~ unloaded: ' .. fs.getName(path))
			return true
		end
	else
		return false
	end
end

local function load(path, recursive)

	if fs.exists(path) == false then
		print('file or path does not exist')
		return false
	end

	if fs.isDir(path) then
		local table = fs.list(path)
		for i = 1, #table do
			if recursive == true and fs.isDir(table[i]) then
				load(fs.combine(path, table[i]), true)
			else
				loadApi(fs.combine(path, table[i]))
			end
		end
	else
		loadApi(path)
	end
end

local function unload(path, recursive)

	if fs.exists(path) == false then
		print('file or path does not exist')
		return false
	end

	if fs.isDir(path) then
		local table = fs.list(path)
		for i = 1, #table do
			if recursive == true and fs.isDir(table[i]) then
				unload(fs.combine(path, table[i]), true)
			else
				unloadApi(fs.combine(path, table[i]))
			end
		end
	else
		unloadApi(path)
	end
end

local arg = { ... }

local function main()

	local argparse = require("argparse")
	local parser = argparse("api", "load an api or folder of apis")
	parser:command("list")
	parser:flag('-r --recursive')
	parser:command("load"):argument('path')
	parser:command("unload"):argument('path')
	local args = parser:parse(arg)
	local recursive = args['recursive'] or false

	if args['load'] then
		load(shell.resolve(args['path']), recursive)
	elseif args['unload'] then
		unload(shell.resolve(args['path']), recursive)
	elseif args['list'] then
		shell.run('apis')
	end
end

main()
