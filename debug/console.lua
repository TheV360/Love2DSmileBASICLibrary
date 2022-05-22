local utf8 = require("utf8")
-- ! FIXME: unfinished utf8 support

local Console = {
	enabled = false,
	
	openKey = "`",
	
	stealth = true,
	stealthLog = {},
	stealthLifetime = 120,
	stealthFadeTime = 30,
	
	width = 80,
	
	input = "",
	cursor = 1,
	camera = 1,
	cursorBlink = 0,
	
	-- select = false,
	-- selectFrom = -1,
	-- selectTo = -1,
	
	inputPrefix = ">> ",
	
	log = {
		-- Oooo dramatic splash screen
		[[     _/_/   _/_/   _/    _/   _/_/   _/_/   _/     _/_/_/_/]],
		[[  _/     _/    _/ _/_/  _/ _/     _/    _/ _/     _/       ]],
		[[ _/     _/    _/ _/  _/_/   _/   _/    _/ _/     _/_/_/    ]],
		[[_/     _/    _/ _/    _/     _/ _/    _/ _/     _/         ]],
		[[ _/_/   _/_/   _/    _/ _/_/     _/_/   _/_/_/ _/_/_/_/    ]],
		"",
		"By V360 - Type 'help' for help.",
		""
	},
	logMax = 24,
	
	history = {},
	historyMax = 32,
	historyNow = "",
	currHistory = 0,
	
	tab = {},
	currTab = 0,
	tabBefore = "",
	tabBeforeCursor = 0,
	tabMessage = nil,
	
	errorMessages = {
		"Oh no",
		"Sorry",
		"Error",
		"Failed"
	},
	
	charWidth = nil,
	lineHeight = nil,
	
	tabStep = 4,
	
	validVariable = "[%a_][%a%d_]*",
	vagueIdentifier = "[%a_][%a%d_%.%:]*",
	
	-- TODO: better way to do this
	init = false,
	fontInit = false,
}

function Console:setup(o)
	o = o or {}
	
	self.logMax = o.logMax or self.logMax or 24
	
	self.init = true
	
	love.keyboard.setKeyRepeat(true)
end

function Console:setupChars(o)
	o = o or {}
	
	self.charWidth  = o.charWidth  or math.max(Util.measureTextWidth("m"), Util.measureTextWidth("w"), Util.measureTextWidth("_"))
	self.lineHeight = o.lineHeight or Util.measureTextHeight()
	
	self.fontInit = true
end

console_print = print

-- Hook to print function
print = function(...)
	console_print(...)
	Console:print(...)
end

print_table = function(t, depth)
	depth = depth or 0
	if depth > 8 then
		print("too much")
		return
	end
	
	local depth_space = string.rep(" ", depth)
	for i, c in pairs(t) do
		if type(c) == "table" then
			if next(c) == nil then
				print(depth_space .. i .. ": {}")
			else
				print(depth_space .. i .. ": {")
				print_table(c, depth + 1)
				print(depth_space .. "}")
			end
		elseif type(c) == "string" then
			print(depth_space .. i .. ": [" .. #c .. "] \"" .. c .. "\"")
		else
			print(depth_space .. i .. ": " .. tostring(c))
		end
	end
end

look_around = function(t)
	local tmp = {}
	local tmpI = 1
	
	for i, _ in pairs(t) do
		if tmpI > 4 then
			tmpI = 1
			print(
				tmp[1]~=nil and tmp[1] or "",
				tmp[2]~=nil and tmp[2] or "",
				tmp[3]~=nil and tmp[3] or "",
				tmp[4]~=nil and tmp[4] or ""
			)
			tmp[1] = nil
			tmp[2] = nil
			tmp[3] = nil
			tmp[4] = nil
		end
		tmp[tmpI] = i
		tmpI = tmpI + 1
	end
	
	print(
		tmp[1]~=nil and tmp[1] or "",
		tmp[2]~=nil and tmp[2] or "",
		tmp[3]~=nil and tmp[3] or "",
		tmp[4]~=nil and tmp[4] or ""
	)
end

-- Converts this: a[tab]b[tab][tab]d
--       to this: a_______b_______________d
-- Used when you print("multiple", "arguments", "like", "this")
function Console:spaceArguments(...)
	local l = select("#", ...)
	
	if l > 0 then
		local t = {...}
		local i
		
		local r = tostring(t[1])
		
		for i = 2, l do
			r = r .. string.rep(" ", 8 - #r % self.tabStep) .. tostring(t[i])
		end
		
		return r
	else
		return ""
	end
end

function Console:print(...)
	local text = self:spaceArguments(...)
	
	if text:find("\n") then
		local i
		local texts = Util.stringSplit(text, "\n")
		
		for i = 1, #texts do
			self:print(texts[i])
		end
		
		return
	end
	
	self.log[#self.log + 1] = text
	
	-- "Scroll"
	if #self.log > self.logMax then
		table.remove(self.log, 1)
	end
	
	if self.stealth then
		self.stealthLog[#self.stealthLog + 1] = {
			text = text,
			life = self.stealthLifetime
		}
		
		-- Also "Scroll"
		if #self.stealthLog > self.logMax then
			table.remove(self.stealthLog, 1)
		end
	end
end

function Console:printSpecial(entryTable)
	self.log[#self.log + 1] = entryTable
	
	-- "Scroll"
	if #self.log > self.logMax then
		table.remove(self.log, 1)
	end
	
	console_print(entryTable.text)
end

function Console:addAtCursor(str)
	self.input = string.sub(self.input, 1, self.cursor - 1) .. str .. string.sub(self.input, self.cursor)
	self.cursor = self.cursor + #str
	self:moveCameraToCursor()
end

function Console:textinput(key)
	if not self.enabled then
		if key == self.openKey then
			self.enabled = true
		end
		return
	end
	
	self:hideTabMessage()
	
	self:addAtCursor(key)
	
	self:clearState()
end

function Console:keypressed(key)
	if not self.enabled then return end
	
	if key == "lshift" or key == "rshift"
	or key == "lctrl"  or key == "rctrl"
	or key == "lalt"   or key == "ralt"
	then return end
	
	self:hideTabMessage()
	
	if love.keyboard.isDown("lctrl", "rctrl") then
		if key == "x" then
			love.system.setClipboardText(self.input)
			self:clearInput()
		elseif key == "c" then
			love.system.setClipboardText(self.input)
		elseif key == "v" then
			self:addAtCursor(love.system.getClipboardText())
		elseif key == "z" then
			self:clearInput()
		else
			return
		end
	elseif love.keyboard.isDown("lshift", "rshift") then
		if key == "tab" then
			self:tabCompletion(-1)
			return
		else
			return
		end
	else
		if key == "up" then
			if self.currHistory == 0 then
				self.historyNow = self.input
			end
			if self.currHistory < #self.history then
				self.currHistory = self.currHistory + 1
				self:clearInput()
				self:addAtCursor(self.history[self.currHistory])
			end
		elseif key == "down" then
			if self.currHistory > 0 then
				self.currHistory = self.currHistory - 1
				self:clearInput()
				if self.currHistory == 0 then
					self:addAtCursor(self.historyNow)
				else
					self:addAtCursor(self.history[self.currHistory])
				end
			end
		elseif key == "left" and self.cursor > 1 then
			self.cursor = self.cursor - 1
			self:moveCameraToCursor()
		elseif key == "right" and self.cursor < utf8.len(self.input) + 1 then
			self.cursor = self.cursor + 1
			self:moveCameraToCursor()
		elseif key == "home" then
			self.cursor = 1
			self:moveCameraToCursor()
		elseif key == "end" then
			self.cursor = utf8.len(self.input) + 1
			self:moveCameraToCursor()
		elseif key == "return" then
			self:runInput()
		elseif key == "delete" then
			if utf8.len(self.input) > 0 and self.cursor <= utf8.len(self.input) then
				self.input = string.sub(self.input, 1, self.cursor - 1) .. string.sub(self.input, self.cursor + 1)
				self:moveCameraToCursor()
			end
		elseif key == "backspace" then
			if utf8.len(self.input) > 0 and self.cursor > 1 then
				self.cursor = self.cursor - 1
				self.input = string.sub(self.input, 1, self.cursor - 1) .. string.sub(self.input, self.cursor + 1)
				self:moveCameraToCursor()
			end
		elseif key == "tab" then
			self:tabCompletion(1)
			return
		end
	end
	
	self:clearState()
end

function Console:hideTabMessage()
	self.tabMessage = nil
end

function Console:tabCompletion(dir)
	if self.currTab < 1 then
		-- Oof, we have to calculate the things
		self.tab = {}
		self.currTab = 0
		self.tabMessage = nil
		
		-- So if you press tab here love.graphics.re|(), it only sees "love.graphics.re" [VALID] and not "love.graphics.re()" [INVALID]
		local inputCur = string.sub(self.input, 1, self.cursor - 1)
		local start, stop = inputCur:find(self.vagueIdentifier .. "$") -- grabs anything that looks like an identifier
		-- also must be at the end, hence the $
		
		local isValid, items
		
		-- We're supposed to have something.
		if utf8.len(self.input) > 0 and start then
			-- Yay, we found something that looks like an identifier!
			inputCur = string.sub(inputCur, start, stop)
			
			-- ...but is it really?
			isValid, items = self:isValidIdentifier(inputCur, true)
			
			-- It wasn't
			if not isValid then return end
		else
			-- It's alright to have nothing.
			items = {""}
		end
		
		-- It was!
		local i
		local tableTrace = _G -- _G contains itself oh gosh oh flip
		
		-- Trace down to the table we are in right now
		for i = 1, #items - 1 do
			tableTrace = tableTrace[items[i]]
			if (not tableTrace) or type(tableTrace) ~= "table" then return end -- Oh, turns out that doesn't exist, okay! :/
		end
		
		self.tabBeforeComponent = items[#items]
		
		-- Find something that looks like it!
		if #items[#items] > 0 then
			for i in pairs(tableTrace) do
				start = string.sub(i, 1, #items[#items]) -- Repurposed variable
				if start == items[#items] then
					table.insert(self.tab, string.sub(i, #items[#items] + 1))
				end
			end
		else
			for i in pairs(tableTrace) do
				table.insert(self.tab, i)
			end
		end
		
		-- If we didn't find anything, give up.
		if #self.tab < 1 then return end
		
		-- Alphabetize the stuff
		table.sort(self.tab)
		
		-- I think we've succeeded. Save the text you've added in preparation to add text
		-- also the cursor too. don't forget!
		self.tabBefore = self.input
		self.tabBeforeCursor = self.cursor
		
		-- Wraps properly.
		self.currTab = dir >= 0 and 0 or 1
	end
	
	-- Now, more general tasks
	self.currTab = ((self.currTab + dir - 1) % #self.tab) + 1
	
	-- Set the input to the base thing (DESCRIPTIVE COMMENTS)
	self.input = self.tabBefore
	self.cursor = self.tabBeforeCursor
	
	-- Add thing
	self:addAtCursor(self.tab[self.currTab])
	
	-- Fix
	self:moveCameraToCursor()
	
	-- Show tab status
	local msg = string.format("%" .. #tostring(#self.tab) .. "d / " .. #self.tab .. ": ", self.currTab)
	msg = msg .. self.tabBeforeComponent .. self.tab[self.currTab]
	
	if not self.tabMessage then
		self.tabMessage = {text = "", color = {1, 1, 1, 0.5}, noCamera = true}
	end
	self.tabMessage.text = msg
	
	-- Whoops
	self.cursorBlink = 0
end

function Console:runInput()
	local line = self.input
	
	self:clearInput()
	self.historyNow = nil
	self.currHistory = 0
	
	if line == "`" or line == "exit" or line == "quit" then self.enabled = false return end
	if line == "~" or line == "cls" or line == "clear" then self.log = {} return end
	if line == "^" or line == "stealth" then self.stealth = not self.stealth return end
	if line == "?" or line == "help" then
		self:print([[
+-----+---- Help ----+
|`    | exit console |
|cls  | clear console|
|help | display this |
|keys | key shortcuts|
+-----+--------------+
|Anything else will  |
|be treated as a Lua |
|statement.          |
+--------------------+
|If you put = at the |
|beginning of a line,|
|it shows the result.|
+--------------------+]]
		)
		return
	end
	if line == "keys" then
		self:print([[
+------+-- Keyboard -+
|up/dn | history     |
+------+-------------+
|ctrlZ | clear line  |
|ctrlX | cut line    |
|ctrlC | copy line   |
|ctrlV | paste line  |
+------+-------------+
|tab   | autocomplete|
| (shift goes back!) |
+--------------------+]]
		)
		return
	end
	
	-- Show line in console
	Console:printSpecial{text = self.inputPrefix .. line, color = {0.75, 0.875, 1}}
	
	-- Add line to history
	table.insert(self.history, 1, line)
	-- If history passed its max, remove a thing.
	if #self.history > self.historyMax then
		table.remove(self.history)
	end
	
	-- If line has = at start, encase the code in print()
	-- If line has double equals at start, encase it in some identifying characters to show how yes, it is a thing
	-- If line has weird bracket equals sad face, encase the code in a pretty print function.
	-- If line has weird arrow, encase the code in a look command.
	if string.sub(line, 1, 2) == "==" then
		self:runLine([[print('"' .. (]] .. string.sub(line, 3) .. [[) .. '"')]])
	elseif string.sub(line, 1, 2) == "=[" then
		self:runLine("print_table(" .. string.sub(line, 3) .. ")")
	elseif string.sub(line, 1, 2) == "=>" then
		self:runLine("look_around(" .. string.sub(line, 3) .. ")")
	elseif string.sub(line, 1, 1) == "=" then
		self:runLine("print(" .. string.sub(line, 2) .. ")")
	else
		self:runLine(line)
	end
end

function Console:runLine(code)
	local HANDLE_WITH_CARE = loadstring(code)
	local status, err = pcall(HANDLE_WITH_CARE)
	if not status then
		local errMsg = self.errorMessages[love.math.random(1, #self.errorMessages)]
		print(errMsg .. ": " .. err)
	else
		if err then print(tostring(err)) end
	end
end

function Console:clearInput()
	self.input = ""
	self.cursor = 1
	self:moveCameraToCursor()
end

function Console:clearState()
	self.currTab = 0
	self.cursorBlink = 0
end

function Console:moveCameraToCursor()
	if self.camera > self.cursor then self.camera = self.cursor end
	if self.camera + self.width - utf8.len(self.inputPrefix) - 1 < self.cursor then
		self.camera = self.cursor - (self.width - utf8.len(self.inputPrefix) - 1)
	end
end

-- One variable
function Console:isValidVariable(str)
	return str:find(self.validVariable) and true or false
end

-- Multiple stuff
function Console:isValidIdentifier(str, openEnded)
	local i
	
	-- variables (cursorBlink, arg2, etc)
	local vars = {}
	
	-- delimiters (. and :)
	local delCount = 0
	
	-- You can't be yourself twice
	local alreadySelf = false
	
	-- Check if the things separating them are good.
	for i in str:gfind("[%.%:]") do
		-- Can't do this: a.b:c.d
		-- I don't accept any delimiters once you use a :.
		if alreadySelf then
			return false
		end
		if i == ":" then
			alreadySelf = true
		end
		delCount = delCount + 1
	end
	
	-- Check if the things in between the delimiters are good.
	for i in str:gfind(self.validVariable) do
		table.insert(vars, i)
	end
	
	if openEnded and delCount == #vars then
		table.insert(vars, "")
	end
	
	return delCount + 1 == #vars, vars
end

function Console:update()
	if not self.init then
		Console:setup()
	end
	
	if not self.enabled then
		if self.stealth then
			local i
			
			for i = #self.stealthLog, 1, -1 do
				self.stealthLog[i].life = self.stealthLog[i].life - 1
				
				if self.stealthLog[i].life <= -self.stealthFadeTime then
					table.remove(self.stealthLog, i)
				end
			end
		end
		
		return
	end
	
	self.cursorBlink = self.cursorBlink + 1
end

function Console:draw(scale)
	if not self.fontInit then
		Console:setupChars()
	end
	
	-- kinda a disaster
	if not self.init then return end
	if not self.enabled then
		if self.stealth then
			local scale = math.max(2, scale - 1)
			
			love.graphics.setColor(0, 0, 0)
			for i = 1, #self.stealthLog do
				local changedColor = false
				
				if self.stealthLog[i].life <= 0 then
					-- Fade out
					love.graphics.setColor(0, 0, 0, (self.stealthFadeTime + self.stealthLog[i].life) / self.stealthFadeTime)
					changedColor = true
				end
				
				if self.stealthLog[i].color then
					love.graphics.setColor(self.stealthLog[i].color)
					changedColor = true
				end
				
				-- how to draw shadow
				love.graphics.print(self.stealthLog[i].text, 8, 9 + (i - 1) * self.lineHeight * scale, 0, scale)
				love.graphics.print(self.stealthLog[i].text, 9, 8 + (i - 1) * self.lineHeight * scale, 0, scale)
				love.graphics.print(self.stealthLog[i].text, 9, 9 + (i - 1) * self.lineHeight * scale, 0, scale)
				
				if changedColor then
					love.graphics.setColor(0, 0, 0)
				end
			end
			
			love.graphics.setColor(1, 1, 1)
			for i = 1, #self.stealthLog do
				local changedColor = false
				
				if self.stealthLog[i].life <= 0 then
					-- Fade out
					love.graphics.setColor(1, 1, 1, (self.stealthFadeTime + self.stealthLog[i].life) / self.stealthFadeTime)
					changedColor = true
				end
				
				if self.stealthLog[i].color then
					love.graphics.setColor(self.stealthLog[i].color)
					changedColor = true
				end
				
				-- Draw the text.
				love.graphics.print(self.stealthLog[i].text, 8, 8 + (i - 1) * self.lineHeight * scale, 0, scale)
				
				if changedColor then
					love.graphics.setColor(1, 1, 1)
				end
			end
		end
		
		return
	end
	
	local wWidth, wHeight = love.graphics.getDimensions()
	
	local i, msg
	local bottomDist = (#self.log + (self.tabMessage and 2 or 1)) * (self.lineHeight * scale)
	
	love.graphics.setColor(0.25, 0.25, 0.25, 0.5)
	love.graphics.rectangle("fill", 0, wHeight - bottomDist, self.width * self.charWidth * scale, bottomDist)
	
	love.graphics.setColor(1, 1, 1)
			
	for i = 1, #self.log do
		love.graphics.print(
			self:drawLineHelper(self.log[i], i),
			0, wHeight - (bottomDist - self.lineHeight * scale * (i - 1)),
			0, scale
		)
	end
		
	if self.tabMessage then
		love.graphics.print(
			self:drawLineHelper(self.tabMessage, #self.log + 1),
			0, wHeight - (bottomDist - self.lineHeight * scale * #self.log),
			0, scale
		)
	end
	
	love.graphics.setColor(0.5, 0.75, 1)
	msg = self.inputPrefix .. string.sub(self.input, self.camera, self.camera + self.width - utf8.len(self.inputPrefix) - 1)
	love.graphics.print(msg, 0, wHeight - self.lineHeight * scale, 0, scale)
	
	love.graphics.setColor(0.25, 0.5, 1, 0.5 + Util.cosine(self.cursorBlink, 90, 0.5))
	love.graphics.print("■", (self.cursor - self.camera + utf8.len(self.inputPrefix)) * self.charWidth * scale, wHeight - (self.lineHeight * scale), 0, scale)
end

function Console:drawLineHelper(line, i)
	local msg
	
	if type(line) == "table" then
		msg = line.text
		love.graphics.setColor(line.color)
			
		if not line.noCamera then
			msg = string.sub(msg, self.camera, self.camera + self.width - 1)
		end
	else
		msg = line
		love.graphics.setColor(1, 1, 1)
		
		msg = string.sub(msg, self.camera, self.camera + self.width - 1)
	end
	
	return msg
end
	
return Console
