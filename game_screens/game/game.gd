extends Node2D
class_name Game

const cloud_amnt : = 1000

const left_bound : = -13400
const right_bound : = 14000
const up_bound : = -6674
const down_bound : = 2583
func _ready() -> void:
	g.game_state = g.game_states.Combat
	%Groundhitbox.set_attack_properties(1)
	cloud_parents = %cloudparallax.get_children()
	#print(320*15)
	SceneManager.fade_in()
	g.game = self
	for n in cloud_amnt:
		%cloud_pos.global_position.y = randf_range(down_bound,up_bound)
		%cloud_pos.global_position.x = randf_range(left_bound,right_bound)
		spawn_cloud(%cloud_pos.global_position)

var cloud_parents : Array = []
const cloud_scn : PackedScene = preload("res://scenes/cloud/cloud.tscn")
func spawn_cloud(pos:Vector2)->void:
	var cloud : Sprite2D = cloud_scn.instantiate()
	
	cloud.global_position = pos
	cloud_parents.pick_random().add_child(cloud)
	cloud.global_position = pos



var airdef_scn : = preload("res://entities/air_defense/air_defense.tscn")
func spawn_adf()->void:
	%adspos.progress_ratio = randf()
	var airdef : CharacterBody2D = airdef_scn.instantiate()
	airdef.global_position = %adspos.global_position
	g.game.add_child(airdef)

var adf_spwn_time : = 10.0
func _on_adftimer_timeout() -> void:
	adf_spwn_time -= 0.0025
	%adftimer.start(adf_spwn_time)
	if adf_spwn_time <= .5:
		adf_spwn_time = 0.5
	if get_tree().get_nodes_in_group("AirDefense").size() <= 5:
		spawn_adf()
