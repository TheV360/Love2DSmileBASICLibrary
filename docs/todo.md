Hello, welcome to the
# TODO FILE!!!
* ~~Move Sprite and Background general functions into a shared object called SmileBASICLike~~ ***DONE***
* ~~Add the text layer? May be even easier to implement. Z-indexing isn't important. It'll use SpriteBatches, and will use [otyaSmileBASIC's font lookup table.](https://github.com/otya128/otyaSMILEBASIC/blob/master/SMILEBASIC/resources/fonttable.txt) Maybe even convert this to binary and make it smaller?~~
* Note that in [text.png](resources/text.png), Ⓐ is on top of A. Maybe have a way of coverting §A to Ⓐ somehow, where § is the control character, and § moves UV coordinates up 8 pixels
````lua
function Text.special(chr)
	return quad
end
````
* Finish [animations.lua](animations.lua). See [the anim reference](anim.md) for more info.
* ~~Finish Background spritebatch implementation~~ ***DONE***
* The Sprite attributes don't work the way they should. Is this even possible to do correctly?
	* Rot90 should only rotate the source image 90 degrees, not the sprite.
	* Could use shader for it, instead of using thing!
* Create shader for text layer's background thing! I really don't want to load redundant data if there's a way to draw backgrounds with masked text.

# Complete things that I shouldn't touch
* Most of `main.lua`
* `watch.lua`
* `smilebasic.lua`
