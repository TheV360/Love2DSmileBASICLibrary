-- This is a bit of a disaster. But it works well enough.
-- It's worse! I added unicode Symbols.
-- Run this with regular old lua to construct the vector.lua file from the vector-template.lua file.

function readAll(file)
	local f = assert(io.open(file, "r"))
	local content = f:read("*a")
	f:close()
	return content
end

local unformattedCode = readAll("vector-template.lua")

-- Ah, here's some "documentation."
local newSyntax = {
	["⊗c"] = "The number of total components will be put here.",
	["⊗v"] = "The name of the variant currently being generated will be put here.",
	["⊗V"] = "The long name of the variant currently being generated will be put here.",
	["⊗f"] = "The number of total components AND the short variant name will be put here.",
	
	["⊗⊗c"] = "The current component letter will be put here. Only works in blocks.",
	["⊗⊗i"] = "The current component index will be put here. Only works in blocks.",
	
	["⊠{}"] = "Repeat this block for each component.",
	["⊠i{}"] = "Repeat this block for each component, inserting some text string 'i' between each repetition.",
	
	["⊘~on{}"] = [[
		Only output this block when this set condition is satisfied.
		Condition consists of:
		- '~', negates the condition if present
		- 'o', which is one of: =, <, >, <=, or >=.
		- 'n', the component to check the current component against
	]],
	["⊘v{}"] = "Only output this block when variant 'v'.",
	
	["⊘first{}"] = "Output this block at the top of the file once.",
	["⊘last{}"] = "Output this block at the bottom of the file once.",
}
--[[local syntaxSymbols = {
	CONSTANT = "@c@",
	VARIABLE = "@c@@",
	REPEAT = "@r@",
	SPECIALIZE = "@s@"
}]]
local syntaxSymbols = {
	CONSTANT = "⊗",
	VARIABLE = "⊗⊗",
	REPEAT = "⊠",
	SPECIALIZE = "⊘"
}

--[[ to build
cd util/geometry
~/Documents/Apps/Lua/lua54.exe vector-creator.lua
--]]

local components = {'x', 'y', 'z', 'w', 'a', 'b', 'c', 'd'}
local variants = {'f', 'i'}
local variantsLong = {"float", "integer"}
-- for i = 1, 64 do -- fun
-- 	components[i] = string.char(string.byte('a') + i - 1)
-- end
local resultingCode = ""

-- Make Vector2 to Vector4.
for component = 2, 4 do
	for variant = 1, #variants do
		local code = unformattedCode
		
		local firstTimeAround = component == 2 and variant == 1
		local lastTimeAround = component == 4 and variant == #variants
		
		-- First/Last Specializer
		code = string.gsub(code, syntaxSymbols.SPECIALIZE .. "first(%b{})", function(sub)
			return firstTimeAround and string.sub(sub, 2, #sub - 1) or ""
		end)
		code = string.gsub(code, syntaxSymbols.SPECIALIZE .. "last(%b{})", function(sub)
			return lastTimeAround and string.sub(sub, 2, #sub - 1) or ""
		end)
		
		-- Variant Specializer
		code = string.gsub(code, syntaxSymbols.SPECIALIZE .. "(%l)(%b{})", function(v, sub)
			return (variants[variant] == v) and string.sub(sub, 2, #sub - 1) or ""
		end)
		
		-- Component Specializer
		code = string.gsub(code, syntaxSymbols.SPECIALIZE .. "(~?)([<>]?=?)(%d+)(%b{})", function(negation, cmp, n, sub)
			negation = negation == "~"
			n = tonumber(n)
			local cmpResult = false
			if false then
				elseif cmp == "<=" then cmpResult = component <= n
				elseif cmp == ">=" then cmpResult = component >= n
				elseif cmp == "<" then cmpResult = component < n
				elseif cmp == ">" then cmpResult = component > n
				else cmpResult = component == n
			end
			if negation then cmpResult = not cmpResult end
			return cmpResult and string.sub(sub, 2, #sub - 1) or ""
		end)
		
		-- Delimited Repetition Block AND Normal Repetition Block
		code = string.gsub(code, syntaxSymbols.REPEAT .. "([^{]*)(%b{})", function(delimiter, expr)
			expr = string.sub(expr, 2, #expr - 1)
			delimiter = #delimiter > 0 and delimiter or false
			
			local result = ""
			for i = 1, component do
				local replaced = expr
				replaced = string.gsub(replaced, syntaxSymbols.VARIABLE .. "c", components[i])
				replaced = string.gsub(replaced, syntaxSymbols.VARIABLE .. "i", i - 1) -- sorry lua users
				
				if delimiter and #result > 0 then
					result = result .. delimiter
				end
				result = result .. replaced
			end
			
			return result
		end)
		
		-- Constants
		code = string.gsub(code, syntaxSymbols.CONSTANT .. "c", component)
		code = string.gsub(code, syntaxSymbols.CONSTANT .. "v", variants[variant])
		code = string.gsub(code, syntaxSymbols.CONSTANT .. "V", variantsLong[variant])
		code = string.gsub(code, syntaxSymbols.CONSTANT .. "f", "" .. component .. variants[variant])
		
		resultingCode = resultingCode .. "-- Generated file.\n" .. code
	end
end

local theResultingFile = io.open("vector.lua", "w")
theResultingFile:write(resultingCode)
theResultingFile:close()
