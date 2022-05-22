local Stats = {
	-- whoops this should be "visible"
	enabled = false,
	
	console = false,
	
	fps = 0,
	maxFps = 61,
	
	time = 0,
	per = 1/4,
	index = 0,
	
	plot = {},
	plotLen = 60,
	
	stats = {}
}

function Stats:update(dt)
	self.time = self.time + dt
	if self.time >= self.per then
		self.time = 0
		self.index = (self.index % self.plotLen) + 1
		
		self.fps = love.timer.getFPS()
		
		-- TODO: table?
		self.plot[self.index] = self.fps
		self.maxFps = math.max(self.fps, self.maxFps)
	end
end

function Stats:draw(scale, someScreenToLookAt)
	if not self.enabled then
		if self.console then
			self.stats = love.graphics.getStats(self.stats)
			
			io.write(string.format(
				"\r%03d FPS - %d (%d Batched) Calls",
					self.fps,
					self.stats.drawcalls,
					self.stats.drawcallsbatched
			))
		end
		
		return
	end
	
	self.stats = love.graphics.getStats(self.stats)
	
	local wWidth, wHeight = love.graphics.getDimensions()
	
	local xofs = wWidth - self.plotLen * scale
	love.graphics.setColor(0.125, 0.5, 0.25, 0.75)
	love.graphics.rectangle("fill", xofs, 0, self.plotLen * scale, 61 * scale)
	for i = 0, #self.plot do
		love.graphics.setColor(0.25, 1, 0.5, ((i - self.index) % self.plotLen) / self.maxFps * 2 + 0.5)
		love.graphics.line(
			xofs + (i    ) * scale,
			(self.maxFps - (self.plot[i + 1] or self.fps)) * scale,
			xofs + (i + 1) * scale,
			(self.maxFps - (self.plot[i + 2] or self.fps)) * scale
		)
	end
	
	local txt = "-- Stats --\n"
	txt = txt .. "FPS:  " .. self.fps .. ",\n"
	txt = txt .. "Draw: " .. self.stats.drawcalls .. " (s" .. self.stats.drawcallsbatched .. "),\n"
	txt = txt .. "WindowSize:\n" .. wWidth .. ", " .. wHeight .. ",\n"
	if someScreenToLookAt then
		txt = txt .. "ScreenSize:\n" .. someScreenToLookAt.size.x .. ", " .. someScreenToLookAt.size.y .. " (x" .. scale .. ")\n"
	end
	
	local tx, ty = wWidth - (80 * scale), 65 * scale
	
	love.graphics.setColor(0, 0, 0)
	for j = -1, 1 do
		for i = -1, 1 do
			if i ~= 0 or j ~= 0 then
				love.graphics.print(
					txt,
					tx + 2 + i * scale, ty + 2 + j * scale,
					0, scale
				)
			end
		end
	end
	love.graphics.setColor(0.25, 1, 0.5)
	love.graphics.print(txt, tx + 2, ty + 2, 0, scale)
	love.graphics.setColor(1, 1, 1)
end

return Stats
