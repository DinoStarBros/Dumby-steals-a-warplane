extends CharacterBody2D

var accelerate_spd : int = 30
var accelerate_limit : int = 600
var accelerating : = true
var dir_to_targ : Vector2
var target : CharacterBody2D

func _ready() ->  void:
	_on_target_deviat_timer_timeout()
	accelerate_spd += randi_range(-5, 5)
	%ShootTimer.start(randf_range(4,5))

var target_deviation : Vector2
func _physics_process(delta: float) -> void:
	move_and_slide()
	target = g.player
	dir_to_targ = (target.global_position - global_position).normalized()
	
	#accelerating = Input.is_action_pressed("accelerate")
	%flamez.visible = accelerating
	%flameparticles.emitting = accelerating
	%flameparticles.direction = -velocity
	
	
	%Plane.look_at(target.global_position)
	%outline.look_at(target.global_position)
	velocity.y += (980 * delta) / 2
	if accelerating:
		velocity += accelerate_spd * dir_to_targ
	
	lim_accel_x()
	lim_accel_y()

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

const tdev_range : = 500
func _on_target_deviat_timer_timeout() -> void:
	target_deviation.x = randf_range(-tdev_range,tdev_range)
	target_deviation.y = randf_range(-tdev_range,tdev_range)

func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.score += 10
	g.killscore += 1
	g.spawn_txt("10", global_position)
	#g.spawn_xp(global_position, 1)
	set_physics_process(false)
	%death.play("die")

var bullet_spd : = 1000

const bullet_scn : = preload("res://projectiles/ene_bullet/ene_bullet.tscn")
var rand_spread_vector : Vector2
const random_spread : float = 0.2
const bullet_amnt : int = 4
func spawn_bullet()->void:
	
	%shoot.pitch_scale = randf_range(.9,1.1)
	%shoot.play()
	%shoot2.pitch_scale = randf_range(.9,1.1)
	%shoot2.play(.2)
	
	var bullet : Projectile = bullet_scn.instantiate()

	g.game.add_child(bullet)
	
	rand_spread_vector.x = randf_range(-random_spread, random_spread)
	rand_spread_vector.y = randf_range(-random_spread, random_spread)
	
	bullet.pos_to_look = target.global_position
	
	bullet.global_position = global_position + (dir_to_targ * 50)
	bullet.velocity = (dir_to_targ + rand_spread_vector) * bullet_spd
	
	bullet.pos_to_look = target.global_position

func _on_shoot_timer_timeout() -> void:
	for n in bullet_amnt:
		spawn_bullet()
	
	%ShootTimer.start(randf_range(4,5))
