local manager         = require('main.scripts.manager')
local collision       = require('main.scripts.collision')

local pad             = {}

local pad_factory_url = '/factories#pad'
local pad_id          = nil
local ball_id         = nil
local speed           = 750
local left            = vmath.vector3(-1, 0, 0)
local right           = vmath.vector3(1, 0, 0)
local zero            = vmath.vector3()
local pressed         = false

function pad.attach_ball(m_ball_id)
	ball_id = m_ball_id
	msg.post(ball_id, "set_parent", { parent_id = pad_id, keep_world_transform = 1 })
end

function pad.init(m_ball_id)
	pad_id = factory.create(pad_factory_url, manager.pad_position)
	collision.add_pad(pad_id, manager.pad_size.w, manager.pad_size.h)
end

local function update_position(dt)
	manager.pad_old_position = manager.pad_position
	manager.pad_position     = manager.pad_position + manager.pad_movement * speed * dt
	go.set_position(manager.pad_position, pad_id)
end

function pad.update(dt)
	if pressed then
		if manager.pad_position.x >= -(manager.screen.w - 40) and manager.pad_movement.x == -1 then
			update_position(dt)
		elseif manager.pad_position.x <= (manager.screen.w - 40) and manager.pad_movement.x == 1 then
			update_position(dt)
		end
	end
end

function pad.input(action_id, action)
	if (action_id == manager.keys['left'] or action_id == manager.keys['right']) and action.released then
		pressed = false
		manager.pad_movement = zero
	elseif action_id == manager.keys['left'] and action.repeated then
		pressed = true
		manager.pad_movement = left
	elseif action_id == manager.keys['right'] and action.repeated then
		pressed = true
		manager.pad_movement = right
	end

	if action_id == manager.keys['trigger'] and action.released and ball_id then
		msg.post(ball_id, "set_parent", { parent_id = nil, keep_world_transform = 1 })
		msg.post('.', 'launch')
		ball_id = nil
	end
end

return pad
