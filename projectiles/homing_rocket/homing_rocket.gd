extends Projectile
class_name Homing_Rocket

@onready var hitbox_component: HitboxComponent = %HitboxComponent

var time : float = 0

var current_velocity : Vector2 = Vector2.ZERO
var max_speed : float = 1500
var initial_velocity : Vector2

func _ready() -> void:
	%explode.pitch_scale = randf_range(1, 1.3)
	
	hitbox_component.Hit.connect(hit)
	
	target_deviation.x = randf_range(-targ_dev_range, targ_dev_range)
	target_deviation.y = randf_range(-targ_dev_range, targ_dev_range)
	
	#current_velocity = max_speed * Vector2.RIGHT.rotated(rotation)
	current_velocity = initial_velocity * max_speed

var direction : Vector2
var desired_velocity : Vector2
var change : Vector2
const drag_factor : float = 10
var previous_velocity : Vector2
func _physics_process(delta:float)->void:
	move_and_slide()
	hitbox_component.set_attack_properties(dmg)
	
	#homing_handle(delta) 
	new_homing_handle(delta)
	#velocity = current_velocity
	
	time += delta
	if time >= lifetime:
		spawn_explosion()
		queue_free()

func hit() -> void:
	velocity = Vector2.ZERO
	spawn_explosion()
	set_physics_process(false)
	%anim.play("hit")

var target : CharacterBody2D
func _on_detection_radius_area_entered(enemy: Area2D) -> void:
	if target != null:
		return
	
	if enemy == null:
		return
	
	if enemy.get_parent().is_in_group("Enemy"):
		target = enemy.get_parent()


var rand_initial_dir : Vector2
var dir_to_target : Vector2
var dist_to_target : float

var target_deviation : Vector2
const targ_dev_range : float = 500

const base_speed : int = 600
const homing_speed : int = 600

var gain_speed : float = 0
func homing_handle(delta: float) -> void: ## The typa homing where it immediately points and goes to the enemy
	if target:
		dist_to_target = global_position.distance_to(target.global_position)
		rand_initial_dir = dir_to_target
		gain_speed += delta * 800.0
		
		if dist_to_target < targ_dev_range + 20:
			dir_to_target = global_position.direction_to(target.global_position)
		else:
			dir_to_target = global_position.direction_to(target.global_position + target_deviation)
		
		look_at(global_position + dir_to_target)
		velocity = dir_to_target * (homing_speed + gain_speed)
	else:
		gain_speed = 0
		look_at(global_position + rand_initial_dir)
		velocity = rand_initial_dir * base_speed

func new_homing_handle(delta: float) -> void: ## The new homing, gradually rotating
	direction = Vector2.RIGHT.rotated(rotation).normalized()
	
	if target:
		direction = global_position.direction_to(target.global_position)
		max_speed += 50 * delta
	else:
		max_speed = 1500
	
	desired_velocity = direction * max_speed
	previous_velocity = current_velocity
	change = (desired_velocity - current_velocity) * drag_factor
	
	current_velocity += change * delta
	
	look_at(global_position + (current_velocity.normalized()))
	velocity = current_velocity

const explosion_scn : PackedScene = preload("res://projectiles/explosion/explosion.tscn")
func spawn_explosion() -> void:
	var explosion : Explosion = explosion_scn.instantiate()
	g.game.add_child(explosion)
	explosion.dmg = 5
	explosion.global_position = global_position
	explosion.scale *= 0.5
