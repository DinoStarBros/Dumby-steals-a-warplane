extends Node2D
class_name Weapon

@export var stats : WeaponStats

var can_shoot : bool = true
var cooldown : float = 0

var dir_to_mouse : Vector2 ## Normalized direction vector from the player to the mouse
#var dist_to_mouse : float ## Distance from the player to the mouse
var rand_spread_vector : Vector2
func _process(_delta: float) -> void:
	pass
