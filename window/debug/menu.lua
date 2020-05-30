local Menu = {
	enabled = false,
	
	option = {
		width = 360,
		height = 32,
		
		margin = 8,
		padding = 8,
		shadow = 4
	},
	
	options = {}
}

function Menu:addOption(text, callback, index)
	local o = {
		text = text or "Option",
		callback = callback or function() end
	}
	
	if index then
		table.insert(self.options, index, o)
	else
		table.insert(self.options, o)
	end
end

function Menu:addDivider(index)
	local d = {}
	
	if index then
		table.insert(self.options, index, d)
	else
		table.insert(self.options, d)
	end
end

function Menu:update()
	if not self.enabled then return end
	
	local _, c
	local y = self.option.margin
	
	for _, c in ipairs(self.options) do
		if c.callback then
			c.hover = Util.pointSquare(
				window.mouse.x,
				window.mouse.y,
				self.option.margin,
				y,
				self.option.width,
				self.option.height
			)
			if window.mouse.release[1] and c.hover then
				c.callback()
			end
			y = y + self.option.height + self.option.margin
		else
			y = y + self.option.margin
		end
	end
end

function Menu:draw()
	if not self.enabled then return end
	
	local i, c
	local y = self.option.margin
	local info = {}
	
	-- Make
	love.graphics.setColor(1, 1, 1)
	for i, c in ipairs(self.options) do
		if c.callback then
			table.insert(info, {y, c})
			y = y + self.option.height + self.option.margin
		else
			y = y + self.option.margin
		end
	end
	
	-- Shadows
	love.graphics.setColor(0.1, 0.2, 0.4, 0.25)
	for i = 1, #info do
		love.graphics.rectangle("fill", self.option.margin + self.option.shadow, info[i][1] + self.option.shadow, self.option.width, self.option.height)
	end
	
	-- Pulse multiplier (for colors)
	-- It makes a pulse effect, it is multiplied.
	local pm = Util.sine(window.trueFrames, 90, 0.1) + 0.9
	
	-- Rectangles
	for i = 1, #info do
		if info[i][2].hover then
			if window.mouse.down[1] then
				love.graphics.setColor(0.1 * pm, 0.2 * pm, 0.4 * pm)
			else
				love.graphics.setColor(0.2 * pm, 0.4 * pm, 0.8 * pm)
			end
		else
			love.graphics.setColor(0.3, 0.6, 1)
		end
		love.graphics.rectangle("fill", self.option.margin, info[i][1], self.option.width, self.option.height)
	end
	
	-- Text
	love.graphics.setColor(1, 1, 1)
	for i = 1, #info do
		love.graphics.print(info[i][2].text, self.option.margin + self.option.padding, info[i][1] + self.option.padding, 0, 2)
	end
end

return Menu
