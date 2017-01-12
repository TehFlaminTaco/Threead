memory = {{},{},{}}
readmemory = {{},{},{}}
pointer = {1,1,1}
instring = {false,false,false}
ignext = {false,false,false}
builtstring = {"","",""}
require"stringmath"
require"functions"
local code = ""

do
	local f = io.open('code.trd')
	code=f:read("*a")
	f:close()
end

-- This chunk validates that the amount of lines is correct. Stops it dumping chunks.
local lines = (#code - #code:gsub("\n",""))
code = code .. ("\n"):rep(3-((lines)%3))

stream1 = ""
stream2 = ""
stream3 = ""

for s in code:gmatch("([^\n]*\n[^\n]*\n[^\n]*)\n?") do
	local chunk1 = s:match("^[^\n]*")
	local chunk2 = s:match("\n([^\n]*)\n")
	local chunk3 = s:match("[^\n]*$")
	stream1 = stream1 .. chunk1
	stream2 = stream2 .. chunk2
	stream3 = stream3 .. chunk3

	local a1 = #stream1
	local a2 = #stream2
	local a3 = #stream3
	local a = math.max(a1,a2,a3)
	stream1 = stream1..(" "):rep(a-a1)
	stream2 = stream2..(" "):rep(a-a2)
	stream3 = stream3..(" "):rep(a-a3)
end

streams = {stream1, stream2, stream3}

for i=1, #stream1 do
	local conflicChars = 0
	if ("[]"):find(stream1:sub(i,i):gsub('[%[%]]','%%%0')) then
		conflicChars = conflicChars+1
	end
	if ("[]"):find(stream2:sub(i,i):gsub('[%[%]]','%%%0')) then
		conflicChars = conflicChars+1
	end
	if ("[]"):find(stream3:sub(i,i):gsub('[%[%]]','%%%0')) then
		conflicChars = conflicChars+1
	end
	if conflicChars > 1 then
		error("Error at point "..i..". Cannot do multiple IP pointer movements at the same time. Use a no-op. to separate them.\n"..(" "):rep(math.min(6,i)-1).."V\n"..stream1:sub(math.max(i-5,0),math.min(i+5,#stream1)).."\n"..stream2:sub(math.max(i-5,0),math.min(i+5,#stream2)).."\n"..stream3:sub(math.max(i-5,0),math.min(i+5,#stream3)))
	end
end

ip = 1

while ip <= #stream1 do
	readmemory = {{},{},{}}
	for k,v in pairs(memory) do
		for k2,v2 in pairs(v) do
			readmemory[k][k2] = v2
		end
	end

	local a = stream1:sub(ip,ip)
	local b = stream2:sub(ip,ip)
	local c = stream3:sub(ip,ip)

	if(instring[1])then
		if ignext[1] then
			builtstring[1] = builtstring[1]..a
		else
			if a == "\\" then
				ignext = true
			elseif a == '"' then
				funcs[a](1,3,2)
			else
				builtstring[1] = builtstring[1]..a
			end
		end
	elseif funcs[a] then local b, e = pcall(funcs[a],1,3,2)
		if not b then error("Error at point "..ip..". "..e.."\n"..(" "):rep(math.min(6,ip)-1).."V\n"..stream1:sub(math.max(ip-5,0),math.min(ip+5,#stream1)).."\n"..stream2:sub(math.max(ip-5,0),math.min(ip+5,#stream2)).."\n"..stream3:sub(math.max(ip-5,0),math.min(ip+5,#stream3))) end end
	if(instring[2])then
		if ignext[2] then
			builtstring[2] = builtstring[2]..b
		else
			if b == "\\" then
				ignext = true
			elseif b == '"' then
				funcs[b](2,1,3)
			else
				builtstring[2] = builtstring[2]..b
			end
		end
	elseif funcs[b] then local b, e = pcall(funcs[b],2,1,3)
		if not b then error("Error at point "..ip..". "..e.."\n"..(" "):rep(math.min(6,ip)-1).."V\n"..stream1:sub(math.max(ip-5,0),math.min(ip+5,#stream1)).."\n"..stream2:sub(math.max(ip-5,0),math.min(ip+5,#stream2)).."\n"..stream3:sub(math.max(ip-5,0),math.min(ip+5,#stream3))) end end
	if(instring[3])then
		if ignext[3] then
			builtstring[3] = builtstring[3]..c
		else
			if c == "\\" then
				ignext = true
			elseif c == '"' then
				funcs[c](3,2,1)
			else
				builtstring[3] = builtstring[3]..c
			end
		end
	elseif funcs[c] then local b, e = pcall(funcs[c],3,2,1)
		if not b then error("Error at point "..ip..". "..e.."\n"..(" "):rep(math.min(6,ip)-1).."V\n"..stream1:sub(math.max(ip-5,0),math.min(ip+5,#stream1)).."\n"..stream2:sub(math.max(ip-5,0),math.min(ip+5,#stream2)).."\n"..stream3:sub(math.max(ip-5,0),math.min(ip+5,#stream3))) end end

	ip = ip + 1
end

print()
for k,v in pairs(memory) do
	for k2, v2 in pairs(v) do
		io.write(v2, ", ")
	end
	print()
end