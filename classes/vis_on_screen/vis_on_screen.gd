extends VisibleOnScreenNotifier2D
class_name VisOnScreen

@export var show_on_start : bool = false ## Decides if the parent node is shown on start or nah, keep it false if it's something that starts offscreen e.g. Projectiles, Enemies)

func _ready() -> void:
	get_parent().visible = show_on_start
	
	screen_entered.connect(_p_show)
	screen_exited.connect(_p_hide)

func _p_show() -> void:
	get_parent().show()

func _p_hide() -> void:
	get_parent().hide()
 
