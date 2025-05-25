extends Node2D
class_name ExplosionSpawner

const explosion_scn : PackedScene = preload("res://juices/explosionParticle/explosion_particle.tscn")
var explosion : ExplosionParticle

var direction : Vector2
var velocity : Vector2
var speed : float = 1000
func _ready() -> void:
	speed += randi_range(-20, 20)
	direction.x = randf_range(-1, 1)
	direction.y = randf_range(-1, 0.5)
	velocity = speed * direction
	
	make_explosion()

func spawn_explosion() -> void:
	explosion = explosion_scn.instantiate()
	set_properties()
	explosion.scale.x -= time
	explosion.scale.y = explosion.scale.x
	g.game.add_child(explosion)
	set_properties()

const pos_rand_range : float = 20
func set_properties() -> void:
	explosion.global_position = global_position
	#explosion.global_position.x += randf_range(-pos_rand_range, pos_rand_range)
	#explosion.global_position.y += randf_range(-pos_rand_range, pos_rand_range)

var explosion_amnt : float
func make_explosion() -> void:
	explosion_amnt = randi_range(10,20)
	spawn_explosion()
	await get_tree().create_timer(0.01).timeout

var lifetime : float = 1
var time : float = 0
func _process(delta: float) -> void:
	move(delta)
	velocity.y += (490 * delta) *2
	
	make_explosion()
	
	time += delta
	if time >= lifetime:
		queue_free()

func move(delta: float) -> void:
	global_position += velocity * delta
