extends Ability

@export var rocket_amount : int = 10
const delay : float = 0.1
var dir_to_mouse: Vector2
var p : Dumby
func activate_ability() -> void:
	p = g.player
	cooldown_time = cooldown
	
	for n in rocket_amount:
		dir_to_mouse = p.global_position.direction_to(p.get_global_mouse_position())
		spawn_rocket(n)
		
		await get_tree().create_timer(delay).timeout

const rocket_scn : PackedScene = preload("res://projectiles/homing_rocket/homing_rocket.tscn")
var calculation : float = 0
var sin_thingy : float = 0
var cos_thingy : float = 0
func spawn_rocket(ndex: float) -> void:
	var rocket : Homing_Rocket = rocket_scn.instantiate()
	
	setting_rocket_parameters(rocket)
	g.game.add_child(rocket)
	setting_rocket_parameters(rocket)
	
	calculation = (ndex * 2 / rocket_amount) - 1
	
	sin_thingy = sin(ndex * 180)
	cos_thingy = cos(ndex * 180)
	
	%shoot1.pitch_scale = randf_range(0.9, 1.1)
	%shoot1.play()
	
	%shoot2.pitch_scale = randf_range(0.7, 1.1)
	%shoot2.play(0.2)
	

func setting_rocket_parameters(rocket: Homing_Rocket) -> void:
	rocket.lifetime = 10
	rocket.dmg = 4
	rocket.initial_velocity = dir_to_mouse
	rocket.global_position = g.player.global_position
