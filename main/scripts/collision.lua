local manager            = require('main.scripts.manager')

local collision          = {}

local collision_group_id = -1
local ball_id            = -1
local result             = {}
local count              = 0
collision.pad_id         = -1

function collision.init()
	collision_group_id = aabb.new_group()
end

local function add_gameobject(go_url, width, height)
	local go_msg_url = msg.url(go_url)
	return aabb.insert_gameobject(collision_group_id, go_msg_url, width, height)
end

function collision.add_ball(go_url, width, height)
	ball_id = add_gameobject(go_url, width, height)
end

function collision.add_pad(go_url, width, height)
	collision.pad_id = add_gameobject(go_url, width, height)
end

function collision.add_brick(x, y, width, height, target_brick, anim)
	local brick_id = aabb.insert(collision_group_id, x, y, width, height)
	manager.bricks[brick_id] = {
		id = target_brick,
		postion = vmath.vector3(x, y, 0),
		w = width,
		h = height,
		w2 = width / 2,
		h2 = height / 2,
		anim = anim
	}
end

function collision.remove_brick(brick_id)
	aabb.remove(collision_group_id, brick_id)
	sprite.play_flipbook(manager.bricks[brick_id].id, manager.bricks[brick_id].anim, nil, { playback_rate = 3 })
	go.animate(manager.bricks[brick_id].id, 'scale', go.PLAYBACK_ONCE_FORWARD, 0, go.EASING_INOUTBOUNCE, 0.2, 0.1, function()
		go.delete(manager.bricks[brick_id].id)
	end)
end

function collision.check()
	result, count = aabb.query_id(collision_group_id, ball_id)
	return result, count
end

return collision
