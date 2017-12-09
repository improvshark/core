

local vocal = true;

function isApi(path)
	return true
end

local function loadApi(path)
	if isApi(path) then
		if os.loadAPI(path) and vocal then
   			print('+ loaded: ' .. fs.getName(path) )
   			return true
   		end
	else
		return false
	end
end

local function unloadApi(path)
	if isApi(path) then
		os.unloadAPI(fs.getName(path))
	 	if vocal then
   			print('~ unloaded: ' .. fs.getName(path) )
   			return true
   		end
	else
		return false
	end
end

local function load(path, recursive)

	if  fs.exists(path) == false  then
		print('file or path does not exist')
		return false
	end

	if fs.isDir(path) then
		local table = fs.list(path)
		for i=1,#table do
   			if recursive == true and fs.isDir(table[i]) then
   				load(fs.combine(path, table[i]), true)
   			else
   				loadApi(fs.combine(path, table[i]) )
   			end
		end
	else
		loadApi(path)
	end
end

local function unload(path, recursive)

	if  fs.exists(path) == false  then
		print('file or path does not exist')
		return false
	end

	if fs.isDir(path) then
		local table = fs.list(path)
		for i=1,#table do
   			if recursive == true and fs.isDir(table[i]) then
   				unload(fs.combine(path, table[i]), true)
   			else
   				unloadApi(fs.combine(path, table[i]) )
   			end
		end
	else
		unloadApi(path)
	end
end

local arg = {...}

local function main()

	if arg[1] == nil then
		print("api <load/unload> <path/file> ")
	end

	if arg[1] == "load" and arg[2] ~= nil then
		load(shell.resolve(arg[2]), false)
	end

	if arg[1] == "unload" and arg[2] ~= nil then
		unload(shell.resolve(arg[2]), false)
	end

	if arg[1] == "list" then
		shell.run('apis')
	end

end


main()