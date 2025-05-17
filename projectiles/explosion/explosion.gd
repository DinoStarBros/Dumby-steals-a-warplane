extends Projectile

func _ready() -> void:
	%HitboxComponent.set_attack_properties(dmg)
