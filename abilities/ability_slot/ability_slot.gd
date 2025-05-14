extends Control
class_name AbilitySlot

var ability : Ability
func _ready() -> void:
	ability = get_child(0)

func activate_ability() -> void:
	if ability.usable:
		ability.activate_ability()
