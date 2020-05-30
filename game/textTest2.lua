function setup()
	sb = {}
	
	t = Text.new(50, 30)
	table.insert(sb, t)
	t:fakeBoot()
	
	x, y = 0, 0
end

function update()
	if y > 0 and window.button.downTime["up"] % 5 == 1 then
		y = y - 1
	end
	if y < 28 and window.button.downTime["down"] % 5 == 1 then
		y = y + 1
	end
	if x > 0 and window.button.downTime["left"] % 5 == 1 then
		x = x - 1
	end
	if x < 49 and window.button.downTime["right"] % 5 == 1 then
		x = x + 1
	end
	
	for i = 1, #sb do
		sb[i]:update()
	end
end

function draw()
	love.graphics.clear(0, 0, 0)
	t:clearScreen()
	
	t:locate(x, y)
	t:print("Hello, world!" .. string.char(10) .. ":D", false)
	
	ZSort.clear()
	for i = 1, #sb do
		ZSort.add(sb[i])
	end
	ZSort.flush()
end
