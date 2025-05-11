extends Area2D
class_name HurtboxComponent

@export var health_component : HealthComponent
@export var ouchnim : AnimationPlayer

signal PlrHit(dmg:int)

func damage(attack:Attack):
	z_index = 1
	
	
	#%hitparticles.look_at(attack.attack_pos)
	#%hitparticles.rotation_degrees+=180
	#%spark.look_at(attack.attack_pos)
	
	if health_component:
		health_component.damage(attack)
	
	if health_component.hp > 0:
		get_parent().damage(attack)
	if health_component.hp <= 0:
		get_parent().Dead(attack)
	
	if get_parent().is_in_group("Enemy"):
		g.cam.apply_shake(10)
	elif get_parent().is_in_group("Player"):
		g.cam.apply_shake(30)
		PlrHit.emit(attack.attack_damage)

	if ouchnim:
		ouchnim.play("Ouch")
 
