-- Backgrounds: more basic grid of tiles. Batched together, unlike sprites.

Backgrounds = {
	Sheet = love.graphics.newImage("resources/tiles.png"),
	Batch = nil,
	
	Tiles = {
		Size = 16,
		
		Width = nil,
		Height = nil,
		
		ScreenWidth = nil,
		ScreenHeight = nil,
		
		Indexes = {}
	},
	
	-- Enums, please don't change!
	Animations = {
		Offset      = 0, XY = 0,
		Depth       = 1, Z  = 1,
		-- NOT IN BACKGROUNDS --
		-- NOT IN BACKGROUNDS --
		Rotation    = 4, R  = 4,
		Scale       = 5, S  = 5,
		Color       = 6, C  = 6,
		Variable    = 7, V  = 7,
		Relative    = 8
	},
	Attributes = {
		Tile   = 0x0fff,
		Rot0   = 0x0000,
		Rot90  = 0x1000,
		Rot180 = 0x2000,
		Rot270 = 0x3000,
		FlipH  = 0x4000,
		FlipV  = 0x8000
	},
	
	-- Proprietary format, if you delete the fromV360Map function you can delete this too!
	V360MapMagicNumber = "V\x03\x60",
	V360MapFileBytes = {
		MagicNumber = 1,
		Layers      = 4,
		Width       = 5,
		Height      = 6,
		MapOffset   = 7
	}
}

Backgrounds.Batch = love.graphics.newSpriteBatch(Backgrounds.Sheet)

Backgrounds.Tiles.Width  = math.floor(Backgrounds.Sheet:getWidth()  / Backgrounds.Tiles.Size)
Backgrounds.Tiles.Height = math.floor(Backgrounds.Sheet:getHeight() / Backgrounds.Tiles.Size)

Backgrounds.Tiles.ScreenWidth  = math.floor(window.screen.width  / Backgrounds.Tiles.Size)
Backgrounds.Tiles.ScreenHeight = math.floor(window.screen.height / Backgrounds.Tiles.Size)

local i, j
for j = 0, Backgrounds.Tiles.Height - 1 do
	for i = 0, Backgrounds.Tiles.Width - 1 do
		Backgrounds.Tiles.Indexes[i + (j * Backgrounds.Tiles.Width)] = love.graphics.newQuad(
			i * Backgrounds.Tiles.Size,
			j * Backgrounds.Tiles.Size,
			Backgrounds.Tiles.Size,
			Backgrounds.Tiles.Size,
			Backgrounds.Sheet:getDimensions()
		)
	end
end

function Backgrounds.new(width, height)
	local background = {
		type = "background",
		
		map = nil,
		
		animations = {}
	}
	
	background = SmileBASIC.apply(background, 0, 0, 0, width or Backgrounds.Tiles.ScreenWidth, height or Backgrounds.Tiles.ScreenHeight, home)
	
	-- Core
	function background:setup()
		local i, j
		
		self.map = {}
		
		for j = 0, self.height - 1 do
			self.map[j] = {}
			for i = 0, self.width - 1 do
				self.map[j][i] = 0
			end
		end
	end
	function background:update()
		-- Continue animation here.
		self:runAnimations()
		
		-- Also, callbacks
		self:runCallbacks()
	end
	function background:draw()
		local i, j
		
		local tileHalf = math.floor(Backgrounds.Tiles.Size / 2)
		
		Backgrounds.Batch:clear()
		Backgrounds.Batch:setColor(self._color)
		for j = 0, self.height - 1 do
			for i = 0, self.width - 1 do
				if bit.band(self.map[j][i], Backgrounds.Attributes.Tile) > 0 then
					local tmpX = i * Backgrounds.Tiles.Size
					local tmpY = j * Backgrounds.Tiles.Size
					
					local tmpRot = 0
					
					local tmpScaleX = bit.band(self.map[j][i], Backgrounds.Attributes.FlipH) > 0 and -1 or 1
					local tmpScaleY = bit.band(self.map[j][i], Backgrounds.Attributes.FlipV) > 0 and -1 or 1
					
					if bit.band(self.map[j][i], Backgrounds.Attributes.Rot90) > 0 then tmpRot = tmpRot + (math.pi / 2) end
					if bit.band(self.map[j][i], Backgrounds.Attributes.Rot180) > 0 then tmpRot = tmpRot + math.pi end
					
					Backgrounds.Batch:add(
						Backgrounds.Tiles.Indexes[bit.band(self.map[j][i], Backgrounds.Attributes.Tile)],
						tmpX + tileHalf, tmpY + tileHalf,
						tmpRot,
						tmpScaleX, tmpScaleY,
						tileHalf, tileHalf
					)
				end
			end
		end
		Backgrounds.Batch:flush()
		love.graphics.draw(Backgrounds.Batch, self.x, self.y, self._rotation, self._scale[1], self._scale[2], self._home.x, self._home.y)
	end
	
	-- SmileBASIC-like
	function background:set(x, y, tile)
		if self:withinBackground(x, y) and tile then
			self.map[y][x] = tile
			
			return tile
		end
	end
	function background:get(x, y)
		if self:withinBackground(x, y) then
			return self.map[y][x]
		end
	end
	function background:fill(x1, y1, x2, y2)
		if self:withinBackground(x1, y1) and self:withinBackground(x2, y2) and tile then
			local i, j
			
			for j = y1, y2 do
				for i = x1, x2 do
					self.map[j][i] = tile
				end
			end
		end
	end
	function background:print(text, x, y)
		local i
		
		for i = 0, #text - 1 do
			background:set(x + i, y, string.byte(text, i + 1))
		end
	end
	
	function background:withinBackground(x, y)
		return x and y and x >= 0 and y >= 0 and x < self.width and y < self.height
	end
	
	background:setup()
	
	return background
end

-- If you don't want this, you can delete it. It's just my proprietary background file format.
-- All files have an extension of *.v360map
function Backgrounds.fromV360Map(filename)
	local bg = {}
	local i, j, l
	local layers, width, height
	local contents
	
	contents = love.filesystem.read(filename)
	
	-- If file not even there...
	if not contents then
		print("Failed to load map!")
		return
	end
	
	-- If file not long enough...
	if #contents < Backgrounds.V360MapFileBytes.MapOffset then
		print("File not nearly long enough!")
		return
	end
	
	-- If the magic number is here...
	if not contents:sub(Backgrounds.V360MapFileBytes.MagicNumber, 3) == Backgrounds.V360MapMagicNumber then
		print("Magic number not present! Make sure your file has 0x56 0x03 0x60 at the beginning, before the metadata!")
		return
	end
	
	-- get the layers
	if contents:byte(Backgrounds.V360MapFileBytes.Layers) > 0 and contents:byte(Backgrounds.V360MapFileBytes.Layers) <= 16 then
		layers = contents:byte(Backgrounds.V360MapFileBytes.Layers)
	else
		print("Layers out of range! Between 1 and 16, please!")
		return
	end
	
	-- get the width
	if contents:byte(Backgrounds.V360MapFileBytes.Width) > 0 then
		width = contents:byte(Backgrounds.V360MapFileBytes.Width)
	else
		print("Width out of range! Greater than 0, please!")
		return
	end
	
	-- get the height
	if contents:byte(Backgrounds.V360MapFileBytes.Height) > 0 then
		height = contents:byte(Backgrounds.V360MapFileBytes.Height)
	else
		print("Height out of range! Greater than 0, please!")
		return
	end
	
	-- check if this all makes sense
	if #contents < Backgrounds.V360MapFileBytes.MapOffset + (2 * layers * height * width) - 1 then
		print("Too many contents!!!")
		return
	end
	
	-- make the backgrounds
	for l = 0, layers - 1 do
		bg[l + 1] = Backgrounds.new(width, height)
		
		for j = 0, height - 1 do
			for i = 0, width - 1 do
				bg[l + 1].map[j][i] = bit.bor(
					-- BIG ENDIAN FOREVER
					bit.lshift(contents:byte(Backgrounds.V360MapFileBytes.MapOffset + 0 + ((l * height * width) + (j * width) + i) * 2), 8),
					(          contents:byte(Backgrounds.V360MapFileBytes.MapOffset + 1 + ((l * height * width) + (j * width) + i) * 2)   )
				)
			end
		end
	end
	
	return bg
end
