# AnimatedImage for Playdate

The goal of AnimatedImage is to be able to plop in animated images in place of static images easily. No calls to update, etc. In fact, AnimatedImage behaves just like a built-in `playdate.graphics.image`. Any API `playdate.graphics.image` supports so does AnimatedImage, except it operates on the current frame. It does this by forwarding any call to the current frame image. It is more or less a drop-in replacement.

AnimatedImage is less than 100 lines of Lua, and most of that is just boilerplate getter/setter as AnimatedImage sits on top of `playdate.graphics.image` and `playdate.graphics.animation.loop`. Simply replace `playdate.graphics.image.new` with `AnimatedImage.new` to get started, and change the path from a static image to that of an image table or gif.

![Example Animation](/demo.gif?raw=true "Example Animation")

# License

Public Domain: Do what you wish! Just don't hold me accountable. :)

# API

AnimatedImage mimics the built-in Playdate SDK image object. This means any function supported by `playdate.graphics.image` can be called directly on an AnimatedImage. That said, AnimatedImage does have a few functions for controlling playback.

## `AnimatedImage.new(image_table_path, options)`
Create a new `AnimatedImage`.

`image_table_path` can be a path to either a simple image, an image table, or a GIF.
`options` is a table of optional settings for your `AnimatedImage`.
`options.delay` is the amount of time to delay (in milliseconds) before moving to the next frame.
`options.loop` is a boolean which enables or disables looping of the animation.
`options.paused` is a boolean which either starts the animation in a paused or playing state.
`options.first` is the index of the first frame in the animation.
`options.last` is the index of the last frame in the animation.


## `AnimatedImage:reset()`
Reset the frame to the start frame of the `AnimatedImage`.

## `AnimatedImage:setDelay(delay)`
Change the delay between frames in the animation.

`delay` is the amount of time (in milliseconds) before moving to the next frame.

## `AnimatedImage:getDelay()`
Get the currently set delay (in milliseconds).

## `AnimatedImage:setShouldLoop(should_loop)`
Change whether the animation should loop or not.

`should_loop` is a boolean that dictates whether the animation should loop or not.

## `AnimatedImage:getShouldLoop()`
Get whether the animation will loop or not.

## `AnimatedImage:setPaused(paused)`
Pause or play the animation.
`paused` is a boolean which determines if the animation should play or pause. Paused animations will stop on the current frame.

## `AnimatedImage:getPaused()`
Get whether the animation is paused or not.

## `AnimatedImage:setFrame(frame)`
Manually set the frame to display.

`frame` is the index of the frame to display.

## `AnimatedImage:getFrame()`
Get the currently displayed frame.

## `AnimatedImage:setFirstFrame(frame)`
Set the frame the animation starts and loops from.

`frame` is the index of the frame to start from.

## `AnimatedImage:setEndFrame(frame)`
Set the frame the animation ends at.

`frame` is the index of the frame to end on.

