funcs = {}

-- Numbers.
for i=0, 9 do
	funcs[i..""] = function(this)
		memory[this][pointer[this]] = (readmemory[this][pointer[this]] or 0)*10 + i
	end
end

funcs['"'] = function(this)
	instring[this]=not instring[this]
	if not instring[this] then
		memory[this][pointer[this]] = builtstring[this]
		builtstring[this] = ""
	end
end

-- Pointer movement
funcs['>'] = function(this)
	pointer[this] = pointer[this]+1
end
funcs['<'] = function(this)
	pointer[this] = pointer[this]-1
end

-- #MATH
funcs['+'] = function(this,left,right)
	local l = (readmemory[left][readpointer[left]] or 0)
	local r = (readmemory[right][readpointer[right]] or 0)
	if(type(l)=='string'and type(r)=='string')then
		memory[this][pointer[this]] = l..r
	else
		memory[this][pointer[this]] = l+r
	end
end
funcs['-'] = function(this,left,right)
	memory[this][pointer[this]] = (readmemory[left][readpointer[left]] or 0)-(readmemory[right][readpointer[right]] or 0)
end
funcs['*'] = function(this,left,right)
	local l = (readmemory[left][readpointer[left]] or 0)
	local r = (readmemory[right][readpointer[right]] or 0)
	if(type(l)=='string'and type(r)=='number')then
		memory[this][pointer[this]] = l:rep(r)
	elseif(type(r)=='string'and type(l)=='number')then
		memory[this][pointer[this]] = r:rep(l)
	else
		memory[this][pointer[this]] = l+r
	end
end
funcs['/'] = function(this,left,right)
	memory[this][pointer[this]] = (readmemory[left][readpointer[left]] or 0)/(readmemory[right][readpointer[right]] or 0)
end
funcs['^'] = function(this,left,right)
	memory[this][pointer[this]] = (readmemory[left][readpointer[left]] or 0)^(readmemory[right][readpointer[right]] or 0)
end
funcs['%'] = function(this)
	memory[this][pointer[this]] = (readmemory[left][readpointer[left]] or 0)%(readmemory[right][readpointer[right]] or 0)
end
funcs['_'] = function(this)
	memory[this][pointer[this]] = 0
end

-- Grab the value from the other two buffers.
funcs['r'] = function(this,left,right)
	memory[this][pointer[this]] = readmemory[right][readpointer[right]]
end
funcs['l'] = function(this,left,right)
	memory[this][pointer[this]] = readmemory[left][readpointer[left]]
end

-- Convert between string and number.
funcs['s'] = function(this)
	memory[this][pointer[this]] = ""..readmemory[this][pointer[this]]
end
funcs['n'] = function(this)
	memory[this][pointer[this]] = tonumber(readmemory[this][pointer[this]])
end

-- To and from character code! :D
funcs['c'] = function(this)
	local b,out = pcall(string.char, readmemory[this][pointer[this]])
	if b then
		memory[this][pointer[this]] = out
	end
end
funcs['b'] = function(this)
	local b,out = pcall(string.byte, readmemory[this][pointer[this]])
	if b then
		memory[this][pointer[this]] = out
	end
end

-- Temporary Buffers
funcs['i'] = function(this)
	local t = {}
	for k, v in pairs(memory[this]) do
		if k < pointer[this] then
			t[k] = v
		else
			t[k+1] = v
		end
	end
	memory[this] = t
end
funcs['d'] = function(this)
	local t = {}
	for k,v in pairs(memory[this]) do
		if k < pointer[this] then
			t[k] = v
		elseif k ~= pointer[this] then
			t[k-1] = v
		end
	end
	memory[this]=t
end

-- Instruction Pointer Control! :D
LoopStack = {}
funcs['['] = function(this)
	if (readmemory[this][pointer[this]] or 0) == 0 then
		local d = 0
		for i=ip, #streams[this] do
			if streams[this]:sub(i,i) == "[" then
				d = d + 1
			elseif streams[this]:sub(i,i) == "]" then
				d = d - 1
				if d == 0 then
					ip = i
					break
				end
			end
		end
	else
		LoopStack[#LoopStack+1] = ip
	end
end
funcs[']'] = function(this)
	if (readmemory[this][pointer[this]] or 0) ~= 0 then
		if LoopStack[#LoopStack] then
			ip = LoopStack[#LoopStack]-1
			LoopStack[#LoopStack] = nil
		end
	end
end


-- I/O
funcs['o'] = function(this)
	io.write(readmemory[this][pointer[this]] or 0)
end
funcs['R'] = function(this)
	memory[this][pointer[this]] = (io.read() or "") --Read a line from StdIn
end
funcs['I'] = function(this) --Read a number from StdIn (I for 'input' or 'integer')
	memory[this][pointer[this]] = (io.read("*n") or 0)
end

funcs['B'] = function(this)
	memory[this][pointer[this]] = string.byte(io.read(1) or "\0")
end

funcs['D'] = function()
	io.stderr:write("\n")
	for k,v in pairs(memory) do
		io.stderr:write(v[readpointer[k] or 0] or "","\n")
	end
end

return funcs