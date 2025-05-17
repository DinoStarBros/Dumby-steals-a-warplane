extends Control
class_name AbilitySlot

var ability : Ability
func _ready() -> void:
	if get_child(0):
		ability = get_child(0)

func activate_ability() -> void:
	if ability.usable:
		ability.activate_ability()
