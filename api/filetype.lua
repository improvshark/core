start = "--<"
finish = ">--"


function openFile(path)
	local fileA = assert( fs.open(path, "r") )
	temp = fileA.readAll()
	fileA.close()
	return temp
end

function strip(s)
	first = string.find(s, start, 1, true)
	b , last  = string.find(s, finish, 1, true)
	if first ~= nil and last ~= nil then
		--print('found at : ' .. first .. ', ' .. last)
		if first ~= 1 then 
			temp = string.sub(s, 1, first-1) .. string.sub(s, last)
		else
			temp = string.sub(s, last + 1)
		end
		return temp
	end
	return s 
end

function is(path, fileType)
	s = openFile(path)
	b, first = string.find(s, start, 1, true)
	last  = string.find(s, finish, 1, true)
	if first ~= nil and last ~= nil then
		--print('found at : ' .. first .. ', ' .. last)
		temp = string.sub(s, first+1, last -1)
		if temp == fileType then
			return true
		end
	end
	return false
end

function set(path, fileType)
	local fileA = assert( fs.open(path, "r") )
	temp = fileA.readAll()
	fileA.close()
	temp = strip(temp)
	local fileA = assert( fs.open(path,"w"))
	fileA.writeLine(start .. fileType .. finish)
	fileA.write(temp)
	fileA.close()
end

function get(path)
	s = openFile(path)
	b, first = string.find(s, start, 1, true)
	last  = string.find(s, finish, 1, true)
	if first ~= nil and last ~= nil then
		--print('found at : ' .. first .. ', ' .. last)
		temp = string.sub(s, first+1, last -1)
		return temp
	end
	return nil
end