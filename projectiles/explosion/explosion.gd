extends Projectile

var dmg : int = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	%HitboxComponent.set_attack_properties(dmg)
