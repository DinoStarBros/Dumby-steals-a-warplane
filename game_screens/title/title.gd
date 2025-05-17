extends Node2D

func _ready() -> void:
	SceneManager.fade_in()

func _on_play_pressed() -> void:
	scene_change("res://game_screens/game/game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func scene_change(scene:String)->void:
	SceneManager.change_scene(
		scene, {
			"pattern_enter" : "circle",
			"pattern_leave" : "fade",
			}
		)
var deltaTime : = 0.0
var sin_val : float
func _process(delta: float) -> void:
	deltaTime += delta
	if deltaTime >= 180:
		deltaTime = 0
	
	sin_val = sin(deltaTime)
	%buttons.global_position.y += (sin_val * delta) * 20
	#%Dumbynplane.global_position.y += (sin_val * delta) * -30
	%Txt.global_position.y += (sin_val * delta) * -10
