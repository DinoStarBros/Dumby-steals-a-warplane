extends CharacterBody2D

var accelerating : = true
var dir_to_targ : Vector2
var target : CharacterBody2D
var dist_to_targ : float

@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var rotation_component: RotationComponent = %RotationComponent

func _ready() -> void:
	_on_target_deviat_timer_timeout()
	%HitboxComponent.set_attack_properties(1)
	
	velocity_component.accelerate_speed += randf_range(-10, 10)
	
	#await get_tree().create_timer(0.1).timeout
	#spawn_arrow()

var target_deviation : Vector2
var direction : Vector2
var target_position : Vector2
func _physics_process(delta : float) -> void:
	move_and_slide()
	target = g.player
	
	dist_to_targ = global_position.distance_to(target.global_position)
	if dist_to_targ >= tdev_range + (tdev_range/5):
		target_position = target.global_position + target_deviation
		dir_to_targ = ((target_position) - global_position).normalized()
	else:
		target_position = target.global_position
		dir_to_targ = (target_position - global_position).normalized()
	
	%flamez.visible = accelerating
	%flameparticles.emitting = accelerating
	%flameparticles.direction = -velocity
	
	rotation_component.plane_rotation_handling(delta, target_position)
	direction = rotation_component.direction
	velocity_component.other_velocity_handle(delta, direction, accelerating)

const tdev_range : = 1000
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

const enemy_arrow_scn : PackedScene = preload("res://scenes/enemyArrow/enemy_arrow.tscn")
var enemy_arrow : EnemyArrow
func spawn_arrow() -> void:
	enemy_arrow = enemy_arrow_scn.instantiate()
	g.enemy_arrows.add_child(enemy_arrow)
