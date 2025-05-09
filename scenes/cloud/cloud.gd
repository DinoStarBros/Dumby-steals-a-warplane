extends Sprite2D

var start_velocity : float

func _ready():
	frame = randi_range(0,4)
	flip_h = randf_range(0,1) > 0.5
	
	#start_velocity = randf_range(-10,-50)
	scale.x = randf_range(3,5)
	scale.y = scale.x
	
	velocity = Vector2.ZERO

func _process(delta):
	move(delta)

	if global_position.x <= 5800 and global_position.x >= 5500:
		queue_free()

var velocity : Vector2
func move(delta:float)->void:
	global_position += velocity * delta
	left_bounding()

var left_bound : = -4528
var right_bound : = 5630
func left_bounding()->void:
	if global_position.x <= left_bound:
		global_position.x = right_bound
