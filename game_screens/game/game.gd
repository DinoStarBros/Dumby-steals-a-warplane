extends Node2D
class_name Game

const cloud_amnt : = 1000

const left_bound : = -13400
const right_bound : = 14000
const up_bound : = -6674
const down_bound : = 2583
func _ready():
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
		
	#spawn_ubound_clouds()

var cloud_parents : = [

]
var cloud_scn : = preload("res://scenes/cloud/cloud.tscn")
func spawn_cloud(pos:Vector2)->void:
	var cloud = cloud_scn.instantiate()
	
	cloud.global_position = pos
	cloud_parents.pick_random().add_child(cloud)
	cloud.global_position = pos

#27400
var x = 0
var ucloud_scn : = preload("res://scenes/cloud/cloud.tscn")
func spawn_ubound_clouds()->void:
	x = left_bound 
	for n in 137:
		var ucloud = ucloud_scn.instantiate()
		ucloud.global_position.y = -4763
		ucloud.global_position.x = x
		%u.add_child(ucloud)
		x += 200
		

var airdef_scn : = preload("res://entities/air_defense/air_defense.tscn")
func spawn_adf()->void:
	%adspos.progress_ratio = randf()
	var airdef = airdef_scn.instantiate()
	airdef.global_position = %adspos.global_position
	g.game.add_child(airdef)

var adf_spwn_time : = 10.0
func _on_adftimer_timeout():
	adf_spwn_time -= 0.0025
	%adftimer.start(adf_spwn_time)
	if adf_spwn_time <= .5:
		adf_spwn_time = 0.5
	if get_tree().get_nodes_in_group("AieDefense").size() <= 5:
		spawn_adf()
