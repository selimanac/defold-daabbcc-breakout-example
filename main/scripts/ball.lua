local manager          = require('main.scripts.manager')
local collision        = require('main.scripts.collision')

local ball             = {}

local ball_factory_url = '/factories#ball'
local ball_position    = vmath.vector3(0, -200, 0)
local ball_size        = { w = 16, h = 16, w2 = 16 / 2, h2 = 16 / 2 }
local ball_id          = hash('')
local velocity         = vmath.vector3()
local speed            = 550
local triggered        = false
local isPad            = false
local result           = {}

local ball_center      = vmath.vector3()
local target_center    = vmath.vector3()
local dx               = 0
local dy               = 0
local hit_point        = 0
local hit_normalized   = 0
local max_bounce_angle = math.pi / 3
local bounce_angle     = 0
local bounce_speed     = 0

function ball.init()
	ball_id = factory.create(ball_factory_url, ball_position)
	return ball_id
end

local function set_bounce(dir)
	bounce_angle = hit_normalized * max_bounce_angle - max_bounce_angle / 2
	bounce_speed = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2)
	velocity.x = bounce_speed * math.sin(bounce_angle)
	velocity.y = dir * bounce_speed * math.cos(bounce_angle)
end

local function handle_collision(target_position, target_size)
	ball_center.x = ball_position.x + ball_size.w2
	ball_center.y = ball_position.y + ball_size.h2

	target_center.x = target_position.x + target_size.w2
	target_center.y = target_position.y + target_size.h2

	dx = ball_center.x - target_center.x
	dy = ball_center.y - target_center.y

	hit_point = ball_center.x - target_position.x
	hit_normalized = hit_point / target_size.w


	if dy > 0 then
		velocity.y = math.abs(velocity.y)
		set_bounce(1)
	else
		velocity.y = -math.abs(velocity.y)
		set_bounce(-1)
	end
end

function ball.update(dt)
	if triggered then
		isPad = false
		if ball_position.y >= manager.screen.h then
			velocity.y = -math.abs(velocity.y)
		elseif ball_position.y <= -manager.screen.h then
			velocity.y = math.abs(velocity.y)
		elseif ball_position.x <= -manager.screen.w then
			velocity.x = math.abs(velocity.x)
		elseif ball_position.x >= manager.screen.w then
			velocity.x = -math.abs(velocity.x)
		end

		result = collision.check()

		if result then
			if result[1] == collision.pad_id and isPad == false then
				handle_collision(manager.pad_position, manager.pad_size)
				isPad = true
			elseif result[1] ~= collision.pad_id then
				local brick = manager.bricks[result[1]]
				handle_collision(brick.postion, brick)
				collision.remove_brick(result[1])
			end
		end

		ball_position = ball_position + velocity * dt
		go.set_position(ball_position, ball_id)
	end
end

function ball.launch()
	ball_position = go.get_position(ball_id)
	collision.add_ball(ball_id, ball_size.w, ball_size.h)

	local dir = rnd.toss() == 1 and -10 or 10
	velocity.x = (rnd.range(1, 5) / dir) * speed
	velocity.y = speed
	triggered = true
end

return ball
