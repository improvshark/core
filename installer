-- check for gitget if dont have download gitget
-- pastebin get ZSjktFxC installer
if fs.exists("gitget") == false then
	shell.run('pastebin', 'get', 'W5ZkVYSi', '/gitget')
end


shell.run('/gitget', 'improvshark', 'core', 'master', '/')

-- make missing folders.
shell.run('mkdir', '/home')
shell.run('mkdir', '/tmp')
shell.run('mkdir', '/usr')
shell.run('mkdir', '/usr/bin')
shell.run('mkdir', '/usr/lib')

fs.delete("/gitget")
fs.delete("/json")

os.reboot()
