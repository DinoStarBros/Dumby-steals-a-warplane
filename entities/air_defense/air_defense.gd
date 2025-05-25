extends CharacterBody2D

var gravity :float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : = 1
func _ready() -> void:
	direction = randi_range(-1,1)
	%AntiAir.flip_h = direction <= 0

func _physics_process(delta: float) -> void:
	move_and_slide()
	if not is_on_floor():
		velocity.y += gravity * delta

var bullet_spd : = 1500
const bullet_scn : = preload("res://projectiles/ene_bullet/ene_bullet.tscn")

func spawn_bullet()->void:
	%shoot.pitch_scale = randf_range(.9,1.1)
	%shoot.play()
	%shoot2.pitch_scale = randf_range(.9,1.1)
	%shoot2.play(.2)
	
	var target : Vector2 = Vector2(.7*direction,-.7)
	var bullet : Projectile = bullet_scn.instantiate()
	bullet.global_position = global_position
	bullet.velocity = target * bullet_spd
	bullet.pos_to_look = target
	g.game.add_child(bullet)
	bullet.velocity = target * bullet_spd
	bullet.pos_to_look = target


func _on_timer_timeout() -> void:
	if shooty:
		spawn_bullet()


func damage(_attack:Attack)->void:
	pass

func Dead(_attack:Attack)->void:
	g.score += 50
	g.killscore += 1
	#g.spawn_txt("50", global_position)
	set_physics_process(false)
	%death.play("die")

var shooty : = true
func disable()->void:
	shooty = false
