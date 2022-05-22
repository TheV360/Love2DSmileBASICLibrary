function setup()
	-- Make a table to hold all the elements we want to update and draw each frame
	sb = {}
	
	-- Make a text screen
	t = Text.new(50, 30) -- Make a 50x30 text screen
	table.insert(sb, t) -- Add its reference to the "sb" table.
	t:fakeBoot() -- ;)
	t:color(0, 15) -- Make the text transparent on a background of white.
	
	-- Print some test text to the text screen
	-- Note that this does not have a second argument, so it will put a line break at the end.
	t:print("This is an example script, showing off the text layer, sprites, and a background! SmileBASIC isn't real")
	
	-- Make a bunch of sprites
	for i = 0, 63 do
		s = Sprites.new(i) -- Make a sprite
		table.insert(sb, s) -- Add its reference to the "sb" table.
		s:offset(8 + (i % 16) * 16, 72 + math.floor(i / 16) * 16) -- Show it in a grid
		s:home(8, 8) -- Set sprite's home to center of sprite
	end
	
	-- Make a background
	b = Backgrounds.new(25, 15) -- It's 25x15 tiles
	table.insert(sb, b) -- Add its reference to the "sb" table.
	b:print("FAKE BACKGROUND TEXT!", 0, 12) -- Special command for writing characters
end

-- Every frame, do this
function update()
	-- We didn't lose the text reference, so print some text every few frames
	if time.frames % 8 == 0 then -- My "built-in" time object -- with frames
		t:print("Hello, world! ", false) -- We don't want a line break, so put false at the end.
	end
	
	-- Handle callbacks and animations, neither of which you're currently using. Still useful.
	for i = 1, #sb do
		sb[i]:update()
	end
end

function draw()
	-- Yes, you have to manually clear the screen.
	love.graphics.clear(0, 0, 0)
	
	-- Z-sort everything you added
	ZSort.clear()
	for i = 1, #sb do
		ZSort.add(sb[i])
	end
	ZSort.flush()
end
