local Stats = {
	enabled = false,
	
	fps = 0,
	
	plot = {},
	
	stats = nil
}

function Stats:update()
	local currIndex = (math.floor(window.trueFrames / 15) % 60) + 1
	
	if window.trueFrames % 15 == 0 or not self.fps then
		self.fps = love.timer.getFPS()
		self.plot[currIndex] = self.fps
	end
end

function Stats:draw()
	if not self.enabled then return end
	
	local scale = window.screen and window.screen.scale or 1
	
	self.stats = love.graphics.getStats()
	
	local currIndex = (math.floor(window.trueFrames / 15) % 60) + 1
	
	local xofs = window.width - (60 * scale)
	love.graphics.setColor(0.125, 0.5, 0.25, 0.75)
	love.graphics.rectangle("fill", xofs, 0, 60 * scale, 61 * scale)
	for i = 0, #self.plot do
		love.graphics.setColor(0.25, 1, 0.5, ((i - currIndex) % 60) / 120 + .5)
		love.graphics.line(
			xofs + ((i    ) * scale),
			(61 - (self.plot[i + 1] or self.fps)) * scale,
			xofs + ((i + 1) * scale),
			(61 - (self.plot[i + 2] or self.fps)) * scale
		)
	end
	
	local txt = "-- Stats --\n"
	txt = txt .. "FPS:  " .. self.fps .. ",\n"
	txt = txt .. "Draw: " .. self.stats.drawcalls .. ",\n"
	txt = txt .. "WindowSize:\n" .. window.width .. ", " .. window.height .. ",\n"
	if window.screen then
		txt = txt .. "ScreenSize:\n" .. window.screen.width .. ", " .. window.screen.height .. " (x" .. scale .. ")\n"
	end
	
	local tx, ty = window.width - (80 * scale), 65 * scale
	
	love.graphics.setColor(0, 0, 0)
	for j = -2, 2, 2 do
		for i = -2, 2, 2 do
			love.graphics.print(txt, tx + 2 + i, ty + 2 + j, 0, scale)
		end
	end
	love.graphics.setColor(0.25, 1, 0.5)
	love.graphics.print(txt, tx + 2, ty + 2, 0, scale)
	love.graphics.setColor(1, 1, 1)
end

return Stats
