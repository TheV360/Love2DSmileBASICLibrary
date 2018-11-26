--[[
--]]

Watch = {}

function Watch.new(keyTable, checkFunction)
	local watch = {
		down = {},
		press = {},
		release = {},
		
		keys = keyTable,
		check = checkFunction
	}
	
	-- Might be nice code style
	function watch:setup()
		local _, value
		
		for _, value in ipairs(self.keys) do
			self.down[value]    = false
			self.press[value]   = false
			self.release[value] = false
		end
	end
	
	function watch:update()
		local index, value, _
		
		for _, value in ipairs(self.keys) do
			if self.check(value) then
				if self.down[value] then
					self.down[value] = self.down[value] + 1
					self.press[value] = false
				else
					self.down[value] = 1
					self.press[value] = true
				end
			else
				if self.down[value] then
					self.release[value] = true
				else
					self.release[value] = false
				end
				self.down[value] = false
			end
		end
	end
	
	watch:setup()
	
	return watch
end
