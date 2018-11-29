function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:color(0, 15)
	t:print("What")
	
	t2 = Text.new(10, 10)
	table.insert(sb, t2)
	t2:offset(200, 120, -2)
	t2:home(5*8, 5*8)
	t2:scale(2, 1)
	t2:addCallback(rotateAround)
	
	t2:color(Text.Colors.Black, Text.Colors.White)
	t2:print("I'm a 10x10 text screen! My text wraps really quickly and it's horrible! I'm pretty sure Text screens are a SmileBASIC 4 feature!")
	
	h = love.graphics.newImage("game/hsvtest.png")
	h_shader = love.graphics.newShader("game/funky.frag")
end

function update()
	t:locate(math.random(0, t.width - 1), math.random(15, t.height - 1))
	t:color(math.random(0, 15), math.random(2, 15))
	t:print("Hello, world! This sentence is too long to fit on one line of the text screen.", false)
	
	for i = 1, #sb do
		sb[i]:update()
	end
	
	h_shader:send("time", window.frames / 120)
end

function draw()
	love.graphics.clear(0, 0, 0)
	
	love.graphics.setShader(h_shader)
	love.graphics.draw(h, 0, 0)
	love.graphics.setShader()
	
	ZSort.clear()
	for i = 1, #sb do
		ZSort.add(sb[i])
	end
	ZSort.flush()
end

function rotateAround(t)
	t:rotation(
		t:rotation() + 1
	)
end
