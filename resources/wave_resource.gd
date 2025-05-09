extends Resource
class_name Wave

@export var enemies : Array[PackedScene] ## The list of enemies you want spawned in that wave

@export var starting_spawn_time : float = 1.5 ## Where the spawn timer starts
@export var minimum_spawn_time : float = 0.05 ## The spawn time will be limited down to this
@export var spawn_time_increment : float = 0.01 ## How much the spawn time decreases everytime, making it quicker the longer

@export var enemy_limit : float = 200 ## Limits the amount of enemies available on screen, to reduce lag

@export var min_enemy_amount : int = 1 ## The minimum amount of enemies it'll spawn at a single instance
@export var max_enemy_amount : int = 1 ## The maximum amount of enemies it'll spawn at a single instance
