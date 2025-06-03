extends CharacterBody2D

var accelerating : = true
var dir_to_targ : Vector2
var target : CharacterBody2D

@onready var velocity_component: VelocityComponent = %VelocityComponent

func _ready() ->  void:
	_on_target_deviat_timer_timeout()

var target_deviation : Vector2
func _physics_process(delta: float) -> void:
	move_and_slide()
	target = g.player
	dir_to_targ = (target.global_position - global_position).normalized()
	
	#accelerating = Input.is_action_pressed("accelerate")
	%flamez.visible = accelerating
	%flameparticles.emitting = accelerating
	%flameparticles.direction = -velocity
	
	
	%Plane.look_at(target.global_position) 
	%outline.look_at(target.global_position)
	velocity_component.other_velocity_handle(delta, dir_to_targ, accelerating)

const tdev_range : = 500
func _on_target_deviat_timer_timeout() -> void:
	target_deviation.x = randf_range(-tdev_range,tdev_range)
	target_deviation.y = randf_range(-tdev_range,tdev_range)

func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.score += 10
	g.killscore += 1
	g.spawn_txt("10", global_position)
	#g.spawn_xp(global_position, 1)
	set_physics_process(false)
	%death.play("die")

var bullet_spd : = 1500

const bullet_scn : = preload("res://projectiles/ene_bullet/ene_bullet.tscn")
func spawn_bullet()->void:
	
	%shoot.pitch_scale = randf_range(.9,1.1)
	%shoot.play()
	%shoot2.pitch_scale = randf_range(.9,1.1)
	%shoot2.play(.2)
	
	var bullet : Projectile = bullet_scn.instantiate()
	bullet.global_position = global_position
	bullet.velocity = dir_to_targ * bullet_spd
	bullet.pos_to_look = target.global_position
	g.game.add_child(bullet)
	bullet.velocity = dir_to_targ * bullet_spd
	bullet.pos_to_look = target.global_position

func _on_shoot_timer_timeout() -> void:
	spawn_bullet()
