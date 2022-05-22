-- OOP stuff.
Object = require("util.object") -- Renamed from "Classic" by rxi
OptObject = require("util.optobject")

-- Math stuff.
VectorTypes = require("util.geometry.vector")
Vec2, Vec3, Vec4 = unpack(VectorTypes.float)

-- Helpful stuff.
CallbackWrapper = require("util.callbackwrapper")
InputHandler = require "util.input" -- Renamed from "Baton" by Tesselode
PixelScreen = require("util.pixelscreen")
Util = require("util.util")

-- Gives you a console and a stats widget. Pretty good. Maybe I'm biased.
-- You can pass "false" to this and the debug tools will be disabled.
DebugHelper = require("debug.helper")(true)

function love.load()
	-- Time spent so far.
	time = {
		frames = 0,
		seconds = 0,
		_tick = 0,
		maxTick = 1/60,
	}
	
	-- Makes everything nice and pixel-perfect.
	PixelScreen.PixelPerfect()
	
	-- Sets up the font.
	local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□☺☻←↑→↓]]
	debugFont = love.graphics.newImageFont("resources/font_debug.png", supportedCharacters)
	love.graphics.setFont(debugFont)
	
	-- Makes a pixel screen that centers itself in the window.
	screen = PixelScreen(Vec2(400, 240))
	screen:centerScaleIn(Vec2(love.graphics.getDimensions()))
	CallbackWrapper:addLoveFunction("resize", function(width, height)
		screen:centerScaleIn(Vec2(width, height))
	end, "screen resize")
	
	-- Makes an input object.
	input = InputHandler.new {
		controls = {
			left  = {"key:a", "axis:leftx-", "button:dpleft"},
			right = {"key:d", "axis:leftx+", "button:dpright"},
			up    = {"key:w", "axis:lefty-", "button:dpup"},
			down  = {"key:s", "axis:lefty+", "button:dpdown"},
			a     = {"key:k", "button:a"},
		},
		pairs = {
			move = {"left", "right", "up", "down"}
		},
		joystick = love.joystick.getJoysticks()[1],
		deadzone = 0.33,
	}
	
	-- Adds a few (okay, one... so far) shortcuts to do common tasks.
	CallbackWrapper:addLoveFunction("keypressed", function(key)
		if key == "f4" then
			love.window.setFullscreen(not love.window.getFullscreen())
			screen:centerScaleIn(Vec2(love.graphics.getDimensions()))
		end
	end, "shortcuts")
	
	-- Load stuff here.
	require("SmileBASIC.smilebasic")
	require("game")
	setup()
end

function love.update(dt)
	time._tick = time._tick + dt
	
	if time._tick < time.maxTick then return end
	time._tick = time._tick - time.maxTick
	
	dt = math.max(dt, time.maxTick)
	
	-- Update inputs.
	input:update()
	
	-- Update here.
	update(dt)
	
	-- Maybe update the debug tools.
	DebugHelper:update(dt)
	
	-- Push time forward.
	time.seconds = time.seconds + dt
	time.frames = time.frames + 1
end

function love.draw()
	-- Clear the screen.
	love.graphics.clear()
	
	love.graphics.setColor(1, 1, 1, 0.25)
	screen:drawOutsideRelative(function()
		love.graphics.rectangle('line', -0.5, -0.5, screen.size.x + 1, screen.size.y + 1)
	end)
	love.graphics.setColor(1, 1, 1)
	screen:renderThenDraw(function()
		love.graphics.clear()
		
		-- Draw here.
		draw()
	end)
	love.graphics.setShader()
	
	-- Maybe draw the debug tools.
	love.graphics.setColor(1, 1, 1)
	DebugHelper:draw(screen, debugFont)
end
