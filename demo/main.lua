import "CoreLibs/graphics"
import "animatedimage"

local graphics <const> = playdate.graphics
local geometry <const> = playdate.geometry

local shyguy_image = AnimatedImage.new("shyguy", {delay = 50, loop = true})
local mario_image = AnimatedImage.new("mario", {delay = 100, loop = true, first = 1, last = 4})
local mario_position = 200
local mario_flip = geometry.kUnflipped
local shyguy_position = geometry.point.new(playdate.display.getWidth(), math.random(10, 80))
local shyguy_speed = math.random(1, 5)
local shyguy_scale = math.random(1, 4)

-- SETUP
playdate.display.setRefreshRate(50)

-- MAIN LOOP
function playdate.update()
	local delta = 0
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		delta -= 5
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		delta += 5
	end
	
	mario_position += delta
	if delta == 0 then
		mario_image:reset()
	elseif delta < 0 then
		mario_flip = geometry.kFlippedX
	elseif delta > 0 then
		mario_flip = geometry.kUnflipped
	end
	
	if shyguy_position.x < -100 then
		shyguy_position.x = playdate.display.getWidth()
		shyguy_position.y = math.random(10, 80)
		shyguy_scale = math.random(1, 4)
	end
	shyguy_position.x -= shyguy_speed
	
	graphics.clear(graphics.kColorWhite)
	shyguy_image:drawScaled(shyguy_position.x, shyguy_position.y, shyguy_scale)
	mario_image:drawCentered(mario_position, 198, mario_flip)
end
