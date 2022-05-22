local PixScr = Object:extend()

local VectorTypes = require("util.geometry.vector")
local Vec2 = unpack(VectorTypes.float)

function PixScr.PixelPerfect()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	love.graphics.setLineStyle('rough')
	love.graphics.setLineWidth(1)
end

function PixScr:new(size)
	self.size = size or Vec2(360, 240)
	
	if love.system.getOS() == 'Android' then
		local dpiScale = love.graphics.getDPIScale()
		self.canvas = love.graphics.newCanvas((self.size * dpiScale):unpack())
		self.dpiScale = dpiScale
	else
		self.canvas = love.graphics.newCanvas(self.size:unpack())
	end
	
	self.offset = Vec2(0, 0)
	self.scale = 1
end

function PixScr:setShader(shader)
	-- TODO: literally any error checking?
	self.shader = shader
end

function PixScr:centerScaleIn(size)
	self.scale = math.floor(math.min(size:div(self.size):unpack()))
	self.offset = ((size - self.size * self.scale) / 2):floor()
end

function PixScr:renderTo(...)
	self.canvas:renderTo(...)
end

function PixScr:renderThenDraw(...)
	self.canvas:renderTo(...)
	
	love.graphics.push()
		love.graphics.setColor(1, 1, 1)
		love.graphics.setShader(self.shader)
		self:draw()
	love.graphics.pop()
end

function PixScr:drawOutsideRelative(fn)
	love.graphics.push()
	if dpiScale then
		love.graphics.scale(1 / self.dpiScale, 1 / self.dpiScale)
	end
	love.graphics.translate(self.offset.x, self.offset.y)
	love.graphics.scale(self.scale)
	fn()
	love.graphics.pop()
end

function PixScr:draw()
	if dpiScale then
		love.graphics.push()
		love.graphics.scale(1 / self.dpiScale, 1 / self.dpiScale)
		love.graphics.draw(self.canvas, self.offset.x, self.offset.y, 0, self.scale)
		love.graphics.pop()
	else
		love.graphics.draw(self.canvas, self.offset.x, self.offset.y, 0, self.scale)
	end
end

function PixScr:pointIn(outside)
	return (outside - self.offset) / self.scale
end

function PixScr:pointOut(inside)
	return inside * self.scale + self.offset
end

return PixScr
