extends Node2D
class_name RotationComponent

@export var turn_speed : float = 7 ## How fast the plane can turn to face the mouse / aim
@export var thing_to_rotate : Node2D
var plane_sprite_rotation_degrees : float ## Used for determining the frame for the ship sprite
var direction : Vector2 = Vector2.ZERO ## The vector of the rotation of the rotated node
var rot_deg_change : float

func plane_rotation_handling(delta: float, desired_target: Vector2)->void:
	
	look_at(desired_target)
	var desired_rotation : float = rotation_degrees
	
	rot_deg_change = (
		desired_rotation - thing_to_rotate.rotation_degrees
		) * turn_speed
	
	if plane_sprite_rotation_degrees > 180:
		plane_sprite_rotation_degrees = -180
	if plane_sprite_rotation_degrees < -180:
		plane_sprite_rotation_degrees = 180
	
	thing_to_rotate.rotation_degrees += rot_deg_change * delta
	# Sets the rotation of the node you want rotated
	# Affected by the gradual turning speed stuff
	
	plane_sprite_rotation_degrees += rot_deg_change * delta
	
	direction.x = cos(thing_to_rotate.rotation)
	direction.y = sin(thing_to_rotate.rotation)
