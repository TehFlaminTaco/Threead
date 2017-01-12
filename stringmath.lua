local str = getmetatable("")

str.__add = function(a,b)
	return a .. b
end
str.__mul = function(a,b)
	if (type(a)=='string' and type(b)=='number') then
		return a:rep(b)
	elseif type(b)=='string' and type(a)=='number' then
		return b:rep(a)
	end
end
str.__pow = function(a,b)
	if (type(a)=='string' and type(b)=='number')then
		return a:sub(b,b)
	elseif type(b)=='string' and type(a)=='number' then
		return b:sub(a,a)
	end
end