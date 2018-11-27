-- Sprites: movable, rotatable, stretchable, animatable, dyeable pieces of a spritesheet

Sprites = {
	Sheet = love.graphics.newImage("resources/sprites.png"),
	InBatch = false,
	Layers = {
		{Batch = nil, BlendMode = "alpha"},
		{Batch = nil, BlendMode = "add"}
	},
	
	-- ENUM sorta thing, don't touch.
	Attributes = {
		Show     = 0x01,
		Rot0     = 0x00,
		Rot90    = 0x02,
		Rot180   = 0x04,
		Rot270   = 0x06,
		FlipH    = 0x08,
		FlipV    = 0x10,
		AltBlend = 0x20,
		Additive = 0x20
	},
	
	-- Also this
	Definitions = {},
	DefaultDefinition = function() return {
		0,  -- X coordinate
		0,  -- Y coordinate
		16, -- Width
		16, -- Height
		0,  -- Home X
		0,  -- Home Y
		1   -- Attribute (Show)
	} end
}

for i = 1, #Sprites.Layers do
	Sprites.Layers[i].Batch = love.graphics.newSpriteBatch(Sprites.Sheet)
end

-- Each line contains:
-- x, y, w, h, hx, hy, a
-- note the lack of an index.
function Sprites.readDefinitionListing(filename)
	local chr = love.filesystem.read(filename)
	local index = 0
	
	if not chr then
		print("Yikes! That doesn't exist!")
		return
	end
	
	Sprites.Definitions = {}
	
	-- Can probably be made smaller, but works for now.
	for l in chr:gmatch("[^\r\n]+") do
		local tmp = Sprites.DefaultDefinition() -- make a new default table
		local source = 1 -- good naming
		
		-- Split by comma
		-- Unless no commas, then just use default.
		for c in l:gmatch("[^,]+") do
			if #c > 0 then
				tmp[source] = tonumber(c)
			end
			
			source = source + 1
		end
		
		if #l > 0 then
			-- The reason this doesn't have a quad inside is because I can just make a quad for each sprite,
			--  then change the quad when the sprite changes, instead of making a new quad altogether.
			Sprites.Definitions[index] = {
				x = tmp[1],
				y = tmp[2],
				
				width = tmp[3],
				height = tmp[4],
				
				home = {
					x = tmp[5],
					y = tmp[6]
				},
				
				attribute = tmp[7]
			}
		end
		
		index = index + 1
	end
end

Sprites.readDefinitionListing("resources/sprites.txt")

function Sprites.AABB(x1, y1, w1, h1, x2, y2, w2, h2)
	return	x1 < x2 + w2 and
			y1 < y2 + h2 and
			x1 + w1>= x2 and
			y1 + h1>= y2
end
function Sprites.startBatch()
	local i
	
	Sprites.InBatch = true
	for i = 1, #Sprites.Layers do
		Sprites.Layers[i].Batch:clear()
		Sprites.Layers[i].Batch:setColor(1, 1, 1, 1)
	end
end
function Sprites.endBatch()
	local i
	
	for i = 1, #Sprites.Layers do
		Sprites.Layers[i].Batch:flush()
		
		love.graphics.setBlendMode(Sprites.Layers[i].BlendMode)
		love.graphics.draw(Sprites.Layers[i].Batch)
	end
	Sprites.InBatch = false
	
	love.graphics.setBlendMode("alpha")
end
function Sprites.layerBlendMode(index, blendMode)
	if index and blendMode then Sprites.Layers[index].BlendMode = blendMode end
	
	return Sprites.Layers[index].BlendMode
end
function Sprites.setDefinition(id, u, v, width, height, homeX, homeY, attribute)
	-- TODO!!!!
	-- if 
end

function Sprites.new(u, v, width, height, home, attributes)
	if u and not v then
		local s = u
		
		u =           (s % 32) * 16
		v = math.floor(s / 32) * 16
	end
	
	local sprite = {
		type = "sprite",
		
		u = u or 0,
		v = v or 0,
		
		attributes = attributes or Sprites.Attributes.Show,
		
		quad = nil,
		transformBase = love.math.newTransform(),
		transformAttr = love.math.newTransform()
	}
	
	sprite = SmileBASIC.apply(sprite, 0, 0, 0, width, height, home)
	
	-- Core
	function sprite:setup()
		quad = love.graphics.newQuad(self.u, self.v, self.width, self.height, Sprites.Sheet:getDimensions())
		
		self:refreshTransform()
	end
	function sprite:update()
		-- Continue animation here.
		self:runAnimations()
		
		-- Also, callbacks
		self:runCallbacks()
	end
	-- refactor?
	function sprite:draw()
		if not (bit.band(self.attributes, Sprites.Attributes.Show) > 0) then return end
		
		self:refreshTransform()
		
		if Sprites.InBatch then
			if bit.band(self.attributes, Sprites.Attributes.AltBlend) > 0 then
				Sprites.Layers[2].Batch:setColor(self._color)
				Sprites.Layers[2].Batch:add(self.quad, self.transformBase)
			else
				Sprites.Layers[1].Batch:setColor(self._color)
				Sprites.Layers[1].Batch:add(self.quad, self.transformBase)
			end
		else
			if bit.band(self.attributes, Sprites.Attributes.Additive) > 0 then
				love.graphics.setBlendMode(Sprites.Layers[2].BlendMode)
			else
				love.graphics.setBlendMode(Sprites.Layers[1].BlendMode)
			end
			
			love.graphics.setColor(self._color)
			love.graphics.draw(Sprites.Sheet, self.quad, self.transformBase)
			
			love.graphics.setBlendMode("alpha")
		end
	end
	
	-- SmileBASIC-like
	function sprite:show()
		self.attributes = bit.bor(self.attributes, Sprites.Attributes.Show)
		--self.attributes = self.attributes | Sprites.Attributes.Show
	end
	function sprite:hide()
		self.attributes = bit.band(self.attributes, bit.bnot(Sprites.Attributes.Show))
		--self.attributes = self.attributes & (~Sprites.Attributes.Show)
	end
	
	function sprite:AABBCollide(spr, scale)
		if scale then
			return Sprites.AABB(
				self.x - (self._home.x * self._scale.x),
				self.y - (self._home.x * self._scale.y),
				self.width * self._scale.x,
				self.height * self._scale.y
			)
		else
			return Sprites.AABB(
				self.x - self._home.x,
				self.y - self._home.y,
				self.width,
				self.height
			)
		end
	end
	function sprite:refreshQuad()
		self.quad:setViewport(self.u, self.v, self.width, self.height)
	end
	function sprite:refreshTransform()
		-- GOOD ENOUGH FOR NOW
		self.transformBase:setTransformation(
			math.floor(self.x), math.floor(self.y),
			self._rotation * math.pi / 180,
			self._scale.x, self._scale.y,
			self._home.x, self._home.y
		)
		self.transformAttr:setTransformation(
			self.width / 2, self.height / 2,
			((self:checkAttribute(Sprites.Attributes.Rot90) and 90 or 0) + (self:checkAttribute(Sprites.Attributes.Rot180) and 180 or 0)) * (math.pi / 180),
			self:checkAttribute(Sprites.Attributes.FlipH) and -1 or 1, self:checkAttribute(Sprites.Attributes.FlipV) and -1 or 1,
			self.width / 2, self.height / 2
		)
		
		self.transformBase:apply(self.transformAttr)
	end
	
	-- New
	function sprite:checkAttribute(attr)
		return bit.band(self.attributes, attr) > 0
	end
	function sprite:toggleAttribute(attr)
		self.attributes = bit.bxor(self.attributes, attr)
		--self.attributes = self.attributes ~ attr
		
		self:refreshQuad()
	end
	
	sprite:setup()
	
	return sprite
end
