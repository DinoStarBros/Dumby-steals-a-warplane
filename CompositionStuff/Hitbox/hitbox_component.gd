extends Area2D
class_name HitboxComponent

@export var delete_after_hit : bool

var attack : Attack = g.attack

var dmg : int

signal Hit

func set_attack_properties(damag:int):
	dmg = damag

func _on_area_entered(area):
	if area is HurtboxComponent:
		emit_signal("Hit")
		if get_parent().is_in_group("Enemy"):
			g.cam.apply_shake(10)
			
			attack.ene_attack_damage = dmg
			%player_hit.pitch_scale = 1 + randf_range(-.2,.2)
			%player_hit.play()
		else:
			g.cam.apply_shake(20)
			attack.attack_damage = dmg
			
			%enemy_hit.pitch_scale = 0.5 + randf_range(-.1,.1)
			%enemy_hit.play()
			
			%enemy_hit2.pitch_scale = randf_range(.4,.6)
			%enemy_hit2.play()
			
			%enemy_hit3.pitch_scale = randf_range(1.4,1.6)
			%enemy_hit3.play()
			
			
		
		area.damage(attack)
		if delete_after_hit:
			if get_parent().is_in_group("Enemy"):
				var plr_hit_sfx = plr_hit_sfx_scn.instantiate()
				g.game.add_child(plr_hit_sfx)
				get_parent().queue_free()
			else:
				var enemy_hit_sfx = enemy_hit_sfx_scn.instantiate()
				g.game.add_child(enemy_hit_sfx)
				get_parent().queue_free()

var enemy_hit_sfx_scn : = preload("res://spawned_sounds/enemy_hit_sfx.tscn")
var plr_hit_sfx_scn : = preload("res://spawned_sounds/plr_hit_sfx.tscn")
