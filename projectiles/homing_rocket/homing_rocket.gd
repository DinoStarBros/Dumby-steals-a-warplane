extends Projectile
class_name Homing_Rocket

@onready var hitbox_component: HitboxComponent = %HitboxComponent

func _ready() -> void:
	hitbox_component.Hit.connect(hit)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(_delta:float)->void:
	move_and_slide()
	hitbox_component.set_attack_properties(6)

func hit() -> void:
	velocity = Vector2.ZERO
	queue_free()


func _on_detection_radius_body_entered(body: Node2D) -> void:
	print(body)
