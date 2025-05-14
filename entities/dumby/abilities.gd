extends CanvasLayer
class_name Abilities

@onready var p : Dumby = get_parent() ## Reference to the Parent Node, Dumby

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Ability1"):
		%as1.activate_ability()
	elif Input.is_action_just_pressed("Ability2"):
		%as2.activate_ability()
	elif Input.is_action_just_pressed("Ability3"):
		%as3.activate_ability()
