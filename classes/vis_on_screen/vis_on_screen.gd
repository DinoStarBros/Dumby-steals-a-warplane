extends VisibleOnScreenNotifier2D
class_name VisOnScreen


func _on_screen_entered() -> void:
	get_parent().show()

func _on_screen_exited() -> void:
	get_parent().hide()
