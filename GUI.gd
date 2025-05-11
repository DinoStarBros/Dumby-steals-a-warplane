extends CanvasLayer

signal NewGun

func _ready():
	g.score = 0
	g.killscore = 0
	g.game_state = g.game_states.Combat

func _process(_delta):
	%joystick.visible = g.mobile
	
	%yLost.visible = g.game_state == g.game_states.Lost
	%score.text = str("Score:\n",g.score)
	%"2next".text = str("Kills 'til next gun: \n", g.killscore, " / 10")
	if g.killscore >= 20:
		%newgunim.play("newgun")
		g.killscore = 0
		emit_signal("NewGun" )
	
	if Input.is_action_just_pressed("pause") and g.game_state == g.game_states.Combat:
		get_tree().paused = not get_tree().paused
	%paused.visible = get_tree().paused

func _on_menu_pressed():
	scene_change("res://game_screens/title/title.tscn")
	g.game_state = g.game_states.Combat

func _on_play_pressed():
	SceneManager.reload_scene()
	g.game_state = g.game_states.Combat

func scene_change(scene:String)->void:
	SceneManager.change_scene(
		scene, {
			
			"pattern_enter" : "curtains",
			"pattern_leave" : "fade",
			
			}
		)


func _on_titlescreen_pressed():
	get_tree().paused = false
	scene_change("res://game_screens/title/title.tscn")
	g.game_state = g.game_states.Title


func _on_resume_pressed():
	get_tree().paused = false


func _on_new_gun() -> void:
	pass # Replace with function body.
