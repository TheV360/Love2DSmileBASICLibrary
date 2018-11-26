# Animation specs:
## NOT FOR USE BY RANDOM PEOPLE!!!
## HOW TO USE
````lua
s = Sprites.new(342)
Animations.new()
````

Animations start at the current thing, then move to the first element, then second, and if they loop, *they move back to the first thing!*
When they run out of loops, they stop at the endpoint! *they don't go back to the first thing!*

# Edge cases and Animation Types
## Sprites
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


