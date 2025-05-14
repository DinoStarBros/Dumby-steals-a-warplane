extends CharacterBody2D
class_name Dumby

var half_viewport : Vector2
var dir_to_mouse : Vector2
var dist_to_mouse : float
var accelerate_spd : int = 60
var accelerate_limit : int = 700
var direc_mouse 
var accelerate_time : float = 0

func _ready():
	#gun_sequence.shuffle()
	g.player = self
	%weapons_parent.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(delta):
	
	move_and_slide()
	
	half_viewport = get_viewport_rect().size / 2.0
	
	dir_to_mouse = (get_global_mouse_position() - global_position).normalized()
	dist_to_mouse = global_position.distance_to(get_global_mouse_position())
	
	
	#%Plane.flip_v = dir_to_mouse.x <= 0
	
	velocity.y += (980 * delta) / 2
	if accelerating and dist_to_mouse >= 50:
		velocity += accelerate_spd * dir_to_mouse
		if not %jet.playing:
			%jet.play()
	else:
		%jet.stop()
	
	lim_accel_x()
	lim_accel_y()
	if g.mobile:
		pass
	else:
		if Input.is_action_just_pressed("accelerate"):
			pass
		accelerating = Input.is_action_pressed("accelerate")
		
	plane_rotation_handling()
	
	if accelerating:
		accelerate_time += delta
		if accelerate_time > 5:
			accelerate_time = 5
	else:
		accelerate_time = 0

var aim_position : Vector2
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_position = (event.position - half_viewport)

var accelerating : = false

func lim_accel_x()->void:
	if velocity.x <= -accelerate_limit:
		velocity.x = -accelerate_limit
	if velocity.x >= accelerate_limit:
		velocity.x = accelerate_limit
func lim_accel_y()->void:
	if velocity.y <= -accelerate_limit:
		velocity.y = -accelerate_limit
	if velocity.y >= accelerate_limit:
		velocity.y = accelerate_limit

func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.game_state = g.game_states.Lost
	set_physics_process(false)
	%explod.play(.4)
	%death.play("die")
	%weapons_parent.process_mode = Node.PROCESS_MODE_DISABLED

@onready var plane_sprite: AnimatedSprite2D = %PlaneSprite
func plane_rotation_handling()->void:
	plane_sprite.look_at(get_global_mouse_position())
	
	if plane_sprite.rotation_degrees > 180:
		plane_sprite.rotation_degrees = -180
	if plane_sprite.rotation_degrees < -180:
		plane_sprite.rotation_degrees = 180
