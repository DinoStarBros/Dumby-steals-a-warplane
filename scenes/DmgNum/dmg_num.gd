extends Node2D
class_name DmgNum

var text : String
var ini_vel : float

func _ready() -> void:
	%DmgText.text = text
	ini_vel = randf_range(-60,60)

func _process(delta : float) -> void:
	position.x += ini_vel * delta
	position.y += (ini_vel * .5) * delta
