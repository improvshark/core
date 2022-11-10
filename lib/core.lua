local baseDir = ''

function coreDir()
	return  baseDir
end

function loadConfig(path)
	if fs.exists(path) then
		local fileA = assert(fs.open(path, "r"))
		temp = json.decode(fileA.readAll())
		fileA.close()
		return temp
	else
		return nil
	end
end

function saveConfig(path, obj)
	local fileA = assert(fs.open(path,"w"))
	string = json.encodePretty(obj)
	fileA.write(string)
	fileA.close()
end

function addBoot(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.boot == nil then userConfig.boot = {} end
	table.insert(userConfig.boot,path)
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function removeBoot(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.boot == nil then userConfig.boot = {} end
	for i=1, #userConfig.boot do
	if userConfig.boot[i] == path then table.remove(userConfig.boot,i) end
	end
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function addLib(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.lib == nil then userConfig.lib = {} end
	table.insert(userConfig.lib,path)
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function removeLib(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.lib == nil then userConfig.lib = {} end
	for i=1, #userConfig.lib do
	if userConfig.lib[i] == path then table.remove(userConfig.lib,i) end
	end
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function addPath(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.path == nil then userConfig.path = {} end
	table.insert(userConfig.path,path)
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function removePath(path)
	local userConfig = loadConfig(core.coreDir()..'/etc/coreConfig')
	if userConfig.path == nil then userConfig.path = {} end
	for i=1, #userConfig.path do
	if userConfig.path[i] == path then table.remove(userConfig.path,i) end
	end
	saveConfig(core.coreDir()..'/etc/coreConfig', userConfig)
end

function isApi(path)

end

function isProgram(path)

end


--[[
function loadProgram(path, reqursive)
	if  fs.exists(path) == false  then
		print('fileA or path does not exist')
		return false
	end

	if fs.isDir(path) then
		local table = fs.list(path)
		for i=1,#table do
   			if reqursive == true and fs.isDir(table[i]) then
   				loadProgram(fs.combine(path, table[i]), true)
   			else
   				shell.setPath(shell.path() .. ':' fs.combine(path, table[i]) ) -- cannot use shell. api in an api
   			end
		end
	else
		loadApi(path)
	end
end
]]--
