-- SmileBASIC: Abstract library for Sprites, Backgrounds, and the Text layer, since they have a lot in common

SmileBASIC = {
	Index = 0
}

-- SmileBASIC.TransformShader = love.graphics.newShader[[
-- 	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
-- 		vec2 texCoords = texture_coords;
		
-- 		if (FlipH) {
-- 			// Flip Horizontally
-- 			texCoords.x = 1.0 - texCoords.x
-- 		}
-- 		if (FlipV) {
-- 			// Flip Vertically
-- 			texCoords.y = 1.0 - texCoords.y;
-- 		}
		
-- 		if (Rot90) {
-- 			// Flip 90
-- 			texCoords.xy = vec2(1.0 - texCoords.y, texCoords.x);
-- 		}
-- 		if (Rot180) {
-- 			// Flip 180
-- 			texCoords.xy = vec2(1.0 - texCoords.x, 1.0 - texCoords.y);
-- 		}
		
-- 		return Texel(texture, texCoords);
-- 	}
-- ]]

function SmileBASIC.apply(old, x, y, z, width, height, home, rotation, color, scale)
	local sb = {
		index = SmileBASIC.Index,
		
		x = x or 0,
		y = y or 0,
		z = z or 0,
		
		width = width or 16,
		height = height or 16,
		
		_home = _home or {x = 0, y = 0},
		
		-- Rotation in Degrees!
		_rotation = _rotation or 0,
		
		_color = _color or {1, 1, 1, 1},
		
		_scale = _scale or {x = 1, y = 1},
		
		animations = {},
		callbacks = {},
		variables = {0, 0, 0, 0, 0, 0, 0, 0}
	}
	
	-- Core will always be different, so it is not included.
	function sb:runAnimations()
		--if self.animations[Animations.Types.Offset] then x, y = 
	end
	function sb:runCallbacks()
		local i
		
		for i = 1, #self.callbacks do
			self.callbacks[i](self)
		end
	end
	
	-- SmileBASIC-like
	function sb:offset(x, y, z)
		if x or y or z then
			-- if (x or y) and self.animations[SmileBASIC.Animations.XY] then
			-- 	self.animations[SmileBASIC.Animations.XY] = nil
			-- end
			-- if z and self.animations[SmileBASIC.Animations.Z] then
			-- 	self.animations[SmileBASIC.Animations.XY] = nil
			-- end
			
			if x then self.x = x end
			if y then self.y = y end
			if z then self.z = z end
		end
		
		return self.x, self.y, self.z
	end
	
	function sb:home(x, y)
		if x or y then
			if x then self._home.x = x end
			if y then self._home.y = y end
		end
		
		return self._home.x, self._home.y
	end
	
	function sb:rotation(r) -- degrees
		if r then
			self._rotation = r
		end
		
		return self._rotation
	end
	
	function sb:color(r, g, b, a)
		if r or g or b or a then
			if r then self._color[0] = r end
			if g then self._color[1] = g end
			if b then self._color[2] = b end
			if a then
				self._color[3] = a
			else
				self._color[3] = 1
			end
		end
		
		return self._color[0], self._color[1], self._color[2], self._color[3]
	end
	
	function sb:scale(x, y)
		if x or y then
			if x then self._scale.x = x end
			if y then self._scale.y = y end
		end
		
		return self._scale.x, self._scale.y
	end
	
	function sb:addCallback(func)
		table.insert(self.callbacks, func)
	end
	function sb:removeCallback(func)
		table.remove(self.callbacks, func)
	end
	function sb:variable(index, value)
		if value then self.variables[index] = value end
		
		return self.variables[index]
	end
	
	-- Death
	function sb:clear()
		self = nil
	end
	
	local name, _
	for name, _ in pairs(old) do
		if not sb[name] then
			sb[name] = old[name]
		end
	end
	
	SmileBASIC.Index = SmileBASIC.Index + 1
	
	return sb
end
