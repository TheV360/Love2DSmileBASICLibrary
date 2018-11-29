Hello, welcome to the
# TODO FILE!!!
* ~~Move Sprite and Background general functions into a shared object called SmileBASICLike~~ ***DONE***
* ~~Add the text layer? May be even easier to implement. Z-indexing isn't important. It'll use SpriteBatches, and will use [otyaSmileBASIC's font lookup table.](https://github.com/otya128/otyaSMILEBASIC/blob/master/SMILEBASIC/resources/fonttable.txt) Maybe even convert this to binary and make it smaller?~~***DONE***
* Finish [animations.lua](animations.lua). See [the anim reference](anim.md) for more info.
* ~~Finish Background spritebatch implementation~~ ***DONE***
* The Sprite attributes do~~n't~~ work the way they should.~~ Is this even possible to do correctly?~~ ***IS THERE A BETTER WAY?***
	* Could use shader for it, instead of using thing! (See commented-out shader in smilebasic.lua)
* Add `~` and `*`, see issue [#2](https://github.com/TheV360/Love2DSmileBASICLibrary/issues/2).
