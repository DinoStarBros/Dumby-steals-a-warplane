extends Node2D
class_name VelocityComponent

@onready var p : CharacterBody2D = get_parent()

@export var accelerate_speed : int = 1000 ## How fast the plane can go
@export var trail_particles : CPUParticles2D

var desired_velocity : Vector2
var current_velocity : Vector2
var change_velocity : Vector2
const drag_factor : float = 4

func _ready() -> void:
	pass

func other_velocity_handle(delta: float, direction: Vector2, accelerating: bool) -> void: ## Improved movement for the ship
	## More control, can fly in straight lines 
	desired_velocity = direction * accelerate_speed
	
	change_velocity = (desired_velocity - current_velocity) * drag_factor
	
	p.velocity = current_velocity
	
	if accelerating:
		current_velocity += change_velocity * delta
	else:
		current_velocity.y += (980 * delta) / 4
		p.velocity.y = clamp(p.velocity.y, -accelerate_speed, accelerate_speed)
	
	if trail_particles:
		trail_particles.emitting = accelerating

func _get_velocity_angle_deg() -> float:
	return rad_to_deg(p.velocity.angle())
