extends CharacterBody2D

var half_viewport : Vector2
var dir_to_mouse : Vector2
var dist_to_mouse : float
var accelerate_spd : int = 60
var accelerate_limit : int = 700
var direc_mouse 

func _ready():
	#gun_sequence.shuffle()
	g.player = self
	bullet_idx = 0#randi_range(0, guns_amnt) 

func _physics_process(delta):
	healing_time -= delta
	if healing_time <= 0:
		heal()
		healing_time = heal_max_time
	move_and_slide()
	
	half_viewport = get_viewport_rect().size / 2.0
	
	dir_to_mouse = (get_global_mouse_position() - global_position).normalized()
	dist_to_mouse = global_position.distance_to(get_global_mouse_position())
	
	
	#%Plane.flip_v = dir_to_mouse.x <= 0

	%flamez.visible = accelerating
	%flameparticles.emitting = accelerating
	%flameparticles.direction = -velocity
	%trailparticle.emitting = accelerating
	
	velocity.y += (980 * delta) / 2
	if accelerating and dist_to_mouse >= 50:
		velocity += accelerate_spd * dir_to_mouse
		if not %jet.playing:
			%jet.play()
		
	else:
		%jet.stop()
	
	lim_accel_x()
	lim_accel_y()
	if g.mobile:
		pass
	else:
		#shooting_handle()
		if Input.is_action_just_pressed("accelerate"):
			pass
		accelerating = Input.is_action_pressed("accelerate")
		
	plane_rotation_handling()


var aim_position : Vector2
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_position = (event.position - half_viewport)

var accelerating : = false

func lim_accel_x()->void:
	if velocity.x <= -accelerate_limit:
		velocity.x = -accelerate_limit
	if velocity.x >= accelerate_limit:
		velocity.x = accelerate_limit

func lim_accel_y()->void:
	if velocity.y <= -accelerate_limit:
		velocity.y = -accelerate_limit
	if velocity.y >= accelerate_limit:
		velocity.y = accelerate_limit

var shoot_cooldown : = .2
var bullet_scenes : = [
	preload("res://projectiles/plr_bullet/bullet.tscn"),
	preload("res://projectiles/rocket/rocket.tscn"),
	preload("res://projectiles/plr_bullet/bullet.tscn"),
	preload("res://projectiles/laser/laser.tscn"),
	preload("res://projectiles/rocket/rocket.tscn"),
]
var bullet_scn 
var can_shoot : = true
var bullet_spd : = 1500
var bullet_idx : = 1
var bullet_amnt : = 1
var gun_type : = 0
func shooting_handle()->void:
	gun_type = gun_sequence[bullet_idx]
	match gun_type:
		0:
			bullet_spd = 2000
			shoot_cooldown = 0.05
			bullet_amnt = 1
		1:
			bullet_spd = 1700
			shoot_cooldown = 0.2
			bullet_amnt = 1
		2:
			bullet_spd = 1500
			shoot_cooldown = 0.25
			bullet_amnt = 6
		3:
			bullet_spd = 0
			shoot_cooldown = .3
			bullet_amnt = 1
		4:
			bullet_spd = 1000
			shoot_cooldown = .4
			bullet_amnt = 3

	bullet_scn = bullet_scenes[gun_sequence[bullet_idx]]
	if Input.is_action_pressed("shoot") and can_shoot:
		healing_time = heal_max_time
		if bullet_amnt > 1:
			for n in bullet_amnt:
				var bullet = bullet_scn.instantiate()
				
				bullet.global_position = %shoot_pos.global_position
				bullet.pos_to_look = get_global_mouse_position()
				g.game.add_child(bullet)
				bullet.velocity = (dir_to_mouse + Vector2(randf_range(-.2,.2),randf_range(-.2,.2))) * bullet_spd
				#bullet.velocity = dir_to_mouse * bullet_spd
				
				%shoot.pitch_scale = randf_range(.9,1.1)
				%shoot.play()
				%shoot2.pitch_scale = randf_range(.9,1.1)
				%shoot2.play(.2)
				
				#%flarenim.play("flare")
				%shootTimer.start(shoot_cooldown)
				can_shoot = false
		else:
			var bullet = bullet_scn.instantiate()
			
			bullet.global_position = %shoot_pos.global_position
			bullet.pos_to_look = get_global_mouse_position()
			g.game.add_child(bullet)
			#bullet.velocity = (dir_to_mouse + Vector2(randf_range(-.1,.1),randf_range(-.1,.1))) * bullet_spd
			bullet.velocity = dir_to_mouse * bullet_spd
			
			if gun_type == 3:
				%shoot3.pitch_scale = randf_range(.9,1.1)
				%shoot3.play()
			else:
				%shoot.pitch_scale = randf_range(.9,1.1)
				%shoot.play()
				%shoot2.pitch_scale = randf_range(.9,1.1)
				%shoot2.play(.2)
			
			#%flarenim.play("flare")
			%shootTimer.start(shoot_cooldown)
			can_shoot = false


func _on_shoot_timer_timeout():
	can_shoot = true

func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.game_state = "lost"
	set_physics_process(false)
	%explod.play(.4)
	%death.play("die")

func plane_rotation_handling()->void:
	%Plane.look_at(get_global_mouse_position())
	#if %Plane.rotation_degrees >= 360:
	#	%Plane.rotation_degrees = 0
	#if %Plane.rotation_degrees <= 0:
	#	%Plane.rotation_degrees = 360

var txt_scn : = preload("res://scenes/DmgNum/dmg_num.tscn")
func spawn_txt(text:String)->void:
	var txt = txt_scn.instantiate()
	txt.text = text
	txt.global_position = global_position
	g.game.add_child(txt)


var gun_sequence : = [0,1,2,3,4]
func _on_gui_new_gun():
	var guns_amnt : = bullet_scenes.size() - 1
	bullet_idx += 1
	if bullet_idx >= guns_amnt + 1:
		bullet_idx = 0
		gun_sequence.shuffle()
	spawn_txt("New Gun! ")
	
	if randi_range(1,6) == 6:
		heal()

func heal()->void:
	if %HealthComponent.hp < %HealthComponent.max_hp:
		%HealthComponent.hp += 1
		spawn_txt("+1 HP!")

const heal_max_time : = 10
var healing_time : float = heal_max_time
