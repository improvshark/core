local expect = require("cc.expect").expect

---Split a string into a list by a given seperator
---@param inputstr string
---@param sep string
---@return table
local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

---insert into table via dot notation
---@param myTable table
---@param key string
---@param value string|boolean|number|table
---@return any
local function insertDotNotation(myTable, key, value)
	expect(1, myTable, 'table')
	expect(2, key, 'string')
	expect(3, value, 'string', 'boolean', 'number', 'table')
	local keys = split(key, '.')
	if #keys > 1 then
		local childKey = string.gsub(key, '^' .. keys[1] .. '.', '')
		local subTable = insertDotNotation(myTable[keys[1]] or {}, childKey, value)
		myTable[keys[1]] = subTable
		return myTable
	end
	myTable[keys[1]] = value
	return myTable
end

---remove a key from a table via dot notation
---@param myTable table
---@param key string
local function removeDotNotation(myTable, key)
	expect(1, myTable, 'table', 'nil')
	expect(2, key, 'string')
	local keys = split(key, '.')
	if #keys == 1 then
		myTable[keys[1]] = nil
	elseif #keys > 1 then
		local childKey = string.gsub(key, '^' .. keys[1] .. '.', '')
		removeDotNotation(myTable[keys[1]] or {}, childKey)
	end
end

return {
	split = split,
	insertDotNotation = insertDotNotation,
	removeDotNotation = removeDotNotation,
}
