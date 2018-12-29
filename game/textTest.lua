function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:color(15, 0)
	t:print("What")
	
	t2 = Text.new(10, 10)
	table.insert(sb, t2)
	t2:offset(200, 120, -2)
	t2:home(5*8, 5*8)
	t2:scale(2, 2)
	t2:addCallback(rotateAround)
	
	t2:color(Text.Colors.Black, Text.Colors.White)
	t2:print("I'm a 10x10 text screen! My text wraps really quickly and it's horrible! I'm pretty sure Text screens are a SmileBASIC 4 feature!")
	
	h = love.graphics.newImage("game/hsvtest.png")
	h_shader = love.graphics.newShader("game/funky.frag")
end

function update()
	t:locate(math.random(0, t.width - 1), math.random(15, t.height - 2))
	t:color(math.random(0, 15), math.random(2, 15))
	if window.frames % 10 == 0 then
		t:attribute(math.random(0, 0xf))
		t:print("Hello, world!" .. string.char(10) .. string.char(13) .. "This sentence is too long to fit on one line of the text screen.", false)
	end
	
	if button.downTime["up"] % 5 == 1 then
		t2:scroll(0, 1, true)
	end
	if button.downTime["down"] % 5 == 1 then
		t2:scroll(0, -1, true)
	end
	if button.downTime["left"] % 5 == 1 then
		t2:scroll(1, 0, true)
	end
	if button.downTime["right"] % 5 == 1 then
		t2:scroll(-1, 0, true)
	end
	
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
	local i, j = t:scale()
	
	t:rotation(
		t:rotation() + 1
	)
end
