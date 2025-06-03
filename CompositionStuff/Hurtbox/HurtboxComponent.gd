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
		# Calls the function to reduce the health from an attack accordingly
	
	if health_component.hp > 0:
		get_parent().damage(attack)
		if get_parent().is_in_group("Player"):
			PlrHit.emit(attack.attack_damage)
			%hitsparkanim.play("spark")
		
	elif health_component.hp <= 0:
		get_parent().Dead(attack)
		if explosion_particles:
			for n in explosion_particle_amount + randi_range(1,2):
				spawn_explosion_particles(attack)
	
	hit(get_parent().is_in_group("Player"), health_component.hp <= 0)
	
	if ouchnim:
		ouchnim.play("Ouch")
 
const explosion_particles_scn : PackedScene = preload("res://juices/explosionSpawner/explosion_spawner.tscn")
func spawn_explosion_particles(attack: Attack) -> void:
	var explosion : ExplosionSpawner = explosion_particles_scn.instantiate()
	explosion.global_position = global_position
	explosion.direction = global_position.direction_to(attack.attack_pos)
	explosion.lifetime = randf_range(0.5,0.7)
	g.game.add_child(explosion)

func hit(player : bool, dead : bool) -> void:
	if player:
		if dead:
			# Dead Player
			g.cam.screen_shake(40, 1)
			g.frame_freeze(0.4, 0.6)
		else:
			# Hit Player
			g.cam.screen_shake(20, 0.4)
			g.frame_freeze(0.4, 0.3)
	else:
		if dead:
			# Dead Enemy
			g.cam.screen_shake(9, 0.1)
			g.frame_freeze(0.6, 0.1)
		else:
			# Hit Enemy
			g.cam.screen_shake(6, 0.1)
			g.frame_freeze(0.7, 0.05)
