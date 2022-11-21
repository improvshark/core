local currentPath = string.sub(debug.getinfo(1).source, 2)
local coreDir = fs.getDir(fs.getDir(currentPath))
package.path = '/' .. coreDir .. '/lib/?.lua;' .. package.path

local utl = require('utl')
local p = require('cc.pretty').pretty_print

local suite = {
	-- test split
	function()
		local result =utl.split('foo.bar', '.')
		assert(#result == 2, 'Split amount not right')
		assert(result[1] == 'foo', 'first element is not correct')
		assert(result[2] == 'bar', 'second element is not correct')
	end,
	-- test inserts at level one
	function()
		local myTable = {}
		utl.insertDotNotation(myTable, 'foo', 1)
		assert(myTable['foo'] == 1, 'failed to insert')
	end,
	-- test inserts at level two
	function()
		local myTable = {}
		utl.insertDotNotation(myTable, 'foo.bar', 1)
		assert(myTable['foo']['bar'] == 1, 'failed to insert')
	end,
	-- test inserts at level two adjacent
	function()
		local myTable = { foo={baz=1}}
		utl.insertDotNotation(myTable, 'foo.bar', 1)
		assert(myTable['foo']['bar'] == 1, 'failed to insert')
		assert(myTable['foo']['baz'] == 1, 'failed to insert')
	end,
	-- test remove at level one 
	function()
		local myTable = { foo=1}
		utl.removeDotNotation(myTable, 'foo')
		assert(#myTable == 0, 'failed to remove')
	end,
	-- test remove at level two
	function()
		local myTable = { foo={bar=2, baz=3}}
		utl.removeDotNotation(myTable, 'foo.bar')
		assert(myTable['foo'] ~= nil, 'table empty')
		assert(myTable['foo']['bar'] == nil, 'failed to remove')
		assert(myTable['foo']['baz'] ~= nil, 'removed something that should not have been')
	end,
	function() print('Success') end,
}

for _, value in pairs(suite) do value() end
