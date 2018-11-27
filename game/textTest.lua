function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:color(0, 15)
	t:print("What")
	
	h = love.graphics.newImage("game/hsvtest.png")
	h_shader = love.graphics.newShader("game/funky.frag")
end

function update()
	t:locate(math.random(0, t.width - 1), math.random(15, t.height - 1))
	-- t:color(math.random() > .5 and math.random(0, 15) or 0, math.random(2, 15))
	t:print("Hello, world! This sentence is too long to fit on one line of the text screen.", false)
	
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
