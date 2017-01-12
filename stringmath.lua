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
		local s = a:sub(b,b)
		if #s == 0 then
			return nil
		else
			return s
		end
	elseif type(b)=='string' and type(a)=='number' then
		local s = b:sub(a,a)
		if #s == 0 then
			return nil
		else
			return s
		end
	end
end