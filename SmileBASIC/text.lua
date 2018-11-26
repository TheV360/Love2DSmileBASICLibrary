-- Text: A text layer that shows up on top of the normal screen.

Text = {
	Sheet = love.graphics.newImage("resources/text.png"),
	Batch = nil,
	BackgroundBatch = nil,
	BackgroundShader = nil,
	
	Characters = {},
	Colors = {
		[ 0] = {0 , 0 , 0 , 0},
		[ 1] = {0  , 0  , 0  },
		[ 2] = {0.5, 0  , 0  },
		[ 3] = {1  , 0  , 0  },
		[ 4] = {0  , 0.5, 0  },
		[ 5] = {0  , 1  , 0  },
		[ 6] = {0.5, 0.5, 0  },
		[ 7] = {1  , 1  , 0  },
		[ 8] = {0  , 0  , 0.5},
		[ 9] = {0  , 0  , 1  },
		[10] = {0.5, 0  , 0.5},
		[11] = {1  , 0  , 1  },
		[12] = {0  , 0.5, 0.5},
		[13] = {0  , 1  , 1  },
		[14] = {0.5, 0.5, 0.5},
		[15] = {1  , 1  , 1  }
	},
	ColorIndex = { -- makes funky music
		Transparent = 0,
		Black       = 1,
		Maroon      = 2,
		Red         = 3,
		Green       = 4,
		Lime        = 5,
		Mustard     = 6,
		Yellow      = 7,
		DarkBlue    = 8,
		Blue        = 9,
		Purple      = 10,
		Pink        = 11,
		Teal        = 12,
		Cyan        = 13,
		DarkGray    = 14,
		DarkGrey    = 14,
		White       = 15
	},
	
	Size = 8
}

-- Names, to reduce redundancy.
Text.Colors.Transparent = Text.Colors[ 0] Text.Colors.DarkBlue    = Text.Colors[ 8]
Text.Colors.Black       = Text.Colors[ 1] Text.Colors.Blue        = Text.Colors[ 9]
Text.Colors.Maroon      = Text.Colors[ 2] Text.Colors.Purple      = Text.Colors[10]
Text.Colors.Red         = Text.Colors[ 3] Text.Colors.Pink        = Text.Colors[11]
Text.Colors.Green       = Text.Colors[ 4] Text.Colors.Teal        = Text.Colors[12]
Text.Colors.Lime        = Text.Colors[ 5] Text.Colors.Cyan        = Text.Colors[13]
Text.Colors.Mustard     = Text.Colors[ 6] Text.Colors.DarkGray    = Text.Colors[14]
Text.Colors.Yellow      = Text.Colors[ 7] Text.Colors.White       = Text.Colors[15]
Text.Colors.DarkGrey    = Text.Colors[14]

-- Batch thing
Text.Batch = love.graphics.newSpriteBatch(Text.Sheet)
Text.BackgroundBatch = love.graphics.newSpriteBatch(Text.Sheet)

Text.BackgroundShader = love.graphics.newShader[[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
		vec4 pixel = Texel(texture, texture_coords);
		return vec4(color.rgb, 1.0 - pixel.a);
	}
]]

function Text.readCharacterListing(filename)
	local chr = love.filesystem.read(filename)
	
	Text.Characters = {}
	
	for l in chr:gmatch("[^\r\n]+") do
		local tmp = {}
		
		-- Split by comma
		for c in l:gmatch("[^,]+") do
			table.insert(tmp, tonumber(c))
		end
		
		if #l > 0 then
			Text.Characters[tmp[1]] = love.graphics.newQuad(tmp[2], tmp[3], Text.Size, Text.Size, Text.Sheet:getDimensions())
		end
	end
end

-- Character Listing
Text.readCharacterListing("resources/characters.txt")

function Text.new(width, height)
	local text = {
		type = "text",
		
		text = nil,
		
		cursor = {x = 0, y = 0, fc = Text.ColorIndex.White, bc = Text.ColorIndex.Transparent}
	}
	
	text = SmileBASIC.apply(text, 0, 0, 0, width, height)
	
	function text:setup()
		self:clearScreen()
	end
	function text:update()
		-- Callbacks
		self:runCallbacks()
	end
	function text:draw()
		local i, j
		
		Text.BackgroundBatch:clear()
		Text.Batch:clear()
		for j = 0, self.height - 1 do
			for i = 0, self.width - 1 do
				if self.text[j][i].bc > 0 then
					Text.BackgroundBatch:setColor(Text.Colors[self.text[j][i].bc])
					Text.BackgroundBatch:add(Text.Characters[self.text[j][i].chr], i * Text.Size, j * Text.Size)
				end
				if self.text[j][i].fc > 0 then
					Text.Batch:setColor(Text.Colors[self.text[j][i].fc])
					Text.Batch:add(Text.Characters[self.text[j][i].chr], i * Text.Size, j * Text.Size)
				end
			end
		end
		Text.BackgroundBatch:flush()
		Text.Batch:flush()
		
		love.graphics.setShader(Text.BackgroundShader)
		love.graphics.draw(Text.BackgroundBatch, self.x, self.y, self._rotation, self._scale.x, self._scale.y, self._home.x, self._home.y)
		love.graphics.setShader()
		
		love.graphics.draw(Text.Batch, self.x, self.y, self._rotation, self._scale.x, self._scale.y, self._home.x, self._home.y)		
	end
	
	-- Text controls
	-- NOT TO BE CONFUSED WITH SB:CLEAR()!!!
	function text:clearScreen()
		local i, j
		
		self.cursor.x = 0
		self.cursor.y = 0
		
		self.text = {}
		
		for j = 0, self.height - 1 do
			self.text[j] = {}
			for i = 0, self.width - 1 do
				self.text[j][i] = {chr = 0, fc = self.cursor.fc, bc = self.cursor.bc}
			end
		end
	end
	function text:print(str, newline)
		local i
		
		if newline ~= false and not newline then newline = true end
		
		for i = 1, #str do
			self.text[self.cursor.y][self.cursor.x] = {chr = string.byte(str, i), fc = self.cursor.fc, bc = self.cursor.bc}
			
			self.cursor.x = self.cursor.x + 1
			if self.cursor.x >= self.width then
				self.cursor.x = 0
				self.cursor.y = self.cursor.y + 1
				
				if self.cursor.y >= self.height then
					self.cursor.y = self.height - 1
					self:scroll(0, 1)
				end
			end
		end
		
		if newline then
			self.cursor.x = 0
			self.cursor.y = self.cursor.y + 1
				
			if self.cursor.y >= self.height then
				self.cursor.y = self.height - 1
				self:scroll(0, 1)
			end
		end
	end
	function text:locate(x, y)
		self.cursor.x, self.cursor.y = self:toScreen(x, y)
		
		return self.cursor.x, self.cursor.y
	end
	function text:color(fc, bc)
		if fc then self.cursor.fc = fc end
		if bc then self.cursor.bc = bc end
		
		return self.cursor.fc, self.cursor.bc
	end
	function text:character(x, y)
		x, y = self:toScreen(x, y)
		
		return self.text[y][x].chr
	end
	function text:toScreen(x, y)
		x = x or self.cursor.x
		y = y or self.cursor.y
		
		return math.max(0, math.min(x, self.width  - 1)), math.max(0, math.min(y, self.height - 1))
	end
	function text:scroll(x, y, keep)
		if x or y then
			x = x or 0
			y = y or 0
			
			local i, j, t
			local newText = {}
			
			if keep then
				for j = 0, self.height - 1 do
					newText[j] = {}
					for i = 0, self.width - 1 do
						newText[j][i] = self.text[(j + y) % self.height][(i + x) % self.width]
					end
				end
			else
				for j = 0, self.height - 1 do
					newText[j] = {}
					for i = 0, self.width - 1 do
						if i + x >= 0 and i + x < self.width and j + y >= 0 and j + y < self.height then
							newText[j][i] = self.text[j + y][i + x]
						else
							-- Intentional
							newText[j][i] = {chr = 0, fc = 15, bc = 0}
						end
					end
				end
			end
			
			self.text = newText
		end
	end
	
	text:setup()
	
	return text
end
