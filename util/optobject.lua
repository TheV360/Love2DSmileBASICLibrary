OptObject = Object:extend()

function OptObject:__call(o, ...)
	local obj = setmetatable({}, self)
	o = o or {}
	obj:new(o, ...)
	return obj
end

return OptObject
