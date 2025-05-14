extends Node2D

var sprite_mode : int = 0
func _ready() -> void:
	randomize_stuff()
	
	for n in get_children():
		if n is Sprite2D:
			n.hide()
	
	match sprite_mode:
		0:
			$spd_line.show()
		1:
			$spd_line2.show()
		2:
			$spd_line3.show()
		3:
			$spd_line4.show()
		4:
			hide()

func randomize_stuff() -> void:
	sprite_mode = randi_range(0,4)
	
	scale.x = randf_range(1, 5) * -1
	scale.y = randf_range(1, 5)
	
	%anim.speed_scale = randf_range(2, 4)

func _process(_delta: float) -> void:
	for n in get_children():
		if n is Sprite2D:
			n.position.x = %spd_line.position.x
