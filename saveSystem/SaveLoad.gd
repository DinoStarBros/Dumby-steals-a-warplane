extends Node

const save_location : String = "user://SaveFile.tres"

var SaveFileData : SaveDataResource = SaveDataResource.new()

func _ready()->void:
	_load()

func _save()->void:
	ResourceSaver.save(SaveFileData, save_location)

func _load()->void:
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)

func _reset_save_file()->void:
	SaveFileData = SaveDataResource.new()
	_save()
