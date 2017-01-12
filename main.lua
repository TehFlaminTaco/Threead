memory = {{},{},{}}
readmemory = {{},{},{}}
pointer = {1,1,1}
instring = {false,false,false}
ignext = {false,false,false}
builtstring = {"","",""}
function require(lib)
	local dir = arg[0]:gsub("main.lua$","")
	loadfile(dir..lib)()
end
require"stringmath.lua"
require"functions.lua"
local code = ""
do
	local f = io.open(arg[1] or 'code.trd','r')
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

	for i=1, 3 do
		local v = ({a,b,c})[i]
		local l = ({3,1,2})[i]
		local r = ({2,3,1})[i]
		if(instring[i])then
			if ignext[i] then
				builtstring[i] = builtstring[i]..v
			else
				if v == "\\" then
					ignext = true
				elseif v == '"' then
					funcs[v](i,l,r)
				else
					builtstring[i] = builtstring[i]..v
				end
			end
		elseif funcs[v] then local b, e = pcall(funcs[v],i,l,r)
			if not b then error("Error at point "..ip..". "..e.."\n"..(" "):rep(math.min(6,ip)-1).."V\n"..stream1:sub(math.max(ip-5,0),math.min(ip+5,#stream1)).."\n"..stream2:sub(math.max(ip-5,0),math.min(ip+5,#stream2)).."\n"..stream3:sub(math.max(ip-5,0),math.min(ip+5,#stream3))) end end
	end

	ip = ip + 1
end

io.stderr:write("\n")
for k,v in pairs(memory) do
	for k2, v2 in pairs(v) do
		io.stderr:write(v2, ", ")
	end
	io.stderr:write("\n")
end