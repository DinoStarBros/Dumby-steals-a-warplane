extends AnimatedSprite2D
class_name PlaneSprite

@export var max_frame : float = 6
@onready var p : Dumby = get_parent() ## Reference to the Parent Node, Dumby
#@onready var dir_to_m: Node2D = %dir_to_m

@onready var rotation_component: RotationComponent = %RotationComponent

func _process(_delta: float) -> void:
	#var rot : float = %PlaneSprite.rotation_degrees
	var rot : float = rotation_component.plane_sprite_rotation_degrees
	if p.rolling:
		pass
	else:
		frame = _pose_matcher(rot)
	%PlaneSprite.scale = Vector2(2,2)
	
	fx()

func _pose_matcher(_rot : float) -> int:
	var index :float
	
	if _rot > 0: # Positive angle
		index = max_frame - abs(remap(_rot, 180, 0, max_frame/2, -max_frame/2))
	else: # Negative Angle
		index = abs(remap(_rot, -180, 0, max_frame/2, -max_frame/2))
	
	flip_v = abs(_rot) > 90
	
	return round(index)

func fx() -> void:
	%flamez.visible = p.accelerating
	%flameparticles.emitting = p.accelerating
	%flameparticles.direction = -p.velocity
	
	%speedring.visible = p.velocity.length() > 800 and p.accelerating and p.accelerate_time > 1
	
	%trail_fx.visible = p.accelerating
