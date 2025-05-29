extends Node2D
class_name Weapon

@export var stats : WeaponStats

@onready var p : Dumby = owner

var can_shoot : bool = true
var cooldown : float = 0

var dir_to_mouse : Vector2 ## Normalized direction vector from the player to the mouse
#var dist_to_mouse : float ## Distance from the player to the mouse
var rand_spread_vector : Vector2

@export var max_ammo : int = 10 ## Max amount of ammo
var ammo : int

var reloading : bool = false ## Checks if the weapon is reloading, if so, it disables shooting
@export var max_reload_duration : float = 1 ## The time it takes to reload said weapon
@export var min_sweet_spot : float = 0.5 ## The minimum time you can do a tactical reload (IT'S VERY IMPORTANT THAT IT'S KEPT LOWER THAN THE MAX RELOAD DURATION AND HIGHER THAN 0)
@export var max_sweet_spot : float = 0.6 ## The maximum time you can do a tactical reload (IT'S VERY IMPORTANT THAT IT'S KEPT LOWER THAN THE MAX RELOAD DURATION AND HIGHER THAN 0)
var r_tact_pressed : bool = false

@export var max_buff_time : float = 0 ## The amount of time the weapon gets buffed after tactical reloading, before going back to normal
var buff_time : float = 0 ## The amount of time that has passed since the buff, weapon goes back to normal once it reaches 0
var buffed : bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
