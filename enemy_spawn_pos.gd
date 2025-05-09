extends Path2D

var enemies : = [
	preload("res://entities/shooter/shooter.tscn"),
	preload("res://entities/chaser/chaser.tscn")
]
func _ready():
	%spawnTimer.start(1)

var spawn_time : float = 0.5
func _on_spawn_timer_timeout():
	spawn_time -= 0.05
	if spawn_time <= 0.05:
		spawn_time = 0.05
	%spawnTimer.start(spawn_time)
	if get_tree().get_nodes_in_group("Enemy").size() <= 100:
		for n in randi_range(4,5):
			spawn_enemy()

func spawn_enemy()->void:
	var enemy_scn = enemies.pick_random()
	var enemy = enemy_scn.instantiate()
	
	%enemy_spawn_pos.progress_ratio = randf()
	enemy.global_position = %enemy_spawn_pos.global_position
	g.game.add_child(enemy)
