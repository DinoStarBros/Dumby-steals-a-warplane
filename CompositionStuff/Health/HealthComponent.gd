extends Node2D
class_name HealthComponent

@export var hp_bar : ProgressBar
@export var hp_text : Label
#@export var cooler_hp_bar : TextureProgressBar

@export var max_hp : = 10.0
var hp : float

func _ready():
	hp = max_hp

func damage(attack:Attack):
	if get_parent().is_in_group("Enemy"):
		hp -= attack.attack_damage
		get_parent().damage(attack)
	else:
		hp -= attack.ene_attack_damage

func _process(_delta:float)->void:

	if hp_bar:
		hp_bar.max_value = max_hp
		hp_bar.value = hp
	
	if hp_text:
		hp_text.text = str(hp, "/", max_hp)
