import "CoreLibs/animation"

local graphics <const> = playdate.graphics
local animation <const> = playdate.graphics.animation

AnimatedImage = {}

-- image_table_path should be an image table or a path to an image table.
-- options is a table of initial settings:
--   delay: time in milliseconds to wait before moving to next frame. (default: 100ms)
--   paused: start in a paused state. (default: false)
--   loop: loop the animation. (default: false)
--   step: number of frames to step. (default: 1)
--   sequence: an array of frame numbers in order to be used in the animation e.g. `{1, 1, 3, 5, 2}`. (default: all of the frames from the specified image table)

function AnimatedImage.new(image_table_path, options)
	options = options or {}
	
	local image_table = image_table_path
	if type(image_table_path) == "string" then
		image_table = graphics.imagetable.new(image_table_path)
	end
		
	if image_table == nil then
		print("ANIMATEDIMAGE: INVALID IMAGE USED", image_table_path)
		return nil
	end
	
	-- Build sequence image table, if specified.
	if options.sequence ~= nil then
		local sequence_image_table = graphics.imagetable.new(#options.sequence)
		for i, v in ipairs(options.sequence) do
			sequence_image_table:setImage(i, image_table:getImage(v))
		end
		image_table = sequence_image_table
	end
	
	local animation_loop = animation.loop.new(options.delay or 100, image_table, options.loop and true or false)
	animation_loop.paused = options.paused and true or false
	animation_loop.startFrame = options.first or 1
	animation_loop.endFrame = options.last or image_table:getLength()
	animation_loop.step = options.step or 1
	
	local animated_image = {}
	setmetatable(animated_image, AnimatedImage)
	animated_image.image_table = image_table
	animated_image.loop = animation_loop
	
	return animated_image
end

function AnimatedImage:reset()
	self.loop.frame = self.loop.startFrame
end

function AnimatedImage:setDelay(delay)
	self.loop.delay = delay
end

function AnimatedImage:getDelay()
	return self.loop.delay
end

function AnimatedImage:setShouldLoop(should_loop)
	self.loop.shouldLoop = should_loop
end

function AnimatedImage:getShouldLoop()
	return self.loop.shouldLoop
end

function AnimatedImage:setStep(frame_count)
	self.loop.step = frame_count
end

function AnimatedImage:getStep()
	return self.loop.step
end

function AnimatedImage:setPaused(paused)
	self.loop.paused = paused
end

function AnimatedImage:getPaused()
	return self.loop.paused
end

function AnimatedImage:setFrame(frame)
	self.loop.frame = frame
end

function AnimatedImage:getFrame()
	return self.loop.frame
end

function AnimatedImage:setFirstFrame(frame)
	self.loop.startFrame = frame
end

function AnimatedImage:setLastFrame(frame)
	self.loop.endFrame = frame
end

function AnimatedImage:isComplete()
	return not self.loop:isValid()
end

function AnimatedImage:getImage()
	return self.image_table:getImage(self.loop.frame)
end

AnimatedImage.__index = function(animated_image, key)
	local proxy_value = rawget(AnimatedImage, key)
	if proxy_value then
		return proxy_value
	end
	proxy_value = animated_image.image_table:getImage(animated_image.loop.frame)[key]
	if type(proxy_value) == "function" then
		rawset(animated_image, key, function(ai, ...)
			local img = ai.image_table:getImage(ai.loop.frame)
			return img[key](img, ...)
		end)
		return animated_image[key]
	end
	return proxy_value
end
