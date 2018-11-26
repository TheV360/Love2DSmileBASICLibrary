# SmileBASIC Features for Love2D

This is SmileBASIC, but for Love2D. Except not really.

# Layout

This repo is split into a bunch of separate things.

* `docs/`: Contains where the documentation should be. I say "should be" because this is currently where some To-do lists and API specs live.
* `game/`: You don't have to worry about anything here. You can easily throw it away. This does have two test programs that test Sprites, Backgrounds, Text, Basic Z-sorting, and... shaders? for some reason?
* `maps/`: For now, it contains one example map (`map1.v360map`) that you can use. It's in my horrible file format, too!
* `resources/`: Some things in this are important, some things in this aren't.
	* `characters.txt`: Very important. [Stolen from otyaSmileBASIC](https://github.com/otya128/otyaSMILEBASIC/blob/master/SMILEBASIC/resources/fonttable.txt). Used for the text layer's font.
	* `font_8x8.png` and `font_16x8.png`: Not important. If you want some debug fonts, here you go. The 8x8 one is the regular SmileBASIC font. The 16x8 one is made by me.
	* `icon.png`: Not important. Fish.
	* `sprites.png`: Very important. Used in `SmileBASIC/sprites.lua`.
	* `text.png`: Very important. Used in `SmileBASIC/text.lua`.
	* `tiles.png`: Very important. Used in `SmileBASIC/backgrounds.lua`. Inconsistent naming, but okay.
* `SmileBASIC/`: Contains all the modules. Or whatever they're called.
	* `animations.lua`: Unfinished. For animating Sprites and Backgrounds.
	* `backgrounds.lua`: Finished. For creating tile backgrounds.
	* `smilebasic.lua`: Finished? Abstract thing that Backgrounds, Sprites, and Text all inherit from.
	* `sprites.lua`: Finished? For creating movable, rotatable, stretchable, animatable, dyeable pieces of a spritesheet.
	* `text.lua`: Finished. For creating text screens and printing text to them.
	* `zsorting.lua`: Finished? For sorting all things that inherit from `smilebasic.lua`, and drawing them in order.

# To-do

Completely separate the main.lua and everything else. `main.lua` is my Love2D template, and I don't want that to get in the way of anyone wanting to use this.

# Issues? Improvements?

Tell me! I really want to help people port their SmileBASIC programs to other languages so SmileBASIC can live on. Feel free to create an Issue or do a Pull Request! I don't quite know how Git works!

# Credits
* Me - All of the code
* SmileBoom - Most assets
* @otya128 - Character listings
