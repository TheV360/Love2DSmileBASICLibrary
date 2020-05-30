function love.load()
	Object = require("objects/object")
	TileMap = require("objects/tilemap")
	TileLayer = require("objects/tilelayer")
	
	GameWindow = require("window/window")
	Util = require("window/util")
	
	GameWindow.pixelPerfect()
	
	-- Import all these "classes"
	require "SmileBASIC/smilebasic"
	
	-- Set up pixel font
	local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□☺☻←↑→↓]]
	font = love.graphics.newImageFont("resources/font_6x8.png", supportedCharacters)
	love.graphics.setFont(font)
	
	require("game")
	
	window = GameWindow{
		title = "Template",
		icon = love.image.newImageData("resources/icon.png"),
		
		screen = {
			scale = 4,
			
			width  = 400,
			height = 240
		},
		
		button = {
			up    = "up",
			down  = "down",
			left  = "left",
			right = "right",
			a     = "z",
			b     = "x",
			start = "return",
			quit  = "escape"
		},
		debug = true,
		
		setup = setup,
		update = update,
		draw = draw
	}
	
	window:setup()
end

function love.update(dt)
	window:update(dt)
end

function love.draw()
	window:draw()
end
