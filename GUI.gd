extends CanvasLayer

signal NewGun

var are_you_sure : bool = false
@onready var settings_menu: Settings = %settingsMenu

func _ready() -> void:
	g.score = 0
	g.killscore = 0
	

func _process(_delta: float) -> void:
	
	%joystick.visible = g.mobile
	%yLost.visible = g.game_state == g.game_states.Lost
	
	if Input.is_action_just_pressed("pause") and g.game_state == g.game_states.Combat:
		get_tree().paused = not get_tree().paused
		are_you_sure = false
		if get_tree().paused:
			#print("pause")
			settings_menu._on_load_pressed()
		else:
			#print("unpause")
			settings_menu._on_save_pressed()
	
	%paused.visible = get_tree().paused and g.game_state == g.game_states.Combat
	%sure.visible = are_you_sure

func _on_menu_pressed() -> void:
	scene_change("res://game_screens/title/title.tscn")
	g.game_state = g.game_states.Title

func scene_change(scene:String)->void:
	SceneManager.change_scene(
		scene, {
			"pattern_enter" : "curtains",
			"pattern_leave" : "fade",
			}
		)

func _on_resume_pressed() -> void:
	get_tree().paused = false
	settings_menu._on_save_pressed()

func newgun_handling() -> void: ## This is old feature, game jam version
	%score.text = str("Score:\n",g.score)
	%"2next".text = str("Kills : \n", g.killscore)
	if g.killscore >= 20:
		%newgunim.play("newgun")
		g.killscore = 0
		emit_signal("NewGun")

func _on_quit_pressed() -> void:
	are_you_sure = not are_you_sure

func _on_sure_pressed() -> void:
	get_tree().paused = false
	scene_change("res://game_screens/title/title.tscn")
	g.game_state = g.game_states.Title
	settings_menu._on_save_pressed()
