extends Ability

@export var rocket_amount : int = 5

func activate_ability() -> void:
	cooldown_time = cooldown
	%anim.play("shoot_rockets")

const rocket_scn : PackedScene = preload("res://projectiles/homing_rocket/homing_rocket.tscn")
func spawn_rocket() -> void:
	var rocket : Homing_Rocket = rocket_scn.instantiate()
	
	rocket.lifetime = 10
	g.game.add_child(rocket)
	
	rocket.lifetime = 10
	rocket.global_position = g.player.global_position
