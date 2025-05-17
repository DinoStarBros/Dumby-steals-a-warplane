extends Area2D
class_name XpOrb

var xp_amount : int = 1

var collected : bool = false
var velocity : Vector2
var dir_to_plr : Vector2 ## Normalized vetor for direction towards player
const SPD : int = 500
var gain_spd : float = 0

var sin_time : float = 0
func _process(delta: float) -> void:
	move(delta)
	if collected:
		dir_to_plr = global_position.direction_to(g.player.global_position)
		velocity = dir_to_plr * (SPD + gain_spd)
		gain_spd += delta * 500
		if gain_spd >= 2000:
			gain_spd = 2000
	else:
		sin_time += delta 
		if sin_time >= 360:
			sin_time = 0
		velocity.y = sin(sin_time) * 200

func move(delta: float) -> void:
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Dumby:
		%CollisionShape2D.disabled = true
		body.finish_collect()
		g.xp += xp_amount
		queue_free()
