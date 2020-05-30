-- Some helper functions
-- By V360

local Util = {}

function Util.round(n)
	return math.floor(n + 0.5)
end

function Util.sine(offset, cycle, height, center)
	height = height or 1
	center = center ~= false
	
	local result = math.sin(2 * math.pi * (offset / cycle))
	
	if center then
		-- From -height to height
		return result * height
	else
		-- From 0 to height
		local halfHeight = (height / 2)
		return halfHeight + (halfHeight * result)
	end
end

function Util.cosine(offset, cycle, height, center)
	height = height or 1
	center = center ~= false
	
	local result = math.cos(2 * math.pi * (offset / cycle))
	
	if center then
		-- From -height to height
		return result * height
	else
		-- From 0 to height
		local halfHeight = (height / 2)
		return halfHeight + (halfHeight * result)
	end
end

function Util.mid(a, b, c)
	return math.min(math.max(a, b), c)
end

function Util.sign(n)
	if n == 0 then return 0 end
	return n > 0 and 1 or -1
end

function Util.lerp(a, b, p)
	return a + (b - a) * p
end

function Util.pointSquare(x1, y1, x2, y2, w2, h2)
	return x1 >= x2 and y1 >= y2 and x1 < x2 + w2 and y1 < y2 + h2
end

function Util.measureText(text)
	local f = love.graphics.getFont()
	
	return f:getWidth(text), f:getHeight()
end

function Util.measureTextWidth(text)
	return love.graphics.getFont():getWidth(text)
end

function Util.measureTextHeight()
	return love.graphics.getFont():getHeight()
end

function Util.stringSplit(str, delimiter, max)
	local result = {}
	local current = 0
	local next = string.find(str, delimiter, current, true)
	
	if #delimiter < 1 then return result end
	if max and max < 1 then return result end
	
	while next do
		table.insert(result, string.sub(str, current, next - 1))
		current = next + 1
		
		if max and #result >= max then
			break
		end
		
		next = string.find(str, delimiter, current, true)
	end
	
	if not (max and #result >= max) then
		table.insert(result, string.sub(str, current))
	end
	
	return result
end

function Util.watch(keyTable, checkFunction)
	local _, value
	local w = {
		downTime = {},
		down = {},
		press = {},
		release = {},
		
		keys = keyTable,
		check = checkFunction
	}
	
	for _, value in ipairs(w.keys) do
		w.downTime[value] = 0
		w.down[value]     = false
		w.press[value]    = false
		w.release[value]  = false
	end
	
	function w:update()
		local index, value, _
		
		for _, value in ipairs(self.keys) do
			self.down[value] = self.check(value)
			self.press[value] = false
			self.release[value] = false
			
			if self.down[value] then
				if self.downTime[value] == 0 then
					self.press[value] = true
				end
				self.downTime[value] = self.downTime[value] + 1
			else
				if self.downTime[value] > 0 then
					self.release[value] = true
				end
				self.downTime[value] = 0
			end
		end
	end
	
	return w
end

return Util
