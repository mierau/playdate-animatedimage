import "CoreLibs/animation"

local graphics <const> = playdate.graphics
local animation <const> = playdate.graphics.animation

AnimatedImage = {}

-- image_table_path should be a path to an image table.
-- options is a table of initial settings:
--   delay: 
--   paused: start in a paused state.
--   loop: loop the animation.
--   

function AnimatedImage.new(image_table_path, options)
	options = options or {}
	
	local image_table = graphics.imagetable.new(image_table_path)
	if image_table == nil then
		print("ANIMATEDIMAGE: FAILED TO LOAD IMAGE TABLE AT", image_table_path)
		return nil
	end
	
	local animation_loop = animation.loop.new(options.delay or 100, image_table, options.loop and true or false)
	animation_loop.paused = options.paused and true or false
	animation_loop.startFrame = options.first or 1
	animation_loop.endFrame = options.last or image_table:getLength()
	
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
