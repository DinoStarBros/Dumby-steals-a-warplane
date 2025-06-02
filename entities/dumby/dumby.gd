extends CharacterBody2D
class_name Dumby

var half_viewport : Vector2
var dir_to_mouse : Vector2
var dist_to_mouse : float
var accelerate_time : float = 0

@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent
@onready var velocity_component: VelocityComponent = %VelocityComponent

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
	
	dir_to_mouse = dir_plane
	dist_to_mouse = global_position.distance_to(get_global_mouse_position())
	
	
	velocity_component.other_velocity_handle(delta, dir_to_mouse, accelerating)
	if accelerating:
		if not %jet.playing:
			%jet.play()
	else:
		%jet.stop()
	
	if g.mobile:
		pass
	else:
		accelerating = Input.is_action_pressed("accelerate")
	
	plane_rotation_handling(delta)
	
	if accelerating:
		
		accelerate_time += delta
		if accelerate_time > 5:
			accelerate_time = 5
	else:
		accelerate_time = 0

var aim_position : Vector2
func _unhandled_input(event: InputEvent) -> void: ## For camera aiming, dynamic camera follow mouse
	if controller:
		aim_position = dir_to_mouse * half_viewport * left_joystick_length
		%Crosshair.position = aim_position
	else:
		if event is InputEventMouseMotion:
			aim_position = (event.position - half_viewport)
			#%Crosshair.position = aim_position * 2

var accelerating : bool = false

func damage(_attack:Attack)->void:
	g.cam.screen_shake(20, 0.3)

func Dead(_attack:Attack)->void:
	g.cam.screen_shake(40, 0.6)
	g.game_state = g.game_states.Lost
	set_physics_process(false)
	%explod.play(.4)
	%death.play("die")
	%weapons_parent.process_mode = Node.PROCESS_MODE_DISABLED
	%Abilities.process_mode = Node.PROCESS_MODE_DISABLED

@onready var plane_sprite: AnimatedSprite2D = %PlaneSprite
@onready var dir_to_m: Node2D = %dir_to_turn
@onready var dir_to_plane_sprite: Node2D = %dir_to_plane_sprite

var rot_deg_change : float
@export var turn_speed : float = 7 ## How fast the plane can turn to face the mouse / aim
var dir_plane : Vector2

@export var controller : bool = false ## Set to true if using controller, false if Mouse
func plane_rotation_handling(delta: float)->void:
	
	if controller:
		dir_to_m.look_at(global_position + (controller_joypad_vector * 50))
	else:
		dir_to_m.look_at(get_global_mouse_position())
	
	rot_deg_change = (
		dir_to_m.rotation_degrees - plane_sprite.rotation_degrees
		) * turn_speed
	
	if dir_to_plane_sprite.rotation_degrees > 180:
		dir_to_plane_sprite.rotation_degrees = -180
	if dir_to_plane_sprite.rotation_degrees < -180:
		dir_to_plane_sprite.rotation_degrees = 180
	
	plane_sprite.rotation_degrees += rot_deg_change * delta
	dir_to_plane_sprite.rotation_degrees += rot_deg_change * delta
	
	dir_plane.x = cos(plane_sprite.rotation)
	dir_plane.y = sin(plane_sprite.rotation)

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
