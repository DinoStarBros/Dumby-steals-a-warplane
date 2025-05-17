extends Path2D

@export var wave : Wave
var spawn_time : float = 1

func _ready() -> void:
	%spawnTimer.start(1)
	spawn_time = wave.starting_spawn_time

func _on_spawn_timer_timeout() -> void:
	spawn_time -= wave.spawn_time_increment
	if spawn_time <= wave.minimum_spawn_time:
		spawn_time = wave.minimum_spawn_time
	%spawnTimer.start(spawn_time)
	if get_tree().get_nodes_in_group("Enemy").size() <= wave.enemy_limit and g.game_state == g.game_states.Combat:
		for n in randi_range(wave.min_enemy_amount, wave.max_enemy_amount):
			spawn_enemy()

func spawn_enemy()->void:
	var enemy_scn : PackedScene = wave.enemies.pick_random()
	var enemy : CharacterBody2D = enemy_scn.instantiate()
	
	%enemy_spawn_pos.progress_ratio = randf()
	enemy.global_position = %enemy_spawn_pos.global_position
	g.game.add_child(enemy)
