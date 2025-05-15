extends Projectile

var pos_to_look : Vector2

func _ready():
	look_at(pos_to_look)

func _physics_process(_delta:float)->void:
	move_and_slide()
	%HitboxComponent.set_attack_properties(1)

func _on_dur_timeout():
	queue_free()
