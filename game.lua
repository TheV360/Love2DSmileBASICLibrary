if love.window.showMessageBox("GAME SELECT!", "Hello! Choose a program to run.", {"Game", "API Test"}, "info") > 1 then
	require "game/apiTest"
else
	require "game/textTest"
end
