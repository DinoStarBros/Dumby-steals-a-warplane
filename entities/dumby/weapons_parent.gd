extends Node2D
class_name WeaponsParent

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("shoot"):
		%flashnim.play("flash")
