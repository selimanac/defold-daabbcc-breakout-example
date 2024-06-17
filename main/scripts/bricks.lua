local manager           = require('main.scripts.manager')
local collision         = require('main.scripts.collision')

local bricks            = {}

local brick_factory_url = '/factories#brick'
local brick_width       = 32
local brick_height      = 16
local rows              = { 12, 16, 20, 24, 20, 0, 0, 0, 12, 20, 26, 16, 14, 12 }

function bricks.init()
	local brick_id = hash('')
	local brick_position = vmath.vector3()
	local brick_row_width = 0
	local brick_row_start_x = 0
	local brick_anim = hash('')

	for i = 1, #rows do
		brick_row_width = rows[i] * brick_width
		brick_row_start_x = -brick_row_width / 2
		brick_position.y = i * brick_height

		brick_anim = manager.brick_anims[rnd.range(1, #manager.brick_anims)]
		for z = 1, rows[i] do
			brick_position.x = brick_row_start_x + brick_width * z
			brick_id = factory.create(brick_factory_url, brick_position)
			sprite.play_flipbook(brick_id, brick_anim)
			collision.add_brick(brick_position.x, brick_position.y, 20, brick_height, brick_id, brick_anim)
		end
	end
end

return bricks
