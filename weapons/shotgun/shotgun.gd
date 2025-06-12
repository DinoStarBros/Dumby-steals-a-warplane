extends Weapon

func _ready() -> void:
	cooldown = stats.shoot_cooldown
	ammo = max_ammo

func _process(delta: float) -> void:
	buffed_handling(delta)
	if ammo > 0:
		if not reloading:
			shooting_handling(delta)
	else:
		if Input.is_action_just_pressed("shoot") and not reloading:
			g.spawn_txt("RELOAD!", global_position)

func shooting_handling(delta:float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		cooldown = stats.shoot_cooldown
		
		ammo -= 1
		
		if buffed:
			for n in stats.bullet_amnt + 3:
				spawn_bullet() # Adds 3 extra bullets when buffed
				await get_tree().create_timer(stats.shoot_delay).timeout
		else:
			for n in stats.bullet_amnt:
				spawn_bullet()
				await get_tree().create_timer(stats.shoot_delay).timeout
	
	if buffed:
		cooldown -= delta * 1.2 # Firerate is slightly faster when buffed
	else:
		cooldown -= delta
	
	if cooldown <= 0:
		cooldown = 0
		can_shoot = true

func spawn_bullet() -> void:
	%shootsfx.pitch_scale = randf_range(0.6, 0.8)
	%shootsfx2.pitch_scale = randf_range(1.0, 1.2)
	
	%shootsfx.play()
	%shootsfx2.play(0.2)
	
	rand_spread_vector.x = randf_range(-stats.random_spread, stats.random_spread)
	rand_spread_vector.y = randf_range(-stats.random_spread, stats.random_spread)
	
	var bullet : CharacterBody2D = stats.bullet_scn.instantiate()
	g.game.add_child(bullet)
	
	dir_to_mouse = global_position.direction_to(get_global_mouse_position())
	
	bullet.global_position = global_position + (dir_to_mouse * 50)
	bullet.velocity = (dir_to_mouse + rand_spread_vector ) * stats.bullet_spd
	bullet.look_at(get_global_mouse_position() + rand_spread_vector)

func buffed_handling(delta: float) -> void:
	if buff_time <= 0:
		buff_time = 0
		buffed = false
	elif buff_time > 0:
		buff_time -= delta
		buffed = true
