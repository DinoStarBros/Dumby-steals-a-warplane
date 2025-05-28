extends Area2D
class_name Evade

signal Perfect_Roll

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		Perfect_Roll.emit()
