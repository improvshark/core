local currentPath = string.sub(debug.getinfo(1).source, 2)
local coreDir = fs.getDir(currentPath)
-- package.path = '/' .. coreDir .. '/lib/?.lua;' .. package.path
package.path = '/lib/?.lua;' .. package.path

local homeDir = fs.combine(coreDir, '/home')
if not fs.isDir(homeDir) then fs.makeDir(homeDir) end
shell.setDir(coreDir .. '/home')

-- loading minimum apis.
local core = require('core')
local config = core.config();

-- set shell path
shell.setPath(core.path() .. ':' .. shell.path())

-- loading apis.
print('loading apis')
for i = 1, #config.api do
	local path = fs.combine(coreDir, config.api[i])
	print('loading ' .. path)
	os.loadAPI(path)
end

-- loading daemonManager.
print('loading daemon Manager')
if not daemon.isInstalled() then daemon.install() end

-- run boot programs
if config.boot ~= nil then
	for i = 1, #config.boot do
		shell.run('/' .. fs.combine(coreDir, config.boot[i]))
	end
end

-- use shell clone
shell.exit()
os.run(_ENV, fs.combine(coreDir, '/bin/shell.lua'))
