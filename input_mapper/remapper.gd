extends Button
class_name Remapper

@export var action : String
@onready var input_mapper : Control = $".."

func _init()->void:
	toggle_mode = true

func _ready()->void:
	#update_text()
	set_process_unhandled_input(false)

func _toggled(button_pressed:bool)->void:
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = " Awaiting Input "
		focus_mode = Control.FOCUS_NONE
	else:
		focus_mode = Control.FOCUS_ALL

func _unhandled_input(event:InputEvent)->void:
	if not event is InputEventMouseMotion:
		if event.pressed:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			button_pressed = false
			release_focus()
			update_text()
			input_mapper.keymaps[action] = event
			input_mapper.save_keymap()

func update_text()->void:
	text = str(action, " : \n", InputMap.action_get_events(action)[0].as_text())
	#text = InputMap.action_get_events(action)[0].as_text()
