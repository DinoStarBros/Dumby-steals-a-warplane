extends Resource
class_name WeaponStats

@export var shoot_cooldown : float = 0.1 ## The amount of time (in seconds) each shot will take before shooting again
@export var bullet_spd : int = 1500 ## Speed of the bullet
@export var bullet_amnt : int = 1 ## How many bullets will come out per shot
@export var random_spread : float = 0 ## How spread out the bullets will be, recommended for high bulllet amounts like shotgun (Keep it in the tenths(0.1) place, having an integer causes it to go crazy)
@export var bullet_lifetime : float = 1 ## How many secondes before the bulet is deleted

@export var bullet_scn : PackedScene

@export var max_ammo : int = 20 ## The max amount of ammo
