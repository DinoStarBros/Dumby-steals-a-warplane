extends Projectile
class_name Homing_Rocket

@onready var hitbox_component: HitboxComponent = %HitboxComponent

var rand_initial_dir : Vector2
var dir_to_target : Vector2

const base_speed : int = 500
const homing_speed : int = 100
func _ready() -> void:
	hitbox_component.Hit.connect(hit)
	
	rand_initial_dir.x = randf_range(-1, 1)
	rand_initial_dir.y = randf_range(-1, 0)
	
	

var time : float = 0
var gain_speed : float = 0
func _physics_process(delta:float)->void:
	move_and_slide()
	hitbox_component.set_attack_properties(2)
	
	if target:
		%hitboxbox.disabled = false
		dir_to_target = global_position.direction_to(target.global_position)
		gain_speed += delta * 50
		velocity = dir_to_target * (homing_speed + gain_speed)
		
		look_at(global_position + dir_to_target)
	else:
		%hitboxbox.disabled = true
		look_at(global_position + rand_initial_dir)
		velocity = rand_initial_dir * base_speed
	
	time += delta
	if time >= lifetime:
		queue_free()
	
func hit() -> void:
	velocity = Vector2.ZERO
	%anim.play("hit")

var target : CharacterBody2D
func _on_detection_radius_area_entered(area: Area2D) -> void:
	if !target:
		if area.get_parent() is CharacterBody2D:
			if area.get_parent().is_in_group("Enemy"):
				%dr.disabled = true
				target = area.get_parent()
