local Wrapper = {
	functions = {}
}

function Wrapper:_makeLoveFunctionHook(key)
	if love[key] then
		self.functions[key]["default"] = love[key]
	end
	love[key] = function(...)
		for _, f in pairs(self.functions[key]) do
			f(...)
		end
	end
end

function Wrapper:addLoveFunction(key, func, name)
	if not self.functions[key] then
		self.functions[key] = {}
		self:_makeLoveFunctionHook(key)
	end
	self.functions[key][name or (#self.functions[key] + 1)] = func
end

function Wrapper:removeLoveFunction(key, name)
	if self.functions[key] then
		self.functions[key][name] = nil
	end
end

return Wrapper
