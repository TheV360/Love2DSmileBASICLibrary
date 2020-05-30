local loveFunctions = {
	functions = {}
}

function loveFunctions:makeLoveFunctionHook(key)
	if love[key] then
		-- oh boy this is interesting
		-- could lead to someone adding their own stuff to love.run which is scary.
		-- don't do that, and don't use expressions for addLoveFunction's key thing!
		-- that's like XSS but offline. Cross Lua Scripting?
		self.functions[key]["Default"] = love[key]
	end
	love[key] = function(...)
		local _, f
		for _, f in pairs(self.functions[key]) do
			f(...)
		end
	end
end

function loveFunctions:addLoveFunction(key, name, func)
	if not self.functions[key] then
		self.functions[key] = {}
		self:makeLoveFunctionHook(key)
	end
	self.functions[key][name] = func
end

function loveFunctions:removeLoveFunction(key, name)
	if self.functions[key] then
		self.functions[key][name] = nil
	end
end

return loveFunctions
