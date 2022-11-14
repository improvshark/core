local core = require('core')

local function main()
	local updateChannel = core.config().updateChannel or 'master'
	local installDir = '/' .. core.coreDir()
	local currentDir = shell.dir()
	shell.setDir('/')
	shell.run('gitget', 'improvshark', 'core', updateChannel, installDir)
	shell.setDir(currentDir)
end

main()
