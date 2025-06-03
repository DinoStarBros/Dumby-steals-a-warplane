extends CharacterBody2D
class_name Dumby

var half_viewport : Vector2
var dir_to_mouse : Vector2
var dist_to_mouse : float
var accelerate_time : float = 0

@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var rotation_component: RotationComponent = %RotationComponent

func _ready() -> void:
	%Crosshair.visible = controller
	g.player = self
	%weapons_parent.process_mode = Node.PROCESS_MODE_INHERIT

var attack : Attack = Attack.new()
func _physics_process(delta: float) -> void:

	if is_on_floor() and health_component.hp > 0:
		attack.ene_attack_damage = 999
		hurtbox_component.damage(attack)
	
	roll_handling(delta)
	
	move_and_slide()
	
	half_viewport = get_viewport_rect().size / 2.0
	
	dir_to_mouse = global_position.direction_to(get_global_mouse_position())
	dist_to_mouse = global_position.distance_to(get_global_mouse_position())
	
	velocity_component.other_velocity_handle(delta, dir_plane, accelerating)
	if controller:
		rotation_component.plane_rotation_handling(delta, global_position + (controller_joypad_vector * 50))
	else:
		rotation_component.plane_rotation_handling(delta, get_global_mouse_position())
	
	if accelerating:
		if not %jet.playing:
			%jet.play()
	else:
		%jet.stop()
	
	if g.mobile:
		pass
	else:
		accelerating = Input.is_action_pressed("accelerate")
	

	
	dir_plane = rotation_component.direction
	
	if accelerating:
		
		accelerate_time += delta
		if accelerate_time > 5:
			accelerate_time = 5
	else:
		accelerate_time = 0

var aim_position : Vector2
var dir_plane : Vector2
func _unhandled_input(event: InputEvent) -> void: ## For camera aiming, dynamic camera follow mouse
	if controller:
		aim_position = dir_plane * half_viewport * left_joystick_length
		%Crosshair.position = aim_position
	else:
		if event is InputEventMouseMotion:
			aim_position = (event.position - half_viewport)
			#%Crosshair.position = aim_position * 2

var accelerating : bool = false

func damage(_attack:Attack)->void:
	#g.cam.screen_shake(20, 0.3)
	pass

func Dead(_attack:Attack)->void:
	#g.cam.screen_shake(40, 1)
	g.game_state = g.game_states.Lost
	set_physics_process(false)
	%explod.play(.4)
	%death.play("die")
	%weapons_parent.process_mode = Node.PROCESS_MODE_DISABLED
	%Abilities.process_mode = Node.PROCESS_MODE_DISABLED

@onready var plane_sprite: AnimatedSprite2D = %PlaneSprite
@onready var dir_to_m: Node2D = %dir_to_turn
@onready var dir_to_plane_sprite: Node2D = %dir_to_plane_sprite

@export var controller : bool = false ## Set to true if using controller, false if Mouse

@export var turn_speed : float = 7 ## How fast the plane can turn to face the mouse / aim
@export var thing_to_rotate : Node2D
var plane_sprite_rotation_degrees : float ## Used for determining the frame for the ship sprite
var direction : Vector2 = Vector2.ZERO ## The vector of the rotation of the rotated node
var rot_deg_change : float
func plane_rotation_handling(delta: float, desired_target: Vector2)->void:
	
	dir_to_m.look_at(desired_target)
	var desired_rotation : float = dir_to_m.rotation_degrees
	
	rot_deg_change = (
		desired_rotation - plane_sprite.rotation_degrees
		) * turn_speed
	
	if plane_sprite_rotation_degrees > 180:
		plane_sprite_rotation_degrees = -180
	if plane_sprite_rotation_degrees < -180:
		plane_sprite_rotation_degrees = 180
	
	thing_to_rotate.rotation_degrees += rot_deg_change * delta
	# Sets the rotation of the node you want rotated
	# Affected by the gradual turning speed stuff
	
	plane_sprite_rotation_degrees += rot_deg_change * delta
	
	direction.x = cos(thing_to_rotate.rotation)
	direction.y = sin(thing_to_rotate.rotation)

func _on_exp_pickup_area_entered(area: Area2D) -> void:
	if area is XpOrb:
		area.collected = true
		%collect.pitch_scale = randf_range(0.9, 1.2)
		%collect.play()

func finish_collect() -> void:
	%collect2.pitch_scale = randf_range(1.1, 1.3)
	%collect2.play()

var rolling : bool = false ## If the player is rolling or not
var roll_duration : float = 0.5 ## The amount of time the roll will last
var roll_cooldown : float = 0.1 ## The amount of time you have to wait after a roll before being able to perform another
var roll_time : float = 0 ## The amount of time that has passed since the start of the roll
var roll_cd_time : float = 0
func roll_handling(delta: float) -> void:
	if Input.is_action_just_pressed("roll") and roll_cd_time <= 0 and not rolling:
		%roll.pitch_scale = randf_range(0.8,1.2)
		%roll.play()
		
		%rollnim.play("roll")
		
		roll_time = 0
		rolling = true
		
		plane_sprite.frame = 0
	
	if rolling:
		roll_time += delta
	
	if roll_time >= roll_duration:
		rolling = false
		roll_time = 0
		roll_cd_time = roll_cooldown
	
	if roll_cd_time > 0:
		roll_cd_time -= delta
 
var controller_joypad_vector : Vector2 ## Vector of the left analog stick
var left_joystick_length : float = 0
func _input(_event: InputEvent) -> void: 
	#old_controller_left_joystick_handling(event)
	controller_joypad_vector = Input.get_vector(
		"left_stick", "right_stick", "up_stick", "down_stick"
	)
	#%Label.text = str(controller_joypad_vector)
	left_joystick_length = controller_joypad_vector.length()
