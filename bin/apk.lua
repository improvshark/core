local core = require('core')
local argparse = require("argparse")
local tmpDir = core.coreDir() .. '/modules'
local moduleList = core.loadConfig(core.coreDir() .. '/etc/moduleList.json')

local function list(...)
	for key, value in pairs(moduleList) do
		print(tostring(key) .. ": " .. string.sub(value.shortDisc, 1, 22))
	end
end

local function install(name)
	if name == nil then return false end
	for key, value in pairs(moduleList) do
		if name == tostring(key) then
			currentDir = shell.dir()
			shell.setDir('/')
			installPath = core.coreDir() .. '/usr/' .. tostring(key)
			print('tmp Path: ' .. installPath)
			print('working dir: ' .. currentDir)
			if shell.run('gitget', value.githubAccount, value.githubName, value.githubBranch, installPath) then

				if fs.exists(installPath .. '/apis') then
					local files = fs.list(installPath .. '/apis')
					for i = 1, #files do
						core.addLib(installPath .. '/apis/' .. files[i])
					end
				end

				if fs.exists(installPath .. '/programs') then
					core.addPath(installPath .. '/programs/')
				end

				if fs.exists(installPath .. '/daemons') then
					local files = fs.list(installPath .. '/daemons')
					for i = 1, #files do
						shell.run('daemon', 'add', installPath .. '/daemons/' .. files[i])
					end
				end

				if fs.exists(installPath .. '/load') then
					shell.run(installPath .. '/load', installPath)
				end
				return true
			end
			shell.setdir(currentDir)
		end
	end
	return false
end

local arg = { ... }

local function main()
	local parser = argparse("apk", "core package manager")
	parser:command("list")
	parser:command("install"):argument('module')
	parser:command("update"):argument('module')
	local args = parser:parse(arg)

	if args['list'] then
		list()
	elseif args['install'] or args['update'] then
		if not install(args['module']) then
			error('cant find: ' .. arg[2])
		end
	end
end

main()
