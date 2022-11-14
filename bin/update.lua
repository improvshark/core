local core = require('core')

local function main()
	local installDir = '/' .. core.coreDir()
	currentDir = shell.dir()
	shell.setDir(installDir)
	shell.run('gitget', 'improvshark', 'core', 'master', installDir)
	shell.setDir(currentDir)
end

main()
