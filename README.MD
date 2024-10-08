# ![Pretty Icon](resources/icon.png) Love2D SmileBASIC Library

Want to port your games and applications over to Love2D? This library makes it easy to add Text layers, Sprites, Backgrounds, and Animations, while maintaining the SmileBASIC aesthetic!

**WARNING:** Due to copyright concerns, the default SmileBASIC Sprites and Backgrounds are not distributed with this library. Replace both `resources/sprites.png` and `resources/tiles.png` with their actual versions before using this library. You can also just use a different spritesheet and tilesheet, but that sorta misses the point of this entire library... <sup><sub>(The text is distributed with this because why not)</sub></sup>

<img src=".screenshotsForREADME/apiTest.png" alt='A bunch of fish orbiting a map. There are two lines text in the top left corner that both read "Hello, world!". One is green.' width="50%" /><img src=".screenshotsForREADME/apiTest2.png" alt='A grid of random sprites. Multiple fish are still orbiting a map. The map is translucent. The text is also still there, and it still reads "Hello, world!".' width="50%" />
<img src=".screenshotsForREADME/animTest.png" alt='A very large sprite reading SmileBASIC (C) SmileBoom. The sprite is at an extreme angle.' width="50%" /><img src=".screenshotsForREADME/textTest.png" alt='Multiple lines of multicolor text fill the background. In the foreground is a small box of text. It is also at an extreme angle.' width="50%" />

<sup>(Please note that I am not SmileBoom or associated with SmileBoom.)</sup>

# Usability status!

Pretty gosh darn useable! The animation syntax is likely to change, but you can also use it the way I'm using it in `game/animTest.lua`

# Layout

This repo is split into a bunch of separate folders and files.

* `docs/`: Contains the documentation. [You can read it online here!](https://thev360.github.io/Love2DSmileBASICLibrary/)
* `game/`: You don't have to worry about anything here. You can easily throw it away. This does have ~~two~~ three test programs that test Sprites, Backgrounds, Text, Basic Z-sorting, Animations, and... shaders? for some reason?
	* `animTest.lua`: A demonstration of animations!
	* `apiTest.lua`: WHOOAAAAAAA fish (Demonstrates loading a map from a file, Sprite callbacks, Sprite definitions, blend modes, Background callbacks, Text colors, and transparency)
	* `textTest.lua`: Random text colors and printing! Also shaders for some reason! This also demonstrates a "cut out" effect for text with a foreground color of 0 (transparent).
	* `funky.frag`: I split the shader into another file.
	* `hsvtest.png` and `othertest.png`: Both of these are used with the shader I'm messing around with.
* `maps/`: For now, it contains one example map (`map1.v360map`) that you can use. It's in my horrible file format, too!
* `resources/`: Some things in this are important, some things in this aren't.
	* `characters.csv`: Very important. ~~[Stolen from otyaSmileBASIC](https://github.com/otya128/otyaSMILEBASIC/blob/master/SMILEBASIC/resources/fonttable.txt)~~ [Generously donated by 12Me21](https://github.com/TheV360/Love2DSmileBASICLibrary/pull/1). Used for the text layer's font.
	* `sprites.csv`: Relatively important. If you leave these out, that's completely fine. Used for Sprite definitions.
	* `icon.png`: Customizable icon for use in taskbar and window decorations.
	* `sprites.png`: Very important. **REPLACE THIS WITH THE ACTUAL VERSION BEFORE USING**. Used in `SmileBASIC/sprites.lua`.
	* `text.png`: Very important. **REPLACE THIS WITH THE ACTUAL VERSION BEFORE USING**. Used in `SmileBASIC/text.lua`.
	* `tiles.png`: Very important. **REPLACE THIS WITH THE ACTUAL VERSION BEFORE USING**. Used in `SmileBASIC/backgrounds.lua`. Inconsistent naming, but okay.
* `SmileBASIC/`: Contains all the modules. Or whatever they're called.
	* `animations.lua`: Unfinished. For animating Sprites and Backgrounds.
	* `backgrounds.lua`: Finished. For creating tile backgrounds.
	* `smilebasic.lua`: Finished? Abstract thing that Backgrounds, Sprites, and Text all inherit from.
	* `sprites.lua`: Finished? For creating movable, rotatable, stretchable, animatable, dyeable pieces of a spritesheet.
	* `text.lua`: Finished. For creating text screens and printing text to them.
	* `zsorting.lua`: Finished? For sorting all things that inherit from `smilebasic.lua`, and drawing them in order.
* `game.lua`: `main.lua` runs this after setting up a bunch of things. I styled it after PICO-8's game loop thing. For now, it's just a game selector. If you want to modify this: use `setup()`, `update()`, and `draw()`.
* `main.lua`: This is the template I usually start with when making things in Love2D.
* `watch.lua`: This is a small library that keeps track of when a condition is met, how long it has happened for, and when it stops being true. Useful for buttons and other inputs.
* `profile.lua`: This won't show up in the actual repo, but it's a lightweight profiler for Love2D. Disabled by default and not included, so you have to [download it from here](https://bitbucket.org/itraykov/profile.lua/src/master/profile.lua).
* `README.MD`: You're already there.

# To-do

* Add attributes to text
* Add 8x8 tiles and 32x32 tiles. Maybe just add ?x? tiles?
* Use [C FFI](http://luajit.org/ext_ffi.html) structs for some internal things (such as map tiles, maybe SPDEF data), to speed the library up a bit.
* Clean up parts of library
* The new icon I drew has both the red and blue parts split 50/50. This is not the case in the actual Love2D logo. Too lazy to fix

# Issues? Improvements?

Tell me! I really want to help people port their SmileBASIC programs to other languages so SmileBASIC can live on. Feel free to create an Issue or do a Pull Request! I don't quite know how Git works!

# License

MIT License

# Credits

* V360 - Most of the code, Sprite definitions dump from SmileBASIC
* rxi - [Classic](https://github.com/rxi/classic), a bundled library that implements the object type I use extensively. - MIT License
* tesselode - [Baton](https://github.com/tesselode/baton), a bundled library that implements a better input system than the one I had made before. - MIT License
* SmileBoom - Original assets, also for making SmileBASIC
* [otya](https://github.com/otya128) - Made a relatively complete reimplementation of SmileBASIC 3, check it out!
* [12Me21](https://github.com/12Me21) - Correct character definitions dump from SmileBASIC
