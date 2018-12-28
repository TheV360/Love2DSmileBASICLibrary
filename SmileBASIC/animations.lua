-- Animations: Vague class that makes an object that updates specific SmileBASIC-related values.

-- Maybe also allow a generic animation mode? You pass a table reference, it updates it over time.
-- if self.type == nil then
-- end

Animations = {
	Types = {
		Offset      = 0, XY = 0,
		Depth       = 1, Z  = 1,
		SourceImage = 2, UV = 2,
		Definition  = 3, I  = 3,
		Rotation    = 4, R  = 4,
		Scale       = 5, S  = 5,
		Color       = 6, C  = 6,
		Variable    = 7, V  = 7
	},
	
	Timing = {
		Instant = function(t, a, b) return b end,
		Linear = function(t, a, b) return a + t * (b - a) end,
		Sine = function(t, a, b) return Animations.Timing.Linear(math.pow(math.sin(math.pi * .5 * t), 2), a, b) end
	}
}

function Animations.animationPart(time, item, timingFunction)
	local r = {
		time = time and math.abs(time) or 0,
		item = item or {0},
		timingFunction = timingFunction
	}
	
	if not timingFunction then
		if time < 0 then
			r.timingFunction = Animations.Timing.Linear
		else
			r.timingFunction = Animations.Timing.Instant
		end
	end
	
	return r
end

function Animations.new(table, type, relative, keyframes, loop)
	if table.type ~= "sprite" and (type == Animations.Types.UV or type == Animations.Types.I) then return nil end
	
	local animation = {
		table = table,
		type = type,
		relative = relative or true,
		current = {
			index = 1,
			frames = 0,
			endFrame = nil
		},
		keyframes = keyframes or {Animations.animationPart(1, 0, Animations.Timing.Instant)},
		loop = loop or 1
	}
	
	-- Core
	function animation:setup()
		self.current.endFrame = self.keyframes[self.current.index].time
		
		-- 0th element is a fake keyframe containing the initial state of the animation.
		self.keyframes[0] = {item = self:getData()}
	end
	function animation:update()
		self.current.frames = self.current.frames + 1
		
		if self.current.frames > self.current.endFrame then
			self.current.index = self.current.index + 1
			
			if self.current.index > #self.keyframes then
				if self.loop > 0 then
					if self.loop > 1 then
						self.loop = self.loop - 1
						
						self.current.index = 1
					else
						self = nil
						return
					end
				else
					self.current.index = 1
				end
			end
			
			self.current.endFrame = self.keyframes[self.current.index].time
			self.current.frames = 1
		end
		
		self:applyData()
	end
	function animation:getData()
		if self.type then
			if     self.type == Animations.Types.Offset      then
				return {self.table.x, self.table.y}
			elseif self.type == Animations.Types.Depth       then
				return {self.table.z}
			elseif self.type == Animations.Types.SourceImage then
				return {self.table.u, self.table.v}
			elseif self.type == Animations.Types.Definition  then
				return {self.table.lastUsedDefinition}
			elseif self.type == Animations.Types.Rotation    then
				return {self.table._rotation}
			elseif self.type == Animations.Types.Scale       then
				return self.table._scale
			elseif self.type == Animations.Types.Color       then
				return self.table._color
			elseif self.type == Animations.Types.Variable or self.type < 0 then
				if self.type < 0 then
					return {self.sb.variables[-self.type]}
				else
					return {self.sb.variables[8]}
				end
			end
		else
			local i, t = 0, {}
			
			for i = 1, #self.table.map do
				t[i] = self.table.data[self.table.map[i]]
			end
			
			return t
		end
	end
	function animation:applyData()
		if self.type then
			if     self.type == Animations.Types.Offset      then
				self.table.x = self:animate(1)
				self.table.y = self:animate(2)
			elseif self.type == Animations.Types.Depth       then
				self.table.z = self:animate(1)
			elseif self.type == Animations.Types.SourceImage then
				self.table.u = self:animate(1)
				self.table.v = self:animate(2)
			elseif self.type == Animations.Types.Definition  then
				self.table:useDefinition(math.floor(self:animate(1)))
			elseif self.type == Animations.Types.Rotation    then
				self.table._rotation = self:animate(1)
			elseif self.type == Animations.Types.Scale       then
				self.table._scale[1] = self:animate(1)
				self.table._scale[2] = self:animate(2)
			elseif self.type == Animations.Types.Color       then
				self.table._color[1] = self:animate(1)
				self.table._color[2] = self:animate(2)
				self.table._color[3] = self:animate(3)
				self.table._color[4] = self:animate(4)
			elseif self.type == Animations.Types.Variable or self.type < 0 then
				if self.type < 0 then
					self.table.variables[-self.type] = self:animate(1)
				else
					self.table.variables[8] = self:animate(1)
				end
			end
		else
			local i
			
			for i = 1, #self.table.map do
				self.table.data[self.table.map[i]] = self:animate(i)
			end
		end
	end
	function animation:animate(index)
		-- if self.relative then
		-- 	return self.keyframes[0].item[index] + 
		-- 	self.keyframes[self.current.index].timingFunction(
		-- 		self.current.frames / self.current.endFrame,
		-- 		self.keyframes[self.current.index - 1].item[index],
		-- 		self.keyframes[self.current.index].item[index]
		-- 	)
		-- else
			return self.keyframes[self.current.index].timingFunction(
				self.current.frames / self.current.endFrame,
				self.keyframes[self.current.index - 1].item[index],
				self.keyframes[self.current.index].item[index]
			)
		-- end
	end
	
	animation:setup()
	
	return animation
end
