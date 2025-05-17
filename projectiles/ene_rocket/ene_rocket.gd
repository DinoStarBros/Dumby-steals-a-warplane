extends Projectile

var pos_to_look : Vector2

func _physics_process(_delta:float)->void:
	move_and_slide()
	%HitboxComponent.set_attack_properties(1)

func _on_dur_timeout() -> void:
	spawn_explosion()
	queue_free()

var explosion_scn : = preload("res://projectiles/ene_explosion/ene_explosion.tscn")
func spawn_explosion()->void:
	var explosion : Projectile = explosion_scn.instantiate()
	explosion.global_position = global_position
	g.game.add_child(explosion)
