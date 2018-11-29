function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:color(0, 15)
	t:print("Looping keyframed Sprite animations!")
	t:print("Not final syntax at all.")
	t:print("It's also off by a few frames.")
	t:print("The code is a bit of a disaster, but IT WORKS!")
	
	s = Sprites.new(4095)
	table.insert(sb, s)
	
	-- NOT FINAL SYNTAX!
	s.animations[1] = Animations.new(s, Animations.Types.Offset, false, {
		Animations.animationPart(120, {64, 64}, Animations.Timing.Sine),
		Animations.animationPart(60, {0, 32}, Animations.Timing.Linear),
		Animations.animationPart(60, {200, 120}, Animations.Timing.Linear)
	}, 0)
	s.animations[2] = Animations.new(s, Animations.Types.Rotation, false, {
		Animations.animationPart(120, {360}, Animations.Timing.Linear),
		Animations.animationPart(120, {0}, Animations.Timing.Linear)
	}, 0)
	s.animations[3] = Animations.new(s, Animations.Types.Scale, false, {
		Animations.animationPart(180, {1,1}, Animations.Timing.Instant),
		Animations.animationPart(20, {2,4}, Animations.Timing.Sine),
		Animations.animationPart(20, {4,2}, Animations.Timing.Sine),
		Animations.animationPart(20, {4,4}, Animations.Timing.Sine)
	}, 0)
	
	-- Animating a variable in a table
	tableThing = {
		a = 32,
		b = 6
	}
	variableAnimation = Animations.new({data = tableThing, map = {"a"}}, nil, false, {
		Animations.animationPart(180, {40}, Animations.Timing.Linear),
		Animations.animationPart(180, {24}, Animations.Timing.Linear),
	}, 0)
end

function update()
	t:locate(0,8)
	t:print(string.format("%.2f should change!!!!", tableThing.a))
	t:print(tableThing.b .. " shouldn't change!!!!")
	
	variableAnimation:update()
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
