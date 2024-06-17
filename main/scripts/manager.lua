local manager            = {}

manager.screen           = { w = sys.get_config_int("display.width") / 2, h = sys.get_config_int("display.height") / 2 }
manager.pad_position     = vmath.vector3(0, -220, 0)
manager.pad_old_position = vmath.vector3(0, -220, 0)
manager.pad_size         = { w = 82, h = 16, w2 = 82 / 2, h2 = 16 / 2 }
manager.pad_movement     = vmath.vector3()
manager.keys             = {
	left = hash("left"),
	right = hash("right"),
	trigger = hash("trigger")
}

manager.brick_anims      = { hash('brick'), hash('brick-red'), hash('brick-blue'), hash('brick-green'), hash('brick-light-blue') }
manager.bricks           = {}

function manager.animate_bricks_loop()
	local delay = rnd.range(1, 3)
	timer.delay(delay, false,
		function()
			local brick = manager.bricks[rnd.range(1, #manager.bricks)].id
			sprite.play_flipbook(brick, 'brick')
			manager.animate_bricks_loop()
		end)
end

return manager
