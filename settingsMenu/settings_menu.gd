extends Control
class_name Settings

func _ready()->void:
	_on_load_pressed()
	
	#_update_res()
	#_update_vol_val()
	
	for n in %buttons.get_children():
		if n is Button:
			n.focus_mode = Control.FOCUS_NONE

func _on_save_pressed()->void:
	SaveLoad.SaveFileData.master_volume = g.master_volume
	SaveLoad.SaveFileData.music_volume = g.music_volume
	SaveLoad.SaveFileData.sfx_volume = g.sfx_volume
	
	SaveLoad.SaveFileData.screen_shake = g.screen_shake_value
	SaveLoad.SaveFileData.frame_freeze = g.frame_freeze_value
	
	SaveLoad.SaveFileData.resolutuion_index = g.resolution_index
	SaveLoad._save()

func _on_load_pressed()->void:
	SaveLoad._load()
	_update_res()
	_update_vol_val()

func _on_reset_pressed()->void:
	SaveLoad._reset_save_file()
	SaveLoad._load()
	_update_res()
	_update_vol_val()

func _update_vol_val()->void:
	g.master_volume = SaveLoad.SaveFileData.master_volume
	%master_volume.value = g.master_volume
	
	g.music_volume = SaveLoad.SaveFileData.music_volume
	%music_volume.value = g.music_volume
	
	g.sfx_volume = SaveLoad.SaveFileData.sfx_volume
	%sfx_vol.value = g.sfx_volume
	
	g.screen_shake_value = SaveLoad.SaveFileData.screen_shake
	if g.screen_shake_value:
		%screen_shake.text = str("On")
	else:
		%screen_shake.text = str("Off")
	
	g.frame_freeze_value = SaveLoad.SaveFileData.frame_freeze
	if g.frame_freeze_value:
		%frame_freeze.text = str("On")
	else:
		%frame_freeze.text = str("Off")

func _update_res()->void:
	%resOptions.select(SaveLoad.SaveFileData.resolutuion_index)
	_on_res_options_item_selected(SaveLoad.SaveFileData.resolutuion_index)

func _on_master_volume_value_changed(value: float)->void:
	g.master_volume = value
func _on_music_volume_value_changed(value: float)->void:
	g.music_volume = value
func _on_sfx_vol_value_changed(value: float)->void:
	g.sfx_volume = value

func _on_res_options_item_selected(_index: int) -> void:
	pass
	#g.resolution_index = index
	#DisplayServer.window_set_size(resolutions[index])

var resolutions : Array[Vector2i] = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1280, 720),
]

func _on_back_pressed() -> void:
	_on_save_pressed()
	hide()
	get_tree().paused = false

func _on_frame_freeze_pressed() -> void:
	g.frame_freeze_value = not g.frame_freeze_value
	if g.frame_freeze_value:
		%frame_freeze.text = str("On")
	else:
		%frame_freeze.text = str("Off")

func _on_screen_shake_pressed() -> void:
	g.screen_shake_value = not g.screen_shake_value
	if g.screen_shake_value:
		%screen_shake.text = str("On")
	else:
		%screen_shake.text = str("Off")
