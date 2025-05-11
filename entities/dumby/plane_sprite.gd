extends AnimatedSprite2D

@export var max_frame : float = 6

func _process(_delta: float) -> void:
	var rot : float = rotation_degrees
	frame = _pose_matcher(rot)
	%PlaneSprite.scale = Vector2(2,2)

func _pose_matcher(_rot : float) -> int:
	var index :float
	
	if _rot > 0: # Positive angle
		index = max_frame - abs(remap(_rot, 180, 0, max_frame/2, -max_frame/2))
	else: # Negative Angle
		index = abs(remap(_rot, -180, 0, max_frame/2, -max_frame/2))
	
	flip_v = abs(_rot) > 90
	
	return round(index)
