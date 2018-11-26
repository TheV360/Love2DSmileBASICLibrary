# Watch.lua Info.

## What's Watch.lua?

Watch dot lua is total garbage.............

## How it works

When you make a watcher, you supply two things:
* A key table
* A check function
It then returns a watcher object. This contains:
* A "down" table
* A "press" table
* A "release"
* update() [function] (by me!)
