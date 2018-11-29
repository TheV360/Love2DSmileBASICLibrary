local w = love.window.showMessageBox("GAME SELECT!", "Hello! Choose a program to run.", {"Text Test", "Animation Test", "API Test"}, "info")

if w == 1 then
	require "game/apiTest"
elseif w == 2 then
	require "game/animTest"
elseif w == 3 then
	require "game/textTest"
end
