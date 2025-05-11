extends CharacterBody2D

var accelerate_spd : int = 40
var accelerate_limit : int = 750
var accelerating : = true
var dir_to_targ : Vector2
var target : CharacterBody2D
var dist_to_targ : float

func _ready():
	_on_target_deviat_timer_timeout()
	%HitboxComponent.set_attack_properties(1)
	
	accelerate_spd += randi_range(-5, 5)

var target_deviation : Vector2
func _physics_process(delta):
	move_and_slide()
	target = g.player
	
	dist_to_targ = global_position.distance_to(target.global_position)
	if dist_to_targ <= tdev_range:
		dir_to_targ = ((target.global_position + target_deviation) - global_position).normalized()
	else:
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

const tdev_range : = 300
func _on_target_deviat_timer_timeout():
	target_deviation.x = randf_range(-tdev_range,tdev_range)
	target_deviation.y = randf_range(-tdev_range,tdev_range)

func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.score += 10
	g.killscore += 1
	g.spawn_txt("10", global_position)
	set_physics_process(false)
	%death.play("die")
