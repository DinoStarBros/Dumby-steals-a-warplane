extends Ability

@export var rocket_amount : int = 10

func activate_ability() -> void:
	cooldown_time = cooldown
	
	for n in rocket_amount:
		spawn_rocket(n)
		
		await get_tree().create_timer(0.025).timeout

const rocket_scn : PackedScene = preload("res://projectiles/homing_rocket/homing_rocket.tscn")
var calculation : float = 0
var sin_thingy : float = 0
var cos_thingy : float = 0
func spawn_rocket(ndex: float) -> void:
	var rocket : Homing_Rocket = rocket_scn.instantiate()
	
	rocket.lifetime = 10
	g.game.add_child(rocket)
	
	rocket.lifetime = 10
	rocket.global_position = g.player.global_position
	
	calculation = (ndex * 2 / rocket_amount) - 1
	
	sin_thingy = sin(ndex * 180)
	cos_thingy = cos(ndex * 180)
	
	rocket.rand_initial_dir.x = cos_thingy / 2
	rocket.rand_initial_dir.y = sin_thingy / 2
