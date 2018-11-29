function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:color(0, 15)
	t:print("Looping keyframed Sprite animations!")
	t:print("Not final syntax at all.")
	t:print("It's also off by a few frames.")
	t:print("The code is a bit of a disaster, but IT WORKS!")
	
	s = Sprites.new(1)
	s:home(8, 8)
	table.insert(sb, s)
	
	-- NOT FINAL SYNTAX!
	s.animations[1] = Animations.new(s, Animations.Types.Offset, false, {
		Animations.animationPart(120, {64, 64}, Animations.Timing.Sine),
		Animations.animationPart(60, {8, 8}, Animations.Timing.Linear),
		Animations.animationPart(60, {200, 120}, Animations.Timing.Linear)
	}, 0)
	s.animations[2] = Animations.new(s, Animations.Types.Rotation, false, {
		Animations.animationPart(120, {360}, Animations.Timing.Linear),
		Animations.animationPart(120, {0}, Animations.Timing.Sine)
	}, 0)
	s.animations[3] = Animations.new(s, Animations.Types.Scale, false, {
		Animations.animationPart(180, {1,1}, Animations.Timing.Instant),
		Animations.animationPart(20, {4,8}, Animations.Timing.Linear),
		Animations.animationPart(20, {8,4}, Animations.Timing.Linear),
		Animations.animationPart(20, {8,8}, Animations.Timing.Linear)
	}, 0)
end

function update()
	s:update()
end

function draw()
	love.graphics.clear(0, 0, 0)
	
	ZSort.clear()
	for i = 1, #sb do
		ZSort.add(sb[i])
	end
	ZSort.flush()
end
