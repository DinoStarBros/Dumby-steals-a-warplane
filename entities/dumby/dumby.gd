extends CharacterBody2D
class_name Dumby

var half_viewport : Vector2
var dir_to_mouse : Vector2
var dist_to_mouse : float
var accelerate_spd : int = 60
var accelerate_limit : int = 700
var accelerate_time : float = 0

@onready var health_component: HealthComponent = %HealthComponent
@onready var hurtbox_component: HurtboxComponent = %HurtboxComponent

func _ready() -> void:
	#gun_sequence.shuffle()
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
	
	#dir_to_mouse = (get_global_mouse_position() - global_position).normalized()
	dir_to_mouse = dir_plane
	dist_to_mouse = global_position.distance_to(get_global_mouse_position())
	
	if not accelerating:
		velocity.y += (980 * delta) / 2
	if accelerating:
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
		
	plane_rotation_handling(delta)
	
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

var accelerating : bool = false

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
	g.cam.screen_shake(20, 0.3)

func Dead(_attack:Attack)->void:
	g.cam.screen_shake(40, 0.6)
	g.game_state = g.game_states.Lost
	set_physics_process(false)
	%explod.play(.4)
	%death.play("die")
	%weapons_parent.process_mode = Node.PROCESS_MODE_DISABLED

@onready var plane_sprite: AnimatedSprite2D = %PlaneSprite
@onready var dir_to_m: Node2D = %dir_to_turn
@onready var dir_to_plane_sprite: Node2D = %dir_to_plane_sprite

var rot_deg_change : float
const turn_speed : float = 10
var dir_plane : Vector2
func plane_rotation_handling(delta: float)->void:
	#plane_sprite.look_at(get_global_mouse_position())
	dir_to_m.look_at(get_global_mouse_position())
	rot_deg_change = (
		dir_to_m.rotation_degrees - plane_sprite.rotation_degrees
		) * turn_speed
	
	#if plane_sprite.rotation_degrees > 180:
	#	plane_sprite.rotation_degrees = -180
	#if plane_sprite.rotation_degrees < -180:
	#	plane_sprite.rotation_degrees = 180
	
	#if dir_to_m.rotation_degrees > 180:
	#	dir_to_m.rotation_degrees = -180
	#if dir_to_m.rotation_degrees < -180:
	#	dir_to_m.rotation_degrees = 180
	
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

var rolling : bool = false
var roll_duration : float = 0.5 ## The amount of time the roll will last
var roll_cooldown : float = 0.05 ## The amount of time you have to wait after a roll before being able to perform another
var roll_time : float = 0 ## The amount of time that has passed since the start of the roll
var roll_cd_time : float = 0
func roll_handling(delta: float) -> void:
	if Input.is_action_pressed("roll") and roll_cd_time <= 0 and not rolling:
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
 
