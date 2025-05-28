extends Node2D

func _ready() -> void:
	randomize_stuff()

func randomize_stuff() -> void:
	
	scale.x = randf_range(1, 5) * -1
	#scale.y = randf_range(1, 5)
	
	#%anim.speed_scale = randf_range(2, 4)

func _process(_delta: float) -> void:
	pass
