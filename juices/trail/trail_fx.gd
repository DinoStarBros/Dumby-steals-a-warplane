extends Line2D
class_name TrailFX

var pos : Vector2
var queue : Array
@export var MAX_LENGTH : int = 20 ## Length of the trail line
var enable : bool = true ## Decides if it will start plotting points or nah

func _process(_delta: float) -> void:
	pos = _get_position()
	
	queue.push_front(pos)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	
	clear_points()
	
	for point : Vector2 in queue:
		if enable:
			add_point(point)

func _get_position() -> Vector2:
	if get_parent() is Node2D:
		return get_parent().global_position
	else:
		return get_global_mouse_position()
