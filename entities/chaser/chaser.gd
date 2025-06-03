extends CharacterBody2D

var accelerating : = true
var dir_to_targ : Vector2
var target : CharacterBody2D
var dist_to_targ : float

@onready var velocity_component: VelocityComponent = %VelocityComponent

func _ready() -> void:
	_on_target_deviat_timer_timeout()
	%HitboxComponent.set_attack_properties(1)
	
	velocity_component.accelerate_speed += randf_range(-10, 10)

var target_deviation : Vector2
var direction : Vector2
func _physics_process(delta : float) -> void:
	move_and_slide()
	target = g.player
	
	dist_to_targ = global_position.distance_to(target.global_position)
	if dist_to_targ <= tdev_range + (tdev_range/5):
		dir_to_targ = ((target.global_position + target_deviation) - global_position).normalized()
	else:
		dir_to_targ = (target.global_position - global_position).normalized()
	
	%flamez.visible = accelerating
	%flameparticles.emitting = accelerating
	%flameparticles.direction = -velocity
	
	direction = global_position + velocity
	%Plane.look_at(direction)
	%outline.look_at(direction)

	velocity_component.other_velocity_handle(delta, dir_to_targ, accelerating)

const tdev_range : = 400
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
