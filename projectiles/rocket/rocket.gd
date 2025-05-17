extends Projectile

var pos_to_look : Vector2

func _ready() -> void:
	look_at(pos_to_look)

func _physics_process(_delta:float)->void:
	move_and_slide()
	%HitboxComponent.set_attack_properties(6)

func _on_duration_timeout() -> void:
	queue_free()

var explosion_scn : PackedScene = preload("res://projectiles/explosion/explosion.tscn")
func spawn_explosion()->void:
	var explosion : Projectile = explosion_scn.instantiate()
	g.game.add_child(explosion)
	explosion.global_position = global_position


func _on_hitbox_component_hit() -> void:
	spawn_explosion()
