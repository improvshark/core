local expect = require("cc.expect").expect
local json = require("json")

local currentPath = string.sub(debug.getinfo(1).source, 2)
local baseDir = fs.getDir(fs.getDir(currentPath))


local function coreDir()
	return baseDir
end

local function coreConfigPath()
	return fs.combine(coreDir(), '/etc/coreConfig.json')
end

---Load a config file at the specified path
---@param path string
---@return string
local function loadConfig(path)
	expect(1, path, 'string')
	if fs.exists(path) then
		local fileA = assert(fs.open(path, "r"))
		local temp = json.decode(fileA.readAll())
		fileA.close()
		return temp
	else
		error('unable to load config: ' .. path)
	end
end

local function saveConfig(path, obj)
	expect(1, path, 'string')
	expect(2, obj, 'table')
	local fileA = assert(fs.open(path, "w"))
	local string = json.encodePretty(obj)
	fileA.write(string)
	fileA.close()
	return true
end

---get and set core config
---@param table any
---@return string|boolean
local function config(table)
	expect(1, table, 'nil', 'table')
	local configPath = coreConfigPath()
	if table == nil then
		return loadConfig(configPath)
	end
	return assert(saveConfig(configPath, table))
end

local function addBoot(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.boot == nil then userConfig.boot = {} end
	table.insert(userConfig.boot, path)
	config(userConfig)
end

local function removeBoot(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.boot == nil then userConfig.boot = {} end
	for i = 1, #userConfig.boot do
		if userConfig.boot[i] == path then table.remove(userConfig.boot, i) end
	end
	config(userConfig)
end

local function addLib(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.lib == nil then userConfig.lib = {} end
	table.insert(userConfig.lib, path)
	config(userConfig)
end

local function removeLib(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.lib == nil then userConfig.lib = {} end
	for i = 1, #userConfig.lib do
		if userConfig.lib[i] == path then table.remove(userConfig.lib, i) end
	end
	config(userConfig)
end

local function addPath(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.path == nil then userConfig.path = {} end
	table.insert(userConfig.path, path)
	config(userConfig)
end

local function removePath(path)
	expect(1, path, 'string')
	local userConfig = config()
	if userConfig.path == nil then userConfig.path = {} end
	for i = 1, #userConfig.path do
		if userConfig.path[i] == path then table.remove(userConfig.path, i) end
	end
	config(userConfig)
end

local function path()
	local config = config();
	local path = ''
	for i = 1, #config.path do
		path = path .. '/' .. fs.combine(coreDir(), config.path[i])
		if i ~= #config.path then
			path = path .. ':'
		end
	end
	return path
end

return {
	coreDir = coreDir,
	config = config,
	loadConfig = loadConfig,
	saveConfig = saveConfig,
	addBoot = addBoot,
	removeBoot = removeBoot,
	addLib = addLib,
	removeLib = removeLib,
	path = path,
	addPath = addPath,
	removePath = removePath,
}
