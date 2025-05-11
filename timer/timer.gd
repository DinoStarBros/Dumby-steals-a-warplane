extends Control

var time : float = 0
var minutes:float=0
var seconds:float=0
var ms:float=0

var time_full : String
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not get_tree().paused and g.game_state == g.game_states.Combat:
		time += delta
	
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	ms = fmod(time, 1) * 100
	
	%Min.text = "%02d:" % minutes
	%Sec.text = "%02d." % seconds
	%MSec.text = "%03d" % ms
	
	time_full = str("%02d:" % minutes, "%02d." % seconds, "%04d" % ms)
