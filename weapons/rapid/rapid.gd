extends Weapon

func _ready() -> void:
	cooldown = stats.shoot_cooldown

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		cooldown = stats.shoot_cooldown
		%shootsfx.pitch_scale = randf_range(0.5, 0.7)
		%shootsfx2.pitch_scale = randf_range(1.1, 1.3)
		
		%shootsfx.play()
		%shootsfx2.play(0.2)
		
		for n in stats.bullet_amnt:
			spawn_bullet()
	
	cooldown -= delta
	if cooldown <= 0:
		cooldown = 0
		can_shoot = true

func spawn_bullet() -> void:
	rand_spread_vector.x = randf_range(-stats.random_spread, stats.random_spread)
	rand_spread_vector.y = randf_range(-stats.random_spread, stats.random_spread)
	
	var bullet : CharacterBody2D = stats.bullet_scn.instantiate()
	g.game.add_child(bullet)
	
	dir_to_mouse = global_position.direction_to(get_global_mouse_position())
	
	bullet.global_position = global_position + (dir_to_mouse * 50)
	bullet.velocity = (dir_to_mouse + rand_spread_vector ) * stats.bullet_spd
	bullet.look_at(get_global_mouse_position() + rand_spread_vector)
