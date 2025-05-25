extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var ouchnim : AnimationPlayer

@export var explosion_particles : bool = false ## Decides if it'll spawn extra explosion particles on death
@export var explosion_particle_amount : int = 1 ## The amount of particles it'll spawn

signal PlrHit(dmg:int)

func damage(attack:Attack) -> void:
	z_index = 1
	
	%hitparticles.look_at(global_position - attack.attack_pos)
	%fx.rotation_degrees = randi_range(-180, 180)
	%fx.scale.x = randf_range(6,8)
	%fx.scale.y = randf_range(6,8)
	
	if health_component:
		health_component.damage(attack)
	
	if health_component.hp > 0:
		get_parent().damage(attack)
	if health_component.hp <= 0:
		get_parent().Dead(attack)
		if explosion_particles:
			for n in explosion_particle_amount + randi_range(0,2):
				spawn_explosion_particles(attack)
	elif get_parent().is_in_group("Player"):
		PlrHit.emit(attack.attack_damage)
		%hitsparkanim.play("spark")
	
	if ouchnim:
		ouchnim.play("Ouch")
 
const explosion_particles_scn : PackedScene = preload("res://juices/explosionSpawner/explosion_spawner.tscn")
func spawn_explosion_particles(attack: Attack) -> void:
	var explosion : ExplosionSpawner = explosion_particles_scn.instantiate()
	explosion.global_position = global_position
	explosion.direction = global_position.direction_to(attack.attack_pos)
	explosion.lifetime = randf_range(0.5,0.7)
	g.game.add_child(explosion)
