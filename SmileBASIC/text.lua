-- Text: A text layer that shows up on top of the normal screen.

Text = {
	Sheet = love.graphics.newImage("resources/text.png"),
	Batch = nil,
	BackgroundBatch = nil,
	BackgroundShader = nil,
	
	Attributes = {
		Rot0     = 0x0,
		Rot90    = 0x1,
		Rot180   = 0x2,
		Rot270   = 0x3,
		FlipH    = 0x4,
		FlipV    = 0x8
	},
	Characters = {},
	Palette = {
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
	Colors = {
		Transparent = 0,
		Black       = 1,
		Maroon      = 2,
		Red         = 3,
		Green       = 4,
		Lime        = 5,
		Olive       = 6,
		Yellow      = 7,
		Navy        = 8,
		Blue        = 9,
		Purple      = 10,
		Magenta     = 11,
		Teal        = 12,
		Cyan        = 13,
		Gray        = 14,
		Grey        = 14,
		White       = 15
	},
	
	Size = 8
}

-- Names, to reduce redundancy.
Text.Palette.Transparent = Text.Palette[ 0] Text.Palette.Navy    = Text.Palette[ 8]
Text.Palette.Black       = Text.Palette[ 1] Text.Palette.Blue    = Text.Palette[ 9]
Text.Palette.Maroon      = Text.Palette[ 2] Text.Palette.Purple  = Text.Palette[10]
Text.Palette.Red         = Text.Palette[ 3] Text.Palette.Magenta = Text.Palette[11]
Text.Palette.Green       = Text.Palette[ 4] Text.Palette.Teal    = Text.Palette[12]
Text.Palette.Lime        = Text.Palette[ 5] Text.Palette.Cyan    = Text.Palette[13]
Text.Palette.Olive       = Text.Palette[ 6] Text.Palette.Gray    = Text.Palette[14]
Text.Palette.Yellow      = Text.Palette[ 7] Text.Palette.White   = Text.Palette[15]

-- Just in case
Text.Palette.Grey = Text.Palette[14]

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
	local file = love.filesystem.read(filename)
	
	if not file then
		print("Yikes! That doesn't exist!")
		return
	end
	
	Text.Characters = {}
	
	for character, x, y in file:gmatch("(%d+),(%d+),(%d+)") do
		Text.Characters[tonumber(character)] = love.graphics.newQuad(tonumber(x), tonumber(y), Text.Size, Text.Size, Text.Sheet:getDimensions())
	end
end

-- Character Listing
Text.readCharacterListing("resources/characters.csv")

function Text.new(width, height)
	local text = {
		type = "text",
		
		text = nil,
		
		cursor = {x = 0, y = 0, z = 0, fc = Text.Colors.White, bc = Text.Colors.Transparent, attr = 0}
	}
	
	text = SmileBASIC.apply(text, 0, 0, 0, width, height)
	
	function text:setup()
		self.text = {}
		
		for j = 0, self.height - 1 do
			self.text[j] = {}
			for i = 0, self.width - 1 do
				self.text[j][i] = self:newCharacter(0)
			end
		end
	end
	function text:update()
		-- Callbacks
		self:runCallbacks()
	end
	function text:draw()
		local i, j
		local textHalf = Text.Size / 2
		
		Text.BackgroundBatch:clear()
		Text.Batch:clear()
		for j = 0, self.height - 1 do
			for i = 0, self.width - 1 do
				if self.text[j][i].fc > 0 or self.text[j][i].bc > 0 then
					local tmpX = i * Text.Size
					local tmpY = j * Text.Size
					
					local tmpRot = 0
					
					local tmpScaleX = bit.band(self.text[j][i].attr, Text.Attributes.FlipH) > 0 and -1 or 1
					local tmpScaleY = bit.band(self.text[j][i].attr, Text.Attributes.FlipV) > 0 and -1 or 1
					
					if bit.band(self.text[j][i].attr, Text.Attributes.Rot90) > 0 then tmpRot = tmpRot + (math.pi / 2) end
					if bit.band(self.text[j][i].attr, Text.Attributes.Rot180) > 0 then tmpRot = tmpRot + math.pi end
					
					if self.text[j][i].bc > 0 then
						Text.BackgroundBatch:setColor(Text.Palette[self.text[j][i].bc])
						Text.BackgroundBatch:add(
							Text.Characters[self.text[j][i].chr],
							tmpX + textHalf, tmpY + textHalf,
							tmpRot,
							tmpScaleX, tmpScaleY,
							textHalf, textHalf
						)
					end
					if self.text[j][i].fc > 0 then
						Text.Batch:setColor(Text.Palette[self.text[j][i].fc])
						Text.Batch:add(
							Text.Characters[self.text[j][i].chr],
							tmpX + textHalf, tmpY + textHalf,
							tmpRot,
							tmpScaleX, tmpScaleY,
							textHalf, textHalf
						)
					end
				end
			end
		end
		Text.BackgroundBatch:flush()
		Text.Batch:flush()
		
		love.graphics.setShader(Text.BackgroundShader)
		love.graphics.draw(Text.BackgroundBatch, self.x, self.y, self._rotation * math.pi / 180, self._scale[1], self._scale[2], self._home.x, self._home.y)
		love.graphics.setShader()
		
		love.graphics.draw(Text.Batch, self.x, self.y, self._rotation * math.pi / 180, self._scale[1], self._scale[2], self._home.x, self._home.y)		
	end
	
	-- Text controls
	-- NOT TO BE CONFUSED WITH SB:CLEAR()!!!
	function text:clearScreen()
		local i, j
		
		self.cursor.x = 0
		self.cursor.y = 0
		
		for j = 0, self.height - 1 do
			for i = 0, self.width - 1 do
				self:setCharacter(i, j) -- in this case, reset character (am i right guys)
			end
		end
	end
	function text:print(str, newline)
		local i
		
		if newline ~= false and not newline then newline = true end
		
		if str then
			for i = 1, #str do
				if string.byte(str, i) == 10 then
					if self.cursor.x ~= 0 then self:lineBreak() end -- SmileBASIC hides linebreaks if they happen on a line wrap.
				else
					self:setCharacter(self.cursor.x, self.cursor.y, string.byte(str, i))
					
					self.cursor.x = self.cursor.x + 1
					if self.cursor.x >= self.width then
						self:lineBreak()
					end
				end
			end
		end
		
		if newline then
			self:lineBreak()
		end
	end
	function text:lineBreak()
		self.cursor.x = 0
		self.cursor.y = self.cursor.y + 1
			
		if self.cursor.y >= self.height then
			self.cursor.y = self.height - 1
			self:scroll(0, 1)
		end
	end
	function text:locate(x, y)
		self.cursor.x, self.cursor.y = self:toScreen(x, y)
		
		return self.cursor.x, self.cursor.y
	end
	function text:attribute(attr)
		if attr then self.cursor.attr = attr end
		
		return self.cursor.attr
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
	function text:scroll(x, y, wrap)
		if x or y then
			x = x or 0
			y = y or 0
			
			local i, j, t
			local newText = {}
			
			if wrap then
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
							newText[j][i] = self:newCharacter(0, Text.Colors.White, Text.Colors.Transparent)
						end
					end
				end
			end
			
			self.text = newText
		end
	end
	
	-- Internal
	function text:newCharacter(chr, fc, bc, attr, z)
		return {
			chr = chr or 0,
			fc = fc or self.cursor.fc,
			bc = bc or self.cursor.bc,
			attr = attr or self.cursor.attr,
			z = z or self.cursor.z
		}
	end
	function text:setCharacter(x, y, chr, fc, bc, attr, z)
		self.text[y][x].chr = chr or 0
		self.text[y][x].fc = fc or self.cursor.fc
		self.text[y][x].bc = bc or self.cursor.bc
		self.text[y][x].attr = attr or self.cursor.attr
		self.text[y][x].z = z or self.cursor.z
	end
	
	-- You found the easter egg!
	function text:fakeBoot(version, bytesFree, projectString)
		self:color(15, 0)
		self:clearScreen()
		self:print("SmileBASIC ver " .. (version or "3.6.0"))
		self:print("(C)2011-20" .. os.date("%y") .." SmileBoom Co.Ltd.")
		-- if cracked then
		-- 	self:print("-- CRACKED BY V360TECH --")
		-- end
		self:print((bytesFree or 8327164) .. " bytes free")
		self:print()
		if projectString and #projectString > 0 then
			self:print("[" .. projectString .. "]OK")
		else
			self:print("OK")
		end
	end
	
	text:setup()
	
	return text
end
