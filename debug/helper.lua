-- Horrible wrapper that handles debug things.

return function(debug)
	local nop = function() end
	local d = { update = nop, draw = nop }
	
	if debug then
		d.stats = require("debug.stats")
		d.console = require("debug.console")
		
		local CallbackWrapper = require("util.callbackwrapper")
		CallbackWrapper:addLoveFunction("textinput", function(text)
			d.console:textinput(text)
		end, "debug")
		CallbackWrapper:addLoveFunction("keypressed", function(key)
			d.console:keypressed(key)
			if key == "-" then
				d.stats.enabled = not d.stats.enabled
			end
		end, "debug")
		
		function d:update(dt)
			self.console:update(dt)
			self.stats:update(dt)
		end
		function d:draw(screen, debugFont)
			local f = love.graphics.getFont()
			if debugFont then love.graphics.setFont(debugFont) end
			self.console:draw(screen.scale)
			self.stats:draw(screen.scale, screen)
			love.graphics.setFont(f)
		end
	end
	
	return d
end
