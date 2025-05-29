extends Ability

@export var rocket_amount : int = 10
const delay : float = 0.075
var dir_to_mouse: Vector2
var p : Dumby

var trig_vector : Vector2
var trig_deg : float

var amount : int = 0
func activate_ability() -> void:
	usable = false
	
	p = g.player
	cooldown_time = cooldown
	
	for n in rocket_amount:
		dir_to_mouse = p.global_position.direction_to(p.get_global_mouse_position())
		spawn_rocket()
		
		trig_deg = (360/rocket_amount) * n
		trig_vector.x = cos(deg_to_rad(trig_deg))
		trig_vector.y = sin(deg_to_rad(trig_deg))
		
		await get_tree().create_timer(delay).timeout

const rocket_scn : PackedScene = preload("res://projectiles/homing_rocket/homing_rocket.tscn")
func spawn_rocket() -> void:
	var rocket : Homing_Rocket = rocket_scn.instantiate()
	
	setting_rocket_parameters(rocket)
	g.game.add_child(rocket)
	setting_rocket_parameters(rocket)
	
	%shoot1.pitch_scale = randf_range(0.9, 1.1)
	%shoot1.play()
	
	%shoot2.pitch_scale = randf_range(0.7, 1.1)
	%shoot2.play(0.2)

func setting_rocket_parameters(rocket: Homing_Rocket) -> void:
	rocket.lifetime = 10
	rocket.dmg = 10
	rocket.initial_velocity = trig_vector
	rocket.global_position = g.player.global_position
