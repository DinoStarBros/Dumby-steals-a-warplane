extends Control
class_name Ability

@export var cooldown_txt : Label = null ## The text taht'll show the amount of cooldown
@export var cooldown : float = 2 ## The amount of time (in seconds) the ability will go in cooldown for after using
@export var sprite : Sprite2D = null ## The sprite node that contains the ability's icon
var cooldown_time : float = 0 
var usable : bool = true

func activate_ability() -> void: ## cooldown_time = cooldown
	pass

func _process(delta: float) -> void:
	if cooldown_time >= 0:
		cooldown_time -= delta
		cooldown_txt.text = str(int(cooldown_time))
	elif cooldown_time <= 0:
		cooldown_time = 0
	
	usable = cooldown_time <= 0
	cooldown_txt.visible = cooldown_time >= 0.1 
	if usable:
		sprite.modulate = Color.WHITE
	else:
		sprite.modulate = Color.DARK_GRAY
