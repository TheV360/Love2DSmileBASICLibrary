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
		Variable    = 7, V  = 7,
		Relative    = 8
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

function Animations.new(startingData, type, data, loop)
	local animation = {
		type = type or Animations.Types.XY,
		initial = startingData or {0},
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
		self.current.endFrame = self.data[self.current.index].time
	end
	function animation:update()
		-- local d
		
		-- self.current.frames = self.current.frames + 1
		
		-- if self.current.frames >= self.current.endFrame then
		-- 	self.current.index = self.current.index + 1
			
		-- 	if self.current.index > #self.keyframes then
		-- 		if self.loop > 0 then
				
		-- 		else
					
		-- 		end
		-- 	end
		-- else
		-- 	for i = 1, #self.keyframes[self.current.index].item do
		-- 		self.keyframes[self.current.index].timingFunction(self.current.frames / self.current.endFrame, )
		-- 	end
		-- end
		
		-- return 
	end
	
	animation:setup()
	
	return animation
end
