extends Projectile

@onready var hitbox_component: HitboxComponent = %HitboxComponent

func _ready() -> void:
	hitbox_component.Hit.connect(hit)

var time : float = 0
func _physics_process(delta:float)->void:
	move_and_slide()
	hitbox_component.set_attack_properties(dmg)
	
	time += delta
	if time >= lifetime:
		queue_free()

func hit() -> void:
	rotation_degrees += 180
	velocity = Vector2.ZERO
	#g.cam.screen_shake(7, 0.1)
	%anim.play("hit")
