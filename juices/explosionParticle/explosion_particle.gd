extends Sprite2D
class_name ExplosionParticle

func _ready() -> void:
	
	rotation_degrees = randf_range(-180, 180)
	%anim.speed_scale = randf_range(1.8, 2.2)
