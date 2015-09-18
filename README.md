core
====

core os for computercraft

pastebin get ZSjktFxC installer

note that
	its a work in progress...
	To be properly used core requires the domain *github.com to be unblocked in computercraft configs. 


core os is broken into 
	
	config ( user and system config files)
	interface ( an atempt at giveing a way to load different..."destop envirnments" )
	modules ( modules are meant to extend the functionality of core)
		
	system ( the files that make up core )
		core_apis
		core_programs
		core_services



modules can be loaded, unloaded, installed via github, set to load on boot, and removed all useing the module program  
	
	moduleName
		apis (loaded into os)
		programs (added to path)
		services 
		startup (ran when module is loaded)

todo
	services
	put interfaces in folders (so they function more like modules)
	filetypes ? 
	make core able to run out of any directory
	add an interface list maybe add a few
	give credit where credit is due (stuff I didnt write)

maybe 
	add a populer cc-app store or something 
	be able to load other os's as interfaces on top of core




