extends Node2D

@onready var sounds : = get_children()
func _ready():
	for sound in sounds:
		if sound is AudioStreamPlayer:
			sound.pitch_scale += randf_range(-.1,.1)
			sound.play()
	
	await get_tree().create_timer(1).timeout
	queue_free()
