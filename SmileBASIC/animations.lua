-- Animations: Vague class that makes an object that updates other variables.

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

function Animations.new(sb, type, relative, keyframes, loop)
	local animation = {
		sb = sb,
		type = type or Animations.Types.XY,
		relative = relative or true,
		current = {
			index = 0,
			frames = -1,
			endFrame = -1
		},
		keyframes = keyframes or {Animations.animationPart(1, 0, Animations.Timing.Instant)},
		loop = loop or 1
	}
	
	-- Core
	function animation:setup()
		-- self.initial = 
		self.current.endFrame = self.keyframes[self.current.index].time
	end
	function animation:update()
		-- local d
		
		-- self.current.frames = self.current.frames + 1
		
		-- if self.current.frames >= self.current.endFrame then
		-- 	self.current.index = self.current.index + 1
			
		-- 	if self.current.index > #self.keyframes then
		-- 		if self.loop > 0 then
		-- 			if self.loop > 1 then
		-- 				self.loop = self.loop - 1
						
		-- 				self.current.index = 1
		-- 			else
		-- 				self = nil
		-- 				return
		-- 			end
		-- 		end
				
		-- 		self.current.frames = 0
		-- 		self.current.endFrame = self.keyframes[self.current.index].time
		-- 	end
		-- end
		
		-- for i = 1, #self.keyframes[self.current.index].item do
		-- 	self.keyframes[self.current.index].timingFunction(self.current.frames / self.current.endFrame, self.keyframes[self.current.index].item[i])
		-- end
	end
	function animation:getData()
		-- if     self.type == Animations.Types.Offset      then
			
		-- elseif self.type == Animations.Types.Depth       then
		-- elseif self.type == Animations.Types.SourceImage then
		-- elseif self.type == Animations.Types.Definition  then
		-- 	return self.sb.lastUsedDefinition
		-- elseif self.type == Animations.Types.Rotation    then
		-- 	return self.sb._rotation
		-- elseif self.type == Animations.Types.Scale       then
		-- 	return self.sb._scale
		-- elseif self.type == Animations.Types.Color       then
		-- 	return self.sb._color
		-- elseif self.type == Animations.Types.Variable or self.type < 0 then
		-- 	if self.type < 0 then
		-- 		return {self.sb.variables[-self.type]}
		-- 	else
		-- 		return {self.sb.variables[8]}
		-- 	end
		-- end
	end
	function animation:applyData()
	end
	
	animation:setup()
	
	return animation
end
