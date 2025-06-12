extends Node2D
class_name EnemyArrow

@onready var arrow: PanelContainer = %arrow
var parent : CharacterBody2D

func _ready() -> void:
	parent = get_parent()

var dir_to_parent : Vector2
func _process(_delta: float) -> void:
	set_marker_position(g.screen_corners)
	dir_to_parent = arrow.global_position.direction_to(parent.global_position)
	arrow.rotation = dir_to_parent.angle()

const aseg : float = 3 #arrow_screen_edge_gap
func set_marker_position(bounds : Rect2) -> void:
	arrow.global_position.x = clamp(global_position.x, 
	bounds.position.x + arrow.size.x * aseg, 
	bounds.end.x - arrow.size.x * aseg)
	
	arrow.global_position.y = clamp(global_position.y, 
	bounds.position.y + arrow.size.y * aseg, 
	bounds.end.y - arrow.size.y * aseg)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
