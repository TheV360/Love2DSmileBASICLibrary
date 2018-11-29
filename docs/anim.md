# Animation specs:
## NOT FOR USE BY RANDOM PEOPLE!!!
## HOW TO USE
````lua
s = Sprites.new(342)
Animations.new()
````

Animations start at the current thing, then move to the first element, then second, and if they loop, *they move back to the first thing!*
When they run out of loops, they stop at the endpoint! *they don't go back to the first thing!*
Edge case 2: when animating Definition numbers, they're secretly 0 by default even if you define them specifically! When animating them, if they go back to the first thing, they go back to 0! Not your specifically defined spchr, but spdef 0!

# Animation Types
## General
- nil: Anything
	- Must supply a table with `data` and `map` items.
		- `data`: contains stuff you want to change. can also contain other stuff. best use: set this to a table reference. data to animate MUST BE NUMBERS
		- `map`: contains what indexes you want to change. this can be used to avoid animating some things.
## SmileBASIC
- 0 or "XY": XY-coordinates
- 1 or "Z": Z-coordinates
- 2 or "UV": UV-coordinates (Coordinates of the definition source image)
- 3 or "I": Definition number
- 4 or "R": Rotation angle
- 5 or "S": Magnification XY
- 6 or "C": Display color
- 7 or "V": Variable (Value of sprite internal variable 7)
- Adding 8 to the target numerical value will cause the value to be relative
- NEW! Negative numbers go like this:
	- -1 = `Variable[1]`
	- -2 = `Variable[2]`
	- -3 = `Variable[3]`
	- and so on. No limit as someone may exploit SP variable with a length greater than 8

# THINGS TO DO!
* ~~looping~~
* actual functions to add animations
* functions that remove their respective animation type
* check to see if relative coordinates even work.
