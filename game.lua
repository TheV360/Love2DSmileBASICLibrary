local w = love.window.showMessageBox("GAME SELECT!", "Hello! Choose a program to run.", {"Text Test", "Animation Test", "API Test", "Example"}, "info")

if w == 1 then
	require "game/textTest"
elseif w == 2 then
	require "game/animTest"
elseif w == 3 then
	require "game/apiTest"
else
	require "game/example"
end
