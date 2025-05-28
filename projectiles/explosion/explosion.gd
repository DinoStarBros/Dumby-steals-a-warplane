extends Projectile
class_name Explosion

func _ready() -> void:
	rotation_degrees = randf_range(-180,180)
	%HitboxComponent.set_attack_properties(dmg)
